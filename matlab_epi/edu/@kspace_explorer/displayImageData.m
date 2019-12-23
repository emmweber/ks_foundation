function displayImageData(app)

if app.showOriginalCheckBox.Value
  imgData = app.imageDataMenu(getImageDataMenuIndex(app)).data;
else
  imgData = app.imageData;
end

if app.MagnitudeButton.Value == 0
  accimage = sumsqcplx(imgData);
end
magimage = sumsq(abs(imgData));

W = 2-app.imageWindow.Value;
L = app.imageLevel.Value;

meanI = mean(magimage(:));
magimage = magimage * W;
magimage = magimage - mean(magimage(:)) + meanI - L;

if app.showOriginalCheckBox.Value == 0
  magimage = imresize(magimage, app.fullDataSize(1:2) ./ app.kspacePixelSize, 'nearest');
  if app.MagnitudeButton.Value == 0
    accimage = imresize(accimage, app.fullDataSize(1:2) ./ app.kspacePixelSize, 'nearest');
  end
end

zoomy = (-7:8) + round(size(magimage,1)/2);
zoomx = (-7:8) + round(size(magimage,2)/2);

canvasSize = app.fullDataSize(1:2);

% image space
if app.MagnitudeButton.Value  
  imshow(app.centerOnCanvas(magimage, canvasSize), 'Parent', app.UI_ispace);  
  imshow(magimage(zoomy,zoomx), 'Parent', app.UI_ispace_zoom);
elseif app.PhaseButton.Value
  imshow(app.centerOnCanvas(angle(accimage)/pi, canvasSize), 'Parent', app.UI_ispace);
  imshow(angle(accimage(zoomy,zoomx))/pi, 'Parent', app.UI_ispace_zoom);
elseif app.MagPhaseButton.Value
  hsvdata(:,:,1) = (angle(accimage) / (2*pi)) + 0.5;
  hsvdata(:,:,2) = 0.6 * ones(size(accimage));
  hsvdata(:,:,3) = magimage;
  imshow(app.centerOnCanvas(hsv2rgb(hsvdata), canvasSize), 'Parent', app.UI_ispace);
  imshow(hsv2rgb(hsvdata(zoomy,zoomx,:)), 'Parent', app.UI_ispace_zoom);
elseif app.RealButton.Value
  data = mat2gray(real(accimage));
  imshow(app.centerOnCanvas(data, canvasSize),'Parent', app.UI_ispace);
  imshow(data(zoomy,zoomx), 'Parent', app.UI_ispace_zoom);
elseif app.ImagButton.Value
  data = mat2gray(imag(accimage));
  imshow(app.centerOnCanvas(data, canvasSize), 'Parent', app.UI_ispace);
  imshow(data(zoomy,zoomx), 'Parent', app.UI_ispace_zoom);
end

axis(app.UI_ispace_zoom,'tight')

end