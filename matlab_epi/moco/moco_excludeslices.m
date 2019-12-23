function excluded_slices = moco_excludeslices(data, thr, ref)

if ~exist('thr','var')
  thr = 0.5;
end

excluded_slices = false(size(data,3), size(data,4));

if ~exist('ref','var')
  ref = mean(data, 4);
end

for z = 1:size(data,3)
  
  sliceintensity = squeeze(vec(mean(mean(data(:,:,z,:),1),2))) ./ mean(vec(ref(:,:,z)));
  excluded_slices(z,:) = sliceintensity < thr;
  
end

end
