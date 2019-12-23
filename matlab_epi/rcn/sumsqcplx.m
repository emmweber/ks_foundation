function s = sumsq(r,h)
% SUMSQ Performs a sum-of-squares operation on the 3rd dim of a (4+)D array.
%
%   S = SUMSQ(R) produces an array S, SIZE(S)=[M,N,1,K,...], from an array
%   R, SIZE(R)=[M,N,P,K,...] by doing a sum-of-squares operation,
%   SQRT(SUM(ABS())), on the 3rd dimension of R.
%
%   DB Clayton - v1.0 - 2003/12/01
%   Stefan Skare - v1.1 March 27, 2006. Removed for loops
%   Rexford Newbould - v1.2 07-17-06. Will work for any number of
%   dims, not just 5D
%   Stefan Skare - v1.2.1 July 18, 2006. Now it works for 2D as
%   well (in which case it does nothing)
%   Rexford Newbould - v2.0 August 7th, 207.  Now we do a sum of squares
%   using the proper complex form, so if you pass in a complex r you get
%   back a complex s.  Also, if you pass in a GE pfile header h, it will
%   weight the sum-of-squares combination using the stddev of the coil
%   noise.
%   Stefan Skare - v2.1 July 20th, 2009: Inverting the noise weighting as it was taken for SNR not noise values. Actually putting this inside the square function by multiplying each coil of r first


%%[ny, nx, nc, ns, ne] = size(r);
if ndims(r) < 3 || size(r,3) == 1
  s = r;
  return;
end
inputsize = size(r);
nc = inputsize(3);
s = zeros([inputsize(1:2) 1 inputsize(4:end)],class(r));

if exist('h','var') && isfield(h.rdb,'rec_noise_std') && all(isfinite(h.rdb.rec_noise_std)) && all(h.rdb.rec_noise_std > 0) && numel(h.rdb.rec_noise_std) > nc
   rec_snr = 1 ./ h.rdb.rec_noise_std ; % Stefan inverted and squared this on July 20, 2009
   for c = 1:nc
      r(:,:,c,:,:,:) = r(:,:,c,:,:,:) * rec_snr(c);
   end
end

if isreal(r)
  s = sqrt(sum(r.^2, 3)/nc);
else
  coilsum = sum(r,3) ;
  coilsum_norm = abs(coilsum);
  coilsum_norm(coilsum_norm == 0) = Inf;
  s = sqrt(sum(abs(r).^2, 3)/nc) .* (coilsum ./ coilsum_norm);
end

