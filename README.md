# Easy miniconda installer script

## miniconda-installer.sh
Script meant to automate installation of Miniconda package. It can be used on linux desktops or doing unattended 
server deployments.

The script downloads the package from https://repo.continuum.io/miniconda/, checks md5sum and then installs it in users
home directory.

This script installs 64bit Linux version (Linux-x86_64) of Miniconda. For anyone interested in a different version
(32bit etc) could easily modify this script (variables "FILE" and "MD5_EXP"). In the future it could be possible to
change this via command variable. 

If you feel that there are issues/bugs or that functionality could be improved, feel free to contribute.

Usage:
    bash miniconda-install.sh [-d] [-u] [-e]
    
    -d      Install Miniconda by overwriting existing miniconda installation if exists
    -u      After install update all Miniconda packages to the latest versions
    -e      Add Miniconda path to ~/.bashrc. This will make conda python default user's python version.
    -h      Show this help info



