function myTE = slider2TE(app,val)
if val <= 1
  myTE = val * 10;
elseif val <=1.2
  myTE = (val - 1) * 50 + 10;
elseif val <=2.0
  myTE = (val - 1.2) * 100 + 20;
elseif val <=2.2
  myTE = (val - 2) * 500 + 100;
else
  myTE = (val - 2.2) * 1000 + 200;
end
end
