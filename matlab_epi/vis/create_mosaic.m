function Im = create_mosaic(I,n)
  % Create 2D image from larger array
  
  sz = size(I);
  z = prod(sz(3:end));
  
  prg = ver;
  
  if usejava('jvm') && feature('ShowFigureWindows') && ~strcmp(prg(1).Name, 'Octave')
      screenspecs = java.awt.Toolkit.getDefaultToolkit().getScreenSize();
      monitorratio = screenspecs.getWidth/screenspecs.getHeight;
  else
      monitorratio = 1.5;
  end
  
  I = reshape(I,[sz(1) sz(2) z]);
  
  if nargin > 1 && ~isempty(n)
    % Creating mosiac with n columns
    m = floor(z/n);
    if m*n < z
      m = m+1;
    end
  elseif z > 2
    % Default to m=n
    m = round(sqrt(z*sz(2)/sz(1)/monitorratio));
    if m < 1, m = 1; end
    n = ceil(z/m);
  else
    m = 1;
    n = z;
  end
  
  % printdbg('Creating a %d x %d mosaic\n',m,n);
  
  % Remaining tiles to be filled with zeros.
  Im = zeros(sz(1),sz(2),m*n);
  Im(:,:,1:z) = I;
  
  % Reshape to give us a 2D array
  Im = reshape(Im,[sz(1) sz(2) n m]);
  Im = permute(Im,[1 4 2 3]);
  Im = reshape(Im,[sz(1) sz(2)*m n]);
  Im = reshape(Im,[sz(1)*m,sz(2)*n]);
  
end
