function [sortarray, meandev] = moco_sortbymode(data, slicepercentage)
% moco_sortbymode    Sorts data by mode.
%
%   [sortedlist, deviation] = moco_sortbymode(data)
% INPUT
%       data              - 4D data [y, x, z, time]
% OUTPUT
%       sortedlist   - Vector of blade quality (best first)

if ~isreal(data)
  data = abs(data);
end

if ~exist('slicepercentage','var')
  slicepercentage = 100;
end

discard_slices = max([floor((1 - slicepercentage/100) / 2 * size(data,3)), 0]);
data = data(:,:,(discard_slices+1):(end-discard_slices),:);
datasz = size(data);

dataformean = true(datasz(4),1);
sortarray = zeros(datasz(4),1);


% Multi-pass mean deviation
for m = 1:datasz(4)
  deviation_data = abs(data(:,:,:,dataformean) - repmat(mean(data(:,:,:,dataformean),4),[1 1 1 sum(dataformean)])); % Deviation from mean of remaining blades
  meandev = zeros(sum(dataformean),1);
  for j = 1:sum(dataformean)
    meandev(j,1) = mean(vec(deviation_data(:,:,:,j)));
  end
  [~, worst] = sort(meandev,'descend'); % worst first
  currindices = find(dataformean);
  sortarray(datasz(4)-m+1,1) = currindices(worst(1)); % Fill sortedlist from worst to best (down->top)
  dataformean(currindices(worst(1))) = false; % Don't use this blade in next pass
end

% penalty value
deviation_data = abs(data - repmat(mean(data,4),[1 1 1 size(data,4)])); % Deviation from mean of remaining blades
meandev = zeros(size(data,4),1);
for j = 1:size(data,4)
  meandev(j,1) = mean(vec(deviation_data(:,:,:,j)));
end

meandev = meandev/max(meandev(:));

end
