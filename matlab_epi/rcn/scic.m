function outdata = scic(indata, rcnhandle)

if ~rcnhandle_getfield(rcnhandle, 'image', 'scic')
  outdata = indata;
  return
end

if rcnhandle_getfield(rcnhandle, 'raw', 'scic_gauss') > 0 && rcnhandle_getfield(rcnhandle, 'raw', 'scic_reduction') > 0 && rcnhandle_getfield(rcnhandle, 'raw', 'scic_threshold') > 0
  outdata = GERecon('Scic', indata, ...
    rcnhandle_getfield(rcnhandle, 'raw', 'scic_gauss'), ...
    rcnhandle_getfield(rcnhandle, 'raw', 'scic_reduction'), ...
    rcnhandle_getfield(rcnhandle, 'raw', 'scic_threshold'));
else
  if contains(rcnhandle_getfield(rcnhandle,'image','cname'), 'HEAD 34', 'IgnoreCase',true) || contains(rcnhandle_getfield(rcnhandle,'image','cname'), '48', 'IgnoreCase',true) % 48 channel (Premier) 'HEAD 34' or '48HAP'
    scic_gauss = 2;
    scic_reduction = 64;
    scic_threshold = 0.4;
  elseif contains(rcnhandle_getfield(rcnhandle,'image','cname'), '32Ch Head', 'IgnoreCase',true)
    scic_gauss = 2;
    scic_reduction = 64;
    scic_threshold = 0.4;
  elseif contains(rcnhandle_getfield(rcnhandle,'image','cname'), 'Nova32', 'IgnoreCase',true)
    scic_gauss = 2;
    scic_reduction = 64;
    scic_threshold = 0.4;
  elseif contains(rcnhandle_getfield(rcnhandle,'image','cname'), 'HEAD24', 'IgnoreCase',true) || contains(rcnhandle_getfield(rcnhandle,'image','cname'), 'HEAD 24', 'IgnoreCase',true)
    scic_gauss = 1.5;
    scic_reduction = 16; % said 6
    scic_threshold = 0.6;
  else % seems most generic case to use 2/64/0.4
    scic_gauss = 2;
    scic_reduction = 64;
    scic_threshold = 0.4;
  end
  
  outdata = zeros(size(indata),'like',indata);
  
  for z = 1:size(indata,3)
    outdata(:,:,z) = GERecon('Scic', indata(:,:,z), scic_gauss, scic_reduction, scic_threshold);
  end
end

end

