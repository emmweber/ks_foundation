%% Diffusion recon dicom tags
function [diffusionImageTypeTag, userData20Tag, userData21Tag, userData22Tag, bValueTag, bValue2Tag, psdEPI2, ipsdEPI2] = recon_epi_diffusiondicomtags(volindx, rcnhandle)

[D, nT2Images, nDiffusionDirections, allbValues] = recon_epi_diffscheme(rcnhandle);

D = D(volindx,:); % select only the current volume

% Diffusion Image Type Annotation (VAS Collapse FLAG)
% Possible Values:
%   DiffusionRightLeftDicomValue = 3
%   DiffusionAnteriorPosteriorDicomValue = 4
%   DiffusionSuperiorInferiorDicomValue = 5
%   DiffusionT2DicomValue = 14
%   DiffusionCombinedDicomValue = 15
%   DiffusionDtiDicomValue = 16
%   DiffusionDirection1DicomValue = 43
%   DiffusionDirection2DicomValue = 44
%   DiffusionDirection3DicomValue = 45
%   DiffusionDirection4DicomValue = 46
%   FA = 18
%   eadc = 17
%   adc = 20
%   cFA = 31
% The diffusion image type is not in the pool header. Thus,
% the diffusion image type must come from an external source.
% By default, the diffusion image type is set to Dir 1.
diffusionImageTypeTag.Group = hex2dec('0043');
diffusionImageTypeTag.Element = hex2dec('1030');
diffusionImageTypeTag.VRType = 'SS';
if volindx <= nT2Images
  diffusionImageTypeTag.Value = 14;
elseif nDiffusionDirections >= 6
  diffusionImageTypeTag.Value = 16;
elseif all(D == [1 0 0])
  diffusionImageTypeTag.Value = 43; % means freq ?
elseif all(D == [0 1 0])
  diffusionImageTypeTag.Value = 44; % means phase ?
elseif all(D == [0 0 1])
  diffusionImageTypeTag.Value = 45; % means slice ?
end


% Diffusion directions in userdata20-22
userData20Tag.Group = hex2dec('0019');
userData20Tag.Element = hex2dec('10BB');
userData20Tag.VRType = 'DS';
userData20Tag.Value = sprintf('%.6f', D(1));

userData21Tag.Group = hex2dec('0019');
userData21Tag.Element = hex2dec('10BC');
userData21Tag.VRType = 'DS';
userData21Tag.Value = sprintf('%.6f', D(2));

userData22Tag.Group = hex2dec('0019');
userData22Tag.Element = hex2dec('10BD');
userData22Tag.VRType = 'DS';
userData22Tag.Value = sprintf('%.6f', D(3));


% SlopInt6-9 (bvalue)
if volindx <= nT2Images
  bValue = 0;
else
  whichb = ceil((volindx - nT2Images) / nDiffusionDirections);
  bValue = allbValues(whichb);
end
bValueTag.Group = hex2dec('0043');
bValueTag.Element = hex2dec('1039');
bValueTag.VRType = 'IS';
bValueTag.Value = [num2str(bValue) '\8\0\0'];

% Diffusion bvalue (another field)
bValue2Tag.Group = hex2dec('0018');
bValue2Tag.Element = hex2dec('9087');
bValue2Tag.VRType = 'FD';
bValue2Tag.Value = bValue;

% forced psdname and psdiname to allow fiber tracking on Advantage Windows
psdEPI2.Group = hex2dec('0019');
psdEPI2.Element = hex2dec('109c');
psdEPI2.VRType = 'LO';
psdEPI2.Value = 'epi2';

ipsdEPI2.Group = hex2dec('0019');
ipsdEPI2.Element = hex2dec('109e');
ipsdEPI2.VRType = 'LO';
ipsdEPI2.Value = 'EPI2';

% BValue Bias Factor (DISABLED)
% Product DICOM images have a bias factor of 1e9 added to the
% bValue dicom field (first integer in 0043,1039) for scans
% with more than one bValue. The bias factor, if applied, is
% stored in DICOM field (0043,107f). The bias factor
% functionality is replicated here.
% The bValue is not present in the pfile header. Thus, the
% bValue must come from another external source. By default,
% the bValue is set to 0.


if 0 % (nbValues > 1)
  % Update bValue tag to include bias factor and include
  % b-Value bias factor in dicom image header.
  bValueBiasFactor = 1000000000;
  bValue = bValue + bValueBiasFactor;
  bValueTag.Value = [num2str(bValue) '\8\0\0'];
  
  bValueBiasFactorTag.Group = hex2dec('0043');
  bValueBiasFactorTag.Element = hex2dec('107f');
  bValueBiasFactorTag.VRType = 'IS';
  bValueBiasFactorTag.Value = num2str(bValueBiasFactor);
else
  bValueBiasFactorTag = [];
end


end