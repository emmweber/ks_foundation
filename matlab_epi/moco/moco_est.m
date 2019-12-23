function estresult = moco_est(data, refdata, fov, varargin)
% Usage:
% estresult = moco_est(data, refdata, fov);
% estresult = moco_est(data, refdata, fov, 'model', {'translation','rigid', 'affine'}, 'metric', {'monomodal', 'multimodal'}, 'dims', {'2D', '3D'}, 'estres', {scalar >= 16});

defaultModel = 'rigid';
validModels = {'translation','rigid', 'affine'};
checkModels = @(x) any(validatestring(x,validModels));

defaultMetric = 'monomodal';
validMetrics = {'monomodal', 'multimodal'};
checkMetrics = @(x) any(validatestring(x, validMetrics));

defaultDim = 3;
checkDims = @(x) (isnumeric(x) && (x == 2 || x == 3));

defaultEstRes = 96;
checkEstRes = @(x) (isnumeric(x) && x >= 16);

checkData = @(x) (isnumeric(x) && min(size(data(:,:,1))) > 8);
checkFOV = @(x) (isnumeric(x) && numel(fov) >=2 && numel(fov) <= 3);

parm = inputParser;
addRequired(parm,'data', checkData);
addRequired(parm, 'refdata', checkData);
addRequired(parm, 'fov', checkFOV);
addParameter(parm, 'model', defaultModel, checkModels);
addParameter(parm, 'metric', defaultMetric, checkMetrics);
addParameter(parm, 'regdims', defaultDim, checkDims);
addParameter(parm, 'estres', defaultEstRes, checkEstRes);

parse(parm, data, refdata, fov, varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dsz = size(data); dsz(end+1:4) = 1;
if parm.Results.regdims == 3
  R = imref3d(dsz(1:3), [-0.5 0.5]*fov(1),[-0.5 0.5]*fov(2),[-0.5 0.5]*fov(3));
else
  R = imref2d(dsz(1:2), [-0.5 0.5]*fov(1),[-0.5 0.5]*fov(2));
end

if any((dsz(1:2) - parm.Results.estres) > 0)
  data    = imresize(data,    [1 1] * parm.Results.estres);
  refdata = imresize(refdata, [1 1] * parm.Results.estres);
end

dsz = size(data); dsz(end+1:4) = 1;
if parm.Results.regdims == 3
  Rest = imref3d(dsz(1:3), [-0.5 0.5]*fov(1),[-0.5 0.5]*fov(2),[-0.5 0.5]*fov(3));
else
  Rest = imref2d(dsz(1:2), [-0.5 0.5]*fov(1),[-0.5 0.5]*fov(2));
end

parfor j = 1:dsz(4)
  tform(:,j) = moco_est_core(data(:,:,:,j), refdata, parm.Results.regdims, Rest, parm.Results.model, parm.Results.metric);
end

estresult.tform = tform;
estresult.R = R;

end




function tform = moco_est_core(data, refdata, regdims, Rest, model, modalflag)
dsz = size(data); dsz(end+1:4) = 1;
max_degrees_until_distrust = 35;

if regdims == 3
  regspervol = 1;
else
  regspervol = size(data,3);
end

if min(dsz(1:regdims)) >= 256
  pl = 5;
elseif min(dsz(1:regdims)) >= 64
  pl = 4;
elseif min(dsz(1:regdims)) >= 16
  pl = 3;
else
  pl = 2;
end

[optimizer, metric] = imregconfig(modalflag);
maxretries = 4;

for s = 1:regspervol
  
  if regspervol == 1
    z = 1:dsz(3);
  else
    z = s;
  end
  
  attempt = 1;
  if strcmp(modalflag, 'monomodal')
    if strcmp(model,'rigid')
      optimizer.MaximumStepLength = 5e-3;
    else
      optimizer.MaximumStepLength = 1e-3;
    end
  else
    optimizer.InitialRadius = 2e-03;
  end
  
  lastwarn('')
  tform(s,1) = imregtform(data(:,:,z), Rest, refdata(:,:,z), Rest, model, optimizer, metric, 'PyramidLevels', pl);
  
  % catch rediculous head motion. reestimate with smaller step sizes
  M = tform(s,1).T; M(regdims+1,1:regdims) = 0;
  rotations = myrotm2eul(M(1:3,1:3));
  while strcmp(modalflag, 'monomodal') && ((~isempty(lastwarn) || (max(abs(rotations))*180/pi > max_degrees_until_distrust)) && attempt < maxretries)
    optimizer.MaximumStepLength = optimizer.MaximumStepLength / 4;
    lastwarn('')
    tform(s,1) = imregtform(data(:,:,z), Rest, refdata(:,:,z), Rest, model, optimizer, metric, 'PyramidLevels', pl);
    rotations = myrotm2eul(tform(s,1).T);
    attempt = attempt + 1;
  end
  
end

end


%#ok<*AGROW>
%#ok<*ISMAT>