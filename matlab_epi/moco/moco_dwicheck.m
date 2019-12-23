

%{
load dwireg

figure(1); render(mean(dwi,4).^.8)
figure(2); render(mean(dwic2d,4).^.8,[0 500]);title('2d')
figure(3); render(mean(dwic2daf,4).^.8,[0 500]);title('2daf')
figure(4); render(mean(dwic3d,4).^.8,[0 500]);title('3d')
figure(5); render(mean(dwic2d3d,4).^.8,[0 500]);title('2d3d')


%}



load dwireg

% {
if ~exist('refdata','var')
  refdata = dwi(:,:,z,refvol);
end

writerObj = VideoWriter('refvol.mp4','MPEG-4');
writerObj.FrameRate = 15;
open(writerObj);
for z=1:size(dwi,3)
  frame = im2frame(uint8(mat2gray(refdata(:,:,z))*300), colormap(gray(256))); writeVideo(writerObj, frame);
end
close(writerObj);

writerObj = VideoWriter('vols.mp4','MPEG-4');
writerObj.FrameRate = 15;
open(writerObj);
for t=1:size(dwi,4)
  frame = im2frame(uint8(mat2gray(create_mosaic(dwi(:,:,:,t)))*300), colormap(gray(256))); writeVideo(writerObj, frame);
end
close(writerObj);

if exist('dwic3d_nonlin','var')
  writerObj = VideoWriter('vols2xiter_a15.mp4','MPEG-4');
  writerObj.FrameRate = 10;
  open(writerObj);
  for t=1:size(dwi,4)
    frame = im2frame(uint8(mat2gray(create_mosaic(dwic(:,:,:,t)))*300), colormap(gray(256))); writeVideo(writerObj, frame);
  end
  close(writerObj);
end

writerObj = VideoWriter('volsrigid2d.mp4','MPEG-4');
writerObj.FrameRate = 15;
open(writerObj);
for t=1:size(dwi,4)
  frame = im2frame(uint8(mat2gray(create_mosaic(dwic2d(:,:,:,t)))*300), colormap(gray(256))); writeVideo(writerObj, frame);
end
close(writerObj);

writerObj = VideoWriter('volsrigid3d.mp4','MPEG-4');
writerObj.FrameRate = 15;
open(writerObj);
for t=1:size(dwi,4)
  frame = im2frame(uint8(mat2gray(create_mosaic(dwic3d(:,:,:,t)))*300), colormap(gray(256))); writeVideo(writerObj, frame);
end
close(writerObj);

writerObj = VideoWriter('volsrigid2d3d.mp4','MPEG-4');
writerObj.FrameRate = 15;
open(writerObj);
for t=1:size(dwi,4)
  frame = im2frame(uint8(mat2gray(create_mosaic(dwic2d3d(:,:,:,t)))*300), colormap(gray(256))); writeVideo(writerObj, frame);
end
close(writerObj);

writerObj = VideoWriter('volsaffine2d.mp4','MPEG-4');
writerObj.FrameRate = 15;
open(writerObj);
for t=1:size(dwi,4)
  frame = im2frame(uint8(mat2gray(create_mosaic(dwic2daf(:,:,:,t)))*300), colormap(gray(256))); writeVideo(writerObj, frame);
end
close(writerObj);


writerObj = VideoWriter('volsaffine2d3d.mp4','MPEG-4');
writerObj.FrameRate = 15;
open(writerObj);
for t=1:size(dwi,4)
  frame = im2frame(uint8(mat2gray(create_mosaic(dwic2d3daf(:,:,:,t)))*300), colormap(gray(256))); writeVideo(writerObj, frame);
end
close(writerObj);
% }

%imwrite(mat2gray(create_mosaic(dwi(:,:,:,refvol))), 'refvol.png');
%imwrite(mat2gray(create_mosaic(moco_straightup(dwi(:,:,:,refvol), fov))), 'refvol_straight.png');


