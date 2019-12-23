function rcnhandle = rcnhandle_setfield(rcnhandle, group, field, value)

group = lower(group);

if ~exist('field','var')
  field = [];
end

if strcmp(rcnhandle.HandleType,'ScanArchive')
  group_rawhdr = 'rcnhandle.DownloadData.rdb_hdr_rec';
  group_rawhdrprefix = 'rdb_hdr_';
  group_exam = 'rcnhandle.DownloadData.rdb_hdr_exam';
  group_series = 'rcnhandle.DownloadData.rdb_hdr_series';
  group_image = 'rcnhandle.DownloadData.rdb_hdr_image';
else
  group_rawhdr = 'rcnhandle.header.RawHeader';
  group_rawhdrprefix = '';
  group_exam = 'rcnhandle.header.ExamData';
  group_series = 'rcnhandle.header.SeriesData';
  group_image = 'rcnhandle.header.ImageData';
  if ~isfield(rcnhandle,'header')
    error('rcnhandle_getfield: missing field ''header'' in rcnhandle');
  end
end

if strncmp(group, 'raw',3) || strcmp(group, 'rdb_hdr_rec')
  if isnumeric(value)
    f = sprintf('%s.%s%s = %g;', group_rawhdr, group_rawhdrprefix, field, value);
  else
    f = sprintf('%s.%s%s = %s;', group_rawhdr, group_rawhdrprefix, field, value);
  end
elseif strncmp(group, 'exam',4) || strcmp(group, 'rdb_hdr_exam')
  if isnumeric(value)
    f = sprintf('%s.%s = %g;', group_exam, field, value);
  else
    f = sprintf('%s.%s = %s;', group_exam, field, value);
  end
elseif strncmp(group, 'series',4) || strcmp(group, 'rdb_hdr_series')
  if isnumeric(value)
    f = sprintf('%s.%s = %g;', group_series, field, value);
  else
    f = sprintf('%s.%s = %s;', group_series, field, value);
  end
elseif strncmp(group, 'image',4) || strcmp(group, 'rdb_hdr_image')
  if isnumeric(value)
    f = sprintf('%s.%s = %g;', group_image, field, value);
  else
    f = sprintf('%s.%s = %s;', group_image, field, value);
  end
end

try
  eval(f);
catch
end

end
