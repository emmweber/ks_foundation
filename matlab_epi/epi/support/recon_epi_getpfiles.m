function [kspacehandle, rcnhandle] = recon_epi_getpfiles(userInput)

warning('recon_epi_getpfiles: This function is no longer maintained. Please migrate to Scan Archives soon');

rcnhandle = pfile_load([], userInput.Results.dataprecision);
rcnhandle.userInput = userInput.Results;


%% Asset
rcnhandle.useAsset = 0;


%% Parameter and variable initialization
% Data format: [nKx, nChannels, nKy, nSlicesPerPass, nEchoes];

% ksepi specific
if strncmp(rcnhandle_getfield(rcnhandle,'image','psd_iname'), 'ksepi', 5)
  
  nVols_ExclCal = rcnhandle_getfield(rcnhandle,'raw','user47');
  
  if nVols_ExclCal > 0 && (mod(nVols_ExclCal,1) == 0) % new psd
    rcnhandle.nVols = nVols_ExclCal;
    nCalVols = rcnhandle.nRawVols - rcnhandle.nVols;
    rcnhandle.FLEET = nCalVols - rcnhandle.isIntegratedRef;
  else % old psd (remove later)
    disp('recon_epi_getpfiles: old data')
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


%% Interpolate ramp sampled data (VRGF)
try
  rcnhandle.vrgfHandle   = GERecon('RampSampling.Load', 'vrgf.dat');
  rcnhandle.kernelMatrix = GERecon('RampSampling.KernelMatrix', rcnhandle.vrgfHandle);
catch
  rcnhandle.vrgfHandle = [];
  rcnhandle.kernelMatrix = recon_epi_vrgfkernel(rcnhandle);
end


%% Read data as kspace handles to limit memory consumption

passCounter = 1;

if rcnhandle.FLEET
  for acqinvol = 1:numel(rcnhandle.SlicesPerPass)
    slicelocs = rcnhandle.geometricSliceNumber(1:rcnhandle.SlicesPerPass(acqinvol),acqinvol);
    FLEETdata(:,:,:,slicelocs,:) = recon_epi_getcurrentpfilepass(rcnhandle, passCounter); passCounter = passCounter + 1;
  end
end

% Get phase correction coefficients by either using ref.h5,
% internal refscan or reflines
if rcnhandle.isIntegratedRef
  for acqinvol = 1:numel(rcnhandle.SlicesPerPass)
    slicelocs = rcnhandle.geometricSliceNumber(1:rcnhandle.SlicesPerPass(acqinvol),acqinvol);
    refkSpace(:,:,:,slicelocs,:) = recon_epi_getcurrentpfilepass(rcnhandle, passCounter); passCounter = passCounter + 1;
  end
  [rcnhandle.phaseCorrectionHandle, rcnhandle.refval] = recon_epi_getref(rcnhandle, refkSpace, rcnhandle.isIntegratedRef);
else
  [rcnhandle.phaseCorrectionHandle, rcnhandle.refval] = recon_epi_getref(rcnhandle);
end

% Ghost correct FLEET data using rcnhandle.refval
if rcnhandle.FLEET
  linesToShift = rcnhandle.nKy - rcnhandle.nover - rcnhandle.FLEETnKy/2;
  FLEETdata = circshift(FLEETdata, [0 linesToShift 0 0]); % match lines for ghost corr
  rcnhandle.FLEETvol = recon_epi_refvrgfcurrentpass(FLEETdata, rcnhandle);
  emptyLines = sum(abs(rcnhandle.FLEETvol(:,:,1)),1) == 0;
  rcnhandle.FLEETvol = rcnhandle.FLEETvol(:,~emptyLines,:,:,:); % remove empty ky lines
end

% number of passes not belonging to image volume to be reconstructed
numCalPasses = passCounter - 1;

% Read data from disk
passCounter = 1;
garbagePasses = 0;
while passCounter + numCalPasses <= rcnhandle.nPasses
  
  acqinvol = recon_pass(rcnhandle, passCounter - garbagePasses, 'acqindxvol');
  volindx  = recon_pass(rcnhandle, passCounter - garbagePasses, 'volindx');
  
  slicelocs = rcnhandle.geometricSliceNumber(1:rcnhandle.SlicesPerPass(acqinvol), acqinvol);
  
  % Get the data for current pass (does also rowflip)
  [kspace.data(:,:,:,slicelocs,:), refLinesInPass] = recon_epi_getcurrentpfilepass(rcnhandle, passCounter + numCalPasses); passCounter = passCounter + 1;
  rsz = size(refLinesInPass);
  
  if ~isempty(kspace.data)
    if ~isempty(refLinesInPass)
      if ~exist('refLines','var')
        rsz(4) = rcnhandle.Slices;
        refLines = zeros(rsz,'like',refLinesInPass);
      end
      refLines(:,:,:,slicelocs,:,:) = refLinesInPass;
    end
    if acqinvol == recon_pass(rcnhandle, passCounter, 'nacqspervol') % last acq in vol
      if ~isempty(refLinesInPass)
        [rcnhandle.phaseCorrectionHandle, rcnhandle.dynamicRefval{volindx}] = recon_epi_getref(rcnhandle, refLines, false);
      end
      % save kspace to disk and return handle to matfile
      fname = sprintf('e%ds%03dv%04d.mat', rcnhandle.ExamNumber, rcnhandle.SeriesNumber, volindx);
      kspacehandle{volindx} = savestruct(fname, kspace);
    end
  else
    garbagePasses = garbagePasses + 1;
  end
  
end % while dabPacketIndex

clear kspace;

rcnhandle.nVols = numel(kspacehandle);


%% PURE Calibration
purefiles = dir('WHEREISPUREDATAFOR_PFILES_PREDV26');
if ~isempty(purefiles)
  rcnhandle.calHandle = GERecon('Pure.LoadCalibration', purefiles(1).name);
else
  rcnhandle.calHandle = [];
end

end
