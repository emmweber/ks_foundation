function [peakpos] = kspace_peak(kspace)
% size(kspace) = [Nkx Nky Ncoils Nslices ...]

kmap = mean(abs(kspace(:,:,:)), 3);
freq  = mean(kmap,2);
phase = mean(kmap,1);
[~, peakpos(1)] = max(freq(:));
[~, peakpos(2)] = max(phase(:));

end
