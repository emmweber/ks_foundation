function dataav = recon_epi_averagevalidnex(data)
% input  size(data)    = [Nx Ny Nz Nechoes Nav Nvols ...]. X-dimensional
% output size(dataav)  = [Nx Ny Nz Nechoes Nvols ...]. (X-1)-dimensional
% (dim 5 removed)

if ndims(data) < 5
  dataav = data;
  return
end

datasz = size(data); datasz(end+1:6) = 1;
dataav = zeros([datasz(1:4) datasz(6:end)],'like',data);

for vol = 1:prod(datasz(6:end))
  dataav(:,:,:,:,vol) = mean(recon_epi_keepnonzeroaverages(data(:,:,:,:,:,vol)), 5);
end

end