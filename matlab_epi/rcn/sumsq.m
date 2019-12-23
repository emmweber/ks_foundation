function sumsqdata = sumsq(data)

nc = size(data,3);
sumsqdata = sqrt(sum(data.^2, 3)/nc);

end
