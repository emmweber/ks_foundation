function selectData(app)
menuItemNo = getImageDataMenuIndex(app);
app.imageData = single(app.imageDataMenu(menuItemNo).data);
app.kspaceData = cft(app.imageDataMenu(menuItemNo).data, [1 1]);

app.fullDataSize = size(app.imageData);

app.grappaWeights = [];

app.imageWindow.Value = 1;
app.imageLevel.Value = 0;
app.kspaceWindow.Value = 1;
app.kspaceLevel.Value = 0;

app.FOVxSlider.Value = 100;
app.FOVySlider.Value = 100;
app.FOVkxSlider.Value = 100;
app.FOVkySlider.Value = 100;

end