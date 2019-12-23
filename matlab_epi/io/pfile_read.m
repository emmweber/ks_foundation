function [retval, p] = pfile_read(pfile, whichpass, returntype, data_precision)

% Data format: [nKx, nKy, nChannels, nSlicesPerPass, nEchoes];


if ~exist('pfile','var')
  pfile = [];
end
if ~exist('whichpass','var')
  whichpass = []; % read all passes
end
if ~exist('returntype','var')
  returntype = 'data'; % data or handle
end
if ~exist('data_precision','var')
  data_precision = [];
end


p = pfile_load(pfile, data_precision);

if strncmp(rcnhandle_getfield(p,'image','psd_iname'), 'ksepi',5)
  p.kSpaceDir = -1 * rcnhandle_getfield(p,'image','user2');
else
  p.kSpaceDir = -1;
end

if isempty(whichpass)
  numpassesToRead = p.passes;
else
  numpassesToRead = 1;
end

if strcmp(returntype,'data')
  for j = 1:numpassesToRead
    retval{j} = zeros(p.nKx, p.nKy, p.nChannels, p.SlicesPerPass, p.nEchoes, p.data_precision);
  end
else
  kspace.data = zeros(p.nKx, p.nKy, p.nChannels, p.SlicesPerPass, p.nEchoes, p.data_precision);
end

for pass = 1:numpassesToRead
  
  if isempty(whichpass)
    sliceInfo.pass = pass;
  else
    sliceInfo.pass = whichpass;
  end
  
  for echo = 1:p.echoes
    for slice = 1:p.slices
      geometricSliceNumber = p.header.DataAcqTable.slice_in_pass(slice);
      sliceInfo.sliceInPass = geometricSliceNumber;
      for channel = 1:p.channels
        if strcmp(returntype,'data')
          retval{pass}(:,:,channel,slice,echo) = GERecon('Pfile.KSpace', sliceInfo, echo, channel, p);
        else
          kspace.data(:,:,channel,slice,echo)  = GERecon('Pfile.KSpace', sliceInfo, echo, channel, p);
        end
      end
    end
  end
  
  % rowflip
  if ~bitget(rcnhandle_getfield(p,'raw','data_format'), 12) || strncmp(rcnhandle_getfield(p,'image','psd_iname'), 'ksepi',5)
    % epic.h: rhformat &= ~RHF_USE_FLIPTABLE (no rowflip done on Pfile write)
    % But also do rowflipping for all ksepi data, even when bit 12 is set. This, since we must have bit 12 set for ghost
    % correction, but we don't want to carry the rowflip.param file with us. Moreover, something is wrong in rowflip.param for
    % ksepi for multishot EPI
    if strcmp(returntype,'data')
      rows2flip = recon_epi_rowstoflip(size(retval{pass}), p.nShots, p.kSpaceDir); % which rows to flip
      retval{pass}(:,rows2flip,:,:,:) = flip(retval{pass}(:,rows2flip,:,:,:), 1);
    else
      rows2flip = recon_epi_rowstoflip(size(kspace.data), p.nShots, p.kSpaceDir); % which rows to flip
      kspace.data(:,rows2flip,:,:,:) = flip(kspace.data(:,rows2flip,:,:,:), 1);
    end    
  end
  
  if ~strcmp(returntype, 'data')
    fname = sprintf('e%ds%03dp%04d.mat', p.ExamNumber, p.SeriesNumber, pass);
    retval{pass} = savestruct(fname, kspace);
  end
  
end % pass

end
