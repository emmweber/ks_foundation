function dataUpdate(app)

app.TE = app.slider2TE(app.TESlider.Value);
app.TR = app.slider2TR(app.TRSlider.Value);
app.TI = app.slider2TI(app.TISlider.Value);

app.Label.Text = num2str(round(app.TE));
app.Label_2.Text = num2str(round(app.TR));  
app.Label_3.Text = num2str(round(app.TI));

gyro = 42.6; % gyromagnetic ratio [MHz/T]
CS = 3.4; % chemical shift [ppm]
CSHz = gyro*app.B0*CS; % chemical shift [Hz]

matrix = 256;
FOV = 240; % [mm]
CSpxls = matrix * (CSHz / (2 * 1000 * (app.BandwidthKnob.Value+eps))); % chemical shift [pixels]
CSmm = FOV * (CSHz / (2 * 1000 * (app.BandwidthKnob.Value+eps))); % chemical shift [mm]
app.ChemicalShiftGauge.Value = CSmm;
app.ChemicalShiftmmGauge_2Label.Text = sprintf('Chemical Shift: %.1f mm', CSmm);
app.BandwidthLabel.Text = sprintf('rBW: %d +/-kHz/FOV', round(app.BandwidthKnob.Value));


if strcmpi(app.AutoIntensitySwitch.Value,'on')
  app.constWMButton.Enable = 'on';
  app.constGMButton.Enable = 'on';
  app.constFatButton.Enable = 'on';
else
  app.constWMButton.Enable = 'off';
  app.constGMButton.Enable = 'off';
  app.constFatButton.Enable = 'off';
end

if app.AutoIntensitySwitch.Value
  if app.constWMButton.Value
    app.adjust2R1 = 1000/1350; %832;
    app.adjust2R2 = 1000/86; %110;
  elseif app.constGMButton.Value
    app.adjust2R1 = 1000/1980; %1331;
    app.adjust2R2 = 1000/112; %90;
  elseif app.constFatButton.Value
    app.adjust2R1 = 1000/500; %300;
    app.adjust2R2 = 1000/80; %30;
  end
end

app.FA = app.FlipAngleKnob.Value;

if app.SpinEchoT2Button.Value
  if app.InversionCheckBox.Value
    app.weightedImage = IRSEeqn(app.TE, app.TR, app.TI, CSpxls, app.FatSuppressed, app.wat, app.fat, app.R1, app.R2);
    scale = SEeqn(app.TE, app.TR, CSpxls, false, 1, 0, app.adjust2R1, app.adjust2R2);
  else   
    app.weightedImage = SEeqn(app.TE, app.TR, CSpxls, app.FatSuppressed, app.wat, app.fat, app.R1, app.R2);
    scale = SEeqn(app.TE, app.TR, CSpxls, false, 1, 0, app.adjust2R1, app.adjust2R2);
  end
else
  app.weightedImage = SPGReqn(app.TE, app.TR, app.FA, CSHz, CSpxls, app.FatSuppressed, app.wat, app.fat, app.R1, app.R2star);
  scale = SPGReqn(app.TE, app.TR, app.FA, CSHz, CSpxls, false, 1, 0, app.adjust2R1, app.adjust2R2);
end

% Add noise
noiseScale = 0.05 * sqrt(app.BandwidthKnob.Value / 32) * (3 / app.B0);
n = noiseScale * app.AddnoiseKnob.Value * (randn(size(app.wat)) + 1i * randn(size(app.wat)));
app.weightedImage = abs(app.weightedImage + n);

% Auto Win/Level
if strcmpi(app.AutoIntensitySwitch.Value,'on')
  app.weightedImage = app.weightedImage / scale;
end

end


function val = SEeqn(TE, TR, CSpxls, FatSuppressed, wat, fat, R1, R2)

weighting = exp(-(TE/1000+eps).*R2) .* (1 - exp(-TR/1000.*R1));
val = wat .* weighting;
if ~FatSuppressed
  val = val + fouriershift(fat .* weighting, [0 CSpxls]);
end

end

function val = IRSEeqn(TE, TR, TI, CSpxls, FatSuppressed, wat, fat, R1, R2)

weighting = exp(-(TE/1000+eps).*R2) .* (1 - 2 * exp(-(TI/1000+eps).*R1) + exp(-TR/1000.*R1));
val = wat .* weighting;
if ~FatSuppressed
  val = val + fouriershift(fat .* weighting, [0 CSpxls]);
end

end



function val = SPGReqn(TE, TR, FA, CSHz, CSpxls, FatSuppressed, wat, fat, R1, R2star)

FA = FA * pi/180; % to radians
numerator = sin(FA) .* (1 - exp(-TR/1000.*R1));
denominator = 1 - cos(FA) * exp(-TR/1000.*R1);
weighting = exp(-(TE/1000+eps).*R2star) .* numerator ./ denominator;
val = wat .* weighting;
if ~FatSuppressed
  val = abs(val + fouriershift(fat .* weighting, [0 CSpxls]) * exp(1i*2*pi*CSHz*TE/1000));
end

end
