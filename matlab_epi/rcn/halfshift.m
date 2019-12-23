function Ish = halfshift(I)


  Isz = size(I); Isz(end+1:3) = 1;
  hshift = exp(-1i*(repmat(linspace(-pi/2,pi/2,Isz(1))',[1 Isz(2)]) + repmat(linspace(-pi/2,pi/2,Isz(2)),[Isz(1) 1])));
  hshift = repmat(hshift,[1 1 Isz(3:end)]);
  Ish = I .* hshift;
  
end
