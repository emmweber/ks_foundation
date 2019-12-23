function move_pfiles

pfiles = dir('P*7');

for j = 1:numel(pfiles)
  
  rcnhandle = pfile_load(pfiles(j).name);
  sedesc = strsplit(rcnhandle_getfield(rcnhandle, 'series', 'se_desc'), char(0)); sedesc = sedesc{1};
  dirname = sprintf('%03d_%03d_%s', rcnhandle_getfield(rcnhandle, 'exam', 'ex_no'), rcnhandle_getfield(rcnhandle, 'series', 'se_no'), sedesc);
  dirname = deblank(strtrim(dirname));
  mkdir(dirname);
  movefile(pfiles(j).name, dirname)
end

end
