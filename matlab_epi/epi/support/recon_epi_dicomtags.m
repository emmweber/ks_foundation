%%
function [performingPhysicianTag, psdNameWithScanTime] = recon_epi_dicomtags(rcnhandle)

error('Call dcm_ksdicomtags instead')

psdname = lower(deblank(strtrim(rcnhandle_getfield(rcnhandle,'image','psdname'))));
psdiname = lower(deblank(strtrim(rcnhandle_getfield(rcnhandle,'image','psd_iname'))));

performingPhysicianTag.Group = hex2dec('0008');
performingPhysicianTag.Element = hex2dec('1050');
performingPhysicianTag.VRType = 'PN';
performingPhysicianTag.Value = sprintf('%s;%s', psdname, psdiname);


numseconds = seconds(rcnhandle_getfield(rcnhandle,'raw','user48')/1e6);
if numseconds > 0
  [h,m,s] = hms(numseconds);
  s = round(s);
  if h > 0
    scantimestr = sprintf('%d:%02d:%02d', h, m, s);
  else
    scantimestr = sprintf('%d:%02d', m, s);
  end
  
  psdNameWithScanTime.Group = hex2dec('0019');
  psdNameWithScanTime.Element = hex2dec('109c');
  psdNameWithScanTime.VRType = 'LO';
  psdNameWithScanTime.Value = sprintf('%s [%s]', psdname, scantimestr);
  
else
  
  psdNameWithScanTime.Group = hex2dec('0019');
  psdNameWithScanTime.Element = hex2dec('109c');
  psdNameWithScanTime.VRType = 'LO';
  psdNameWithScanTime.Value = psdname;
  
end

end
