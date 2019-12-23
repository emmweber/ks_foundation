function drot = fourierrot(d, phi)
%
% Lossless rotation of a 2D image via 3 consecutive shears.
% If the input image is not square, it will be zeropadded before rotation
%
% FORMAT drot = rot(d, phi);
%
% Inputs:
%
%  d    : 2D data to be rotated
%  phi  : rotation degrees (must be strict -90 -> +90)
%
% Output:
%  drot : rotated image of d
%
% https://www.ocf.berkeley.edu/~fricke/projects/israel/paeth/rotation_by_shearing.html
%_____________________________________________________________
% 2014-07-02
% Stefan Skare, Karolinska University Hospital
% Stockholm, Sweden
%_____________________________________________________________

if nargin < 2 || ~isnumeric(d) ||  ~isnumeric(phi) || phi <= -90 || phi >= 90
  help rot
  return
end


sz = size(d);

if sz(1) ~= sz(2)
  d = zerofill(d, max(sz(1:2)));
end

phi = -phi*pi/180; % deg->rad and negate for counter-clockwise rotation

sc = sz(1);
alpha = -tan(phi/2) * sc;
beta = sin(phi) * sc;
gamma = alpha;

drot = fouriershear(d, alpha, 2);
drot = fouriershear(drot, beta, 1);
drot = fouriershear(drot, gamma, 2);

end
