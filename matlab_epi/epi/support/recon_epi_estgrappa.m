function gw = recon_epi_estgrappa(kspace, R, maxestres)

if ~iscell(kspace)
  error('kspace (arg 1) must be a cell array with #elements = #calvolumes');
end

if R <= 1
  gw = [];
end

nCalVolumes = numel(kspace);

if ~exist('maxestres','var')
  maxestres = 128;
end

for vol = 1:nCalVolumes
  ksz = size(kspace{vol});
  bbox = min([maxestres maxestres ; ksz(1:2)]); % don't exceed acquired k-space
  
  % crop k-space during estimation around its peak
  [~, rfreq, rphase] = kspace_croparoundpeak(kspace{vol}, bbox);
  
  tmp = grappa(kspace{vol}(rfreq,rphase,:,:,:), R);
  if vol == 1
    gw = tmp;
  else
    % potentially update with better weights across cal volumes (slice by slice)
    for z = 1:size(kspace{1},4) % spatial slice index
      for echo = 1:size(kspace{1},5) % echo index
        if tmp.fiterror(z,echo) < gw.fiterror(z,echo)
          gw.w(:,:,z,echo) = tmp.w(:,:,z,echo);
          gw.fiterror(z,echo) = tmp.fiterror(z,echo);
        end
      end
    end
  end
  
end

end
