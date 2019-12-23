function p = gencs(res, pts, centerpercentage)

if ~exist('centerpercentage','var')
  centerpercentage = 10;
end

p = pdisk2([res res], pts);
p = p-res/2;

p = complex(p(:,1), p(:,2));
r = round(res * centerpercentage/200);

% remove center
p = p( ~( (abs(real(p)) <= (r+1)) & (abs(imag(p)) <= (r+1)) ) );
[X,Y] = meshgrid(-r:r,-r:r);
g = complex(X(:),Y(:));
p = [p(:);g(:)];

% within circle
p = p(abs(p) < res/2);

end
