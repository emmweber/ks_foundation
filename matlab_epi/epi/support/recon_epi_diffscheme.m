%%
function [D,nT2Images,nDiffusionDirections,allbValues,reconAllDWIFlag] = recon_epi_diffscheme(rcnhandle)

isDiffusion = bitget(rcnhandle_getfield(rcnhandle,'raw','data_collect_type1'), 22);

if ~isfield(rcnhandle,'isIntegratedRef')
  isIntegratedStaticPC = rcnhandle_getfield(rcnhandle,'raw','ref') == 5;
  isIntegratedRefBitSet = bitget(rcnhandle_getfield(rcnhandle,'raw','pcctrl'), 5);
  isIntegratedRef = isIntegratedStaticPC || isIntegratedRefBitSet || isDiffusion;
else
  isIntegratedRef = rcnhandle.isIntegratedRef;
end

% with integrated ref scan, a leading extra volume is played out without
% phase encoding blips. Need to subtract that here to get #image volumes
% if a FLEET calibration volume is acquired, it must also be subtracted
if ~isfield(rcnhandle,'FLEET')
  rcnhandle.FLEET = 0;
end

D = [];

nVolsAfterRef        = recon_pass(rcnhandle, [], 'nvols') - isIntegratedRef - rcnhandle.FLEET;

if rcnhandle.isDiffusion
  
  nbValues             = rcnhandle_getfield(rcnhandle,'raw','numbvals');
  allbValues           = rcnhandle_getfield(rcnhandle,'raw','bvalstab'); allbValues = allbValues(1:nbValues);
  if all(allbValues == 0)
    allbValues = 1000 * ones(1,nbValues);
  end
  
  nDiffusionDirections = rcnhandle_getfield(rcnhandle,'raw','numdifdirs'); % rhnumdifdirs
  reconAllDWIFlag      = (rcnhandle_getfield(rcnhandle,'raw','dp_type') == 3); % psd: rhdptype
  tensorFlag           = (rcnhandle_getfield(rcnhandle,'raw','user_usage_tag') == 2); % psd: rhuser_usage_tag = DTI_PROC;
  nonTensorDirCtrl     = rcnhandle_getfield(rcnhandle,'image','dfax'); % 1:x 2:y 3:z => 7:all
  nT2Images            = nVolsAfterRef - (nbValues * nDiffusionDirections);
  
  D(1:nT2Images,1:3) = 0;
  if tensorFlag
    diffdirs = recon_epi_readtensordat(nDiffusionDirections);
  else
    if nonTensorDirCtrl == 7 % all
      diffdirs = eye(3);
    elseif nonTensorDirCtrl == 1 % x
      diffdirs = [1 0 0];
    elseif nonTensorDirCtrl == 2 % y
      diffdirs = [0 1 0];
    elseif nonTensorDirCtrl == 4 % z
      diffdirs = [0 0 1];
    end
  end
  
  for j = 1:nbValues
    D((nT2Images+nDiffusionDirections*(j-1)+1):(nT2Images+nDiffusionDirections*j),:) = diffdirs;
  end
  
else
  
  nT2Images = nVolsAfterRef;
  nDiffusionDirections = 0;
  allbValues = [];
  reconAllDWIFlag = [];
  
end

end
