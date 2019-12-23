%% Load the given Epi Scanrcnhandle
function [kspacehandle, rcnhandle] = recon_epi_getarchive(userInput)

rcnhandle = archive_load([], userInput.Results.dataprecision);
rcnhandle.userInput = userInput.Results;

%% Asset
rcnhandle.useAsset = archive_load_asset(rcnhandle);

%% Moco
rcnhandle.moco = rcnhandle.userInput.moco;

%% Parameter and variable initialization
% Data format: [nKx, nChannels, nKy, nSlicesPerPass, nEchoes];

rcnhandle.imagemode3D = false;
rcnhandle.SWI_bitmask = 0;
% ksepi specific
if strncmp(rcnhandle_getfield(rcnhandle,'image','psd_iname'), 'ksepi', 5)
  
  rcnhandle.imagemode3D = rcnhandle_getfield(rcnhandle,'raw','user46') == 1 || rcnhandle_getfield(rcnhandle,'image','imode') == 2;
  
  if rcnhandle.imagemode3D
    rcnhandle.moco = false;
  end
  
  nVols_ExclCal = rcnhandle_getfield(rcnhandle,'raw','user47');
  
  if nVols_ExclCal > 0 && (mod(nVols_ExclCal,1) == 0) % new psd
    rcnhandle.nVols = nVols_ExclCal;
    nCalVols = rcnhandle.nRawVols - rcnhandle.nVols;
    rcnhandle.FLEET = nCalVols - rcnhandle.isIntegratedRef;
  else % old psd (remove later)
    disp('recon_epi_getarchive: old data')
    rcnhandle.nVols = rcnhandle.nRawVols - rcnhandle.isIntegratedRef;
    rcnhandle.FLEET = 0;
  end
    
  if rcnhandle.FLEET
    rcnhandle.FLEETnKy = rcnhandle_getfield(rcnhandle,'raw','user29');
  end
  
  rcnhandle.nRefLines = rcnhandle_getfield(rcnhandle,'raw','user30');
  if rcnhandle.nRefLines > 0
    rcnhandle.nEchoes = rcnhandle.nRawEchoes - 1;
  end
  
  if ~rcnhandle.useAsset && rcnhandle.nShots > 1
    % How data is acquired when multishot (not ASSET) is selected. For the
    % 'ksepi' psd, the CV ksepi_multishot_control is stored in rhuser31
    % MultiShotControl = 0: Only acquire the first shot for all volumes (like parallel imaging). Requires external PI cal (not
    % implemented)
    % MultiShotControl = 1: Acquire all shots for all volumes (GRAPPA per shot for diffusion, otherwise no PI)
    % MultiShotControl = 2: Acquire all shots for the 1st volume, only 1st shot for the remaining volumes
    % MultiShotControl = 3: Acquire all shots for the b0 volumes, only 1st shot for the remaing DWI volumes (only diffusion)
    % Options 2-3 results in GRAPPA weights estimation on the multishot data, and weights are applied to all data
    % Option 1 results in GRAPPA weights estimation on the b0 data for diffusion, applied to each DWI shot
    rcnhandle.MultiShotControl = rcnhandle_getfield(rcnhandle,'raw','user31');
  else
    rcnhandle.MultiShotControl = [];
  end
end


%% Load rowflip.param
try
  rcnhandle.rowFlipHandle = GERecon('Epi.LoadRowFlip', 'rowflip.param');
catch
  rcnhandle.rowFlipHandle = [];
end


%% Interpolate ramp sampled data (VRGF)
try
  % If there is no vrgf.dat in the *.h5 file, the following line with
  % throw an error. try-catch it so we get an empty vrgfHandle that
  % we can use as an indicator later to get the VRGF kernel by other
  % means (rhuser variables).
  rcnhandle.vrgfHandle = GERecon('RampSampling.Load', 'vrgf.dat');
  rcnhandle.kernelMatrix = GERecon('RampSampling.KernelMatrix', rcnhandle.vrgfHandle);
catch
  rcnhandle.vrgfHandle = [];
  rcnhandle.kernelMatrix = recon_epi_vrgfkernel(rcnhandle);
end

%% Read data as kspace handles to limit memory consumption

dabPacketIndex = 1;

if rcnhandle.FLEET
  for acqinvol = 1:numel(rcnhandle.SlicesPerPass)
    slicelocs = rcnhandle.geometricSliceNumber(1:rcnhandle.SlicesPerPass(acqinvol),acqinvol);
    [FLEETdata(:,:,:,slicelocs,:), rcnhandle, dabPacketIndex] = recon_epi_getcurrentpass(rcnhandle, dabPacketIndex, acqinvol);
  end
end

% Get phase correction coefficients by either using ref.h5,
% internal refscan or reflines
if rcnhandle.isIntegratedRef
  for acqinvol = 1:numel(rcnhandle.SlicesPerPass)
    slicelocs = rcnhandle.geometricSliceNumber(1:rcnhandle.SlicesPerPass(acqinvol),acqinvol);
    [refkSpace(:,:,:,slicelocs,:), rcnhandle, dabPacketIndex] = recon_epi_getcurrentpass(rcnhandle, dabPacketIndex, acqinvol);
  end
  [rcnhandle.phaseCorrectionHandle, rcnhandle.GE_refval] = recon_epi_getref(rcnhandle, refkSpace);
else
  rcnhandle.phaseCorrectionHandle = recon_epi_getref(rcnhandle);
  rcnhandle.GE_refval = [];
end

% Ghost correct FLEET data using rcnhandle.refval
if rcnhandle.FLEET
  linesToShift = rcnhandle.nKy - rcnhandle.nover - rcnhandle.FLEETnKy/2;
  FLEETdata = circshift(FLEETdata, [0 linesToShift 0 0]); % match lines for ghost corr
  rcnhandle.FLEETvol = recon_epi_refvrgfcurrentpass(FLEETdata, rcnhandle);
  emptyLines = sum(abs(rcnhandle.FLEETvol(:,:,1)),1) == 0;
  rcnhandle.FLEETvol = rcnhandle.FLEETvol(:,~emptyLines,:,:,:); % remove empty ky lines
end


% Read data from disk
passCounter = 1;
while dabPacketIndex <= rcnhandle.ControlCount
  
  acqinvol = recon_pass(rcnhandle, passCounter, 'acqindxvol');
  volindx  = recon_pass(rcnhandle, passCounter, 'volindx');
  
  slicelocs = rcnhandle.geometricSliceNumber(1:rcnhandle.SlicesPerPass(acqinvol), acqinvol);
  
  % Get the data for current pass (does also rowflip)
  [kspace.data(:,:,:,slicelocs,:), rcnhandle, dabPacketIndex, refLines] = recon_epi_getcurrentpass(rcnhandle, dabPacketIndex, acqinvol);
  
  if ~isempty(kspace.data)
    if acqinvol == recon_pass(rcnhandle, passCounter, 'nacqspervol') % last acq in vol
      if ~isempty(refLines)
        refLines = refLines(:,:,:,slicelocs,:,:); % Temporal to spatial slice index
        for shot = 1:size(refLines,6)
          [rcnhandle.phaseCorrectionHandle, rcnhandle.dynamicGERefval{volindx}(:,:,:,:,:,shot)] = recon_epi_getref(rcnhandle, refLines(:,:,:,:,:,shot));
        end
      end
      if strcmp(userInput.Results.tempdata, 'disk')
        % save kspace to disk and return handle to matfile
        fname = sprintf('e%ds%03dv%04d.mat', rcnhandle.ExamNumber, rcnhandle.SeriesNumber, volindx);
        kspacehandle{volindx} = savestruct(fname, kspace); % supports only real data, splitting up in 'data' and 'data_i'
      else
        kspacehandle{volindx} = kspace.data;
      end
    end
    passCounter = passCounter + 1;
  end
  
end % while dabPacketIndex

clear kspace;

rcnhandle.nVols = numel(kspacehandle);


%% PURE Calibration
purefiles = dir(sprintf('calib/Pure*ID%d*h5', rcnhandle.DownloadData.rdb_hdr_ps.calUniqueNo));

if isempty(purefiles)
  purefiles = dir(sprintf('calib/Pure*h5'));
end

if ~isempty(purefiles)
  rcnhandle.calHandle = GERecon('Pure.LoadCalibration', [purefiles(end).folder filesep purefiles(end).name]);
else
  rcnhandle.calHandle = [];
end

end
