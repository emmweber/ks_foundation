function [performingPhysicianTag, psdNameWithScanTime, echoTime, rcvCoil] = dcm_ksdicomtags(rcnhandle, echo, coilprefix)

psdname = lower(deblank(strtrim(rcnhandle_getfield(rcnhandle,'image','psdname'))));
psdiname = lower(deblank(strtrim(rcnhandle_getfield(rcnhandle,'image','psd_iname'))));
performingPhysicianTag = dcm_makeperformingphysicican(rcnhandle);


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



te1 = rcnhandle_getfield(rcnhandle,'image','te');
if te1 <= 0
  te1 = rcnhandle_getfield(rcnhandle,'raw','te');
end
te2 = rcnhandle_getfield(rcnhandle,'image','te2');
if te2 <= 0
  te2 = rcnhandle_getfield(rcnhandle,'raw','te2');
end
delta_te = te2 - te1;

if exist('echo','var') && echo >= 2
  if delta_te > 0 % otherwise te2 field was probably 0
    te = te1 + (echo-1) * delta_te; % assuming echoes 1-N are equidistant
  else
    te = 0;
  end
else
  te = te1;
end

echoTime.Group = hex2dec('0018');
echoTime.Element = hex2dec('0081');
echoTime.VRType = 'DS';
if te > 100000
  echoTime.Value = num2str(round(te/1000));
else
  echoTime.Value = sprintf('%.1f',te/1000);
end


rcvCoil.Group = hex2dec('0018');
rcvCoil.Element = hex2dec('1250');
rcvCoil.VRType = 'SH';
if exist('coilprefix','var')
  rcvCoil.Value = sprintf('%s%s', coilprefix, rcnhandle_getfield(rcnhandle,'image','cname'));
else
  rcvCoil.Value = rcnhandle_getfield(rcnhandle,'image','cname');
end


end
