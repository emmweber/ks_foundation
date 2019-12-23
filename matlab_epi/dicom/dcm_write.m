function seriesNumber = dcm_write(I, rcnhandle, varargin)

checkData = @(x) (isnumeric(x) && min(size(x(:,:,1))) > 8);
checkHandle = @(x) (isfield(x,'HandleType') && isfield(x,'sliceInfo'));

defaultVolindx = 1;
checkVolindx = @(x) (isnumeric(x) && x >= 1 && x <= 100000 && (mod(x,1) == 0));

defaultSeriesPrefix = '';
checkSeriesPrefix = @(x) (ischar(x));

defaultCoilPrefix = '';
checkCoilPrefix = @(x) (ischar(x));

defaultFields = [];
checkFields = @(x) (isfield(x(1),'Group') && isfield(x(1),'Element') && isfield(x(1),'VRType') && isfield(x(1),'Value'));

defaultseriesNumber = rcnhandle_getfield(rcnhandle,'series','se_no');
checkSeriesNumber = @(x) (isnumeric(x) || isempty(x));

defaultColorDicom = false;
checkColorDicom = @(x) (x == 0 || x == 1);

defaultEchoIndex = 0;
checkEchoIndex = @(x) (x >= 1 && x <= 16);

pth = fileparts(mfilename('fullpath'));
defaultDcmHostsJson = fullfile(pth,'..','wrappers','dicomutils','hosts.json');
checkDcmHostsJson = @(x) (ischar(x) && exist(x,'file'));

defaultSendTo = {};
checkSendTo = @(x) (iscell(x));

defaultRmNotDiag = 1;
checkRmNotDiag = @(x) (x == 0 || x == 1);

defaultOutputdir = 'matlabDicoms';
checkOutputdir = @(x) (ischar(x) && exist(x,'file'));

parm = inputParser;
addRequired(parm, 'I', checkData);
addRequired(parm, 'rcnhandle', checkHandle);

addParameter(parm, 'volindx', defaultVolindx, checkVolindx);
addParameter(parm, 'sedescprefix', defaultSeriesPrefix, checkSeriesPrefix);
addParameter(parm, 'coilprefix', defaultCoilPrefix, checkCoilPrefix);
addParameter(parm, 'dcmfields', defaultFields, checkFields);
addParameter(parm, 'seriesnumber', defaultseriesNumber, checkSeriesNumber);
addParameter(parm, 'colordicom', defaultColorDicom, checkColorDicom);
addParameter(parm, 'echoindex', defaultEchoIndex, checkEchoIndex);

addParameter(parm, 'dcmhostsjson', defaultDcmHostsJson, checkDcmHostsJson);
addParameter(parm, 'sendto', defaultSendTo, checkSendTo);
addParameter(parm, 'remove_notdiagnostic', defaultRmNotDiag, checkRmNotDiag);
addParameter(parm, 'outputdir', defaultOutputdir, checkOutputdir);

defaultSlicevec = [];
checkSlicevector = @(x) (isnumeric(x) && isvector(x) && isinteger(x) && min(x) >=1 && max(x) <= size(I,3+parm.Results.colordicom));
addParameter(parm, 'slicevec', defaultSlicevec, checkSlicevector);

parse(parm, I, rcnhandle, varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if parm.Results.colordicom
  % if max(I(:)) > 1 || min(I(:)) < 0, warning('%s: ColorDicom expects image data in range [0,1]', mfilename); end
  I(I>1) = 1;
  I(I<0) = 0;
  finalImage = I * 255;
else
  I(I < -32767) = -32767;
  I(I > 32767) = 32767;
  finalImage = int16(I);
end

if isempty(parm.Results.slicevec)
  slicevec = 1:size(I,parm.Results.colordicom + 3);
else
  slicevec = parm.Results.slicevec;
end

Nslices = numel(parm.Results.slicevec);
Nechoes = size(I, 4+parm.Results.colordicom);
Nvols   = size(I, 5+parm.Results.colordicom);

% Series description
seriesDesc = sprintf('%s%s', parm.Results.sedescprefix, rcnhandle_getfield(rcnhandle,'series','se_desc'));

psdiname = deblank(strtrim(rcnhandle_getfield(rcnhandle,'image','psd_iname')));

% Output path
matlabDicomPath = parm.Results.outputdir;
[~, tmpdir] = fileparts(tempname);
matlabDicomPath_temp = fullfile(matlabDicomPath, tmpdir);
mkdir(matlabDicomPath_temp);


%% Write DICOMs

fname = cell(1,Nvols * Nslices * Nechoes);
f = 1;

start_slice = min(slicevec);
for v = 1:Nvols
  volOffset = (parm.Results.volindx-1 + v-1);
  for z = slicevec % spatial slice index (multiple acqs merged)
    for echo = 1:Nechoes
      
      % Compute image number and create dicom image

      imageNumber = echo + (z-start_slice) * rcnhandle.nEchoes + volOffset * rcnhandle.nEchoes * rcnhandle.Slices;
           
      % Output filename
      fname{f} = [matlabDicomPath_temp '/Image_' num2str(parm.Results.seriesnumber, '%03d') '_' num2str(imageNumber, '%05d') '.dcm'];
      
      if parm.Results.colordicom
        evalstr = 'GERecon(''Dicom.Write'', fname{f}, finalImage(:,:,:,z,echo,v), imageNumber, rcnhandle.sliceInfo(z).Orientation, rcnhandle.sliceInfo(z).Corners, parm.Results.seriesnumber, seriesDesc ';
      else
        evalstr = 'GERecon(''Dicom.Write'', fname{f}, finalImage(:,:,z,echo,v),   imageNumber, rcnhandle.sliceInfo(z).Orientation, rcnhandle.sliceInfo(z).Corners, parm.Results.seriesnumber, seriesDesc ';
      end
      
      % Always modify the following DICOM fields
      if parm.Results.echoindex > 0
        echo4annotation = parm.Results.echoindex;
      else
        echo4annotation = echo;
      end
      [performingPhysicianTag, psdNameWithScanTime, echoTime, rcvCoil] = dcm_ksdicomtags(rcnhandle, echo4annotation, parm.Results.coilprefix);
      evalstr = sprintf('%s, performingPhysicianTag, psdNameWithScanTime, echoTime, rcvCoil', evalstr);
      
      % Add user dicom tags
      if ~isempty(parm.Results.dcmfields)
        for j = 1:numel(parm.Results.dcmfields)
          evalstr = sprintf('%s, parm.Results.dcmfields(%d)', evalstr, j);
        end        
      end     
      
      % close parenthesis
      evalstr = sprintf('%s);', evalstr);
      
      % disp(evalstr)
      eval(evalstr);
      
      f = f + 1;
      
    end % Echoes
  end % Slices
end % Nvols

%% Remove "NOT Diagnostic:" in the series description (uses dcmodify and dcmdump)
if parm.Results.remove_notdiagnostic
  dcm_remove_nondiagnosticdesc(fullfile(matlabDicomPath_temp,'*dcm'));
end

%% send dicoms if hosts are set
if ~isempty(parm.Results.sendto)
  dcm_send(parm.Results.dcmhostsjson, parm.Results.sendto, matlabDicomPath_temp);
end

%% move dcm from tmp folder to outputdir
for f = 1:numel(fname)
  [pth,newname] = fileparts(fname{f});
  pth = fileparts(pth); % remove tmpdir
  movefile(fname{f}, [fullfile(pth,newname) '.dcm']);
end
rmdir(matlabDicomPath_temp);


%% return value
seriesNumber = parm.Results.seriesnumber;

end

