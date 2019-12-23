function h = fermi2d(dim, width, trans)
%FERMI2D creates a symmetric 2D Fermi function
%
% USAGE
%   h = fermi2d(dim, width, trans)
%
% REQUIRED INPUTS
%   dim = [nrows, ncols] gives the size of the output: size(h) = [nrows, ncols].
%   if dim is scalar nrows = ncols.
%   "width" is the width of the flat portion of the function.  if width is a
%     scalar, it is assumed to be a diameter and a circularly symmetric
%     function is generated.  if width is a 2-element array, [wy, wx], the
%     flat top is rectangular with wy width in each column and wx width in
%     each row.
%   "trans" is the transition width between the top and bottom of the function.
%
% DB Clayton - 2006/02/15 v1.0
% Stefan Skare - 2006/07/12. Changed width to be the radius instead of diameter and combined first two args

if nargin ~= 3, error('fermi2d: 3 args required'); end

if numel(dim) == 1,	dim(2) = dim(1); end
nrows = dim(1);
ncols = dim(2);

if (numel(width) == 1)
  [x, y] = meshgrid(-ncols/2:(ncols/2-1), -nrows/2:(nrows/2-1));
  r = sqrt(x.^2 + y.^2);
  h = 1./(1 + exp((r-width)/trans));
else
  x = -ncols/2:(ncols/2-1);
  y = -nrows/2:(nrows/2-1);
  gx = 1./(1 + exp((abs(x)-width(2))/trans));
  gy = 1./(1 + exp((abs(y)-width(1))/trans));
  hx = repmat(gx, [nrows, 1]);
  hy = repmat(gy', [1, ncols]);
  h = hx .* hy;
end
