function varargout = swi_filter(img, varargin)
% Usage:
% [Iswi, Pflt, input.Results] = swi_filter(ComplexImage, params);
% ComplexImage should have size [nX, nY, nCoils]
%
% Stefan Skare, Dept. Neuroradiology, Karolinska Hospital, Stockholm, Sweden
% v0.1. June 9, 2011


%% Input checking

defaultPmOrder = 4; % Normal range between 2 - 8
checkPmOrder = @(x) (x > 0);

defaultFilterType = 'fermi';
checkFilterType = @(x) (strcmp(x,'gaussian') || strcmp(x,'fermi'));

defaultFilterSize = 40; % filter diameter, voxel units
checkFilterSize = @(x) (x > 0);

defaultFilterWidth = 15; % filter transition width, voxel units
checkFilterWidth = @(x) (x > 0);

defaultUnwrap = 'hassan'; % Unwrap the phase map first. Currently only one method: 'hassan'
checkUnwrap = @(x) (strcmp(x,'hassan') || strcmp(x,'off'));

defaultAircavityFilter = true; % Only compatible with 'unwrap'
checkAircavityFilter = @(x) (true);

defaultMagmsksmooth = 50; % voxel units
checkMagmsksmooth = @(x) (x > 0);

defaultMagmskthr = 0.2; % threshold
checkMagmskthr = @(x) (isfloat(x));

defaultFOVratio = 1.0; % phaseFOV (dim1) /freqFOV (dim2)
checkFOVratio = @(x) (isfloat(x));

input = inputParser;
addParameter(input, 'pm_order', defaultPmOrder, checkPmOrder);
addParameter(input, 'filter_type', defaultFilterType, checkFilterType);
addParameter(input, 'filter_size', defaultFilterSize, checkFilterSize);
addParameter(input, 'filter_width', defaultFilterWidth, checkFilterWidth);
addParameter(input, 'unwrap', defaultUnwrap, checkUnwrap);
addParameter(input, 'aircavity_filter', defaultAircavityFilter, checkAircavityFilter);
addParameter(input, 'magmsksmooth', defaultMagmsksmooth, checkMagmsksmooth);
addParameter(input, 'magmskthr', defaultMagmskthr, checkMagmskthr);
addParameter(input, 'fovratio', defaultFOVratio, checkFOVratio);

parse(input, varargin{:});

% Only allow aircavity_filter if unwrap is applied
if input.Results.aircavity_filter && strcmp(input.Results.unwrap, 'off')
  error('If unwrap is off, aircavity_filter must be false');
end

isz = size(img); isz(end+1:3) = 1;
if prod(isz) == 0
  error('Size of img must be at least 1')
elseif mod(isz(1),2) || mod(isz(2),2)
  error('Size nX and nY of img must be even')
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  MAIN  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--- 2D filter
isz_fov = round([isz(1)/input.Results.fovratio isz(2)]); % isz_fov is the effective size (or distance from k-space center), independent on the rectangularness of the FOV
switch input.Results.filter_type
  case 'gaussian'
    flt = imresize(fspecial('gaussian', isz_fov(1:2), input.Results.filter_size/2),isz(1:2),'bicubic');
    flt5 = imresize(fspecial('gaussian', isz_fov(1:2), 5),isz(1:2),'bicubic');
  case 'fermi'
    flt = imresize(fermi2d(isz_fov, input.Results.filter_size/2, input.Results.filter_width),isz(1:2),'bicubic');
    flt5 = imresize(fermi2d(isz_fov, 5, 5),isz(1:2),'bicubic');
end
flt = mat2gray(flt); % Normalize 0->1
flt(flt < 1e-3) = 0; % Zero out values that are lower than 0.1 % of max


%--- Unwrap the phase map
switch input.Results.unwrap
  case 'hassan'
    P = ph_unwrap_hassan(img); % accepts: complex data or phase map
  case 'off'
    P = angle(img ./ ifft2(fft2(img) .* repmat(fftshift(flt),[1 1 isz(3:end)]))); % Complex operations
end

%--- Remove low spatial frequencies of the phase
if ~strcmp(input.Results.unwrap, 'off')
  if input.Results.aircavity_filter
    P5 = real(ifft2(fft2(P) .* (1-repmat(fftshift(flt5),[1 1 isz(3:end)])))); % Fixed filter size of 5
  end
  P = real(ifft2(fft2(P) .* (1-repmat(fftshift(flt),[1 1 isz(3:end)])))); % operate on the unwrapped phase. Using ifft2 (and fftshifted flt instead). Faster !  
end



%% %%%%%%% Variables needed below this line: I, P, input.Results %%%%%%%


%--- Remove phase from image
I = abs(img);

%--- Negative phase mask with values ranging from 0 to 1
Pmsk = zeros(size(P),class(P)); % init with zeros
Pmsk(P>=0 | P<-pi) = 1;
Pmsk(P>=-pi & P<0) = (P(P>=-pi & P<0) + pi)/pi;

% Sinus and ears pass-through (Experimental)
if input.Results.aircavity_filter
  Pmsk(P5 < -pi) = 1;
end

%--- Magnitude mask
Mmsk = smooth(sumsq(I), input.Results.magmsksmooth);
Mmsk = (Mmsk > mean(Mmsk(:)) * input.Results.magmskthr);
Mmsk = repmat(Mmsk,[1 1 isz(3) 1]);

%--- SWI image
Iswi = I.* ((Pmsk .* Mmsk) .^ input.Results.pm_order);
varargout{1} = Iswi;

%--- Coil combined phase image (weighted by the mag sq)
if nargout > 1
  varargout{2} = sum(P .* Mmsk .* I.^2,3) ./ sum(I.^2,3);
end
  
%--- options
if nargout > 2
  varargout{3} = input.Results;
end


end





