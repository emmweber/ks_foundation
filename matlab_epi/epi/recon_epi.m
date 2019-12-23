function recon_epi(varargin)

% Convert string arguments that are actually numbers to double
varargin = deployedargs(varargin);

if numel(dir('ScanArchive*h5'))
  rcnhandle = archive_load();
  GERecon('Archive.Close', rcnhandle);
elseif numel(dir('P*7'))
  rcnhandle = pfile_load();
else
  error('recon_epi: No Scan Archive (*.h5) or Pfiles (P*.7) in current directory');
end

is_ksepi = strncmp(rcnhandle_getfield(rcnhandle,'image','psd_iname'), 'ksepi', 5);
is_3D = rcnhandle_getfield(rcnhandle,'image','imode') == 2 || rcnhandle_getfield(rcnhandle,'image','imode') == 6; % PSD_3D = 2, PSD_3DM = 6

if is_ksepi && is_3D
  recon_3Depi(varargin{:});
else
  recon_2Depi(varargin{:});
end


end























