function varargout = render(img, range, chan, numcols, cmap, sqimflag)
  %RENDER Display intensity images stored in a N-dimensional array
  %
  %  RENDER(IMG) renders IMG by treating the first 2 dimensions as
  %  the in-plane dimensions and all other dimensions as being
  %  multiple slice planes.  The images are displayed in magnitude
  %  mode.
  %
  %  RENDER(IMG, RANGE) renders IMG with windowing from RANGE(0)
  %  to RANGE(1).  The default is [], which uses the minimum value
  %  in IMG' for RANGE(0) and the max for RANGE(1) where IMG' is
  %  the given channel for IMG (see CHAN below).  See MAT2GRAY for
  %  more details.
  %
  %  RENDER(IMG, RANGE, CHAN) renders IMG in one of the available
  %  channels, CHAN: 'abs', 'real', 'imag', 'phase', 'angle' or
  %  'log'. The default is 'abs'. the 'log' channel is actually
  %  log(1+abs(img)).  The difference between 'phase' and 'angle'
  %  is that the former does an unwrap.
  %
  %
  %  RENDER(IMG, RANGE, CHAN, CMAP) renders IMG with one of the 
  %  available COLORMAPS: 'gray', 'jet' & 'parula'.
  %
  %  EXAMPLE: 
  %     
  %     render(image, [0 0.6], 'real', 3, 'parula');
  %
  %  Defualt CHAN & NUMCOLS:
  %
  %     render(image, [0.2 0.8], [], [], 'gray'); 
  %
  %  Defualt everything:
  %
  %     render(image); 
  %         
  
  
  % prologue
  warning('off', 'Images:truesize:imageTooBigForScreen');
  warning('off', 'Images:imshow:magnificationMustBeFitForDockedFigure');
  s = size(img);
  ny = s(1);
  nx = s(2);
  nz = numel(img)/(nx*ny);  % total number of out-of-plane dimensions
  
  % args
  if (nargin < 2)
      range=[]; 
  end  % default range = []
  
  if (nargin < 3) || isempty(chan)
    if isnumeric(range) || isempty(range)
      if ~isreal(img)
        chan='abs';
      else
        chan='real';
      end
    elseif ischar(range)
      chan = range;
      range=[];
    end
  end  % default channel = 'abs'
  
  if nargin < 4
    numcols = '';
  end

  if nargin < 5 || isempty(cmap)
      cm = gray(2^16);
  else
      switch cmap
          case 'jet', cm = jet(2^16);
          case 'parula', cm = parula(2^16);
          case 'gray', cm = gray(2^16);
          otherwise, error('unrecognized colormap');
      end
  end
  
  if isempty(numcols) && ndims(img) == 4
    numcols = size(img,3);
  end    
  
  if ~exist('sqimflag','var')
      sqimflag = 'off';
  end
  
  if ~strcmpi(sqimflag,'off')
      sz = size(img);
      if strcmpi(sqimflag,'sqmax')
          newsz = max(sz(1:2))*[1 1];
      elseif strcmpi(sqimflag,'sqmin') || strcmpi(sqimflag,'sq')
          newsz = min(sz(1:2))*[1 1];
      end
      if ~isreal(img)
          img = imresize(real(img), newsz, 'bilinear') + 1i* imresize(imag(img), newsz, 'bilinear');
      else
          img = imresize(img, newsz, 'bilinear');
      end
  end
  
  % extract the requested channel
  switch lower(chan)
    case 'abs', img = abs(double(img));
    case 'real', img = real(double(img));
    case 'imag', img = imag(double(img));
    case 'angle', img = angle(double(img));
    case 'phase', img = unwrap(unwrap(angle(double(img)),[],1),[],2);
    case 'log', img = log(1+abs(double(img)));
    otherwise, error('unrecognized channel');
  end
  
  img = create_mosaic(img,numcols);
  
  % display
  if (isempty(range))
    range = [min(img(:)), max(img(:))];
  end
  imshow(img,range,'Colormap',colormap(cm))
  axis image
  axis off
  set(gca,'LooseInset',get(gca,'TightInset'))
  
  % put the current figure in front
  if strcmpi(get(gcf,'Visible'),'on')
    figure(gcf);
  end
  
  
  if nargout
      varargout{1} = img;
  end
  
  
end

