function pth = deployed_exepath


  if strcmpi(computer, 'glnxa64')
    [~, exeloc] = system(sprintf('readlink -f /proc/%d/exe',feature('getpid')));
    pth = fileparts(exeloc);
  elseif strcmpi(computer, 'maci64')
    [~, exeloc] = system(sprintf('lsof -p %d | awk ''$4 == "txt" { print $9 }'' | head -1', feature('getpid')));
    pth = fileparts(exeloc);
  else
    pth = './'; % no better solution for now for windows
  end
  
end
