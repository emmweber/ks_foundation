function kspacehandle = recon_epi_refvrgfcurrentpass(kspacehandle, rcnhandle, volIndx)
% Data format: [nKx, nKy, nChannels, nSlicesPerPass, nEchoes];

rawkSpace = getdata(kspacehandle);

ksz = size(rawkSpace); ksz(end+1:5) = 1;

% Ghost (a.k.a. ref or phase) correction
xind = ((-(rcnhandle.nKx-1)/2:(rcnhandle.nKx-1)/2)).'; % array with kx indices
if isfield(rcnhandle, 'dynamicGERefval') % dynamic phase correction (per volume and shot)  
  dynamicGERefval = rcnhandle.dynamicGERefval{volIndx};
  for shot = 1:size(dynamicGERefval,6)
    coeff0 = dynamicGERefval(:,shot:rcnhandle.nShots:end,:,:,1,shot);
    coeff1 = dynamicGERefval(:,shot:rcnhandle.nShots:end,:,:,2,shot);
    
    lastPair = false; % unclear which is the better method of the two:
    if lastPair % pick out last line pair and repeat
      coeff0 = repmat(coeff0(:,size(coeff0, 2)-1:end,:,:), [1, size(rawkSpace,2)/(2*rcnhandle.nShots), 1, 1]);
      coeff1 = repmat(coeff1(:,size(coeff1, 2)-1:end,:,:), [1, size(rawkSpace,2)/(2*rcnhandle.nShots), 1, 1]);
    else % average over all line pairs and repeat
      coeff0 = repmat([mean(coeff0(:,1:2:end,:,:),2), mean(coeff0(:,2:2:end,:,:),2)], [1, size(rawkSpace,2)/(2*rcnhandle.nShots), 1, 1]);
      coeff1 = repmat([mean(coeff1(:,1:2:end,:,:),2), mean(coeff1(:,2:2:end,:,:),2)], [1, size(rawkSpace,2)/(2*rcnhandle.nShots), 1, 1]);
    end
        
    phasecorr = exp(1i*((coeff1 .* xind) + coeff0));
    hybridspace = cft(rawkSpace(:,shot:rcnhandle.nShots:end,:,:,:),[-1 0]);
    hybridspace = hybridspace .* phasecorr;
    rawkSpace(:,shot:rcnhandle.nShots:end,:,:,:) = cft(hybridspace,[1 0]);
  end % shots
  
else  % static phase correction (same for all volumes and shots)
  % This is identical to GERecon('Epi.ApplyPhaseCorrection') but much faster
  coeff0 = rcnhandle.GE_refval(:,:,:,:,1);
  coeff1 = rcnhandle.GE_refval(:,:,:,:,2);
  
  if size(rcnhandle.GE_refval, 4) < size(rawkSpace, 4)
    coeff0 = mean(coeff0, 4);
    coeff1 = mean(coeff1, 4);
  end
  
  % phasecorr = exp(1i*bsxfun(@plus, bsxfun(@times, GEcoeff1, xind), GEcoeff0)); % pre Matlab2016b
  phasecorr = exp(1i*((coeff1 .* xind) + coeff0));
  hybridspace = cft(rawkSpace,[-1 0]);
  hybridspace = hybridspace .* phasecorr;
  rawkSpace  = cft(hybridspace,[1 0]);
end

clear kSpace

% VRGF (rampsampling) correction
% output kspace size

if ismatrix(rcnhandle.kernelMatrix)
  % identical with the loop but 4 times faster
  kSpace.data = reshape(rcnhandle.kernelMatrix*rawkSpace(:,:), [rcnhandle.nx ksz(2:end)]);
else
  kSpace.data = zeros(rcnhandle.nx, rcnhandle.nKy, rcnhandle.nChannels, rcnhandle.Slices, rcnhandle.nEchoes, rcnhandle.data_precision);
  for z = 1:rcnhandle.Slices % spatial slice index
    for echo = 1:ksz(5)
      for channel=1:rcnhandle.nChannels
        if ~isempty(rcnhandle.vrgfHandle)
          % kernelMatrix = GERecon('RampSampling.KernelMatrix', rcnhandle.vrgfHandle);
          kSpace.data(:,:,channel,z,echo) = GERecon('RampSampling.Interpolate', rcnhandle.vrgfHandle, rawkSpace(:,:,channel,z,echo));
        elseif ismatrix(rcnhandle.kernelMatrix)
          error('Need to have either kernelMatrix or vrgfHandle');
        end
      end
    end
  end
end

% fast save to disk and return handle
if isa(kspacehandle,'matlab.io.MatFile') && isprop(kspacehandle,'Properties') && isprop(kspacehandle.Properties,'Source')
  kspacehandle = savestruct(kspacehandle.Properties.Source, kSpace);
else
  kspacehandle = kSpace.data;
end

end

