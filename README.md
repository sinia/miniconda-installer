# A collection deployment scripts

* miniconda-installer.sh
Script meant to automate installation of miniconda package. The script downloads the package from 
https://repo.continuum.io/miniconda/, checks md5sum and then installs it in users home directory

This script installs 64bit Linux version (Linux-x86_64) of miniconda. For anyone interested in a different version
(32bit etc) could easily modify this script (variables "FILE" and "MD5_EXP"). 

Usage:
    bash miniconda-install.sh [-d] [-u] [-e]
    
    -d      Install Miniconda by overwriting existing miniconda installation if exists
    -u      After install update all Miniconda packages to the latest versions
    -e      Add Miniconda path to ~/.bashrc. This will make conda python default user's python version.
    -h      Show this help info



