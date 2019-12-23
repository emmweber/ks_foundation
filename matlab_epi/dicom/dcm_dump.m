function fieldvalue = dcm_dump(group, field, fileptrn)
% http://dicom.offis.de/

if any([ischar(group) ischar(field) ischar(fileptrn)] == 0)
  error('dcm_dump: All 4 input args must be strings');
end

progpth = fileparts(which('dcm_dump'));

f = dir(fileptrn);
firstfile = fullfile(f(1).folder, f(1).name);

if strcmp(computer,'MACI64')
  dumpcmd = fullfile(progpth,'dcmdump_mac');
elseif strcmp(computer, 'PCWIN64')
  dumpcmd = fullfile(progpth,'dcmdump_win');  
else
  dumpcmd = fullfile(progpth,'dcmdump_linux');
end

cmd = sprintf('%s +P "%s,%s" %s', dumpcmd, group, field, firstfile);
  
[~, fieldvalue] = system(cmd);
tokens = regexp(fieldvalue, '\[(.*)\]','tokens');
if ~isempty(tokens) && ~isempty(tokens{1})
  fieldvalue = tokens{1}{1};
else
  warning('dcm_dump ERROR: %s', cmd, fieldvalue);
  fieldvalue = '';
end

end
