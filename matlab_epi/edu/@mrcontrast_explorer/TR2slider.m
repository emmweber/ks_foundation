function val = TR2slider(app,TR)

if TR <= 100
  val = TR/100;
elseif TR <= 200
  val = (TR-100)/500+1;
elseif TR <= 1000
  val = (TR-200)/1000+1.2;
elseif TR <= 2000
  val = (TR-1000)/5000+2;
else
  val = (TR-2000)/10000+2.2;
end

end