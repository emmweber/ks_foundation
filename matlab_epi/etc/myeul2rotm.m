function R = myeul2rotm( eul, varargin )

R = zeros(3,3,size(eul,1),'like',eul);
ct = cos(eul);
st = sin(eul);

R(1,1,:) = ct(:,2).*ct(:,1);
R(1,2,:) = st(:,3).*st(:,2).*ct(:,1) - ct(:,3).*st(:,1);
R(1,3,:) = ct(:,3).*st(:,2).*ct(:,1) + st(:,3).*st(:,1);
R(2,1,:) = ct(:,2).*st(:,1);
R(2,2,:) = st(:,3).*st(:,2).*st(:,1) + ct(:,3).*ct(:,1);
R(2,3,:) = ct(:,3).*st(:,2).*st(:,1) - st(:,3).*ct(:,1);
R(3,1,:) = -st(:,2);
R(3,2,:) = st(:,3).*ct(:,2);
R(3,3,:) = ct(:,3).*ct(:,2);


end

