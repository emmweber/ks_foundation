function w = gausswin(N, a)
%GAUSSWIN Gaussian window.
%   GAUSSWIN(N) returns an N-point Gaussian window.
%
%   GAUSSWIN(N, ALPHA) returns the ALPHA-valued N-point Gaussian
%   window.  ALPHA is defined as the reciprocal of the standard
%   deviation and is a measure of the width of its Fourier Transform.
%   As ALPHA increases, the width of the window will decrease. If omitted,
%   ALPHA is 2.5.
%
%   EXAMPLE:
%      N = 32;
%      wvtool(gausswin(N));
%
%
%   See also CHEBWIN, KAISER, TUKEYWIN, WINDOW.

%   Reference:
%     [1] fredric j. harris [sic], On the Use of Windows for Harmonic
%         Analysis with the Discrete Fourier Transform, Proceedings of
%         the IEEE, Vol. 66, No. 1, January 1978

%   Author(s): P. Costa
%   Copyright 1988-2002 The MathWorks, Inc.
%   $Revision: 831 $  $Date: 2009-07-13 11:15:32 -0700 (Mon, 13 Jul 2009) $

narginchk(1,2);

% Default value for Alpha
if nargin < 2 || isempty(a)
    a = 2.5;
end

% Index vector
k = -(N-1)/2:(N-1)/2;

% Equation 44a from [1]
w = exp((-1/2)*(a * k/(N/2)).^2)';

end
