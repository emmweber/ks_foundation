function archive_renamedirs(prefix)


if exist('prefix','var')
  D = dir(sprintf('%s*',prefix));
else
  D = dir('*');
end

P = pwd;

for d = 1:numel(D)
  
  if ~strncmp(D(d).name,'.',1)
    
    cd(D(d).name)
    
    try
      
      if numel(dir('ScanArchive*h5'))
        rcnhandle = archive_load;
      elseif numel(dir('P*7'))
        rcnhandle = pfile_load;
      else
        rcnhandle = [];
      end
      
      if ~isempty(rcnhandle)
        cd(P)
        dirname = sprintf('%03d_%03d_%s', rcnhandle_getfield(rcnhandle, 'exam', 'ex_no'), rcnhandle_getfield(rcnhandle, 'series', 'se_no'), strrep(rcnhandle_getfield(rcnhandle, 'series', 'se_desc'), ' ', ''));        
        movefile(D(d).name, dirname)
      end
    catch
      cd(P)
    end
    
  end
  
end
