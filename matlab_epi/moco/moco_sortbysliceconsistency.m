function [sortarray,c] = moco_sortbysliceconsistency(data, slicepercentage)
% size(data)   = [Nx Ny Nz Nvols]

if ndims(data) ~= 4
  error('moco_sortbysliceconsistency: ''data'' must be 4D');
end

if ~isreal(data)
  data = abs(data);
end

if ~exist('slicepercentage','var')
  slicepercentage = 100;
end

discard_slices = max([floor((1 - slicepercentage/100) / 2 * size(data,3)), 0]);
data = data(:,:,(discard_slices+1):(end-discard_slices),:);

parfor j = 1:size(data,4)
  c(j,1) = moco_sliceconsistency(data(:,:,:,j)); 
end

[~, sortarray] = sort(c);

c = c/max(c(:));

end



function c = moco_sliceconsistency(data)

regdims = 2;
dsz = size(data);

rotangle = 1:dsz(3);

fov = dsz(1:2);

for z = 2:(dsz(3)-1)
  
  res = moco_est(data(:,:,z), (data(:,:,z-1) + data(:,:,z+1))/2, fov, 'regdims', 2, 'estres', 96);
  
  M = res.tform.T; M(regdims+1,1:regdims) = 0;
  r = myrotm2eul(M(1:3,1:3)) / 2;
  if (r(1) * 180/pi) > 45 % don't trust extreme results
    r = r * 0;
  end
  rotangle(z) = r(1) * 180/pi;
  
end

c = std(rotangle(2:end-1));

end


