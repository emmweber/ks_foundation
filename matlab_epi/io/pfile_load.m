function p = pfile_load(pfile, data_precision)

if nargin < 1 || isempty(pfile)
  pfiles = dir('P*7');
  pfile = pfiles(1).name;
end

% The real read of pfile handle and header that is used for recon
p = GERecon('Pfile.Load', pfile, 'No-Anonymize');
p.header = GERecon('Pfile.Header');

if exist('data_precision','var') && ~isempty(data_precision)
  if strcmp(data_precision,'double') || strcmp(data_precision,'single')
    p.data_precision = data_precision;
  else
    error('pfile_load: data_precision must be ''single'' or ''double''');
  end
else
  p.data_precision = 'single';
end


p.ExamNumber = p.header.ExamData.ex_no;
p.SeriesNumber = p.header.SeriesData.se_no;

p.SlicesPerPass = p.slicesPerPass;
p.Slices = p.slices;

p.nShots      = p.header.RawHeader.ileaves;
p.nRawEchoes  = p.header.RawHeader.nechoes;
p.nEchoes     = p.header.ImageData.numecho;
p.nKx         = p.header.RawHeader.da_xres;
p.nKy         = p.header.RawHeader.da_yres-1;
p.nover       = p.header.RawHeader.hnover;
p.nx          = p.header.ImageData.dim_X;
p.ny          = p.header.ImageData.dim_Y;
p.nRecX       = p.header.RawHeader.rc_xres;
p.nRecY       = p.header.RawHeader.rc_yres;
p.nChannels   = p.channels;
p.nAcqsPerVol = recon_pass(p, 1, 'nacqspervol');
p.nRawVols    = recon_pass(p, 1, 'nvols');
p.nVols       = p.header.ImageData.fphase;
if p.nVols == 0
  p.nVols = p.nRawVols;
end
p.nPasses     = recon_pass(p, 1, 'npasses');

diffusionBit = bitget(p.header.RawHeader.data_collect_type1, 22);

p.isDiffusion = rcnhandle_getfield(p,'image','dfax') > 0;
isIntegratedStaticPC = p.header.RawHeader.ref == 5;
isIntegratedRefBitSet = bitget(p.header.RawHeader.pcctrl, 5);
p.isIntegratedRef = isIntegratedStaticPC || isIntegratedRefBitSet || diffusionBit;

for acqinvol = 1:p.nAcqsPerVol
  for z = 1:p.SlicesPerPass(acqinvol)
    p.geometricSliceNumber(z,acqinvol) = z; % works only for acqs = 1 for now 
  end
end

for z = 1:p.Slices % spatial slice location index
  p.sliceInfo(z).Corners     = GERecon('Pfile.Corners', z);
  p.sliceInfo(z).Orientation = GERecon('Pfile.Orientation', z);
end


end
