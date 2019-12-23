function canvas = centerOnCanvas(app, data, framesize, align)

if ~exist('align','var')
  align = 'center';
end

canvas = zeros([framesize(1:2) 3]);
canvas(:,:,1) = 0.6;
canvas(:,:,2) = 0.7;
canvas(:,:,3) = 0.8;

sz = size(data); sz(end+1:3) = 1;

shift = round((framesize(1:2) - sz(1:2))/2);
if strcmp(align,'top')
  shift(1) = 0;
elseif strcmp(align,'right')
  shift(2) = shift(2) * 2;
end

yrange = (1:sz(1)) + shift(1);
xrange = (1:sz(2)) + shift(2);

if sz(3) == 3
  canvas(yrange,xrange,:) = data;
else 
  canvas(yrange,xrange,:) = repmat(data, [1 1 3]);
end

end
