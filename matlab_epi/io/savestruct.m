function filehandle = savestruct(filename, savestruct)

if ~isstruct(savestruct)
  error('savestruct: must pass in struct as 2nd arg')
end

varnames = fieldnames(savestruct);

for j = 1:numel(varnames)
  if ~isreal(savestruct.(varnames{j}))
    savestruct.([varnames{j} '_i']) = imag(savestruct.(varnames{j}));
    savestruct.(varnames{j}) = real(savestruct.(varnames{j}));
  end
end

if nargout > 0
  filehandle = savefast(filename, savestruct);
else
  savefast(filename, savestruct);
end

end
