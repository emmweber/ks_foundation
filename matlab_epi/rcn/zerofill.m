function zfilldata = zerofill(data, zfillsize, varargin)

checkData = @(x) (isnumeric(x) && ~isreal(x) && min(size(x(:,:,1))) > 8);
checkZfillSize = @(x) (isnumeric(x) && isreal(x) && all(x >= 0));

defaultFill = 'both';
expectedFill = {'both', 'pre', 'post', 'left', 'right', 'top', 'bottom'};
checkFill = @(x) (ischar(x) &&  any(validatestring(x, expectedFill) ));

parm = inputParser;
addRequired(parm, 'data', checkData);
addRequired(parm, 'zfillsize', checkZfillSize);
addParameter(parm, 'fill', defaultFill, checkFill);

parse(parm, data, zfillsize, varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zfillsz = parm.Results.zfillsize;
fillmode = parm.Results.fill; % both, pre, post, left, right, top, bottom

if numel(zfillsz) > 1 && contains(fillmode, {'left', 'right', 'top', 'bottom'})
  error('zerofill: ''fill = left/right/top/bottom'' requires scalar 2nd argument');
end

if numel(zfillsz) == 1 && contains(fillmode, {'both', 'pre', 'post'})
  zfillsz = [1 1] * zfillsz; % scalar input
elseif strcmp(fillmode, 'left')  
  zfillsz = [0 1] * zfillsz;
  fillmode = 'pre';
elseif strcmp(fillmode, 'right')
  zfillsz = [0 1] * zfillsz;
  fillmode = 'post';
elseif strcmp(fillmode, 'top')
  zfillsz = [1 0] * zfillsz;
  fillmode = 'pre';
elseif strcmp(fillmode, 'bottom')
  zfillsz = [1 0] * zfillsz;
  fillmode = 'post';
end

sz = size(data);

zfillsz(end+1:numel(sz)) = 0;
zfillsz = zfillsz(1:numel(sz));

padsz = zfillsz - sz;
padsz(padsz < 0) = 0;

if strcmp(fillmode,'both')
  padsz = padsz/2;
end

padsz = round(padsz);

zfilldata = padarray(data, padsz, fillmode);

end
