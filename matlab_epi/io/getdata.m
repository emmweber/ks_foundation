%
% Return ND array from either ND array or matfile handle to disk (complex data)
function data = getdata(handle)

if isa(handle,'matlab.io.MatFile')

  if ~isprop(handle,'data_i') && ~isprop(handle,'data')
    handle = matfile(handle.Properties.Source); % reconnect if lost
  end
  
  if isprop(handle,'data_i')
    data = complex(handle.data, handle.data_i);
  elseif isa(handle,'matlab.io.MatFile') && isprop(handle,'data')
    data = handle.data;
  end

else
  data = handle;
end