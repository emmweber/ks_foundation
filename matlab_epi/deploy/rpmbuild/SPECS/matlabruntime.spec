
#*******************************************************************************************************
# Neuro MR Physics group
# Department of Neuroradiology
# Karolinska University Hospital
# Stockholm, Sweden
#
# Filename : matlabruntime.spec
#
# Authors  : Stefan Skare
# Date     : 2019-Feb-15
# Version  : 2.2
#
# Spec file for rpmbuild command in build_RPM_matlabruntime.sh
#*******************************************************************************************************
 


#==============================================================================================================
# Config: RPM build directives, path variables and naming templates
#==============================================================================================================
%global __os_install_post %{nil}
%global _enable_debug_package 0
%global debug_package %{nil}

%define _rpmfilename matlab%{matlab_release}_runtime_linux.rpm
%define _missing_build_ids_terminate_build 0
%define main_folder /export/home/sdc/MATLAB/matlab%{matlab_release}_runtime_linux

Name:           matlab%{matlab_release}_runtime_linux
Version:        %{matlab_release}
Release:        1%{?dist}
Summary:        RPM to install Matlab runtime in $HOME/MATLAB/
Source:    			%{source_file}
License:		    See Mathworks
BuildRoot:      %{_tmppath}/%{name}-v%{matlab_release}

# no dependency checks, otherwise install may fail because because of missing libraries also they are included in the binaries (and we disable stripping)
Autoreq: 0



#==============================================================================================================
# Description: The output of 'rpm -qip <rpmfile>.rpm' for the end user to get info about this RPM
#==============================================================================================================
%description

#==============================================================================================================
# unused stages
#==============================================================================================================
%prep
%setup -c
%build


#==============================================================================================================
# Install: Commands used at target computer to install files (here with some RPM %variables)
#==============================================================================================================
%install

rm -rf $RPM_BUILD_ROOT

mkdir -p  %{buildroot}/%{main_folder}/

cp -a * %{buildroot}/%{main_folder}/

#==============================================================================================================
# unused stage
#==============================================================================================================
%check



#==============================================================================================================
# Files: The list of files that will be installed in their final resting place in the context of the target system
#==============================================================================================================
%files
%defattr(-,sdc,sdc)
%dir %{main_folder}
%{main_folder}/*

#==============================================================================================================
# unused stages
#==============================================================================================================
%doc
%changelog
