function eul = myrotm2eul(R)
    
eulShaped = calculateEulerAngles(R, 'ZYX');

% Shape output as a series of row vectors
eul = reshape(eulShaped,[3, numel(eulShaped)/3]).';

end


function eul = calculateEulerAngles(R, seq)
eul = zeros(1, 3, size(R,3), 'like', R);  %#ok<PREALL>
nextAxis = [2, 3, 1, 2];
seqSettings.ZYX = [1, 0, 0, 1];
seqSettings.ZYZ = [3, 1, 1, 1];
seqSettings.XYZ = [3, 0, 1, 1];

% Retrieve the settings for a particular axis sequence
setting = seqSettings.(seq);
firstAxis = setting(1);
repetition = setting(2);
parity = setting(3);
movingFrame = setting(4);

% Calculate indices for accessing rotation matrix
i = firstAxis;
j = nextAxis(i+parity);
k = nextAxis(i-parity+1);

if repetition
    % Find special cases of rotation matrix values that correspond to Euler
    % angle singularities.
    sy = sqrt(R(i,j,:).*R(i,j,:) + R(i,k,:).*R(i,k,:));    
    singular = sy < 10 * eps(class(R));
    
    % Calculate Euler angles
    eul = [atan2(R(i,j,:), R(i,k,:)), atan2(sy, R(i,i,:)), atan2(R(j,i,:), -R(k,i,:))];
    
    % Singular matrices need special treatment
    numSingular = sum(singular,3);
    assert(numSingular <= length(singular));
    if numSingular > 0
        eul(:,:,singular) = [atan2(-R(j,k,singular), R(j,j,singular)), ...
            atan2(sy(:,:,singular), R(i,i,singular)), zeros(1,1,numSingular,'like',R)];
    end
    
else
    % Find special cases of rotation matrix values that correspond to Euler
    % angle singularities.  
    sy = sqrt(R(i,i,:).*R(i,i,:) + R(j,i,:).*R(j,i,:));    
    singular = sy < 10 * eps(class(R));
    
    % Calculate Euler angles
    eul = [atan2(R(k,j,:), R(k,k,:)), atan2(-R(k,i,:), sy), atan2(R(j,i,:), R(i,i,:))];
    
    % Singular matrices need special treatment
    numSingular = sum(singular,3);
    assert(numSingular <= length(singular));
    if numSingular > 0
        eul(:,:,singular) = [atan2(-R(j,k,singular), R(j,j,singular)), ...
            atan2(-R(k,i,singular), sy(:,:,singular)), zeros(1,1,numSingular,'like',R)];
    end    
end

if parity
    % Invert the result
    eul = -eul;
end

if movingFrame
    % Swap the X and Z columns
    eul(:,[1,3],:)=eul(:,[3,1],:);
end

end

