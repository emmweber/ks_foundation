function selectMaps(app)

menuItemNo = getImageDataMenuIndex(app);
app.wat = single(app.imageDataMenu(menuItemNo).wat);
app.fat = single(app.imageDataMenu(menuItemNo).fat);
app.R1 = single(app.imageDataMenu(menuItemNo).R1);
app.R2 = single(app.imageDataMenu(menuItemNo).R2);
app.R2star = single(app.imageDataMenu(menuItemNo).R2star);
if isfield(app.imageDataMenu(menuItemNo), 'adjust2T1')
  app.adjust2R1 = app.imageDataMenu(menuItemNo).adjust2R1;
  app.adjust2R2 = app.imageDataMenu(menuItemNo).adjust2R2;
end

app.imageWindow.Value = 1;
app.imageLevel.Value = 0;

end
