function combdata = acc(data)
% Adaptive Coil Combination (ACC)
%
%   S = ACC(R) produces an array S, SIZE(S)=[M,N,1,K,...], from an array
%   R, SIZE(R)=[M,N,P,K,...] by doing a real-SUPER combination
%
%   Combination of Signals From Array Coils Using Image Based Estimation of
%   Coil Sensitivity Profiles
%   M. Bydder, D.J. Larkman, and J.V. Hajnal
%   Magn Reson Med 47:539-548 (2002)
%
% Mathias Engstrom, Karolinska University Hospital, 2015
% Stefan Skare, Karolinska University Hospital, 2018

n = size(data); n(end+1:4) = 1;
if n(3) == 1
  combdata = data;
end

% Set filter defaults
f_width = .1;
trans = 4;

F = fermi(n(1:2),f_width * max(n(1:2)), trans);
combdata = zeros([n(1:2) 1 n(4:end)]);
beta = cft(bsxfun(@times, cft(data, [1 1]),F), [-1 -1]);
beta = bsxfun(@rdivide,beta,sum(beta.*conj(beta),3));
beta = bsxfun(@rdivide,bsxfun(@times,beta,sum(data.*conj(beta),3)),sum(beta.*conj(beta),3));
combdata = reshape(sumsq(beta),[n(1:2) 1 n(4:end)]);

end
