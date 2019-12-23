function performingPhysicianTag = dcm_makeperformingphysicican(rcnhandle, prefix)
% Performing Physician is one of few DICOM fields that is a string and can be used for Smart Folders and auto routing using OsiriX and Horos

if ~exist('prefix','var')
  prefix = '';
end

psdname = lower(deblank(strtrim(rcnhandle_getfield(rcnhandle,'image','psdname'))));
psdiname = lower(deblank(strtrim(rcnhandle_getfield(rcnhandle,'image','psd_iname'))));

performingPhysicianTag.Group = hex2dec('0008');
performingPhysicianTag.Element = hex2dec('1050');
performingPhysicianTag.VRType = 'PN';
if ~isempty(prefix)
  performingPhysicianTag.Value = sprintf('%s;%s;%s', prefix, psdname, psdiname);
else
  performingPhysicianTag.Value = sprintf('%s;%s', psdname, psdiname);
end

end
