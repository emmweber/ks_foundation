
#*******************************************************************************************************
# Neuro MR Physics group
# Department of Neuroradiology
# Karolinska University Hospital
# Stockholm, Sweden
#
# Filename : ksepi.spec
#
# Authors  : Stefan Skare
# Date     : 2019-Feb-15
# Version  : 2.2
#
# Spec file for rpmbuild command in build_RPM_ksepi.sh
#*******************************************************************************************************
 


#==============================================================================================================
# Config: RPM build directives, path variables and naming templates
#==============================================================================================================
%global __os_install_post %{nil}
%global _enable_debug_package 0
%global debug_package %{nil}

%define _missing_build_ids_terminate_build 0
%define main_folder /export/home/sdc/ksepi
%define psd_folder %{main_folder}/psd
%define recon_folder %{main_folder}/recon
%define data_folder %{main_folder}/data
%define psd_install_name ksepi-vre

Name:           ksepi_%{version}
Version:        %{release_version}
Release:        1%{?dist}
Summary:        RPM to install the psd ksepi and the correconding matlab based son of recon reconstruction
Source:    			%{source_file}
License:		    EPIC License and sharing agreement with GE Healthcare
BuildRoot:      %{_tmppath}/%{name}-v%{version}

# no dependency checks, otherwise install may fail because because of missing libraries also they are included in the binaries (and we disable stripping)
Autoreq: 0



#==============================================================================================================
# Description: The output of 'rpm -qip <rpmfile>.rpm' for the end user to get info about this RPM
#==============================================================================================================
%description

----------------------------------------------------------------------------------------------------------------
RPM package to install ksepi pulse sequence 'ksepi.e' and its compiled matlab recon 'recon_epi'.
The RPM file should be installed on a GE MR system from DV26.0_R01 or later. DV24-25 works on the psd side, built
use Pfiles for recon. recon_epi.m need more testing on Pfiles for now. PET/MR systems (MP24/MP26) should
work as well.
All files are installed in the home directory of sdc on the MR host computer in the directory 'ksepi'
I.e., we have
/export/home/sdc/ksepi                              as the root folder
/export/home/sdc/ksepi/psd/ksepi.*                  The psd files
/export/home/sdc/ksepi/psd/recon/recon_epi_live.sh  The top-most recon script, calling...
/export/home/sdc/ksepi/psd/recon/recon_epi.sh       which in turn calls the compiled Matlab binary
/export/home/sdc/ksepi/psd/recon/recon_epi          on the Version

The RPM installation creates symbolic links for the psd:
/usr/g/bin/ksepi-vre -> /export/home/sdc/ksepi/psd/ksepi
/usr/g/bin/ksepi-vre.psd.ice -> /export/home/sdc/ksepi/psd/ksepi.psd.ice # used by RX27
/usr/g/bin/ksepi-vre.psd.mgd -> /export/home/sdc/ksepi/psd/ksepi.psd.mgd # used by DV26, MP26

The RPM installation creates a symbolic link for the recon:
/usr/g/bin/recon961 -> /export/home/sdc/ksepi/recon/recon_epi_live.sh
----------------------------------------------------------------------------------------------------------------

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
mkdir -p  %{buildroot}/%{main_folder}
mkdir -p  %{buildroot}/%{psd_folder}
mkdir -p  %{buildroot}/%{recon_folder}
mkdir -p  %{buildroot}/%{data_folder}

install ksepi %{buildroot}/%{psd_folder}/ksepi
install ksepi.psd.* %{buildroot}/%{psd_folder}/

install mkdir_vre_ksepi %{buildroot}/%{recon_folder}/mkdir_vre_ksepi
install recon_epi %{buildroot}/%{recon_folder}/recon_epi
install recon_epi.sh %{buildroot}/%{recon_folder}/recon_epi.sh
install recon_epi_live.sh %{buildroot}/%{recon_folder}/recon_epi_live.sh
install runtimeversion.txt %{buildroot}/%{recon_folder}/runtimeversion.txt

# creating the links here and mention them in the next section as files --> the advantage over doing that in %post is that they get automatically installed and uninstalled
# setting up psd links (we create links for the scanner filesystem, they link to the scanner, not to %{buildroot}, once they are copied they will be working)
mkdir -p %{buildroot}/usr/g/bin

ln -s %{psd_folder}/ksepi %{buildroot}/usr/g/bin/%{psd_install_name}
ln -s %{psd_folder}/ksepi.psd.ice %{buildroot}/usr/g/bin/%{psd_install_name}.psd.ice
ln -s %{psd_folder}/ksepi.psd.mgd %{buildroot}/usr/g/bin/%{psd_install_name}.psd.mgd

# setting up recon links links (we create links for the scanner filesystem, they link to the scanner, not to %{buildroot}, once they are copied they will be working)
ln -s %{recon_folder}/recon_epi_live.sh %{buildroot}/usr/g/bin/recon961



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
%dir %{recon_folder}
%dir %{psd_folder}
%dir %{data_folder}
%attr(4755, root, root) %{recon_folder}/mkdir_vre_ksepi
%attr(0755, sdc, sdc) %{recon_folder}/recon_epi
%attr(0755, sdc, sdc) %{recon_folder}/recon_epi.sh
%attr(0755, sdc, sdc) %{recon_folder}/recon_epi_live.sh
%attr(0755, sdc, sdc) %{recon_folder}/runtimeversion.txt
%{psd_folder}/*
/usr/g/bin/*

#==============================================================================================================
# unused stages
#==============================================================================================================
%doc
%changelog
