%
% Centered FFT along multiple dimensions of an ND-array
%
% Usage:
%
% fftdata = cft(data); % defaults to 2D inverse FFT
%
% fftdata = cft(data, oper);
%
% where oper should be an array containing integers -1, 0 or 1
% with the following meaning:
%  1: Forward Fourier transform
% -1: Inverse Fourier transform
%  0: No action
%
% For a 4D array ('data'), with forward Fourier transform along
% the first dimension and inverse Fourier transform along the
% third dimension would be:
%
% oper = [1 0 -1]
% fftdata = cft(data, oper);
%
% When oper has fewer elements than the dimensions of data, no
% transformation is performed on dimensions higher than numel(oper).
% ------------------------------------------------------
% Stefan Skare, Nov 2017, Karolinska University Hospital
%
function [x,oper] = cft(x, oper)

nd = ndims(x); % number of dimensions

if nargin < 2
  oper(1:2) = -1; % Inverse FFT2 if oper is missing
elseif ~(isvector(oper) && isnumeric(oper) && numel(oper) <= nd)
  error('cft: 2nd arg must be a numeric array with max length %d', nd);
end
if numel(oper) > nd
  oper = oper(1:nd); % remove excess dimensions
end

if ismatrix(x) && size(x,1) == 1
  x = x.';
  transposeback = true;
else
  transposeback = false;
end

%% Forward and inverse Fourier transforms

for j = 1:numel(oper)  
  if oper(j) > 0
      x = fftshift(  fft( fftshift(x,j),[],j),j); % forward centered fft
  elseif oper(j) < 0
      x = ifftshift(ifft(ifftshift(x,j),[],j),j);  % inverse centered fft
  end
end

if transposeback
  x = x.';
end


end
