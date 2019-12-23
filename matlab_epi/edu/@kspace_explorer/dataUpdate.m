function dataUpdate(app)

app.showOriginalCheckBox.Value = 0;

if (strcmp(app.kycropModeSwitch.Value,'Bottom') && app.FOVkySlider.Value < 100) || ...
    (strcmp(app.kxcropModeSwitch.Value,'Left') && app.FOVkxSlider.Value < 100)
  app.HomodyneButton.Enable = 'On';
else
  app.iFFTButton.Value = 1;
  app.HomodyneButton.Value = 0;
  app.HomodyneButton.Enable = 'off';
end

% copy original data
app.imageData = app.imageDataMenu(getImageDataMenuIndex(app)).data;
sz = size(app.imageData); sz(end+1:3) = 1;
origsz = sz;


%% image FOV
imageYPixelsToCrop = max([0 floor(sz(1) * (100 - app.FOVySlider.Value) / 200)]);
imageXPixelsToCrop = max([0 floor(sz(2) * (100 - app.FOVxSlider.Value) / 200)]);
yrange = (1+imageYPixelsToCrop):(sz(1)-imageYPixelsToCrop);
xrange = (1+imageXPixelsToCrop):(sz(1)-imageXPixelsToCrop);


% if the frequency encoding direction is horizontal, first crop FOVx in the image domain
if app.PhaseEncodingHorizontalButton.Value == 0 && imageXPixelsToCrop > 0
  app.imageData = app.imageData(:,xrange,:);
end
if app.PhaseEncodingVerticalButton.Value == 0 && imageYPixelsToCrop > 0
  app.imageData = app.imageData(yrange,:,:);
end

% to k-space (after potential freq FOV crop)
app.kspaceData = cft(app.imageData, [1 1]);
sz = size(app.kspaceData); sz(end+1:3) = 1; % size info update

if (app.PhaseEncodingHorizontalButton.Value == 1 && imageXPixelsToCrop > 0) || (app.PhaseEncodingVerticalButton.Value == 1 && imageYPixelsToCrop > 0)
  % resample k-space to change image space FOV (phase encoding direction)
  kxsamp = 1:sz(2);
  kysamp = 1:sz(1);
  if app.PhaseEncodingHorizontalButton.Value == 1 && imageXPixelsToCrop > 0
    kxsamp = linspace(1, sz(2), max([2 floor(sz(2) * app.FOVxSlider.Value / 200) * 2]));
  end
  if app.PhaseEncodingVerticalButton.Value == 1 && imageYPixelsToCrop > 0
    kysamp = linspace(1, sz(1), max([2 floor(sz(1) * app.FOVySlider.Value / 200) * 2]));
  end
  
  [Ys,Xs] = ndgrid(single(kysamp),single(kxsamp));
  ktmp = zeros([numel(kysamp) numel(kxsamp) sz(3)], 'like', app.kspaceData);
  for c = 1:sz(3)
    ktmp(:,:,c) = interpn(real(app.kspaceData(:,:,c)),Ys,Xs,'spline') + 1i * interpn(imag(app.kspaceData(:,:,c)),Ys,Xs,'spline');
  end
  
  app.kspaceData = ktmp; clear ktmp;
  sz = size(app.kspaceData); sz(end+1:3) = 1; % size info update
end

app.kspacePixelSize = origsz(1:2) ./ sz(1:2);

%% k-space FOV
prekcropsz = sz;

kspaceYPixelsToCrop = max([0 floor(prekcropsz(1) * (100 - app.FOVkySlider.Value) / 200)]);
kspaceXPixelsToCrop = max([0 floor(prekcropsz(2) * (100 - app.FOVkxSlider.Value) / 200)]);

if strcmp(app.kycropModeSwitch.Value,'Bottom')
  kyrange = 1:(prekcropsz(1)-kspaceYPixelsToCrop);
else
  kyrange = (1+kspaceYPixelsToCrop):(prekcropsz(1)-kspaceYPixelsToCrop);
end
if strcmp(app.kxcropModeSwitch.Value,'Left')
  kxrange = (1+kspaceXPixelsToCrop):prekcropsz(2);
else
  kxrange = (1+kspaceXPixelsToCrop):(prekcropsz(2)-kspaceXPixelsToCrop);
end

app.kspaceData = app.kspaceData(kyrange, kxrange, :);
sz = size(app.kspaceData); sz(end+1:3) = 1; % size info update

app.acqMatrix = sz;

app.imagePixelSize = prekcropsz(1:2) ./ sz(1:2);

%% Add noise
noiseScale = 2;
n = noiseScale * app.AddnoiseKnob.Value * (randn(size(app.kspaceData)) + 1i * randn(size(app.kspaceData)));
app.kspaceData = app.kspaceData + n;

%% Fermi
if app.UseFermiCheckBox.Value
  if strcmp(app.kycropModeSwitch.Value,'Bottom')
    fsz = [prekcropsz(1) sz(2)];
    F = fermi(min(fsz), min(fsz) * 0.45, 6);
    F = imresize(F, fsz, 'cubic');
    F = F(kyrange,:);
  elseif strcmp(app.kxcropModeSwitch.Value,'Left')
    fsz = [sz(1) prekcropsz(2)];
    F = fermi(min(fsz), min(fsz) * 0.45, 6);
    F = F(:, kxrange);
  else
    ms = min(sz(1:2));
    p = 100 * ms ./ mean(origsz(1:2));
    r = 0.48; w = 6;
    if p < 40, r = 0.0037 * p + 0.3357; end
    if p < 20, w = 0.2 * p + 2; end
    F = fermi(ms, ms * r, w);
    F = imresize(F, sz(1:2), 'cubic');
  end
  app.kspaceData = app.kspaceData .* repmat(F, [1 1 sz(3)]);
end

%% Parallel imaging (removing ky lines)
R = round(str2double(app.accelerationFactorRKnob.Value));
if R == 1
  app.centerstripSlider.Enable = 'Off';
else
  app.centerstripSlider.Enable = 'On';
end
if app.centerstripSlider.Value == 0 || R == 1 || sz(3) == 1
  app.ApplyGRAPPAweightsSwitch.Value = 'Off';
  app.ApplyGRAPPAweightsSwitch.Enable = 'Off';
else
  app.ApplyGRAPPAweightsSwitch.Enable = 'On';
end

if app.PhaseEncodingHorizontalButton.Value
  kindrange = false(1,sz(2));
  kindrange(1:R:end) = true;
  if app.centerstripSlider.Value > 0
    centerStrip = round(app.centerstripSlider.Value / 200 * origsz(2));
    centerStrip = (-centerStrip:centerStrip);
    if strcmp(app.kxcropModeSwitch.Value,'Left')
      centerStrip = centerStrip + round(origsz(2)/2) - kxrange(1);
    else
      centerStrip = centerStrip + round(sz(2)/2);
    end
    centerStrip = centerStrip(centerStrip <= sz(2) & centerStrip >= 1);
    kindrange(centerStrip) = true;
    if R > 1 && isempty(app.grappaWeights) && sz(3) > 1
      if numel(centerStrip) < (R + 1)
        app.centerstripSlider.Value = 0;
        kindrange(centerStrip) = false;
      else
        app.grappaWeights = grappa(app.kspaceData(:,centerStrip,:), R);
      end
    end
  end
  
  app.kspaceData(:,~kindrange,:) = 0;  
  
  if R > 1 && strcmp(app.ApplyGRAPPAweightsSwitch.Value,'On') && sz(3) > 1
    cs = app.kspaceData(:,centerStrip,:);
    app.kspaceData = grappa(app.kspaceData, app.grappaWeights);
    app.kspaceData(:,centerStrip,:) = cs;
  end
  
  app.effR = sz(2) / sum(kindrange == true);
  app.phaseEncodingPercentage = round(100 * sum(kindrange == true) / origsz(2));
else
  kindrange = false(1,sz(1));
  kindrange(1:R:end) = true;
  if app.centerstripSlider.Value > 0
    centerStrip = round(app.centerstripSlider.Value / 200 * origsz(1));
    centerStrip = (-centerStrip:centerStrip);
    if strcmp(app.kycropModeSwitch.Value,'Bottom')
      centerStrip = centerStrip + round(origsz(1)/2);
    else
      centerStrip = centerStrip + round(sz(1)/2);
    end
    
    centerStrip = centerStrip(centerStrip <= sz(1) & centerStrip >= 1);
    kindrange(centerStrip) = true;
    if R > 1 && isempty(app.grappaWeights) && sz(3) > 1
      if numel(centerStrip) < (R + 1)
        app.centerstripSlider.Value = 0;
        kindrange(centerStrip) = false;
      else
        app.grappaWeights = grappa(permute(app.kspaceData(centerStrip,:,:),[2 1 3]), R);
      end
    end
  end
  
  app.kspaceData(~kindrange,:,:) = 0;
  
  if R > 1 && strcmp(app.ApplyGRAPPAweightsSwitch.Value,'On') && sz(3) > 1
    cs = app.kspaceData(centerStrip,:,:);
    app.kspaceData = ipermute(grappa(permute(app.kspaceData,[2 1 3]), app.grappaWeights),[2 1 3]);
    app.kspaceData(centerStrip,:,:) = cs;
  end
  
  app.effR = sz(1) / sum(kindrange == true);
  app.phaseEncodingPercentage = round(100 * sum(kindrange == true) / origsz(1));
end


app.kspaceSizePreZfill = size(app.kspaceData(:,:,1));

%% update corresponding image
if strcmp(app.kycropModeSwitch.Value,'Bottom')
  hftype = 2;
  nover = numel(kyrange) - prekcropsz(1)/2;
elseif strcmp(app.kxcropModeSwitch.Value,'Left')
  hftype = 1;
  nover = numel(kxrange) - prekcropsz(2)/2;
else
  nover = 0;
  hftype = 0;
end

if app.UsezerofillCheckBox.Value 
  % partial Fourier: This does only zerofilling on the non-partial Fourier side (regardless
  % of Homodyne/FFT setting)
  if app.HomodyneButton.Value && strcmp(app.kycropModeSwitch.Value,'Bottom')
    app.imagePixelSize(2) = 1;
  elseif app.HomodyneButton.Value && strcmp(app.kxcropModeSwitch.Value,'Left')
    app.imagePixelSize(1) = 1;
  else
    app.imagePixelSize = [1 1];
  end
  app.kspaceData = zerofill(app.kspaceData, prekcropsz(1:2), nover, hftype);
else
  if app.HomodyneButton.Value && strcmp(app.kycropModeSwitch.Value,'Bottom')
    intensityscale = prekcropsz(2) / sz(2);
  elseif app.HomodyneButton.Value && strcmp(app.kxcropModeSwitch.Value,'Left')
    intensityscale = prekcropsz(1) / sz(1);
  else
    intensityscale = prod(prekcropsz(1:2)) / prod(sz(1:2));
  end
  if contains(app.imageDataMenu(getImageDataMenuIndex(app)).description, 'brain') && app.centerstripSlider.Value == 0 && R > 1
    if R == 2
      intensityscale = intensityscale  / R;
    else
      intensityscale = intensityscale / sqrt(R); % less dark for high R and no center strip
    end
  end
  app.kspaceData = app.kspaceData / intensityscale;
end

if app.HomodyneButton.Value && strcmp(app.kycropModeSwitch.Value,'Bottom')
  app.imageData = homodyne(app.kspaceData, nover, 'bottom');
elseif app.HomodyneButton.Value && strcmp(app.kxcropModeSwitch.Value,'Left')
  app.imageData = ipermute(flip(homodyne(flip(permute(app.kspaceData,[2 1 3]),1), nover, 'bottom'),1),[2 1 3]);
else
  if strcmp(app.kycropModeSwitch.Value,'Bottom')
    if app.UsezerofillCheckBox.Value
      app.kspaceData(prekcropsz(1),:,:) = 0;
    end
  elseif strcmp(app.kxcropModeSwitch.Value,'Left')
    if app.UsezerofillCheckBox.Value
      app.kspaceData(:,prekcropsz(2),:) = 0;
      s = prekcropsz(2) - sz(2);
      app.kspaceData = circshift(app.kspaceData, [0 s 0]);
    end
  end
  app.imageData = cft(app.kspaceData, [-1 -1]);
end


end