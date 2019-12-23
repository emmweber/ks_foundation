function seriesNumber = recon_epi_writedicom(I, rcnhandle, varargin)

error('Call dcm_write.m instead')

checkData = @(x) (isnumeric(x) && min(size(x(:,:,1))) > 8);
checkHandle = @(x) (isfield(x,'HandleType') && isfield(x,'sliceInfo'));

defaultVolindx = 1;
checkVolindx = @(x) (isnumeric(x) && x >= 1 && x <= 100000 && (mod(x,1) == 0));

defaultPrefix = '';
checkPrefix = @(x) (ischar(x));

defaultFields = [];
checkFields = @(x) (isfield(x(1),'Group') && isfield(x(1),'Element') && isfield(x(1),'VRType') && isfield(x(1),'Value'));

defaultseriesNumber = rcnhandle_getfield(rcnhandle,'series','se_no');
checkSeriesNumber = @(x) (isnumeric(x) || isempty(x));

defaultColorDicom = false;
checkColorDicom = @(x) (x == 0 || x == 1);

parm = inputParser;
addRequired(parm, 'I', checkData);
addRequired(parm, 'rcnhandle', checkHandle);

addParameter(parm, 'volindx', defaultVolindx, checkVolindx);
addParameter(parm, 'sedescprefix', defaultPrefix, checkPrefix);
addParameter(parm, 'dcmfields', defaultFields, checkFields);
addParameter(parm, 'seriesnumber', defaultseriesNumber, checkSeriesNumber);
addParameter(parm, 'colordicom', defaultColorDicom, checkColorDicom);

parse(parm, I, rcnhandle, varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if parm.Results.colordicom
  % if max(I(:)) > 1 || min(I(:)) < 0, warning('%s: ColorDicom expects image data in range [0,1]', mfilename); end
  I(I>1) = 1;
  I(I<0) = 0;
  finalImage = I * 255;
else
  I(I < 0) = 0;
  I(I > 32767) = 32767;
  finalImage = int16(I);
end

Nslices = size(I, 3+parm.Results.colordicom);
Nechoes = size(I, 4+parm.Results.colordicom);
Nvols   = size(I, 5+parm.Results.colordicom);

% Series description
seriesDesc = sprintf('%s%s', parm.Results.sedescprefix, rcnhandle_getfield(rcnhandle,'series','se_desc'));
      
for v = 1:Nvols
  volOffset = (parm.Results.volindx-1 + v-1);
  for z = 1:Nslices % spatial slice index (multiple acqs merged)
    for echo = 1:Nechoes
      
      % Compute image number and create dicom image
      matlabDicomPath = 'matlabDicoms/';
      imageNumber = echo + (z-1) * rcnhandle.nEchoes + volOffset * rcnhandle.nEchoes * rcnhandle.Slices;
      
      % Modify DICOM fields
      [performingPhysicianTag, psdNameWithScanTime] = recon_epi_dicomtags(rcnhandle);     
      
      % Output filename
      fname = [matlabDicomPath 'Image_' num2str(parm.Results.seriesnumber, '%03d') '_' num2str(imageNumber, '%05d') '.dcm'];
      
      if parm.Results.colordicom
        evalstr = 'GERecon(''Dicom.Write'', fname, finalImage(:,:,:,z,echo,v), imageNumber, rcnhandle.sliceInfo(z).Orientation, rcnhandle.sliceInfo(z).Corners, parm.Results.seriesnumber, seriesDesc, performingPhysicianTag, psdNameWithScanTime';
      else
        evalstr = 'GERecon(''Dicom.Write'', fname, finalImage(:,:,z,echo,v), imageNumber, rcnhandle.sliceInfo(z).Orientation, rcnhandle.sliceInfo(z).Corners, parm.Results.seriesnumber, seriesDesc, performingPhysicianTag, psdNameWithScanTime';
      end
      if ~isempty(parm.Results.dcmfields)
        for j = 1:numel(parm.Results.dcmfields)
          evalstr = sprintf('%s, parm.Results.dcmfields(%d)', evalstr, j);
        end
      end
      evalstr = sprintf('%s);', evalstr);
      % disp(evalstr)
      eval(evalstr);
      
    end
  end
end


seriesNumber = parm.Results.seriesnumber;

end

