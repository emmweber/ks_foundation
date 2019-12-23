function val = TE2slider(app,TE)

if TE <= 10
  val = TE/10;
elseif TE <= 20
  val = (TE-10)/50+1;
elseif TE <= 100
  val = (TE-20)/100+1.2;
elseif TE <= 200
  val = (TE-100)/500+2;
else
  val = (TE-200)/1000+2.2;
end

end