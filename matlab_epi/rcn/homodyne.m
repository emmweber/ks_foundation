function I = homodyne(kspace, nover, peak, varargin)

checkData = @(x) (isnumeric(x) && ~isreal(x) && min(size(x(:,:,1))) > 8);
checkNover = @(x) (isnumeric(x) && isreal(x) && mod(x,1) == 0 && x > 0);

checkPeakPos = @(x) (ischar(x) && ...
  (strncmpi(x,'left',1) || strncmpi(x,'right',1) || strncmpi(x,'top',1) || strncmpi(x,'bottom',1)) );

defaultTran = 4;
checknTran = @(x) (isnumeric(x) && x >= 1 && x <= 10);

parm = inputParser;
addRequired(parm, 'kspace', checkData);
addRequired(parm, 'nover',  checkNover);
addRequired(parm, 'peak', checkPeakPos); % left, right, top, bottom
addParameter(parm, 'ntran', defaultTran, checknTran);

parse(parm, kspace, nover, peak, varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ntran = parm.Results.ntran;
nover = parm.Results.nover;
peak = parm.Results.peak;

ksz = size(kspace); ksz(end+1:6) = 1;

if strncmpi(peak,'left',1) || strncmpi(peak,'right',1)
  np = ksz(2); % size in partial Fourier dim
  nx = ksz(1); % size in full Fourier dim
else
  np = ksz(1); % size in partial Fourier dim
  nx = ksz(2); % size in full Fourier dim
end
nf = 2 * (np - nover); % full size in partial Fourier dim
padsz = nf-np;

% form the weighting matrices -- only 1D, nf in length
y = 1:nf;
q = np - 2 * ntran;
p = nf - q;
u = 2 - 1./(1+exp((p-y)/ntran)) - 1./(1+exp((q-y)/ntran));
v = 1./(1+exp((y-q)/ntran)) - 1./(1+exp((y-p)/ntran));
u = repmat(u, nx, 1);  % asymmetric weights
v = repmat(v, nx, 1);  % symmetric weights

if isa(kspace,'single')
  u = single(u);
  v = single(v);
end

% zerofill kspace based on k-space peak position
if strncmpi(peak,'left',1)
  kspace = padarray(kspace, [0 padsz], 'pre');
  u = flip(u,2);
  v = flip(v,2);
elseif strncmpi(peak,'right',1)
  kspace = padarray(kspace, [0 padsz], 'post');
elseif strncmpi(peak,'top',1)
  kspace = padarray(kspace, [padsz 0], 'pre');
  u = flip(u',1);
  v = flip(v',1);
elseif strncmpi(peak,'bottom',1)
  kspace = padarray(kspace, [padsz 0], 'post');
  u = u';
  v = v';
end

% Matlab2016b or later. Implicit expansion without using bsxfun
au = kspace .* u; % asymmetric k-space data
av = kspace .* v; % symmetric k-space data

% get image domain data
a = cft(au, [-1 -1]);  % asymmetric image data
s = cft(av, [-1 -1]);  % symmetric image data
I = real(a .* conj(s./abs(s))); % image is real part of phase-corrected data

end
