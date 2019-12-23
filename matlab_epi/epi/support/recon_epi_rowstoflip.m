function kylines_neglobe = recon_epi_rowstoflip(datasize, nShots, kSpaceDir)
% Data format: [nKx, nKy, nChannels, nSlicesPerPass, nEchoes];

kylines_neglobe = false(datasize(2),1);

if nargin < 3
    kSpaceDir = -1; % Bottom-Up
end

firstEPIlobeIsPositive = true; % For now we don't have any logic for negative 1st EPI lobe

for j = 1:nShots
    if firstEPIlobeIsPositive
        kylines_neglobe((j+nShots):(2*nShots):end) = true;
    else
        kylines_neglobe(j:(2*nShots):end) = true;
    end
end

if kSpaceDir < 0 % Bottom-Up k-space order
    kylines_neglobe = flip(kylines_neglobe,1);
end

kylines_neglobe = kylines_neglobe(:);

end
