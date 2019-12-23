function myTR = slider2TR(app,val)

if val <= 1
  myTR = val * 100;
elseif val <=1.2
  myTR = (val - 1) * 500 + 100;
elseif val <=2.0
  myTR = (val - 1.2) * 1000 + 200;
elseif val <=2.2
  myTR = (val - 2) * 5000 + 1000;
else
  myTR = (val - 2.2) * 10000 + 2000;
end


end