% Fermi filter with radius and width dependent on k-space size
% based on expermental testing only
function F = adaptivefermi(sz)

ms = min(sz(1:2));
p = 100 * ms ./ 512; % 512 k-space matrix as reference

r = 0.48; % fermi radius 48% of k-space width
w = 6;

if p < 40
  r = 0.0037 * p + 0.3357;
end
if p < 20
  w = 0.2 * p + 2;
end

F = fermi(ms, ms * r, w);

% Stretch fermi filter if k-space is not symmetrical
% Will affect the fermi transition width
F = imresize(F, sz(1:2), 'cubic');

end
