#!/usr/bin/env bash

### tell bash that it should exit the script if any statement returns a non-true return value
set -e

### Set main variables. You can change this per your preferences
FILE=Miniconda3-latest-Linux-x86_64.sh

# Path to which Miniconda will be installed
PREFIX=${HOME}/miniconda


# Update miniconda to latest version or not. Default false
UPDATE=false
# Add miniconda to ~/.bashrc. Default false
ENV=false


### Main script logic. Normally shouldn't change this

# Read command parameters
while :; do
    case $1 in
        -d|--delete)
            if [ -d "${PREFIX}" ]; then
                echo "Path \"${PREFIX}\" already exists. Deleting with: \"rm -rf ${PREFIX}\""
                rm -rf ${PREFIX}
            fi
            ;;
        -u|--update)
            UPDATE=true
            ;;
        -e)
            ENV=true
            ;;
        -h|--help|-?*)
            echo "
This script installs Miniconda in ${PREFIX} and adds enviromant path to .bashrc

    bash conda-install.sh [-d] [-u]

    -d      Install Miniconda overwriting existing miniconda installation if exists
    -u      After install update all packages to the latest versions
    -e      Add miniconda path to ~/.bashrc. This will make conda python default user's python version.
    -h      Show this help info

"
            exit 0
            ;;
        *)
            break
    esac
    shift
done

# If Miniconda is already installed print a warning and exit
if [ -d "${PREFIX}" ]; then
    echo "Path \"${PREFIX}\" already exists. If you want to overwrite run this script wiht \"-d\" option"
    exit 1
fi

wget -c https://repo.continuum.io/miniconda/${FILE}


bash ${FILE} -b -p ${PREFIX}
if [ $ENV = true ]; then
    echo -e "\n#added by miniconda-installer installation script" >> ~/.bashrc
    echo "export PATH=\"${PREFIX}"'/bin:$PATH"' >> ~/.bashrc
fi
rm ${FILE}
echo 'Script successfully finished. To start using conda command open a new shell.'

if [ $UPDATE = true ]; then
    echo "Updating conda to the latest version"
    ${PREFIX}/bin/conda update -qy --all
fi

# TODO: Interactive uninstall script.
# TODO: Allow installation of additional python packages
# TODO: allow install into preexisting dir without deleting it
# TODO: allow define install path
