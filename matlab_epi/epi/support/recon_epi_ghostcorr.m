function kSpace = recon_epi_ghostcorr(kSpace, nShots, refVal, kSpaceDir)

ksz = size(kSpace); ksz(end+1:7) = 1;
if nargin < 4
  kSpaceDir = 1; % -1: Bottom-Up
end

negLines = recon_epi_rowstoflip(ksz, nShots, kSpaceDir);

for z = 1:ksz(4)
  for channel = 1:ksz(3)
    kSpace(:,~negLines,channel,z,:,:) = exp(-1i * refVal(1,channel,z)) * fouriershift(kSpace(:,~negLines,channel,z,:,:), -[refVal(2,channel,z) 0]);
    kSpace(:, negLines,channel,z,:,:) = exp( 1i * refVal(1,channel,z)) * fouriershift(kSpace(:, negLines,channel,z,:,:),  [refVal(2,channel,z) 0]);
  end
end

end
