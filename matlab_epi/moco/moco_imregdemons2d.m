function datac = moco_imregdemons2d(data, refdata)

% if data has 4 or more dimensions, copy dfield for current slice

dsz = size(data); dsz(end+1:4) = 1;
datac = zeros(dsz, 'like', data);

pyramidlevels = [25 15 15];

for z = 1:dsz(3)
  [dfield,datac(:,:,z,1)] = imregdemons(data(:,:,z,1), refdata(:,:,z), pyramidlevels, 'AccumulatedFieldSmoothing', 2, 'DisplayWaitbar', false);
  %dfield = imregdemons(data(:,:,z,1), refdata(:,:,z), [100 50 20], 'AccumulatedFieldSmoothing', 2, 'DisplayWaitbar', false);
  for e = 2:prod(dsz(4:end))
    datac(:,:,z,e) = imwarp(data(:,:,z,e), dfield);
  end
end

end
