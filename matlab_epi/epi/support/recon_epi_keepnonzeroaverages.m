function data = recon_epi_keepnonzeroaverages(data)
% size(data)    = [Nx Ny Nz Nechoes Nav]

if ndims(data) < 5
  return;
end

datasz = size(data); datasz(end+1:6) = 1;

% average the center slice for 1st echo, is it zero?
nonzero = permute(mean(mean(data(:,:,ceil(datasz(3)/2),1,:,:),1),2), [5 6 1 2 3 4]) > 0;

if any(std(nonzero,[],2))
  error('recon_epi_nonzeroaverages: Inconsistent blank averages across volumes (dim 6)')
else
  data = data(:,:,:,:,nonzero(:,1),:,:,:,:);
end

end