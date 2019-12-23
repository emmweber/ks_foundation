function C = dctmtx(nrows, nbasisfcns)
% Creates basis functions for Discrete Cosine Transform

n = vec(0:(nrows-1));
C = zeros(numel(n), nbasisfcns);
C(:,1) = ones(size(n,1),1)/sqrt(nrows);

for k = 2:nbasisfcns
  C(:,k) = sqrt(2/nrows) * cos(pi*(2*n+1)*(k-1)/(2*nrows));
end

end


