function s = sincfcn(x)


s = sin(pi*x)./(pi*x);
s(x==0) = 1;

end
