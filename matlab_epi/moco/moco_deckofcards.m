function [datac, res] = moco_deckofcards(data, fov)

dsz = size(data);
regdims = 2;

datac = data;

% find slice with most data
zsum = vec(squeeze(sum(sum(data,1),2)));
A = dctmtx(numel(zsum), 5);
zsum = A*(A\zsum); % fitted
refslice = find(zsum == max(zsum));

for j = 1:3
  for z = 2:2:(dsz(3)-1)
    res(z) = moco_est(data(:,:,z), (datac(:,:,z-1) + datac(:,:,z+1))/2, fov, 'regdims', 2);
    datac(:,:,z) = moco_apply(data(:,:,z), res(z));
  end
  for z = 3:2:(dsz(3)-1)
    res(z) = moco_est(data(:,:,z), (datac(:,:,z-1) + datac(:,:,z+1))/2, fov, 'regdims', 2);
    datac(:,:,z) = moco_apply(data(:,:,z), res(z));
  end 
end



end