function y = fouriershift(x, delta)
%
% y = fouriershift2d(x, [delta_x delta_y])
%
% Shifts x by delta cyclically using the Fourier shift theorem.
%
% Real inputs should give real outputs.
%
% By Tim Hutt, 26/03/2009
% Small fix thanks to Brian Krause, 11/02/2010
% Modified to support of ND-arrays. Stefan Skare, Nov 2017

% The size of the matrix.
sz = size(x); sz(end+1:3) = 1;

N = sz(1);
M = sz(2);

if isempty(x)
  error('Input is empty')
end

if numel(delta) < 2
  delta(2) = 0;
end

y = zeros(sz, 'like', x); % output

for j = 1:prod(sz(3:end))
  
  % FFT of our possibly padded input signal.
  X = fft2(x(:,:,j));
  
  % The mathsy bit. The floors take care of odd-length signals.
  x_shift = exp(-1i * 2 * pi * delta(1) * [0:floor(N/2)-1 floor(-N/2):-1]' / N);
  y_shift = exp(-1i * 2 * pi * delta(2) * [0:floor(M/2)-1 floor(-M/2):-1]  / M);
  
  % Force conjugate symmetry. Otherwise this frequency component has no
  % corresponding negative frequency to cancel out its imaginary part.
  if mod(N, 2) == 0
    x_shift(N/2+1) = real(x_shift(N/2+1));
  end
  if mod(M, 2) == 0
    y_shift(M/2+1) = real(y_shift(M/2+1));
  end
  
  Y = X .* (x_shift * y_shift);
  
  % Invert the FFT.
  if isreal(x)
    % There should be no imaginary component (for real input
    % signals) but due to numerical effects some remnants remain.
    y(:,:,j) = real(ifft2(Y));
  else
    y(:,:,j) = ifft2(Y);
  end
  
end

end

