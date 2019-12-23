function kSpace = recon_epi_applygrappa(kspacehandle, rcnhandle, volIndx)

% input size:  [nKx, nKy, nChannels, nSlices, nEchoes]
% output size: [nKx, nKy, nChannels, nSlices, nEchoes, magnitudeNex]

if ~(rcnhandle.nShots > 1  && isfield(rcnhandle,'grappaWeights') && ~isempty(rcnhandle.grappaWeights)) || ...
    ~rcnhandle.isDiffusion && volIndx <= rcnhandle.nCalVolumes
  % R=1, we don't have grappaweights, or non-diffusion and multishot volume (volIndx <= nCalVolumes)
  % then output = input (disk -> mem as necessary)
  kSpace = getdata(kspacehandle);
  return;
end

ksz = [rcnhandle.nx, rcnhandle.nKy, rcnhandle.nChannels, rcnhandle.Slices, rcnhandle.nEchoes];

if rcnhandle.isDiffusion
  % diffusion EPI (apply GRAPPA on each shot (b0 and DWI) and use as magnitude NEX)
  if (rcnhandle.MultiShotControl == 1) || (volIndx <= rcnhandle.nCalVolumes)
    multiShotAsNex = rcnhandle.nShots;
  else
    multiShotAsNex = 1;
  end
  kSpace = zeros([ksz multiShotAsNex], rcnhandle.data_precision); % do multiShotNEX over dimension 6
  
  mShotkSpace = getdata(kspacehandle); % load from mat file to complex array or from mem (rcnhandle.UserInput.tempdata)
  
  for shotNex = 1:multiShotAsNex
    thisShot = zeros(ksz, rcnhandle.data_precision);
    thisShot(:,shotNex:rcnhandle.nShots:end,:,:,:) = mShotkSpace(:,shotNex:rcnhandle.nShots:end,:,:,:);
    % each shot GRAPPA synthesized and stored as sep. k-space
    kSpace(:,:,:,:,:,shotNex) = grappa(thisShot, rcnhandle.grappaWeights);
  end
  
else
  
  % non-diffusion EPI (apply GRAPPA only on undersampled data)
  if volIndx > rcnhandle.nCalVolumes
    kSpace = grappa(getdata(kspacehandle), rcnhandle.grappaWeights);
  end
  
end

end

