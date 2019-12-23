function cmddir(mycmd,mypath,mytype)

rootdir = pwd;

if nargin <= 1
  mypath = '.';
end
if nargin <= 2
  mytype = 'matlab';
end

tmp = dir(mypath);
k = 1;
for d = 1:numel(tmp)
  if tmp(d).isdir && tmp(d).name(1) ~= '.'
    D(k) = tmp(d); k = k+1;
  end
end

if 0 && exist('parfor','builtin')
  parfor d = 1:numel(D)
    cd(rootdir);
    dothejob(D(d).name,mycmd,mytype,rootdir);
  end
else
  for d = 1:numel(D)
    disp(d)
    dothejob(D(d).name,mycmd,mytype,rootdir);
  end
end

end



function dothejob(tmpdir,mycmd,mytype,rootdir)
retval = [];
retval.data = [];

fprintf('Starting job in directory: %s\n',tmpdir);
retval.dir = tmpdir;
try
  cd(tmpdir);
  if ~strcmp(mytype,'matlab')
    system(mycmd);
  else
    eval(mycmd);
  end
catch
  cd(rootdir);
end
cd(rootdir);

end
