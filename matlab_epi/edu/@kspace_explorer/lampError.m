function lampError(app, msg)

app.CalculationstatusLamp.Color = [1 0 0];
app.CalculationstatusLampLabel.Text = msg;
drawnow;

end