function [FA, C, EigVal] = diff_FA(D, usemex)

if ~exist('usemex','var')
  usemex = 1;
end

if usemex && exist('diff_FA_omp','file')
  if nargout >= 3
    [FA, C, EigVal] = diff_FA_omp(D);
  elseif nargout == 2
    [FA, C] = diff_FA_omp(D);
  else
    FA = diff_FA_omp(D);
  end
  
else  % matlab code
  
  dim = [size(D,2) size(D,3) size(D,4)];
  FA = zeros(dim,class(D));
  if nargout > 1
    C = zeros([3 dim],class(D));
  end
  if nargout > 2
    EigVal = zeros([3 dim],class(D));
  end
  
  for j = 1:prod(dim(1:3))
    d = D(:,j); % Dxx Dyy Dxx Dxy Dxz Dyz
    if ~all(d == 0)
      [e_vec,e_val] = eig([d(1) d(4) d(5); d(4) d(2) d(6); d(5) d(6) d(3)]);
      e_val = diag(e_val);
      FA(j) = sqrt(3*var(e_val) / (e_val'*e_val));
      if nargout > 1
        C(:,j) = e_vec(:,e_val == max(e_val));
      end
      if nargout > 2
        e_val_sort = sort(e_val);
        EigVal(1,j) = e_val_sort(3);
        EigVal(2,j) = e_val_sort(2);
        EigVal(3,j) = e_val_sort(1);
      end
    end
  end
  
end

FA(FA(:) > 1) = 1;
FA(FA(:) < 0) = 0;

if nargout >= 2
  C = permute(C,[2 3 4 1]);
end
if nargout >= 3
  EigVal = permute(EigVal,[2 3 4 1]);
end

end