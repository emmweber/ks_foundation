function seriesNumber = recon_epi_diffusion(I, rcnhandle, varargin)

% Nov2018 change: Now input array I may be corrected for coil sensitivities in recon_2Depi already using either PURE or SCIC
% However, as the same coil sensitivity field has been applied to all b0 and b>0 volumes, this will not affect the ADC data

checkData = @(x) (isnumeric(x) && min(size(x(:,:,1))) > 8);
checkHandle = @(x) (isfield(x,'HandleType') && isfield(x,'sliceInfo'));

defaultPrefix = '';
checkPrefix = @(x) (ischar(x));

defaultFields = [];
checkFields = @(x) (isfield(x(1),'Group') && isfield(x(1),'Element') && isfield(x(1),'VRType') && isfield(x(1),'Value'));

defaultseriesNumber = rcnhandle_getfield(rcnhandle,'series','se_no') * 100;
checkSeriesNumber = @(x) (isnumeric(x) || isempty(x));

defaultSendTo = {};
checkSendTo = @(x) (iscell(x));

parm = inputParser;
addRequired(parm, 'I', checkData);
addRequired(parm, 'rcnhandle', checkHandle);

addParameter(parm, 'sedescprefix', defaultPrefix, checkPrefix);
addParameter(parm, 'dcmfields', defaultFields, checkFields);
addParameter(parm, 'seriesnumber', defaultseriesNumber, checkSeriesNumber);
addParameter(parm, 'sendto', defaultSendTo, checkSendTo);

parse(parm, I, rcnhandle, varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% size(I) = [Nx, Ny, spatialSliceindex, Echo, VolNo]
[diffscheme, nT2Images, nDiffusionDirections, allbValues] = recon_epi_diffscheme(rcnhandle);
[diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag] = recon_epi_diffusiondicomtags(1, rcnhandle);


% remove diffusion direction info
userData20Tag.Value = sprintf('%.6f', 0);
userData21Tag.Value = sprintf('%.6f', 0);
userData22Tag.Value = sprintf('%.6f', 0);

% rescale I to avoid discretization errors before converting to int16 (DICOM)
I = I * 1e4 / max(I(:));
I(I < 0) = 0;
I(I > 32767) = 32767;
I(~isfinite(I)) = 0; % remove potential NaNs or Infs

% masking threshold
tmp = squeeze(mean(abs(I(:,:,:,1,1:nT2Images)),5)); % all z, 1st echo
mskthr = mean(tmp(:)) * 0.6; clear tmp;

% output # and description
seriesNumber = parm.Results.seriesnumber; % need to increment by 1 before each series write
globalSeriesPrefix = parm.Results.sedescprefix;
extraDicomFields = parm.Results.dcmfields;

if isfield(rcnhandle, 'coilSensitivityFieldLabel') && ~isempty(rcnhandle.coilSensitivityFieldLabel)
  coilSensitivityFieldLabel = rcnhandle.coilSensitivityFieldLabel;
else
  coilSensitivityFieldLabel = '';
end
centerPrefix = sprintf('%s%s', globalSeriesPrefix, coilSensitivityFieldLabel);
if ~isempty(centerPrefix)
  centerPrefix = [centerPrefix ':'];
end


for echo = 1:size(I,4)
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mean b0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  b0 = squeeze(mean(abs(I(:,:,:,echo,1:nT2Images)),5));
  msk = smooth(b0,15);
  msk = msk > mskthr;
  
  seriesNumber = seriesNumber + 1;
  diffusionImageTypeTag.Value = 14; % T2
  bValueTag.Value = [num2str(0) '\8\0\0']; % no bvalue for T2
  bValue2Tag.Value = 0;
  seriesPrefix = sprintf('b0:%s', centerPrefix);
  coilPrefix = seriesPrefix;
 
  if rcnhandle.returnseries.b0
    dcm_write(b0, rcnhandle, 'sedescprefix', seriesPrefix, 'coilprefix', coilPrefix, ...
      'dcmfields', [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, extraDicomFields], ...
      'seriesnumber', seriesNumber, 'sendto', parm.Results.sendto, 'echoindex', echo);
  end

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% meandwi per b-value %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  diffusionImageTypeTag.Value = 15; % Combined DWI
  for b = 1:numel(allbValues)
    range = (nT2Images+nDiffusionDirections*(b-1)+1):(nT2Images+nDiffusionDirections*b);
    meandwi{b} = squeeze(mean(abs(I(:,:,:,echo,range)),5));
    
    seriesNumber = seriesNumber + 1;
    if numel(allbValues) > 1
      seriesPrefix = sprintf('DWI[b%d]:%s', round(allbValues(b)), centerPrefix);
    else
      seriesPrefix = sprintf('DWI:%s', centerPrefix);
    end
    coilPrefix = seriesPrefix;

    bValueTag.Value = [num2str(round(allbValues(b))) '\8\0\0'];
    bValue2Tag.Value = round(allbValues(b));
    
    if rcnhandle.returnseries.meandwi
      dcm_write(meandwi{b}, rcnhandle, 'sedescprefix', seriesPrefix, 'coilprefix', coilPrefix, ...
        'dcmfields', [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, extraDicomFields], ...
        'seriesnumber', seriesNumber, 'sendto', parm.Results.sendto, 'echoindex', echo);
    end

  end
  
    
  if nDiffusionDirections < 6
    
    %%%%%%%%%%%%%%% meanADC %%%%%%%%%%%%
    diffusionImageTypeTag.Value = 20; % adc
    for b = 1:numel(allbValues)
      
      meanadc{b} = 1e6 * log(b0 ./ meandwi{b}) / allbValues(b);
      meanadc{b}(~isfinite(meanadc{b})) = 0;
      meanadc{b}(meanadc{b} < 0) = 0;
      meanadc{b} = meanadc{b} .* msk;
      
      seriesNumber = seriesNumber + 1;
      if numel(allbValues) > 1
        seriesPrefix = sprintf('ADC[b%d]:%s', round(allbValues(b)), centerPrefix);
      else
        seriesPrefix = sprintf('ADC:%s', centerPrefix);
      end
      coilPrefix = seriesPrefix;
      
      bValueTag.Value = [num2str(round(allbValues(b))) '\8\0\0'];
      bValue2Tag.Value = round(allbValues(b));
      
      if rcnhandle.returnseries.meanadc
        dcm_write(meanadc{b}, rcnhandle, 'sedescprefix', seriesPrefix, 'coilprefix', coilPrefix, ...
          'dcmfields', [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, extraDicomFields], ...
          'seriesnumber', seriesNumber, 'sendto', parm.Results.sendto, 'echoindex', echo);
      end
      
    end
    
    
    %%%%%%%%%%%%%%% ExpAtt (exponential attenuation) %%%%%%%%%%%%%%%
    diffusionImageTypeTag.Value = 17; % eadc
    for b = 1:numel(allbValues)
      
      eadc = exp(-allbValues(b) * 1e-6 * meanadc{b}) * 1e3;
      eadc(~isfinite(eadc)) = 0;
      eadc = eadc .* msk;
      
      seriesNumber = seriesNumber + 1;
      
      if numel(allbValues) > 1
        seriesPrefix = sprintf('ExpAtt[b%d]:%s', round(allbValues(b)), centerPrefix);
      else
        seriesPrefix = sprintf('ExpAtt:%s', centerPrefix);
      end
      coilPrefix = seriesPrefix;
      
      bValueTag.Value = [num2str(round(allbValues(b))) '\8\0\0'];
      bValue2Tag.Value = round(allbValues(b));
      
      if rcnhandle.returnseries.expatt
        dcm_write(eadc, rcnhandle, 'sedescprefix', seriesPrefix, 'coilprefix', coilPrefix, ...
          'dcmfields', [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, extraDicomFields], ...
          'seriesnumber', seriesNumber, 'sendto', parm.Results.sendto, 'echoindex', echo);
      end
      
    end
    
    
    
  else
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Tensor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for b = 1:numel(allbValues)
      
      range  = (nT2Images+nDiffusionDirections*(b-1)+1):(nT2Images+nDiffusionDirections*b);
      dwi    = squeeze(I(:,:,:,echo,range));
      adc    = diff_adc(b0, dwi, allbValues(b));
      D      = diff_tensor(adc, diffscheme(range,:));
      isoadc = squeeze(mean(D(1:3,:,:,:),1));
      eadc   = exp(-allbValues(b) * 1e-6 * isoadc) * 1e3;
      eadc(~isfinite(eadc)) = 0;
      [FA,C] = diff_FA(D);
      isoadc = isoadc .* msk;
      eadc   = eadc .* msk;
      FA     = FA .* msk;
      C      = permute(abs(C).*repmat(FA,[1 1 1 3]),[1 2 4 3]);
      
      bValueTag.Value = [num2str(round(allbValues(b))) '\8\0\0'];
      bValue2Tag.Value = round(allbValues(b));
      
      %%%%%%%%%%%%%%% isoADC %%%%%%%%%%%%
      seriesNumber = seriesNumber + 1;
      diffusionImageTypeTag.Value = 20; % meanadc from tensor (guaranteed to be isotropically weighted)
      
      if numel(allbValues) > 1
        seriesPrefix = sprintf('ADC[b%d]:%s', round(allbValues(b)), centerPrefix);
      else
        seriesPrefix = sprintf('ADC:%s', centerPrefix);
      end
      coilPrefix = seriesPrefix;

      if rcnhandle.returnseries.meanadc
        dcm_write(isoadc, rcnhandle, 'sedescprefix', seriesPrefix, 'coilprefix', coilPrefix, ...
          'dcmfields', [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, extraDicomFields], ...
          'seriesnumber', seriesNumber, 'sendto', parm.Results.sendto, 'echoindex', echo);
      end
      
      %%%%%%%%%%%%%%% eADC (a.k.a. exponential attenuation) %%%%%%%%%%%%%%%
      seriesNumber = seriesNumber + 1;
      diffusionImageTypeTag.Value = 17; % eadc
      
      if numel(allbValues) > 1
        seriesPrefix = sprintf('ExpAtt[b%d]:%s', round(allbValues(b)), centerPrefix);
      else
        seriesPrefix = sprintf('ExpAtt:%s', centerPrefix);
      end
      coilPrefix = seriesPrefix;
      
      if rcnhandle.returnseries.expatt
        dcm_write(eadc, rcnhandle, 'sedescprefix', seriesPrefix, 'coilprefix', coilPrefix, ...
          'dcmfields', [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, extraDicomFields], ...
          'seriesnumber', seriesNumber, 'sendto', parm.Results.sendto, 'echoindex', echo);
      end
      
      %%%%%%%%%%%%%%% FA %%%%%%%%%%%%%%%
      seriesNumber = seriesNumber + 1;
      diffusionImageTypeTag.Value = 18; % FA
      
      if numel(allbValues) > 1
        seriesPrefix = sprintf('FA[b%d]:%s', round(allbValues(b)), centerPrefix);
      else
        seriesPrefix = sprintf('FA:%s', centerPrefix);
      end
      coilPrefix = seriesPrefix;
      
      if rcnhandle.returnseries.fa
        dcm_write(FA*1e3, rcnhandle, 'sedescprefix', seriesPrefix, 'coilprefix', coilPrefix, ...
          'dcmfields', [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, extraDicomFields], ...
          'seriesnumber', seriesNumber, 'sendto', parm.Results.sendto, 'echoindex', echo);
      end
      
      %%%%%%%%%%%%%%% cFA %%%%%%%%%%%%%%%
      seriesNumber = seriesNumber + 1;
      diffusionImageTypeTag.Value = 31; % color FA (cFA)
      
      if numel(allbValues) > 1
        seriesPrefix = sprintf('cFA[b%d]:%s', round(allbValues(b)), centerPrefix);
      else
        seriesPrefix = sprintf('cFA:%s', centerPrefix);
      end
      coilPrefix = seriesPrefix;
      
      if rcnhandle.returnseries.cfa
        dcm_write(C, rcnhandle, 'sedescprefix', seriesPrefix, 'coilprefix', coilPrefix, ...
          'dcmfields', [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, extraDicomFields], ...
          'seriesnumber', seriesNumber, 'colordicom', true, 'sendto', parm.Results.sendto, 'echoindex', echo);
      end
      
    end % b
    
    
  end % dir > 6
  
end % echo

end
