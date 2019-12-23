function [I, rcnhandle] = recon_epi_reconcurrentpass(kspacehandle, rcnhandle, userInput)
% kspace data format:       [nKx, nKy, nChannels, nSlices, nEchoes, magnitudeNex];
% output image data format: [nx,  ny,  nSlices, nEchoes, magnitudeNex];

kspace = getdata(kspacehandle);

ksz = size(kspace); ksz(end+1:6) = 1;
magnitudeNex = ksz(6);

% need to use same x and y size for final image or Gradwarp will crash
reconSize = max([rcnhandle.nRecX rcnhandle.nRecY ksz(1:2)]);

havegot_coilsensitivity = isfield(rcnhandle, 'coilSensitivityField'); % if done on previous volume, don't do it again

for z = 1:ksz(4)
  for echo = 1:ksz(5)
    
    % Reconstruct each channel
    if rcnhandle.useAsset && rcnhandle.nover
      % to fit low/high pass filtered image. Output change from GERecon('Transform') in this case
      channelImages = zeros(rcnhandle.nRecX, rcnhandle.nRecY, rcnhandle.nChannels, 2, class(kspace));
    else
      channelImages = zeros(rcnhandle.nRecX, rcnhandle.nRecY, rcnhandle.nChannels, class(kspace));
    end
    
    for magnex = 1:magnitudeNex
      
      if rcnhandle_getfield(rcnhandle,'raw','hnover') == 0
        % Full Fourier
        channelImages = cft(kspace(:,:,:,z,echo,magnex), [-1 -1]);
      elseif rcnhandle_getfield(rcnhandle,'raw','hnover') > 0
        % Partial Fourier (assumes for now only in ky, with the peak at the bottom of
        % k-space (PSD & inituition) = right in kspace array here
        if strcmp(userInput.Results.halffourier,'homodyne')
          channelImages = homodyne(kspace(:,:,:,z,echo,magnex), rcnhandle_getfield(rcnhandle,'raw','hnover'), 'right');
        else
          channelImages = pocs(kspace(:,:,:,z,echo,magnex), rcnhandle_getfield(rcnhandle,'raw','hnover'), 'right');
        end
      end           
           
      % Channel combine processing - either Sum of Squares or ASSET
      if (rcnhandle.useAsset)
        % This will break for partial Fourier as it expects size
        % [x,y,channel,2]. Figure out what GERecon('Transform') does for pFourier ASSET
        channelCombinedImage = abs(GERecon('Asset.Unalias', channelImages, rcnhandle.sliceInfo(z).Corners));
      else
        % channelCombinedImage = abs(GERecon('SumOfSquares', channelImages));
        channelCombinedImage = sumsq(abs(channelImages)); % 3x faster, but does not honor the noise info
      end
      
      % back to k-space for Fermi filtering and zerofilling (which is cheap after coil combine)
      k = cft(channelCombinedImage,[1 1]);
      
      % Fermi
      if userInput.Results.fermi
        if z == 1 && echo == 1
          F = adaptivefermi(size(k));
        end
        k = k .* F;
      end

      
      % zerofill to square matrix size (otherwise gradwarp will crash)
      k = zerofill(k, [1 1] * reconSize);
      
      % return to image domain again for Gradwarp and image reorientation
      channelCombinedImage = cft(k, [-1 -1]);
      
      % Zero out kissoff views
      kissoffViews = rcnhandle_getfield(rcnhandle,'raw','kissoff_views');
      channelCombinedImage(:,1:kissoffViews) = 0;
      channelCombinedImage(:,(end-kissoffViews+1):end) = 0;
      
      % Gradwarp
      % Note 1: Gradwarp must have size(channelCombinedImage,1) == size(channelCombinedImage,2)
      % Note 2: When phaseFOV < 1 (rarely for EPI when Freqdir = L/R, but still), then GERecon('Gradwarp')
      % not only performs the gradwarp, but also add black bands on the sides of the image to make FOV square
      % (and pixel size square) based on rcnhandle.sliceInfo(z).Corners points
      gradwarpImage = GERecon('Gradwarp', channelCombinedImage, rcnhandle.sliceInfo(z).Corners, 'XRMW');
      
      % Get coil sensitivity for PURE
      % Put this the if-statement below to only do PURE if PURE menu was selected during scan: 
      % Without this, PURE will be done always unless there's no PURE calibration data
      if nargout > 1 && rcnhandle_getfield(rcnhandle, 'raw', 'pure') && ~isempty(rcnhandle.calHandle) && strcmp(rcnhandle.calHandle.HandleType,'PureCalibration') && ~havegot_coilsensitivity && echo == 1 && magnex == 1
        [~, c] = GERecon('Pure2.Apply', gradwarpImage, rcnhandle.sliceInfo(z).Corners);
        coilSensitivityField = 1./c;
        coilSensitivityField(~isfinite(coilSensitivityField)) = Inf;
        coilSensitivityField = GERecon('Orient', coilSensitivityField, rcnhandle.sliceInfo(z).Orientation);
        rcnhandle.coilSensitivityField(:,:,z) = coilSensitivityField;
        rcnhandle.coilSensitivityFieldLabel = 'p';
      end  

      % Rotate/Transpose
      rotatedTransposedSlice = GERecon('Orient', gradwarpImage, rcnhandle.sliceInfo(z).Orientation);
      
      if ~exist('I','var')
        I = zeros([size(rotatedTransposedSlice) ksz(4:6)], 'like', kspace);
      end
      I(:,:,z,echo,magnex) = rotatedTransposedSlice;
      
    end % magnex
    
  end % echo
end % slice location (z)

end % recon volume

