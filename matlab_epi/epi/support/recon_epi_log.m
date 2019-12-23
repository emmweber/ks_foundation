function recon_epi_log(logstr, timestamp)
timecolumn = 45;
padding = timecolumn - numel(logstr) - 2;
persistent lasttime;


if nargin > 1
  fprintf('%03d (%03d) [s]\n..%s%s', timestamp, timestamp-lasttime, logstr, repmat(' ', 1,padding));
  lasttime = timestamp;
else
  fprintf('\n..%s%s', logstr, repmat(' ', 1,padding));
  lasttime = 0;
end


end