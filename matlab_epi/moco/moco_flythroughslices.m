function moco_flythroughslices(data, data2)

w = warning;
warning off

h = figure(100); colormap(gray(256));

gam = 0.5;
upsamp = 2;

for z = 1:size(data,3)
  
  x{z} = imresize(create_mosaic(mat2gray(permute(data(:,:,z,:,:),[1 2 4 5 3])),size(data,4)).^gam,upsamp,'nearest');
  if exist('data2','var')
    x{z} = [x{z} imresize(create_mosaic(mat2gray(permute(data2(:,:,z,:,:),[1 2 4 5 3])),size(data,4)).^gam,upsamp,'nearest')];
  end
  
end

play = true;

while play
  
  for z = 1:size(data,3)
    
    try
      imshow(x{z}); drawnow
    catch
      play = false;
      break
    end
  end
  
end

warning(w);

end