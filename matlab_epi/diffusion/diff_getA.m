function A = diff_getA(q)
% usage: A = diff_getA(q)
%
% Calulates the diffusion design matrix A
% given a set of diffusion gradient directions (q)
% 
% The elements d = [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz] 
% in the diffusion tensor tensor D are related to the N
% measured ADC values y(j), j=1:N corresponding to 
% diffusion directions q(j,:), j=1:N
% via
% y = A * d;
% So, the diffusion tensor elements are calculated by
% d = A \ y;
%
% ----------------------------------------------------
% Stefan Skare, Stanford University
% Version 1.0, March 1st, 2007


if ndims(q) ~= 2
  fprintf('q must be a 2D matrix\n');
  return
end

if size(q,2) ~= 3
  fprintf('q must have 3 columns\n');
  return
end

for j = 1:size(q,1)
		A(j, 1) = q(j,1).^2;
		A(j, 2) = q(j,2).^2;
		A(j, 3) = q(j,3).^2;
		A(j, 4) = 2*q(j,1)*q(j,2);
		A(j, 5) = 2*q(j,1)*q(j,3);
		A(j, 6) = 2*q(j,2)*q(j,3);
end
