function struct_valuematch(s, value, value2)


v = struct2cell(s);
f = fieldnames(s);

for j = 1:numel(v)
  if exist('value2','var') && isnumeric(v{j}) && isnumeric(value) && numel(v{j}) == numel(value) && all((v{j} - value) > 0) && all((v{j} - value2) < 0)
    fprintf('%s: %g\n', f{j}, v{j});    
  elseif isnumeric(v{j}) && isnumeric(value) && numel(v{j}) == numel(value) && ~any(v{j} - value)
    fprintf('%s: %g\n', f{j}, v{j});    
  elseif (ischar(v{j}) && ischar(value) && contains(v{j},value))
    fprintf('%s: %s\n', f{j}, v{j});    
  end
end