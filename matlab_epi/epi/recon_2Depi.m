function recon_2Depi(varargin)
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

defaultParPool = 0;
checkParPool = @(x) (x >= 0 && mod(x,1) == 0);

defaultGPU = false;
checkGPU = @(x) (x == false || x == true);

defaultDebug = false;
checkDebug = @(x) (x == false || x == true);

defaultmeanmocodims = 2;
checkmeanmocodims = @(x) (x == 2 || x== 3);

userInput = inputParser;
addParameter(userInput, 'tempdata', defaultTempDataStore, checkTempDataStore);
addParameter(userInput, 'dataprecision', defaultDataPrecision, checkDataPrecision);
addParameter(userInput, 'sendto', defaultSendTo, checkSendTo);
addParameter(userInput, 'moco', defaultMoCo, checkMoCo);
addParameter(userInput, 'fermi', defaultFermi, checkFermi);
addParameter(userInput, 'halffourier', defaultHalfFourier, checkHalfFourier);
addParameter(userInput, 'parpool', defaultParPool, checkParPool);
addParameter(userInput, 'gpu', defaultGPU, checkGPU);
addParameter(userInput, 'debug', defaultDebug, checkDebug);

% 2D or 3D correction for last step aligning the mean volumes against each other
% meanb0 against meanDWI_lowestb
% More experience will show when 2D vs 3D correction of the mean volumes is best
addParameter(userInput, 'meanmocodims', defaultmeanmocodims, checkmeanmocodims);

parse(userInput, varargin{:});


%% Cleanup
starttime = tic;
fprintf('----------------------------------------------------------\n');
fprintf('  Task                               Time  total (self)  \n');
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
  recon_epi_log(sprintf('Starting parallel pool (%d workers)',userInput.Results.parpool), round(toc(starttime)));
  evalc(sprintf('parpool(%d)', userInput.Results.parpool));  % start pool. user evalc to suppress message
elseif userInput.Results.parpool == 0 && ~isempty(gcp('nocreate'))
  delete(gcp('nocreate')); % close pool if user don't want it
end


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

%% Ghost and VRGF correction
% it is possible to use parfor instead of for as long as fast_phase_corr_flag = 1 in recon_epi_refvrgfcurrentpass()
% but it seems not to make it faster for now, perhaps better on large datasets
recon_epi_log('Ghost & VRGF correction', round(toc(starttime)));
for volIndx = 1:numel(kspacehandle) 
  kspacehandle{volIndx} = recon_epi_refvrgfcurrentpass(kspacehandle{volIndx}, rcnhandle, volIndx);
end


%% GRAPPA estimation
rcnhandle.nCalVolumes = 0; % number of volumes used for grappa calibration

doEstimateGRAPPA = false;
if ~isempty(rcnhandle.MultiShotControl)
  %{
    ksepi (opuser5 = ksepi_multishot_control) has the following modes
    0:PI (Parallel Imaging), i.e. all volumes undersampled by R = #shots
    1:All MulShot. All volumes acquired each in #shots (data fully sampled)
    2:1stMulShot. First volume multishot (#shots), remaining undersampled by R = #shots
    3:b0MulShot (diffusion only). b0 volumes acquired multishot (#shots), DWI data undersampled by R = #shots
  %}
  if ~rcnhandle.useAsset && ((rcnhandle.isDiffusion && (rcnhandle.nShots > 1) && (rcnhandle.MultiShotControl > 0)) || ...
     ~rcnhandle.isDiffusion && (rcnhandle.nShots > 1) && (rcnhandle.MultiShotControl == 2 && rcnhandle.nVols > 1))
   % Diffusion: Always estimate GRAPPA weights if #shots > 1 and MultiShotControl != 0 Need external calibration
   % Non-Diffusion: Estimate GRAPPA weights if #shots > 1 and and MultiShotControl == 2 and nVols > 1
    if rcnhandle.nShots > 5, warning('recon_2Depi: GRAPPA estimation on 6+ shot EPI is not going to be pretty'); end
    doEstimateGRAPPA = true;
  end
end

if doEstimateGRAPPA
  recon_epi_log('GRAPPA estimation', round(toc(starttime)));
  
  if rcnhandle.MultiShotControl == 1 && ~rcnhandle.isDiffusion
    rcnhandle.nCalVolumes = rcnhandle.nVols;
  elseif rcnhandle.MultiShotControl == 2
    rcnhandle.nCalVolumes = 1;
  elseif rcnhandle.isDiffusion && (rcnhandle.MultiShotControl == 1 || rcnhandle.MultiShotControl == 3)
    [~, rcnhandle.nCalVolumes] = recon_epi_diffscheme(rcnhandle);
  end
   
  for vol = 1:rcnhandle.nCalVolumes
    kcal{vol} = getdata(kspacehandle{vol});
    if size(kcal{vol},5) > 1
      kcal{vol} = kcal{vol}(:,:,:,:,1); % 1st echo
    end
  end
  
  if rcnhandle.FLEET
    kcal{rcnhandle.nCalVolumes+1} = rcnhandle.FLEETvol(:,:,:,:,1); % 1st echo
  end
    
  % Select the best grappa weights on a slice-by-slice basis across the nCalVolumes
  grappaest_maxres = 80;
  rcnhandle.grappaWeights = recon_epi_estgrappa(kcal, rcnhandle.nShots, grappaest_maxres);
 
end

clear kcal



%% Apply GRAPPA & main recon
recon_epi_log('GRAPPA apply & main recon', round(toc(starttime)));
rcnhandle.coilSensitivityFieldLabel = ''; % init, may change in recon_epi_reconcurrentpass() and below

% control what to return to the user
rcnhandle.returnseries = recon_epi_returnwhatdata(rcnhandle);

% first recon 1st volume and return rcnhandle, updated with .coilSensitivityField
kspaceVol = recon_epi_applygrappa(kspacehandle{1}, rcnhandle, 1);
[Itmp{1},rcnhandle] = recon_epi_reconcurrentpass(kspaceVol, rcnhandle, userInput);

parfor volIndx = 2:numel(kspacehandle)
  kspaceVol = recon_epi_applygrappa(kspacehandle{volIndx}, rcnhandle, volIndx);
  Itmp{volIndx} = recon_epi_reconcurrentpass(kspaceVol, rcnhandle, userInput);
end

%% If we didn't get rcnhandle.coilSensitivityField from recon_epi_reconcurrentpass() using PURE, get it from SCIC instead for many-channel coils
if rcnhandle.nChannels >= 32 && ~isfield(rcnhandle, 'coilSensitivityField')
  Itmpc = scic(Itmp{1}(:,:,:,1,1), rcnhandle);
  rcnhandle.coilSensitivityField = Itmp{1}(:,:,:,1,1) ./ Itmpc; rcnhandle.coilSensitivityField(~isfinite(rcnhandle.coilSensitivityField)) = Inf;
  rcnhandle.coilSensitivityFieldLabel = 's';
end

%% Reshuffle to single ND array & Coil sensitivity correction (PURE or SCIC)
% [Nx, Ny, Nslices, Nechoes, NmagNex, Nvols]
isz = size(Itmp{1}); isz(end+1:5) = 1;
isz(6) = rcnhandle.nVols;
I = zeros(isz,'like',Itmp{1});
for volIndx = 1:numel(kspacehandle)
  if isfield(rcnhandle, 'coilSensitivityField') && ~isempty(rcnhandle.coilSensitivityField)
    % Correct for coilsensitivity now before motion correction
    % Matlab 2016b+: Division of arrays of different sizes
    I(:,:,:,:,1:size(Itmp{volIndx},5),volIndx) = Itmp{volIndx} ./ rcnhandle.coilSensitivityField;
  else
    I(:,:,:,:,1:size(Itmp{volIndx},5),volIndx) = Itmp{volIndx};
  end
end
clear Itmp kspacehandle


%% Global image intensity scaling (as DICOM images are short integers)
I = I * 1e4 / max(I(:));


%% Motion correction & merging magnitude NEX (b0). 6D -> 5D

if rcnhandle.moco
  recon_epi_log('Motion/eddy correction', round(toc(starttime)));
  % N.B. For non-diffusion scans (e.g. fMRI), we still call recon_epi_realigndiffusion, where the number of b0 correspond
  % to number of volumes total
  [Ic, mocoamount] = recon_epi_realigndiffusion(I, rcnhandle, ...
    'debug', userInput.Results.debug, 'gpu', userInput.Results.gpu, 'meanmocodims', userInput.Results.meanmocodims); % 6D -> 5D (Multishot/MagNex dimension removed)
end

if rcnhandle.moco && (max(mocoamount) < recon_epi_smallmotionthreshold)
  I = Ic; % The DWI part of Ic has then been only eddy current corrected, and...
  clear Ic;
  rcnhandle.moco = 0; % ...we no longer say we have done motion correction (see dicom write below)
else
  I = recon_epi_averagevalidnex(I); % 6D -> 5D (Multishot/MagNex dimension removed)
end


%% Diffusion processing & DICOM write (also non-diffusion)
%  Data format at this stage: [Nx, Ny, Nslices, Nechoes, Nvols] (MagNex dimension removed)
if ~isempty(rcnhandle.coilSensitivityFieldLabel)
  prefix      = [rcnhandle.coilSensitivityFieldLabel ':'];
  prefix_moco = ['M' rcnhandle.coilSensitivityFieldLabel ':'];
else
  prefix = '';
  prefix_moco = 'M:';
end
          
for w = 1:(1+rcnhandle.moco)
  
  if w == 1
    recon_epi_log('Write DICOMs', round(toc(starttime)));
  else
    recon_epi_log('Write DICOMs (MoCo)', round(toc(starttime)));
  end
  
  if rcnhandle.isDiffusion
    
    % Performing Physician is one of few DICOM fields that is a string and can be used for Smart Folders and auto routing using OsiriX and Horos
    performingPhysicianTag = dcm_makeperformingphysicican(rcnhandle, 'diffusion'); % = "diffusion;<psdname>;<psdiname>" = "diffusion;ksepi;ksepi"
    
    if rcnhandle.returnseries.acquired
      % write out the acquired diffusion data (original series)
      for volindx = 1:size(I,5)
        [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag] = recon_epi_diffusiondicomtags(volindx, rcnhandle);
        if w == 1
          dcm_write(I(:,:,:,:,volindx), rcnhandle, 'sedescprefix', prefix, 'coilprefix', prefix, 'volindx', volindx, ...
            'dcmfields', [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, performingPhysicianTag], ...
            'sendto', userInput.Results.sendto);
        else
          seriesNumberMoCo = rcnhandle_getfield(rcnhandle,'series','se_no') * 100;
          dcm_write(Ic(:,:,:,:,volindx), rcnhandle, 'sedescprefix', prefix_moco, 'coilprefix', prefix_moco, 'seriesnumber', seriesNumberMoCo, 'volindx', volindx, ...
            'dcmfields', [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, performingPhysicianTag], ...
            'sendto', userInput.Results.sendto);
        end
      end
    end
    
    if w == 1
      recon_epi_log('Diffusion processing & DICOM write', round(toc(starttime)));
      recon_epi_diffusion(I, rcnhandle, 'sedescprefix', '', 'dcmfields', performingPhysicianTag, 'sendto', userInput.Results.sendto);
    else
      recon_epi_log('Diffusion processing & DICOM write (MoCo)', round(toc(starttime)));
      recon_epi_diffusion(Ic, rcnhandle, 'sedescprefix', 'M', 'seriesnumber', rcnhandle_getfield(rcnhandle,'series','se_no') * 100  + 10 * size(Ic,4), ...
        'dcmfields', performingPhysicianTag, 'sendto', userInput.Results.sendto);
    end
    
  else % non-diffusion (e.g. fMRI)
    performingPhysicianTag = dcm_makeperformingphysicican(rcnhandle, '2D'); % = "2D;<psdname>;<psdiname>" = "2D;ksepi;ksepi"

    if w == 1
      dcm_write(I, rcnhandle, 'sedescprefix', prefix, 'coilprefix', prefix, 'dcmfields', performingPhysicianTag, 'sendto', userInput.Results.sendto);
    else
      seriesNumberMoCo = rcnhandle_getfield(rcnhandle,'series','se_no') * 100;
      dcm_write(Ic, rcnhandle, 'sedescprefix', prefix, 'coilprefix', prefix, 'seriesnumber', seriesNumberMoCo, 'dcmfields', performingPhysicianTag, 'sendto', userInput.Results.sendto);
    end
    
  end
  
end % for w (no moco, moco)


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























