function [datac, vol_av] = recon_epi_realign(data, fov, varargin)
% Usage:
% datac = moco_est(data, fov);
% datac = moco_est(data, fov, 'dwi', {true, false});
%
% Motion estimation on 1st echo, applied to all echoes
% Nav are averaged after motion correction and Nav dimension removed
%
% input  size(data)   = [Nx Ny Nz Nechoes Nav Nvols]
% output size(datac)  = [Nx Ny Nz Nechoes 1   Nvols]

defaultEstRes = 96;
checkEstRes = @(x) (isnumeric(x) && x >= 16);

checkData = @(x) (isnumeric(x) && min(size(data(:,:,1))) > 8 && (ndims(data) == 5 || ndims(data) == 6));
checkFOV = @(x) (isnumeric(x) && numel(fov) >=2 && numel(fov) <= 3);

defaultDWI = false;
checkDWI = @(x) (x == false || x == true);

defaultGPU = false;
checkGPU = @(x) (x == false || x == true);

parm = inputParser;
addRequired(parm,'data', checkData);
addRequired(parm, 'fov', checkFOV);
addParameter(parm, 'dwi', defaultDWI, checkDWI);
addParameter(parm, 'estres', defaultEstRes, checkEstRes);
addParameter(parm, 'gpu', defaultGPU, checkGPU);

parse(parm, data, fov, varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

datasz = size(data);
swapvolechoes = [1 2 3 5 4];

% keep non-zero averages along dim 5 (a.k.a. shots/NEX)
data = recon_epi_keepnonzeroaverages(data);
datasz = size(data); datasz(end+1:7) = 1;

% combine multishot and volume dimensions during registration (6D->5D)
data = reshape(data, [datasz(1:4) prod(datasz(5:6))]); % => [Nx Ny Nz Nechoes Nav*Nvols]

% swap echo and volume dimensions for easier moco
data = permute(data, swapvolechoes); % => [Nx Ny Nz Nav*Nvols Nechoes]

% initialize output
datac = zeros(size(data),'like', data);


% find the best volume to register to
[~, mode_penalty] = moco_sortbymode(data(:,:,:,:,1), 75);
con_penalty = 0; % [~, con_penalty]  = moco_sortbysliceconsistency(data(:,:,:,:,1),75);
exclslices        = moco_excludeslices(data(:,:,:,:,1), 0.8);
[~, v_penalty]    = moco_sortbyvalidslices(exclslices);
[~,referencevol]  = sort(mode_penalty + con_penalty + v_penalty); referencevol = referencevol(1);

% moco 2D
result2d = moco_est(data(:,:,:,:,1), data(:,:,:,referencevol,1), fov, 'regdims', 2, 'estres', parm.Results.estres);

% overall sense of how much motion (rotation) that was found per volume
vol_av = moco_reg2d_amount(result2d.tform, exclslices);

%if strcmp(moco_scanplane(rcnhandle),'axial')
%  referencedata_straight = moco_straightup(data(:,:,:,referencevol,1), fov);
%end

if max(vol_av) < recon_epi_smallmotionthreshold && parm.Results.dwi
  
  % without motion corruption, let's do non-linear correction against the mean to correct for eddy currents
  meandwi1stecho = mean(data(:,:,:,:,1), 4);
  
  % run imregdemons on GPU if available and input option selected
  if gpuDeviceCount && parm.Results.gpu
    disp('GPU moco')
    data = gpuArray(data);
    datac = gpuArray(datac);
    meandwi1stecho = gpuArray(meandwi1stecho);
    parfor j = 1:size(data,4)
      datac(:,:,:,j,:) = moco_imregdemons2d(data(:,:,:,j,:), meandwi1stecho);
    end
    datac = gather(datac);
  else
    parfor j = 1:size(data,4)
      datac(:,:,:,j,:) = moco_imregdemons2d(data(:,:,:,j,:), meandwi1stecho);
    end
  end
  
else
  
  % Apply 2D correction
  for echo = 1:size(data,5)
    datac(:,:,:,:,echo) = moco_apply(data(:,:,:,:,echo), result2d); % resample 2D correction
  end
  
  if max(vol_av) > recon_epi_smallmotionthreshold
    % Additional 3D motion correction of 2D corrected data
    result3d = moco_est(datac(:,:,:,:,1), data(:,:,:,referencevol,1), fov, 'regdims', 3, 'estres', parm.Results.estres);
    for echo = 1:size(data,5)
      datac(:,:,:,:,echo) = moco_apply(datac(:,:,:,:,echo), result3d);
    end
  end
  
end

datac = ipermute(datac, swapvolechoes);  % => [Nx Ny Nz Nechoes Nav*Nvols]
datac = reshape(datac, datasz);          % => [Nx Ny Nz Nechoes Nav Nvols]
datac = mean(datac, 5);                  % => [Nx Ny Nz Nechoes 1 Nvols]

end


