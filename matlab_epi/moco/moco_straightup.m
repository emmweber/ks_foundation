function [straightdata, res, rotangle] = moco_straightup(data, fov)

dsz = size(data);
regdims = 2;

straightdata = data;

for z = 1:dsz(3)
  res(z) = moco_est(data(:,:,z), flip(data(:,:,z),2), fov, 'regdims', regdims, 'model', 'rigid');
    
  M = res(z).tform.T; M(regdims+1,1:regdims) = 0;
  r = myrotm2eul(M(1:3,1:3)) / 2;
  if (r(1) * 180/pi) > 45 % don't trust extreme results
    r = r * 0;
  end
  rotangle(z) = r(1) * 180/pi;
  
  M = myeul2rotm(r);
  res(z).tform.T(3,1:2) = res(z).tform.T(3,1:2)/2;
  res(z).tform.T(1:2,1:2) = M(1:2,1:2);
  
  straightdata(:,:,z) = moco_apply(data(:,:,z), res(z));
  
  render([data(:,:,z), straightdata(:,:,z), flip(data(:,:,z),2)]); drawnow

end

end