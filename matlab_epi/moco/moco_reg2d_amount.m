function [rot_vol_av, vol_suitablefor3d] = moco_reg2d_amount(tform, exclslices)

regdims = tform(1).Dimensionality;

for z = 1:size(tform,1)
  for v = 1:size(tform,2)
    M = tform(z,v).T; M(regdims+1,1:regdims) = 0;
    rotations = myrotm2eul(M(1:3,1:3));
    m(z,v) = rotations(1)*180/pi;
  end
end

if exist('exclslices','var') && ~isempty(exclslices)
  m(exclslices) = Inf;
end

for v = 1:size(m,2)
  x = m(:,v);
  x = x(isfinite(x));
  rot_vol_av(v) = abs(mean(x));
  rot_vol_maxmin(v) = max(x) - min(x);
  rot_vol_std(v) = std(x);
end

vol_suitablefor3d = rot_vol_av ./ sqrt(rot_vol_std.*rot_vol_maxmin);
vol_suitablefor3d(isnan(vol_suitablefor3d)) = 0;

end

%#ok<*AGROW>
