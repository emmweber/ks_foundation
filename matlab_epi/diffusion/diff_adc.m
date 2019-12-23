function adc = diff_adc(t2w, dwi, bvalue)
% size(t2w) = [Nx, Ny, reps]
% size(dwi) = [Nx, Ny, dirs]


checkT2wdata = @(x) (isnumeric(x) && min(size(x(:,:,1))) > 8 && ndims(x) >= 2 && ndims(x) <= 3 && ndims(x) <= ndims(dwi));
checkDWIdata = @(x) (isnumeric(x) && min(size(x(:,:,1))) > 8 && ndims(x) >= 2 && ndims(x) <= 4);
checkbvalue = @(x) (isnumeric(x) && x > 0 && x <= 50000);

parm = inputParser;
addRequired(parm, 't2w', checkT2wdata);
addRequired(parm, 'dwi', checkDWIdata);
addRequired(parm, 'bvalue', checkbvalue);
parse(parm, t2w, dwi, bvalue);

% ADC

dwisz = size(dwi);
if ndims(t2w) == ndims(dwi)
  ndirs = 1;
else
  ndirs = dwisz(end);
  dwisz = dwisz(1:end-1);
end

adc = zeros([ndirs dwisz], 'like', t2w);

for d = 1:ndirs
  if ndims(t2w) == 3
    adc(d,:,:,:) = log(abs(t2w) ./ abs(dwi(:,:,:,d))) / bvalue * 1e6;
  elseif ismatrix(t2w)
    adc(d,:,:)   = log(abs(t2w) ./ abs(dwi(:,:,d)))   / bvalue * 1e6;
  end
end

% set NaN's, inf's, negative ADC values and all pixels outside 'msk' to zero
adc(~isfinite(adc)) = 0; 
adc(adc<0) = 0;

end
