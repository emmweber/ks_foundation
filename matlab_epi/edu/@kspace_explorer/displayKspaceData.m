function displayKspaceData(app)

% k-space
logbias = 1;
scale = abs(1/max(vec(log(abs(app.kspaceData)+logbias))));

acckspace = sumsqcplx(app.kspaceData);
magkspace = abs(scale * log(sumsq(abs(app.kspaceData)) + logbias));

W = 2-app.kspaceWindow.Value;
L = app.kspaceLevel.Value;

meanI = mean(magkspace(:));
magkspace = magkspace * W;
magkspace = magkspace - mean(magkspace(:)) + meanI - L;

magkspace = imresize(magkspace, app.fullDataSize(1:2) ./ app.imagePixelSize, 'nearest');
if app.kMagnitudeButton.Value == 0
  acckspace = imresize(acckspace, app.fullDataSize(1:2) ./ app.imagePixelSize, 'nearest');
end

kp = kspace_peak(magkspace);
zoomy = (-7:8) + kp(1) - 1;
zoomy = zoomy(zoomy >= 1 & zoomy <= size(magkspace,1));
zoomx = (-7:8) + kp(2) - 1;
zoomx = zoomx(zoomx >= 1 & zoomx <= size(magkspace,2));

canvasSize = app.fullDataSize(1:2);

align = 'center';
if strcmp(app.kycropModeSwitch.Value,'Bottom')
  align = 'top';
end
if strcmp(app.kxcropModeSwitch.Value,'Left')
  align = 'right';
end

if app.kMagnitudeButton.Value
  imshow(app.centerOnCanvas(magkspace, canvasSize, align), 'Parent', app.UI_kspace);
  imshow(magkspace(zoomy,zoomx), 'Parent', app.UI_kspace_zoom);
elseif app.kPhaseButton.Value
  imshow(app.centerOnCanvas(angle(acckspace)/pi, canvasSize, align), 'Parent', app.UI_kspace);
  imshow(angle(acckspace(zoomy,zoomx))/pi, 'Parent', app.UI_kspace_zoom);
elseif app.kMagPhaseButton.Value
  hsvdata(:,:,1) = (angle(acckspace) / (2*pi)) + 0.5;
  hsvdata(:,:,2) = 0.6 * ones(size(magkspace));
  hsvdata(:,:,3) = magkspace;
  imshow(app.centerOnCanvas(hsv2rgb(hsvdata), canvasSize, align), 'Parent', app.UI_kspace);
  imshow(hsv2rgb(hsvdata(zoomy,zoomx,:)), 'Parent', app.UI_kspace_zoom);
elseif app.kRealButton.Value
  imshow(app.centerOnCanvas(real(scale * log(real(acckspace)+1)), canvasSize, align), 'Parent', app.UI_kspace);
  imshow(real(scale * log(real(acckspace(zoomy,zoomx))+logbias)), 'Parent', app.UI_kspace_zoom);
elseif app.kImagButton.Value
  imshow(app.centerOnCanvas(real(scale * log(imag(acckspace)+1)), canvasSize, align), 'Parent', app.UI_kspace);
  imshow(real(scale * log(imag(acckspace(zoomy,zoomx))+logbias)), 'Parent', app.UI_kspace_zoom);
end

axis(app.UI_kspace_zoom,'tight')

end