function updateLabels(app, whatIsChanged, changingValue)

if isempty(app.TE)
  app.TE = app.slider2TE(app.TESlider.Value);
end
if isempty(app.TR)
  app.TR = app.slider2TR(app.TRSlider.Value);
end

if strcmp(whatIsChanged, 'TE')
  app.TEGauge.Value = changingValue;
  app.TESlider.Value = changingValue;
  app.TE = app.slider2TE(changingValue);
  if app.slider2TR(app.TRSlider.Value) < app.TE
    val = app.TR2slider(app.TE);
    app.TRSlider.Value = val;
    app.TRGauge.Value = val;
  end
elseif strcmp(whatIsChanged, 'TR')
  app.TRGauge.Value = changingValue;
  app.TRSlider.Value = changingValue;
  app.TR = app.slider2TR(changingValue);
  if app.slider2TE(app.TESlider.Value) > app.TR
    val = app.TE2slider(app.TR);
    app.TESlider.Value = val;
    app.TEGauge.Value = val;
  end
elseif strcmp(whatIsChanged, 'TI')
  app.TIGauge.Value = changingValue;
  app.TISlider.Value = changingValue;
end

app.TE = app.slider2TE(app.TESlider.Value);
app.TR = app.slider2TR(app.TRSlider.Value);
app.TI = app.slider2TI(app.TISlider.Value);

end
