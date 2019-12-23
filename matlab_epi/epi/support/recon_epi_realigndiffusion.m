function [Ic,vol_av_all] = recon_epi_realigndiffusion(I, rcnhandle, varargin)

checkData = @(x) (isnumeric(x) && min(size(x(:,:,1))) > 8);
checkHandle = @(x) (isfield(x,'HandleType') && isfield(x,'sliceInfo'));

defaultGPU = false;
checkGPU = @(x) (x == false || x == true);

defaultDebug = false;
checkDebug = @(x) (x == false || x == true);

defaultmeanmocodims = 2;
checkmeanmocodims = @(x) (x == 2 || x== 3);

parm = inputParser;
addRequired(parm, 'I', checkData);
addRequired(parm, 'rcnhandle', checkHandle);
addParameter(parm, 'gpu', defaultGPU, checkGPU);
addParameter(parm, 'debug', defaultDebug, checkDebug);
% 2D or 3D correction for last step aligning the mean volumes against each other
% meanb0 against meanDWI_lowestb
% For multible b-values also: meanDWI_higherb against meanDWI_lowestb
% Note that recon_epi_realign.m, called below within the b0 group and each DWI bval group separately
% still has its own 2D/3D realignment system and rules independent on 'meanmocodims'
addParameter(parm, 'meanmocodims', defaultmeanmocodims, checkmeanmocodims);

parse(parm, I, rcnhandle, varargin{:});

w = warning;
warning off;
f = figure('visible', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isz = size(I); isz(end+1:6) = 1; % [Nx Ny Nz Nechoes Nshots Nvols]

[~, nT2Images, nDiffusionDirections, allbValues] = recon_epi_diffscheme(rcnhandle);

% Return early for single volume
if nT2Images == 1 && nDiffusionDirections == 0
  Ic = I;
  vol_av_all = 0;
  return
end


fov = [rcnhandle_getfield(rcnhandle,'image','dfov') ...
  rcnhandle_getfield(rcnhandle,'image','dfov_rect') ...
  (rcnhandle_getfield(rcnhandle,'image','slthick') + rcnhandle_getfield(rcnhandle,'image','scanspacing')) * isz(3)];

b0vols = 1:nT2Images;
for b = 1:numel(allbValues)
  dwivols{b} = (nT2Images+nDiffusionDirections*(b-1)+1):(nT2Images+nDiffusionDirections*b);
end

icsz = isz;
icsz(5) = 1; % average over shots/NEX
icsz(6) = 1 + numel(allbValues) * nDiffusionDirections;
Ic = zeros(icsz, 'like', I);



%% Realign volumes for b0s and each b-value independently
for b = 0:numel(allbValues)
  
  if b == 0
    if (isz(5) * nT2Images) > 1 % more than 1 b0 and 1 average/MagNex
      [Ic(:,:,:,:,1,b0vols), vol_av_b0] = recon_epi_realign(I(:,:,:,:,:,b0vols), fov, 'dwi', false, 'gpu', parm.Results.gpu);
    else
      Ic(:,:,:,:,:,b0vols) = I(:,:,:,:,:,b0vols);
      vol_av_b0 = 0;
    end
  else
    if numel(dwivols{b}) > 1
      [Ic(:,:,:,:,1,dwivols{b}), vol_av{b}] = recon_epi_realign(I(:,:,:,:,:,dwivols{b}), fov, 'dwi', true, 'gpu', parm.Results.gpu);
    else
      Ic(:,:,:,:,1,dwivols{b}) = I(:,:,:,:,:,dwivols{b});
      vol_av{b} = 0;
    end
  end
  
end % b


%% write data as PNG and movies (b0+1st bvalue, echo 1)

if exist('dwivols','var') % if not, we are doing SE-EPI or GE-EPI (fMRI)
  
  % uncorrected data (1st echo)
  meandwi_1stb = mean(I(:,:,:,1,1,dwivols{1}),6);
  meanb0       = mean(I(:,:,:,1,1,b0vols),6);
  
  % eddy or 2D/3D corrected data (1st echo)
  meandwi_1stbc = mean(Ic(:,:,:,1,1,dwivols{1}),6);
  meanb0c       = mean(Ic(:,:,:,1,1,b0vols),6);
  
  if parm.Results.debug
    imshowpair(create_mosaic(meandwi_1stb),create_mosaic(meanb0)); title('dwi-b0'); drawnow
    print -dpng dwi_b0.png
    
    imshowpair(create_mosaic(meandwi_1stbc),create_mosaic(meanb0c)); title('dwic-b0c'); drawnow
    print -dpng dwic_b0c.png
    
    recon_epi_realigndiffusion_videowrite(I(:,:,:,:,:,dwivols{1}),  sprintf('dwi_b%d',allbValues(1)));
    recon_epi_realigndiffusion_videowrite(Ic(:,:,:,:,:,dwivols{1}), sprintf('dwic_b%d',allbValues(1)));
  end
  
end % exist dwivols

if numel(b0vols) > 1 && parm.Results.debug
  recon_epi_realigndiffusion_videowrite(I(:,:,:,:,:,b0vols),      'b0');
  recon_epi_realigndiffusion_videowrite(Ic(:,:,:,:,:,b0vols),     'b0c');
end

%% 2D or 3D register mean b0 to mean DWI for 1st bvalue, and apply to all b0s (and echoes)

if exist('meandwi_1stbc','var') && (any(vol_av_b0 > recon_epi_smallmotionthreshold) || any(vol_av{1} > recon_epi_smallmotionthreshold)) && numel(dwivols{1}) > 0
    
  if parm.Results.meanmocodims == 2
    groupaligntitle = 'dwic-b0c: 2D monomodal correction';
    % 2D ('multimodal' should be the way, but 'monomodal' works better)
    for z = 1:size(meanb0c,3)
      result2d = moco_est(meanb0c(:,:,z), meandwi_1stbc(:,:,z), fov, 'regdims', 2,'metric','monomodal');
      for echo = 1:icsz(4)
        for b0 = b0vols
          Ic(:,:,z,echo,1,b0) = moco_apply(Ic(:,:,z,echo,1,b0), result2d);
        end
      end
    end
  else
    % 3D
    groupaligntitle = 'dwic-b0c: 3D multimodal correction';
    result3d = moco_est(meanb0c, meandwi_1stbc, fov, 'regdims', 3,'metric','multimodal');
    for echo = 1:icsz(4)
      for b0 = b0vols
        Ic(:,:,:,echo,1,b0) = moco_apply(Ic(:,:,:,echo,1,b0), result3d);
      end
    end
  end
  
  % update meanb0c for PNG
  meanb0c = mean(Ic(:,:,:,1,1,b0vols),6);
  
  if parm.Results.debug
    % write out 2D+3D corrected data as PNG and movies (b0+1st bvalue)
    imshowpair(create_mosaic(meandwi_1stbc),create_mosaic(meanb0c)); title(groupaligntitle); drawnow
    print -dpng dwic_b0c_multimodal.png
    
    if numel(b0vols) > 1
      recon_epi_realigndiffusion_videowrite(Ic(:,:,:,:,:,b0vols), 'b0_multimodal');
    end
  end
  
end % had motion



%% 3D realign higher bvalues to mean DWI for 1st bvalue
for b = 2:numel(allbValues)
  
  meandwi_thisb  = mean(I(:,:,:,1,1,dwivols{b}),6);
  meandwi_thisbc = mean(Ic(:,:,:,1,1,dwivols{b}),6);
  
  if parm.Results.debug
    imshowpair(create_mosaic(meandwi_1stb),create_mosaic(meandwi_thisb)); title(sprintf('dwi b%d vs b%d', round(allbValues(1)), round(allbValues(b)))); drawnow
    print('-dpng',sprintf('dwi_b%d_vs_b%d.png', round(allbValues(1)), round(allbValues(b))));
    
    imshowpair(create_mosaic(meandwi_1stbc),create_mosaic(meandwi_thisbc)); title(sprintf('dwic b%d vs b%d', round(allbValues(1)), round(allbValues(b)))); drawnow
    print('-dpng',sprintf('dwic_b%d_vs_b%d.png', round(allbValues(1)), round(allbValues(b))));
    
    recon_epi_realigndiffusion_videowrite(I(:,:,:,:,:,dwivols{b}),  sprintf('dwi_b%d',allbValues(b)));
    recon_epi_realigndiffusion_videowrite(Ic(:,:,:,:,:,dwivols{b}), sprintf('dwic_b%d',allbValues(b)));
  end
  
  if any(vol_av{1} > recon_epi_smallmotionthreshold) || any(vol_av{b} > recon_epi_smallmotionthreshold)
           
    if parm.Results.meanmocodims == 2
      groupaligntitle = sprintf('dwic b%d vs b%d 2D monomodal', round(allbValues(1)), round(allbValues(b)));
      % 2D ('multimodal' should be the way, but 'monomodal' works better)
      for z = 1:size(meandwi_thisbc,3)
        result2d = moco_est(meandwi_thisbc(:,:,z), meandwi_1stbc(:,:,z), fov, 'regdims', 2,'metric','monomodal');
        for echo = 1:icsz(4)
          for d = dwivols{b}
            Ic(:,:,:,echo,1,d) = moco_apply(Ic(:,:,:,echo,1,d), result2d);
          end
        end
      end
    else
      % 3D
      groupaligntitle = sprintf('dwic b%d vs b%d 2D multimodal', round(allbValues(1)), round(allbValues(b)));
      result3d = moco_est(meandwi_thisbc, meandwi_1stbc, fov, 'regdims', 3,'metric','multimodal');
      for echo = 1:icsz(4)
        for d = dwivols{b}
          Ic(:,:,:,echo,1,d) = moco_apply(Ic(:,:,:,echo,1,d), result3d);
        end
      end
    end
      
    % update meandwi_thisbc for PNG
    meandwi_thisbc = mean(Ic(:,:,:,1,1,dwivols{b}),6);
    
    %% write out PNG and movies
    if parm.Results.debug
      imshowpair(create_mosaic(meandwi_1stbc),create_mosaic(meandwi_thisbc)); title(groupaligntitle); drawnow
      print('-dpng',sprintf('dwi_b%d_vs_b%d_multimodal.png', round(allbValues(1)), round(allbValues(b))));
      
      recon_epi_realigndiffusion_videowrite(Ic(:,:,:,:,:,dwivols{b}), sprintf('dwic_multimodal_b%d',allbValues(b)));
    end
    
  end
  
end


% remove shot dimension
Ic = permute(mean(Ic,5),[1 2 3 4 6 5]); % 6D -> 5D % => [Nx Ny Nz Nechoes Nvols]

warning(w);
close(f)

if exist('vol_av','var')
  vol_av_all = [vol_av_b0 vol_av{:}];
else
  vol_av_all = vol_av_b0;
end


if max(vol_av_all(:)) > recon_epi_smallmotionthreshold
  % remove 1st and last slice as they are corrupted from out-of-volume resampling effects
  Ic(:,:,[1 end],:,:,:) = 0;
end

end

%#ok<*AGROW>



