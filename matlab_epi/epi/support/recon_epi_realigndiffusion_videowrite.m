%% 
function recon_epi_realigndiffusion_videowrite(I, fname)

if strcmp(computer, 'GLNXA64')
  videoformat = 'Motion JPEG AVI';
  videoext = '.avi';
else
  videoformat = 'MPEG-4';
  videoext = '.mp4';
end

fv = figure('visible', 'off');

writerObj = VideoWriter(sprintf('%s%s',fname,videoext), videoformat);
writerObj.FrameRate = 15;
open(writerObj);

isz = size(I); isz(end+1:4) = 1;

for t = 1:prod(isz(4:end))
  if sum(vec(I(1:16:end,1:16:end,1:2:end,t))) > 0
   frame = im2frame(uint8(mat2gray(create_mosaic(I(:,:,:,t)))*300), colormap(gray(256))); 
   writeVideo(writerObj, frame);
  end
end

close(writerObj);
close(fv);

end