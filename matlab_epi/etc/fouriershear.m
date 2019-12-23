function s = fouriershear(d, x, dim)
%
% Lossless shearing of a 2D image
%
% FORMAT s = shear(d, x, dim)
%
% Inputs:
%
%  d    : 2D data to be sheared
%  x    : shearing amount (in # pixels)
%  dim  : In which dimension to shear (1 or 2)
%
% Output:
%  s    : sheared image of d
%
%_____________________________________________________________
% 2014-07-02
% Stefan Skare, Karolinska University Hospital
% Stockholm, Sweden
%_____________________________________________________________

if nargin < 3 || ~isnumeric(x) ||  ~isnumeric(dim) || dim < 1 || dim > 2
  help shear
  return
end


sz = size(d);

if dim == 2
  punit = linspace(-pi/2, pi/2, sz(2));
  y = linspace(-1,1, sz(1))' * x;
  P = repmat(punit,[sz(1) 1]) .* repmat(y,[1 sz(2)]);
elseif dim == 1
  y = linspace(-pi/2, pi/2, sz(2))';
  punit = linspace(-1,1, sz(1)) * x;
  P = repmat(punit,[sz(1) 1]) .* repmat(y,[1 sz(2)]);
end

if numel(sz) > 2
  P = repmat(P, [1 1 sz(3:end)]);
end

if isreal(d)
  D = ifftshift(ifft(ifftshift(d,dim),[],dim), dim);
  D = D .* exp(1i * P);
  s = fftshift(fft(fftshift(D,dim),[],dim),dim);
  s = abs(s);
else
  Dre = ifftshift(ifft(ifftshift(real(d),dim),[],dim), dim);
  Dim = ifftshift(ifft(ifftshift(imag(d),dim),[],dim), dim);
  Dre = Dre .* exp(1i * P);
  Dim = Dim .* exp(1i * P);
  sre = fftshift(fft(fftshift(Dre,dim),[],dim),dim);
  sim = fftshift(fft(fftshift(Dim,dim),[],dim),dim);
  s = abs(sre) + 1i * abs(sim);
end

end

