function plane = moco_scanplane(rcnhandle)

nR = abs(rcnhandle_getfield(rcnhandle,'image','norm_R'));
nA = abs(rcnhandle_getfield(rcnhandle,'image','norm_A'));
nS = abs(rcnhandle_getfield(rcnhandle,'image','norm_S'));

if nR > nA && nR > nS
  plane = 'sagittal';
elseif nS > nA && nS > nR
  plane = 'axial';
else
  plane = 'coronal';
end

end