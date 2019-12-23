function menuItemNo = getImageDataMenuIndex(app)
for j = 1:numel(app.ChooseimageDropDown.Items)
  if strcmp(app.ChooseimageDropDown.Value, app.ChooseimageDropDown.Items{j})
    menuItemNo = j;
    break;
  end
end
end