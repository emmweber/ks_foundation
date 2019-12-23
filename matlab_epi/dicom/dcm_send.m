function dcm_send(jsonhostsfile, desthostname, dicomdir)

configured_hosts = cell2mat(struct2cell(orderfields(loadjson(jsonhostsfile))));

[~,matlabhostname]= system('hostname'); matlabhostname = lower(matlabhostname(1:end-1)); matlabhostname_stripped = strrep(matlabhostname,'-','');
origin = dcm_send_gethostinfo(configured_hosts, matlabhostname_stripped);

if isempty(origin) % try with short form instead w/o domain
  [~,matlabhostname]= system('hostname -s'); matlabhostname = lower(matlabhostname(1:end-1)); matlabhostname_stripped = strrep(matlabhostname,'-','');
  origin = dcm_send_gethostinfo(configured_hosts, matlabhostname_stripped);
end

if isempty(origin)
  fprintf('dcm_send: Missing matlab computer (origin) in hosts.json');
end

if ~iscell(desthostname)
  desthostname = {desthostname};
end

for j = 1:numel(desthostname)
  if ~isempty(desthostname{j})
    dest = dcm_send_gethostinfo(configured_hosts, lower(strrep(desthostname{j},'-','')));
    if ~isempty(dest)
      if strcmp(dest.hostname,'localhost')
        fprintf('dcm_send: %s (AE=%s from origin AE=%s)\n', dest.hostname, dest.aet, dest.aet);
        networkHandle = GERecon('Dicom.CreateNetwork', dest.ip, dest.dicomport, dest.aet, dest.aet);
      else
        fprintf('dcm_send: %s (AE=%s from origin AE=%s)\n', dest.hostname, dest.aet, origin.aet);
        networkHandle = GERecon('Dicom.CreateNetwork', dest.ip, dest.dicomport, origin.aet, dest.aet);
      end
      GERecon('Dicom.Store', dicomdir, networkHandle);
      GERecon('Dicom.CloseNetwork', networkHandle);
    end
  end
end

end


function hostdata = dcm_send_gethostinfo(configured_hosts, host)
hostdata = [];
% First try to find matching hostname
for j = 1:numel(configured_hosts)
  if strcmpi(configured_hosts(j).hostname, host)
    hostdata = configured_hosts(j);
    return;
  end
end
% Second try to find matching nickname
for j = 1:numel(configured_hosts)
  if j == 6
    disp('');
  end
  for k = 1:numel(configured_hosts(j).nickname)
    nickname = configured_hosts(j).nickname(k);
    if strcmpi(nickname{1}, host)
      hostdata = configured_hosts(j);
      return;
    end
  end
end

end


