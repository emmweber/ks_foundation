function displayImageData(app)

magimage = app.weightedImage;

W = 2 - app.imageWindow.Value;
L = app.imageLevel.Value;

meanI = mean(magimage(:));
magimage = magimage * W;
magimage = magimage - mean(magimage(:)) + meanI - L;

imshow(imresize(magimage,2,'lanczos3'), 'Parent', app.UI_image);

end