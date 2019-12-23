function varargout = grappa(varargin)
% Usage - Estimating GRAPPA weights
% ---------------------------------
% syntax 1: p     = grappa(cosfdata,R)
% syntax 2: p     = grappa(cosfdata,R,parm)
%                   cosfdata: is a 3-5D complex array (NKY,NKX,NCOILS,NSLICES,NECHOES)
%                   that may not have any zero lines, i.e. should only include
%                   the COSF (CutOffSpatialFreq.) ky lines of the data used for the
%                   GRAPPA weight estimation
%                   Second arg may either be a scalar indicating the acceleration factor
%                   or a structure holding one or more of the following fields:
%                   parm.R = acceleration factor
%                   parm.gky = srclines = kernel width ky. Default = 4
%                   parm.gkx = kernel width, kx. Default = 5
%                   parm.delt = [dy dx]. How much we should jump with the GRAPPA kernel. Default = [1 1]
%                   parm.returnAY. Returns the matrix of source lines (A) and the matrix of ACS lines (Y). Default = 0
%                   In the 'get' mode, values > 1 are only useful when estimating on undersampled orthogonal
%                   propeller blades, so leave parm.delt = [1 1] unless you know what you are doing
%
%                   p is a struct containing the field in the parm struct plus the GRAPPA
%                   weights ('w'). size of w is 2D to 4D: [NCOILS*gkx*gky,NCOILS*numel(acslines),NSLICES,NECHOES]
%
%
% Usage - Applying GRAPPA weights
% -------------------------------
% syntax: kfull = Grappa(kspacesub,p)
%                 kspacesub: is the k-space to be synthesized with non-zero entries every Rth line
%                 assumption 1: The first acquired line from the top is expected to be 1,2,..,R (no zerofilled data please!)
%                 assumption 2: For the cicular convolution in ky to work, the sum of the number of zero lines
%                 (above the first acquired line) + (below the last acquired line) must be equal to R-1
%

if nargin < 2
  error('G: need 2 input args');
end


if isfield(varargin{2},'w')
  action = 'apply';
  actionindx = 2;
  parm = varargin{2};
  parm.delt = [1 parm.R]; % this has to be different from the get case since we have to jump by R in ky
else
  action = 'get';
  actionindx = 1;
  
  defaults = struct(...
    'dbg', 0, ...
    'R',[],...
    'gky',2, ...
    'gkx',3, ...
    'delt',[1 1],...
    'crosscal', 0, ...
    'returnAY', 0,...
    'calcfiterror', 1);
  
  
  if ~isscalar(varargin{2}) || varargin{2} < 2
    error('grappa: specify R > 1 as 2nd arg');
  end
  
  parm.R = varargin{2};
  
  parm = check_defaults(defaults,parm);
end


if isempty(parm.R), error('Grappa: Specify R please'); end

if ndims(varargin{1}) < 3 || ndims(varargin{1}) > 5
  error('Grappa: input must have 3 to 5 dimensions');
end

% New Ox data format permute
sortarray = [2 1 3 4 5];
% [nKx nKy nChannels nSlicesPerPass nEchoes] => [nKy nKx nChannels nSlicesPerPass nEchoes]
varargin{1} = permute(varargin{1}, sortarray);

parm.nonblanklines = find(mean(abs(varargin{1}(:,:,1)),2) ~= 0);

% nky nkx ncoils nslices, nechoes
ksize = size(varargin{1});
ksize(end+1:7) = 1;

% Use one simple acqpattern corresponding to the number of shots. E.g. 4 shots => [1 0 0 0 1]
srclines = find( logical([repmat([1 zeros(1,parm.R-1)],1,parm.gky-1) 1]));
% acslines = find(~logical([repmat([1 zeros(1,parm.R-1)],1,parm.gky-1) 1]));
centergap_offset = srclines(floor(numel(srclines)/2));
acslines = centergap_offset + (1:(parm.R-1));


% x-y coordinates for top-left position of GRAPPA kernel
if parm.crosscal
  gkxlocs = 1:parm.R:parm.gkx;
  [A_kx,A_ky] = meshgrid(int32(gkxlocs),int32(srclines));
  A_kx = A_kx(:); A_ky = A_ky(:);
  [Y_kx,Y_ky] = meshgrid(int32(ceil(parm.gkx/2)),int32(acslines));
  Y_kx = Y_kx(:); Y_ky = Y_ky(:);
else
  gkxlocs = 1:parm.gkx;
  [A_kx,A_ky] = meshgrid(int32(gkxlocs),int32(srclines));
  A_kx = A_kx(:); A_ky = A_ky(:);
  [Y_kx,Y_ky] = meshgrid(int32(ceil(parm.gkx/2)),int32(acslines));
  Y_kx = Y_kx(:); Y_ky = Y_ky(:);
end


% x-y offsets for all other locations for the GRAPPA kernel
if strcmpi(action,'get')
  if parm.crosscal, parm.delt = [parm.R 1]; end
  [off_kx,off_ky] = meshgrid(int32(0:parm.delt(1):(ksize(2)-parm.delt(1))),int32(0:parm.delt(2):ksize(1)));
else % Only catch with this is that we end up with some zero lines at the edges for gky > 2, as we don't wrap around ky. Fix!
  parm.delt = [1 parm.R];
  [off_kx,off_ky] = meshgrid(int32(0:parm.delt(1):(ksize(2)-parm.delt(1))),int32((parm.nonblanklines(1)-1):parm.delt(2):(parm.nonblanklines(end)-1)));
end
% currAx/y: add base x/y positions + x/y offsets together
%          each row is one GRAPPA kernel member location (Nsrc x kernelNx members)
%          each column is each location of the GRAPPA kernel
currAx = repmat(A_kx,1,numel(off_kx)) + repmat(vec(off_kx')',size(A_kx,1),1);
currAy = repmat(A_ky,1,numel(off_ky)) + repmat(vec(off_ky')',size(A_ky,1),1);
currYx = repmat(Y_kx,1,numel(off_kx)) + repmat(vec(off_kx')',size(Y_kx,1),1);
currYy = repmat(Y_ky,1,numel(off_ky)) + repmat(vec(off_ky')',size(Y_ky,1),1);

% wrap indices to the right and bottom that end up outside the size of the input data
currAx(currAx>size(varargin{1},2)) = currAx(currAx>size(varargin{1},2)) - size(varargin{1},2);  % wrap end of A
currYx(currYx>size(varargin{1},2)) = currYx(currYx>size(varargin{1},2)) - size(varargin{1},2);  % wrap end of Y
currAy(currAy>size(varargin{1},1)) = currAy(currAy>size(varargin{1},1)) - size(varargin{1},1);  % wrap end of A
currYy(currYy>size(varargin{1},1)) = currYy(currYy>size(varargin{1},1)) - size(varargin{1},1);  % wrap end of Y

if parm.dbg > 1
  for j = 1:numel(off_kx)
    hold off; render(varargin{1}(:,:,1),'log');
    hold on; plot(double(currAx(:,j)) + 1i*double(currAy(:,j)),'mo','markersize',5);
    hold on; plot(double(currYx(:,j)) + 1i*double(currYy(:,j)),'mx','markersize',8);
    pause
  end
end

% setup linear index for input data
Aindx{actionindx} = sub2ind(...
  ksize(1:3), ...
  vec(repmat(currAy(:)',ksize(3),1)) , ...
  vec(repmat(currAx(:)',ksize(3),1)) , ...
  vec(repmat(int32((1:ksize(3))'),1,numel(currAx))));
Yindx{actionindx} = sub2ind(...
  ksize(1:3), ...
  vec(repmat(currYy(:)',ksize(3),1)) , ...
  vec(repmat(currYx(:)',ksize(3),1)) , ...
  vec(repmat(int32((1:ksize(3))'),1,numel(currYx))));


for echo = 1:ksize(5)
  for z = 1:ksize(4)
    % fprintf('Grappa: echo %d, slice = %d\n',echo,z);
    
    % pick data to be used as the model in y = A w
    K = varargin{1}(:,:,:,z,echo);
    
    %figure(1);KA = zeros(size(K)); KA(Aindx{actionindx}) = ones(numel(Aindx{actionindx}),1); render(sumsq([K,KA*1e3]+1),'log'); drawnow
    %figure(2);KY = zeros(size(K)); KY(Yindx{actionindx}) = ones(numel(Yindx{actionindx}),1); render(sumsq([K;,KY*1e3]+1),'log'); drawnow
    
    
    A = reshape(K(Aindx{actionindx}), ksize(3)*numel(gkxlocs)*parm.gky,[]).';
    
    % size(A,1)/size(A,2)
    
    switch action
      case 'get'
        Y = reshape(K(Yindx{actionindx}), ksize(3)*numel(acslines),[]).';
        
        if parm.returnAY
          varargout{1}.A = A;
          varargout{1}.Y = Y;
          return
        end
        
        if z == 1 && echo == 1
          varargout{1} = parm;
          varargout{1}.w = zeros(numel(gkxlocs)*parm.gky*ksize(3),ksize(3)*numel(acslines),ksize(4),ksize(5), class(varargin{1}));
        end
        
        % varargout{1}.w(:,:,z,echo) = inv(A'*A) * (A'*Y);
        varargout{1}.w(:,:,z,echo) = A \ Y;
        
        if parm.calcfiterror
          e = vec((A*varargout{1}.w(:,:,z,echo)) - Y);
          varargout{1}.fiterror(z,echo) = e'*e;
        end
        
      case 'apply'
        
        if z == 1 && echo == 1
          varargout{1} = zeros(ksize, class(varargin{1}));
        end
        
        % do we have 1 or ksize(5) unique GRAPPA weight sets per slice?
        if ndims(varargin{2}.w) == 4 && size(varargin{2}.w,4) == ksize(5)
          eindx = echo;
        else
          eindx = 1;
        end
        
        K(Yindx{actionindx}) = vec((A*varargin{2}.w(:,:,z,eindx)).'); % synthesized lines
        varargout{1}(:,:,:,z,echo) = K;
        
    end
    
  end
end


% New Ox data format ipermute
% [nKx nKy nChannels nSlicesPerPass nEchoes] <= [nKy nKx nChannels nSlicesPerPass nEchoes]
varargout{1} = ipermute(varargout{1}, sortarray);

end
