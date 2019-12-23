function [kspace, refLines] = recon_epi_getcurrentpfilepass(rcnhandle, passIndex)


%% Read data as kspace handles to limit memory consumption (does also rowflip)
kspace = pfile_read([], passIndex, 'data');
kspace = cell2mat(kspace);
refLines = [];

if isfield(rcnhandle, 'nRefLines') && rcnhandle.nRefLines >= 1
  
  if rcnhandle.nRawEchoes ~= (rcnhandle.nEchoes + 1)
    error('recon_epi_getcurrentpfilepass: nRawEchoes ~= nEchoes+1')
  end
  
  rawRefLines = kspace(:,:,:,:,rcnhandle.nRawEchoes);
  kspace = kspace(:,:,:,:,1:rcnhandle.nEchoes);
  
  % phase reference lines
  if any(rawRefLines(:))
    for shot = 1:rcnhandle.nShots
      refLinesShot = rawRefLines(:,shot:rcnhandle.nShots:rcnhandle.nShots*rcnhandle.nRefLines,:,:);
      if any(refLinesShot(:))
        refLines(:,:,:,:,1,shot) = refLinesShot;
      end
    end
  end
end

end
