function returnseriesstruct = recon_epi_returnwhatdata(rcnhandle)

%{
ksepi: (opuser6)
typedef enum {
  OFFLINE_DIFFRETURN_ALL = 0,
  OFFLINE_DIFFRETURN_ACQUIRED = 1,
  OFFLINE_DIFFRETURN_B0 = 2,
  OFFLINE_DIFFRETURN_MEANDWI = 4,
  OFFLINE_DIFFRETURN_MEANADC = 8,
  OFFLINE_DIFFRETURN_EXPATT = 16,
  OFFLINE_DIFFRETURN_FA = 32,
  OFFLINE_DIFFRETURN_CFA = 64,
} OFFLINE_DIFFRETURN_MODE;

%}

returndatabitmask = rcnhandle_getfield(rcnhandle, 'image', 'user6');

returnseriesstruct.acquired = false;
returnseriesstruct.b0 = false;
returnseriesstruct.meandwi = false;
returnseriesstruct.meanadc = false;
returnseriesstruct.expatt = false;
returnseriesstruct.fa = false;
returnseriesstruct.cfa = false;

if rcnhandle.isDiffusion
  if strncmp(rcnhandle_getfield(rcnhandle,'image','psd_iname'), 'ksepi',5) && returndatabitmask > 0
    if bitget(returndatabitmask, 1), returnseriesstruct.acquired = true; end
    if bitget(returndatabitmask, 2), returnseriesstruct.b0 = true; end
    if bitget(returndatabitmask, 3), returnseriesstruct.meandwi = true; end
    if bitget(returndatabitmask, 4), returnseriesstruct.meanadc = true; end
    if bitget(returndatabitmask, 5), returnseriesstruct.expatt = true; end
    if bitget(returndatabitmask, 6), returnseriesstruct.fa = true; end
    if bitget(returndatabitmask, 7), returnseriesstruct.cfa = true; end
  else
    returnseriesstruct.acquired = true;
    returnseriesstruct.b0 = true;
    returnseriesstruct.meandwi = true;
    returnseriesstruct.meanadc = true;
    returnseriesstruct.expatt = true;
    returnseriesstruct.fa = true;
    returnseriesstruct.cfa = true;
  end
else
  returnseriesstruct.acquired = true;
end


end

