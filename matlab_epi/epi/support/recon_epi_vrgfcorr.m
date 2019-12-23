function interpolatedData = recon_epi_vrgfcorr(kspace, kernelMatrix)

ksz = size(kspace);

interpolatedData = zeros([size(kernelMatrix,1) ksz(2:end)]);

for j = 1:prod(ksz(3:end))
    interpolatedData(:,:,j) = kernelMatrix * kspace(:,:,j);
end

end

