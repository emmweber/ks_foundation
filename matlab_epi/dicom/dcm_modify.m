function dcm_modify(group, field, value, fileptrn)
% http://dicom.offis.de/

if nargin ~= 4
    error('dcm_modify: 4 input args (strings)');
end

if any([ischar(group) ischar(field) ischar(value) ischar(fileptrn)] == 0)
  error('dcm_modify: All 4 input args must be strings');
end

progpth = fileparts(which('dcm_modify'));

if strcmp(computer,'MACI64')
  modcmd = fullfile(progpth,'dcmodify_mac');
elseif strcmp(computer, 'PCWIN64')
  modcmd = fullfile(progpth,'dcmodify_win');
else
  modcmd = fullfile(progpth,'dcmodify_linux');
end

p = pwd;
[fpath, fname, ext] = fileparts(fileptrn);
if ~isempty(fpath)
  cd(fpath);
end
fileptrn = [fname ext];

system(sprintf('%s -nb -m "(%s,%s)=%s" %s 2> /dev/null', modcmd, group, field, value, fileptrn));

cd(p);

end
