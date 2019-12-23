function val = deployedargs(val)

if isdeployed
  if iscell(val)
    for j = 1:numel(val)
      if ischar(val{j}) && ~isnan(str2double(val{j}))
        val{j} = str2double(val{j});
      elseif numel(strfind(val{j},'{')) == 1 && numel(strfind(val{j},'}')) == 1
        val{j} = eval(val{j});
      elseif xor(numel(strfind(val{j},'{')) == 1, numel(strfind(val{j},'}')) == 1)
        error('deployedargs: Cell array split into two arguments. Remove white space');
      end
    end
  elseif ischar(val)
    val = str2double(val);
  end
end

end
