function compile_recon_epi
% realpath for macos: brew install coreutils

p = pwd;
cd(fullfile(fileparts(which(mfilename)), '..')) % cd .. to 'deploy' directory

buildpath = fullfile(fileparts(which(mfilename)),'recon');


if strcmpi(computer, 'glnxa64')
  % compile a mkdir binary that should run as root on VRE to create the directory vre:/data/acq/ksepi via setuid
  system(sprintf('gcc -o %s/mkdir_vre_ksepi %s/mkdir_vre_ksepi.c', buildpath, buildpath));

  suffix = 'linux';
elseif strcmpi(computer, 'maci64')
  suffix = 'mac';
else
  suffix = 'win';
end

% bring the dcm* binaries too (called from dcm_dump.m and dcm_modify.m)
dcmdump  = fullfile('..', 'dicom', sprintf('dcmdump_%s', suffix));
dcmodify = fullfile('..', 'dicom', sprintf('dcmodify_%s', suffix));

% bring the hosts.json file
hostsjson = fullfile('..', 'wrappers','dicomutils','hosts.json');

cmd = sprintf('mcc -R ''-logfile,./recon_epi.log'' -d %s -m recon_epi.m -a %s -a %s -a %s', buildpath,  dcmdump, dcmodify, hostsjson);
fprintf('%s\n',cmd);
eval(cmd);

delete(fullfile(buildpath,'mccExcludedFiles.log'));
delete(fullfile(buildpath,'readme.txt'));
delete(fullfile(buildpath,'requiredMCRProducts.txt'));
delete(fullfile(buildpath,'run_recon_epi.sh'));

v = version; % version on the form '9.5.0.944444 (R2018b)'
pos = strfind(v,'R20');
f = fopen(fullfile(buildpath,'runtimeversion.txt'),'w');
fprintf(f,'%s\n', v((pos+1):(pos+5)));
fprintf(f,'%s\n', suffix);
fclose(f);

cd(p);
  
end