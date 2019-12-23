function recon_3Depi(varargin)
%% Input checking

defaultTempDataStore = 'disk';
checkTempDataStore = @(x) (strcmp(x,'mem') || strcmp(x,'disk'));

defaultDataPrecision = 'single';
checkDataPrecision = @(x) (strcmp(x,'single') || strcmp(x,'double'));

defaultSendTo = {};
checkSendTo = @(x) (iscell(x));

defaultMoCo = 1;
checkMoCo = @(x) (x == 0 || x== 1);

defaultFermi = 1;
checkFermi = @(x) (x == 0 || x== 1);

defaultHalfFourier = 'homodyne';
checkHalfFourier = @(x) (strcmp(x,'homodyne') || strcmp(x,'pocs'));

defaultSWI = 0;
checkSWI = @(x) (x >= 0 || x <= 7);

defaultParPool = 0;
checkParPool = @(x) (x >= 0 && mod(x,1) == 0);

defaultGPU = false;
checkGPU = @(x) (x == false || x == true);

userInput = inputParser;
addParameter(userInput, 'tempdata', defaultTempDataStore, checkTempDataStore);
addParameter(userInput, 'dataprecision', defaultDataPrecision, checkDataPrecision);
addParameter(userInput, 'sendto', defaultSendTo, checkSendTo);
addParameter(userInput, 'moco', defaultMoCo, checkMoCo);
addParameter(userInput, 'fermi', defaultFermi, checkFermi);
addParameter(userInput, 'halffourier', defaultHalfFourier, checkHalfFourier);
addParameter(userInput, 'swi', defaultSWI, checkSWI);
addParameter(userInput, 'parpool', defaultParPool, checkParPool);
addParameter(userInput, 'gpu', defaultGPU, checkGPU); % not used yet

parse(userInput, varargin{:});


%% Cleanup
starttime = tic;
fprintf('----------------------------------------------------------\n');
fprintf('  Task                               Time  total (self)   \n');
fprintf('----------------------------------------------------------');
recon_epi_log('Recon init');

% clear previous recon from memory (clear mex) and delete recon files
clear mex
try rmdir('matlabDicoms','s'); catch; end
delete('e*s*.mat');

%% Parallel pool (lets us use parfor calls that may or may not run in parallel depending on userInput.Results.parpool)
% Prevent auto-start of parpool 
ps = parallel.Settings;
ps.Pool.AutoCreate = false;

if userInput.Results.parpool && isempty(gcp('nocreate'))
  %{
    % Ignore parpool requests for 3D recon until we find a use case making the recon faster
   recon_epi_log(sprintf('Starting parallel pool (%d workers)',userInput.Results.parpool), round(toc(starttime)));
   evalc(sprintf('parpool(%d)', userInput.Results.parpool));  % start pool. user evalc to suppress message
  %}
elseif userInput.Results.parpool == 0 && ~isempty(gcp('nocreate'))
  delete(gcp('nocreate')); % close pool if user don't want it
end

% myCluster = parcluster('local'); delete(myCluster.Jobs); % clean up previous crashed jobs if present

%% Read archive/Pfile data from disk
recon_epi_log('Data read', round(toc(starttime)));

if numel(dir('ScanArchive*h5'))
  %%% Data format: Scan Archives (DV26+)
  [kspacehandle, rcnhandle] = recon_epi_getarchive(userInput);
elseif numel(dir('P*7'))  
  %%% Data format: Pfiles
  [kspacehandle, rcnhandle] = recon_epi_getpfiles(userInput);  
else  
  error('Wrong directory');  
end


% opuser7 or userInput.swi are bit masks; SWI_bitmask==0 or SWI_bitmask==1 --> swi processing off and only magnitude recon; 
% rcnhandle.SWI_bitmask: 1:normal acq recon 2:SWI recon 4:Phase images
if userInput.Results.swi > 1
    rcnhandle.SWI_bitmask = userInput.Results.swi;
elseif rcnhandle_getfield(rcnhandle, 'image', 'user7') > 1
    rcnhandle.SWI_bitmask = rcnhandle_getfield(rcnhandle, 'image', 'user7');
end

%% Ghost and VRGF correction
% it is possible to use parfor instead of for as long as fast_phase_corr_flag = 1 in recon_epi_refvrgfcurrentpass()
% but it seems not to make it faster for now, perhaps better on large datasets
recon_epi_log('Ghost & VRGF correction', round(toc(starttime)));
for volIndx = 1:numel(kspacehandle) 
  kspacehandle{volIndx} = recon_epi_refvrgfcurrentpass(kspacehandle{volIndx}, rcnhandle, volIndx);
end

%% Apply ARC & main recon
recon_epi_log('ARC apply & main recon', round(toc(starttime)));
rcnhandle.coilSensitivityFieldLabel = ''; % init, may change in recon_epi_reconcurrentpass3D() and below

Itmp = cell(numel(kspacehandle), 1);
for volIndx = 1:numel(kspacehandle)
  arcorder = [1,2,4,3,5];
  kspaceVol = ipermute(GERecon('Arc.Synthesize', permute(getdata(kspacehandle{volIndx}), arcorder)), arcorder);
  kspaceVol = cft(kspaceVol, [0 0 0 -1]); % ifft along z
  [Itmp{volIndx}, rcnhandle, dicom_prefix] = recon_epi_reconcurrentpass3D(kspaceVol, rcnhandle, userInput);
end

%% SCIC: if we didn't get rcnhandle.coilSensitivityField from recon_epi_reconcurrentpass3D() using PURE, use SCIC instead for 32+ channels
if rcnhandle.nChannels >= 32 && ~isfield(rcnhandle, 'coilSensitivityField')
  notswiphase = find(~contains(dicom_prefix,'SWIphase')); % any non-SWIphase will do
  if ~isempty(notswiphase)
    Itmpc = scic(Itmp{1}(:,:,:,1,notswiphase(1)), rcnhandle);
    rcnhandle.coilSensitivityField = Itmp{1}(:,:,:,1,notswiphase(1)) ./ Itmpc; rcnhandle.coilSensitivityField(~isfinite(rcnhandle.coilSensitivityField)) = Inf;
    rcnhandle.coilSensitivityFieldLabel = 's';
  end
end


%% reshuffle to single ND array
% [Nx, Ny, Nslices, Nechoes, NContrasts, Nvols]
NContrasts = numel(dicom_prefix);
isz = size(Itmp{1}); isz(end+1:4) = 1; isz(5) = NContrasts; isz(6) = rcnhandle.nVols;

I = zeros(isz,'like',Itmp{1});
for volIndx = 1:numel(kspacehandle)
  I(:,:,:,:,:,volIndx) = Itmp{volIndx};
end
clear Itmp kspacehandle

%% DICOM write
%  Data format at this stage: [Nx, Ny, Nslices, Nechoes, Nvols] (MagNex dimension removed)

recon_epi_log('Write DICOMs', round(toc(starttime)));

% Performing Physician is one of few DICOM fields that is a string and can be used for Smart Folders and auto-routing using OsiriX and Horos
performingprefix = '3D';
if any(contains(dicom_prefix, 'SWI'))
  performingprefix = [performingprefix 'SWI'];
end
performingPhysicianTag = dcm_makeperformingphysicican(rcnhandle, performingprefix);

for n = 1:NContrasts
  
  if contains(dicom_prefix{n},'SWIphase')
    % SWI phase: +/pi => +/- 3141
    I_for_dicom = squeeze(I(:,:,:,:,n,:)) * 1e3;
  else
    % Global image intensity scaling (as DICOM images are short integers)
    I_for_dicom = squeeze(I(:,:,:,:,n,:) * 1e4 / max(reshape(I(:,:,:,:,n,:),[],1)));
    if isfield(rcnhandle, 'coilSensitivityField') && ~isempty(rcnhandle.coilSensitivityField)
      I_for_dicom = I_for_dicom ./ rcnhandle.coilSensitivityField;
    end
  end
  
  N_dicom_slices = size(I,3);
  
  rhslblank = rcnhandle_getfield(rcnhandle,'raw','slblank');
  slicevec = int16(1+rhslblank:N_dicom_slices-rhslblank);
  
  if isempty(slicevec)
    error('The slice vector for the dicom export is empty...\n')
  end
  
  if NContrasts == 1
    seriesNumber = rcnhandle_getfield(rcnhandle,'series','se_no');
  elseif n == 1
    seriesNumber = rcnhandle_getfield(rcnhandle,'series','se_no') * 100;
  else
    seriesNumber = seriesNumber + 1;
  end
  
  if ~isempty(dicom_prefix{n})
    coilprefix = [dicom_prefix{n} ':'];
  else
    coilprefix = '';
  end
  if ~isempty(rcnhandle.coilSensitivityFieldLabel)
    coilprefix = sprintf('%s%s:', coilprefix, rcnhandle.coilSensitivityFieldLabel);
  elseif ~isempty(coilprefix)
    coilprefix = [coilprefix ':'];
  end
  sedescprefix = coilprefix;
  
  dcm_write(I_for_dicom, rcnhandle, 'sedescprefix', sedescprefix, 'coilprefix', coilprefix, 'seriesnumber', seriesNumber, 'dcmfields', performingPhysicianTag, 'sendto', userInput.Results.sendto, 'slicevec', slicevec, 'volindx', n);
  
end


%% Close archive
if strcmp(rcnhandle.HandleType, 'ScanArchive')
  GERecon('Archive.Close', rcnhandle);
end

%% Close parpool and delete cluster
%{
if ~isempty(gcp('nocreate'))
  myCluster = parcluster('local'); 
  delete(myCluster.Jobs); % clean up previous crashed jobs if present
end
%}

%% Remove temp files
delete('e*s*v*.mat');

processtime = round(toc(starttime));
recon_epi_log('All done', processtime);
fprintf('\n');

if isdeployed
  fclose('all'); % Close potential open files to prevent: "Too many open files. Close files to prevent MATLAB instability"
end

end % recon_ksepi

%#ok<*EFIND> 












