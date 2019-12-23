function varargout = recon_epi_vrgfkernel(varargin)

if nargin == 1 && isfield(varargin{1},'DownloadData')
    % Usage: kernelMatrix = recon_epi_vrgfkernel(ScanArchive); Works for
    % ksepi.e or other EPI psds with rhuser32-35 set correctly
    npoints_acquired       = varargin{1}.DownloadData.rdb_hdr_rec.rdb_hdr_da_xres;
    npoints_reconstructed  = varargin{1}.DownloadData.rdb_hdr_image.dim_X;
    sampletime             = varargin{1}.DownloadData.rdb_hdr_rec.rdb_hdr_user32; % [us]
    plateautime            = varargin{1}.DownloadData.rdb_hdr_rec.rdb_hdr_user34 * 2 * 1e6; % [us]
    ramptime               = varargin{1}.DownloadData.rdb_hdr_rec.rdb_hdr_user35 * 1e6; % [us]
elseif nargin == 1 && isfield(varargin{1},'header')
    npoints_acquired       = varargin{1}.header.RawHeader.da_xres;
    npoints_reconstructed  = varargin{1}.header.ImageData.dim_X;
    sampletime             = varargin{1}.header.RawHeader.user32; % [us]
    plateautime            = varargin{1}.header.RawHeader.user34 * 2 * 1e6; % [us]
    ramptime               = varargin{1}.header.RawHeader.user35 * 1e6; % [us]
elseif nargin == 5
    % Usage: kernelMatrix = recon_epi_vrgfkernel(npoints_acquired, npoints_reconstructed, sampletime, plateautime, ramptime);
    npoints_acquired       = varargin{1};
    npoints_reconstructed  = varargin{2};
    sampletime             = varargin{3}; % [us]
    plateautime            = varargin{4}; % [us]
    ramptime               = varargin{5}; % [us]
else
    error('recon_epi_vrgfkernel: Wrong input args');
end

if npoints_acquired == npoints_reconstructed
  varargout{1} = eye(npoints_acquired);
  return;
elseif ~all([npoints_acquired npoints_reconstructed sampletime plateautime ramptime] > 0)
    error('recon_epi_vrgfkernel: VRGF input parameters must all be positive');
end

esp = ramptime*2 + plateautime; % echo spacing [us]
t1 = (esp-sampletime*npoints_acquired)/2 + 1; % delay from start of attack ramp until start of readout [us]
% tn = esp-(esp-sampletime*npoints_acquired)/2;   % sampling of last data point [us]

a = 1;
b = 1;

Gt1 = b*t1/ramptime; % relative gradient strength at t = t1
Gtn = (1/b)*t1/ramptime; % relative gradient strength at t = tn
na_ramp = round((ramptime-t1+1)/sampletime);
% na_plateau = round(plateautime/sampletime); % Number of plateau points based on time
na_plateau = npoints_acquired - na_ramp * 2; % Number of plateau points guaranteed to sum up to #acquired points with ramps

% Create the nominal trapzodial gradient wave form G
attack = linspace(Gt1,1,na_ramp).^a;
plateau = ones(1,na_plateau);
decay = linspace(1,Gtn,na_ramp).^(1/a);
G = [attack, plateau, decay];
k = cumsum(G);

k = (k-min(k(:)))*(npoints_reconstructed-1)/(max(k(:)-min(k(:)))) + 1;

varargout{1} = k2vrgf(k,npoints_acquired,npoints_reconstructed)';

if nargout > 1
    varargout{2} = k;
end


end


function v = k2vrgf(k,npoints_acquired,npoints_reconstructed)

v = zeros(npoints_acquired,npoints_reconstructed,class(k));

for col = 1:npoints_reconstructed
    v(:,col) = sincfcn(col-k);
    v(isnan(v(:,col)),col) = 0;
    vsum(col) = sum(v(:,col));
end

v = v ./ repmat(vsum,npoints_acquired,1);

end
