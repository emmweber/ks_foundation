function [I, rcnhandle, dicom_prefix] = recon_epi_reconcurrentpass3D(kspacehandle, rcnhandle, userInput)
% kspace data format:       [nKx, nKy, nChannels, nSlices, nEchoes];
% output image data format: [nx,  ny,  nSlices, nEchoes, NContrasts];

kspace = getdata(kspacehandle);

ksz = size(kspace); ksz(end+1:5) = 1;

% need to use same x and y size for final image or Gradwarp will crash
fovratio = rcnhandle_getfield(rcnhandle,'image','dfov_rect') ./ rcnhandle_getfield(rcnhandle,'image','dfov');

havegot_coilsensitivity = isfield(rcnhandle, 'coilSensitivityField'); % if done on previous volume, don't do it again


if rcnhandle.SWI_bitmask
  N_contrasts = 0;
  dicom_prefix = [];
  oper = {};
  if bitget(rcnhandle.SWI_bitmask, 1)
    dicom_prefix{end+1} = '';
    N_contrasts = N_contrasts + 1;
    oper{N_contrasts} = 'abs';
  end
  
  if bitget(rcnhandle.SWI_bitmask, 2)
    dicom_prefix{end+1} = 'SWI';
    N_contrasts = N_contrasts + 1;
    oper{N_contrasts} = 'abs';
  end
  
  if bitget(rcnhandle.SWI_bitmask, 3)
    dicom_prefix{end+1} = 'SWIphase';
    N_contrasts = N_contrasts + 1;
    oper{N_contrasts} = 'real';
  end
else
  dicom_prefix{1} = '';
  N_contrasts = 1;
  oper{N_contrasts} = 'abs';
end

for z = 1:ksz(4)
  for echo = 1:ksz(5)
    
    if rcnhandle_getfield(rcnhandle,'raw','hnover') == 0
      % Full Fourier
      channelImages = cft(kspace(:,:,:,z,echo), [-1 -1]);
    elseif rcnhandle_getfield(rcnhandle,'raw','hnover') > 0
      % Partial Fourier (assumes for now only in ky, with the peak at the bottom of
      % k-space (PSD & inituition) = right in kspace array here
      % For SWI always POCS is needed to preserve phase information
      channelImages = pocs(kspace(:,:,:,z,echo), rcnhandle_getfield(rcnhandle,'raw','hnover'), 'right');
    end
    
    if ~exist('I','var')
      % test run to learn about final recon size
      tmp = run_postprocessing(abs(GERecon('SumOfSquares', channelImages)), rcnhandle, rcnhandle.sliceInfo(z), userInput.Results.fermi);
      I = zeros([size(tmp) ksz(4:5) N_contrasts], 'like', kspace);
    end
    
    if rcnhandle.SWI_bitmask
      [SWI, SWI_phase] = swi_filter(channelImages, 'fovratio', fovratio); % perform SWI filtering
      
      if bitget(rcnhandle.SWI_bitmask, 1)
        index = ~contains(dicom_prefix,'SWI'); % not SWI processed
        [I(:,:,z,echo,index), coilSensitivityField] = run_postprocessing(GERecon('SumOfSquares', channelImages), rcnhandle, rcnhandle.sliceInfo(z), userInput.Results.fermi);
      end
      if bitget(rcnhandle.SWI_bitmask, 2)
        index = endsWith(dicom_prefix,'SWI');
        I(:,:,z,echo,index) = run_postprocessing(GERecon('SumOfSquares', SWI), rcnhandle, rcnhandle.sliceInfo(z), userInput.Results.fermi);
      end
      if bitget(rcnhandle.SWI_bitmask, 3)
        index = endsWith(dicom_prefix,'SWIphase');
        I(:,:,z,echo,index) = run_postprocessing(SWI_phase, rcnhandle, rcnhandle.sliceInfo(z), userInput.Results.fermi);
      end
    else
      [I(:,:,z,echo,1), coilSensitivityField] = run_postprocessing(GERecon('SumOfSquares', channelImages), rcnhandle, rcnhandle.sliceInfo(z), userInput.Results.fermi);
      I(:,:,z,echo,1) = I(:,:,z,echo,1);
    end
    
    if echo == 1 && exist('coilSensitivityField', 'var') && ~isempty(coilSensitivityField) && ~havegot_coilsensitivity
      rcnhandle.coilSensitivityField(:,:,z) = coilSensitivityField;
      rcnhandle.coilSensitivityFieldLabel = 'p';
    end
    
  end % echo
end % slice location (z)

% to be added, rh variable from psd to control z fermi filtering
if true
  z_size = size(I,3);
  z_fermi = fermi(z_size, z_size * 0.48, 6);
  z_fermi = reshape(z_fermi(:,floor(z_size/2)),1,1,[]); 
  I = cft(cft(I,[0 0 1]) .* z_fermi,[0 0 -1]);
end

% abs or real depending on the output
for j = 1:N_contrasts
  if strcmp(oper{j},'abs')
    I(:,:,:,:,j) = abs(I(:,:,:,:,j));
  elseif strcmp(oper{j},'real')
    I(:,:,:,:,j) = real(I(:,:,:,:,j));
  end
end


end % recon_epi_reconcurrentpass3D


% this is a nested function with access to all variables in the mmain
% function, we use it
function [rotatedTransposedSlice, coilSensitivityField] = run_postprocessing(images, rcnhandle, sliceInfo, use_fermi)

% back to k-space for Fermi filtering and zerofilling (which is cheap after coil combine)
k = cft(images,[1 1]);
ksz = size(k);

% need to use same x and y size for final image or Gradwarp will crash
reconSize = max([rcnhandle.nRecX rcnhandle.nRecY ksz(1:2)]);

% Fermi
if use_fermi
  if ~exist('F', 'var')
    F = adaptivefermi(size(k));
  end
  k = k .* F;
end

% zerofill to square matrix size (otherwise gradwarp will crash)
k = zerofill(k, [1 1] * reconSize);

% return to image domain again for Gradwarp and image reorientation
images = cft(k, [-1 -1]);

% Zero out kissoff views
kissoffViews = rcnhandle_getfield(rcnhandle,'raw','kissoff_views');
images(:,1:kissoffViews) = 0;
images(:,(end-kissoffViews+1):end) = 0;

% Gradwarp
% Note 1: Gradwarp must have size(channelCombinedImage,1) == size(channelCombinedImage,2)
% Note 2: When phaseFOV < 1 (rarely for EPI when Freqdir = L/R, but still), then GERecon('Gradwarp')
% not only performs the gradwarp, but also add black bands on the sides of the image to make FOV square
% (and pixel size square) based on rcnhandle.sliceInfo(z).Corners points
gradwarpImage = GERecon('Gradwarp', images, sliceInfo.Corners, 'XRMW');

if nargout >= 2 && rcnhandle_getfield(rcnhandle, 'raw', 'pure') && ~isempty(rcnhandle.calHandle)
  [~, c] = GERecon('Pure2.Apply', gradwarpImage, sliceInfo.Corners);
  coilSensitivityField = 1./c;
  coilSensitivityField(~isfinite(coilSensitivityField)) = Inf;
  coilSensitivityField = GERecon('Orient', coilSensitivityField, sliceInfo.Orientation);
else
  coilSensitivityField = [];
end

% Rotate/Transpose
rotatedTransposedSlice = GERecon('Orient', gradwarpImage, sliceInfo.Orientation);

end

