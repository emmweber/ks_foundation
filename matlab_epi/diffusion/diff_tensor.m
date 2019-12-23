function [D,e] = diff_tensor(adc,q)

if ndims(adc) < 3
	error('diff_tensor: 1st arg must be at least 3D [Ndirs Ny Nx (Nz ...)]');
end

A = diff_getA(q);
iA = pinv(double(A));
if isa(adc,'single')
  iA = single(iA);
end
dim = size(adc);
adc = reshape(adc,size(adc,1),[]);
D = iA * adc;

if nargout >= 2
  e = adc - A*D;
  e = reshape(e.*e,dim);
end

D = reshape(D,[6,dim(2:end)]); % size(D) = [6 Ny Nx Nz]
