function sI = smooth(I,f)
% Gaussian 2D smoothing (dimensions 1 and 2) of an ND array
% Usage:
% smoothed_image = smooth(image, fwhm);
% --------------------------------------------------------------------
% Stefan Skare. Dept of Neuroradiology, Karolinska University Hospital
% V1.1: Normalized the intensity of the output

if f <= 0
    sI = I;
    return
end

G = gausswin(f)*gausswin(f)';
sI = imfilter(I,G,'conv');
sI = sI * (mean(I(:)) / mean(sI(:)));
