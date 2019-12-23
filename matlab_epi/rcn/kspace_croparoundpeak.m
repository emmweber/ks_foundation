function [croppedkspace, rfreq, rphase] = kspace_croparoundpeak(kspace, newsize)
% size(kspace) = [Nkx Nky Ncoils Nslices ...]

if nargin < 2
  error('kspace_croparoundpeak: 2nd arg must be a 1x2 array with the new size');
end

ksz = size(kspace);

if isscalar(newsize)
  newsize = [newsize newsize];
end
newsize = min([newsize(1) newsize(2) ; ksz(1:2)]); % don't exceed acquired k-space

peak = kspace_peak(kspace);

half_newsize = ceil(newsize / 2);
rfreq  = peak(1) + (-half_newsize(1):(half_newsize(1)-1));
rphase = peak(2) + (-half_newsize(2):(half_newsize(2)-1));
rfreq  = rfreq(:)  + (min(rfreq)  < 1) * (abs(min(rfreq))  + 1) - (max(rfreq)  > ksz(1)) * (max(rfreq)  - ksz(1));
rphase = rphase(:) + (min(rphase) < 1) * (abs(min(rphase)) + 1) - (max(rphase) > ksz(2)) * (max(rphase) - ksz(2));


croppedkspace = kspace(rfreq, rphase, :,:,:,:,:,:,:);

end
