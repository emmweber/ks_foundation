function [sortarray,badslicecount] = moco_sortbyvalidslices(exclslices)

if ~ismatrix(exclslices) || ~isa(exclslices,'logical')
  error('moco_sortbyvalidslices: arg 1 must be a logical 2D (rows = slices, cols = volumes');
end

badslicecount = sum(exclslices,1)' + 1; % +1 to avoid 0 penalty 

if sum(badslicecount) > 0
  [~, sortarray] = sort(badslicecount);
  badslicecount = badslicecount/max(badslicecount(:));
else
  badslicecount = ones(size(exclslices,2),1);
  sortarray = (1:size(exclslices,2))';
end

end

