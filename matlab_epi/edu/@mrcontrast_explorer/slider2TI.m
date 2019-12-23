function myTI = slider2TI(app,val)

if val <= 1
  myTI = val * 100;
elseif val <=1.2
  myTI = (val - 1) * 500 + 100;
elseif val <=2.0
  myTI = (val - 1.2) * 1000 + 200;
elseif val <=2.2
  myTI = (val - 2) * 5000 + 1000;
else
  myTI = (val - 2.2) * 10000 + 2000;
end

end
