function I = pocs(kspace, nover, peak, varargin)

checkData = @(x) (isnumeric(x) && ~isreal(x) && min(size(x(:,:,1))) > 8);
checkNover = @(x) (isnumeric(x) && isreal(x) && mod(x,1) == 0 && x > 0);

checkPeakPos = @(x) (ischar(x) && ...
  (strncmpi(x,'left',1) || strncmpi(x,'right',1) || strncmpi(x,'top',1) || strncmpi(x,'bottom',1)) );

defaultTran = 2;
checknTran = @(x) (isnumeric(x) && x >= 1 && x <= 10);

defaultIter = 3;
checkIter = @(x) (isnumeric(x) && mod(x,1) == 0 && x >= 1 && x <= 100);

parm = inputParser;
addRequired(parm, 'kspace', checkData);
addRequired(parm, 'nover',  checkNover);
addRequired(parm, 'peak', checkPeakPos); % left, right, top, bottom
addParameter(parm, 'ntran', defaultTran, checknTran);
addParameter(parm, 'iter', defaultIter, checkIter);

parse(parm, kspace, nover, peak, varargin{:});

ntran = parm.Results.ntran;
nover = parm.Results.nover;
peak = parm.Results.peak;
iter =  parm.Results.iter;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


ksz = size(kspace); ksz(end+1:6) = 1;

if strncmpi(peak,'left',1) || strncmpi(peak,'right',1)
  np = ksz(2); % size in partial Fourier dim
  nother = ksz(1); % size in full Fourier dim
else
  np = ksz(1); % size in partial Fourier dim
  nother = ksz(2); % size in full Fourier dim
end

na = np - 2 * nover;
nf = 2 * (np - nover); % full size in partial Fourier dim
padsz = nf-np;

% form the weighting matrices -- only 1D, nf in length
y = 1:nf;
q = np - 2 * ntran;
p = nf - q;
v = 1./(1+exp((y-q)/ntran)) - 1./(1+exp((y-p)/ntran));
v = repmat(v, nother, 1);  % symmetric weights

if isa(kspace,'single')
  v = single(v);
end

if strncmpi(peak,'left',1) || strncmpi(peak,'right',1)
  first_fft = [-1 0];
  second_fft = [0 -1];
else
  first_fft = [0 -1];
  second_fft = [-1 0];
end

hspace = cft(kspace, first_fft);
%clear kspace

% zerofill hspace based on k-space peak position
if strncmpi(peak,'left',1)
  hspace = padarray(hspace, [0 padsz], 'pre');
  padrange1 = 1:nother; % pad region dim 1
  padrange2 = 1:na; % pad region dim 2
  s = hspace(:,(nf/2-nover+1):(nf/2+nover),:,:,:,:,:);
  v = flip(v,2);
elseif strncmpi(peak,'right',1)
  hspace = padarray(hspace, [0 padsz], 'post');
  padrange1 = 1:nother; % pad region dim 1
  padrange2 = (np+1):nf; % pad region dim 2
  s = hspace(:,(nf/2-nover+1):(nf/2+nover),:,:,:,:,:);
elseif strncmpi(peak,'top',1)
  hspace = padarray(hspace, [padsz 0], 'pre');
  padrange1 = 1:na; % pad region dim 1
  padrange2 = 1:nother; % pad region dim 2
  s = hspace((nf/2-nover+1):(nf/2+nover),:,:,:,:,:,:);
  v = flip(v',1);
elseif strncmpi(peak,'bottom',1)
  hspace = padarray(hspace, [padsz 0], 'post');
  padrange1 = (np+1):nf; % pad region dim 1
  padrange2 = 1:nother; % pad region dim 2
  s = hspace((nf/2-nover+1):(nf/2+nover),:,:,:,:,:,:);
  v = v';
end

% low-resolution phase estimate
pe = cft(zerofill(s, size(v)) .* v, second_fft); pe = pe./abs(pe);

for j = 1:iter
  u = cft(abs(cft(hspace, second_fft)) .* pe, -second_fft);
  hspace(padrange1, padrange2,:,:,:,:,:) = u(padrange1,padrange2,:,:,:,:,:);
end

I = cft(hspace, second_fft);

end
