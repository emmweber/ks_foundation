function datac = moco_apply(data, eststruct)
% Usage:
% datac = moco_apply(data, eststruct);
%
% eststruct is output from moco_est(), and contains the following fields:
% 'tform', 'R'

checkData  = @(x) (isnumeric(x) && min([size(data,1) size(data,2)] > 8));
checkStruct = @(x) (isstruct(x) && isfield(x,'tform') && isfield(x,'R'));

parm = inputParser;
addRequired(parm,'data', checkData);
addRequired(parm, 'eststruct', checkStruct);

parse(parm, data, eststruct);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dsz = size(data); dsz(end+1:4) = 1;

if isa(eststruct.R, 'imref3d')
  regdims = 3;
  regspervol = 1;
elseif isa(eststruct.R, 'imref2d')
  regdims = 2;
  regspervol = dsz(3);
else
  error('moco_apply: bad content of field ''eststruct.R''');
end

datac = zeros(dsz, 'like', data);

for s = 1:regspervol
  if regdims == 3
    z = 1:dsz(3);
  else
    z = s;
  end
  
  for j = 1:dsz(4)
    [datac(:,:,z,j)] = imwarp(data(:,:,z,j), eststruct.R, eststruct.tform(s,j), 'Interp', 'cubic', 'OutputView', eststruct.R);
  end
  
end

end


%#ok<*ISMAT>