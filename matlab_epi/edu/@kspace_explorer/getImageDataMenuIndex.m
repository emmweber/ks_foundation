function menuItemNo = getImageDataMenuIndex(app)
% in this function we will combine multichannel data
for j = 1:numel(app.ChooseimageDropDown.Items)
  if strcmp(app.ChooseimageDropDown.Value, app.ChooseimageDropDown.Items{j})
    menuItemNo = j;
    break;
  end
end
end