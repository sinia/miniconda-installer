#!/usr/bin/env bash

set -e

FILE=Miniconda3-latest-Linux-x86_64.sh
PREFIX=${HOME}/miniconda
UPDATE=false
ENV=false
AUTO=false
INSTALL_PKGS=""
INSTALL_DIR=""
UNINSTALL=false
CREATE_ENV=false
ENV_NAME=""

function clear_pythonpath {
    if [ -n "$PYTHONPATH" ]; then
        echo "Temporarily clearing PYTHONPATH to avoid conflicts with Miniconda installation."
        export OLD_PYTHONPATH="$PYTHONPATH"
        export PYTHONPATH=""
    fi
}

function restore_pythonpath {
    if [ -n "$OLD_PYTHONPATH" ]; then
        echo "Restoring PYTHONPATH after Miniconda installation."
        export PYTHONPATH="$OLD_PYTHONPATH"
        unset OLD_PYTHONPATH
    fi
}

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
        -p|--packages)
            shift
            INSTALL_PKGS="$1"
            ;;
        --dir)
            shift
            INSTALL_DIR="$1"
            ;;
        --auto)
            AUTO=true
            ;;
        --uninstall)
            UNINSTALL=true
            ;;
        --create-env)
            CREATE_ENV=true
            shift
            ENV_NAME="$1"
            ;;
        -h|--help|-?*)
            echo "
This script installs Miniconda in ${PREFIX} and adds environment path to .bashrc

bash conda-install.sh [-d] [-u] [--auto] [-p <packages>] [--dir <directory>] [--uninstall] [--create-env <env_name>]

    -d      Install Miniconda overwriting existing miniconda installation if exists
    -u      After install update all packages to the latest versions
    -e      Add miniconda path to ~/.bashrc. This will make conda python default user's python version.
    -p      Install additional python packages
    --dir   Define installation directory
    --auto  Automatically install Miniconda without user interaction
    --uninstall Interactive uninstall script
    --create-env Create a new conda environment with the given name
    -h      Show this help info

"
            exit 0
            ;;
        *)
            break
    esac
    shift
done

if [ -n "${INSTALL_DIR}" ]; then
    PREFIX=${INSTALL_DIR}
fi

if [ ${UNINSTALL} = true ]; then
    echo "Do you want to uninstall Miniconda from \"${PREFIX}\"? (y/n)"
    read -r ANSWER
    if [ "${ANSWER}" = "y" ]; then
        rm -rf ${PREFIX}
        echo "Uninstalled Miniconda from ${PREFIX}."
    else
        echo "Uninstall canceled."
    fi
    exit 0
fi

if [ ${AUTO} = true ]; then
    if [ -d "${PREFIX}" ]; then
        rm -rf ${PREFIX}
    fi
    ENV=true
fi

if [ -d "${PREFIX}" ]; then
    echo "Path \"${PREFIX}\" already exists. If you want to overwrite run this script with \"-d\" option"
    exit 1
fi

wget -c https://repo.anaconda.com/miniconda/${FILE}

if [ ${AUTO} = true ]; then
    bash ${FILE} -b -p ${PREFIX}
else
    bash ${FILE} -p ${PREFIX}
fi

if [ ${ENV} = true ]; then
    echo -e "\n#added by miniconda-installer installation script" >> ~/.bashrc
    echo "export PATH=\"${PREFIX}/bin:$PATH\"" >> ~/.bashrc
fi

rm ${FILE}
echo "Script successfully finished. To start using conda command open a new shell."

if [ ${UPDATE} = true ]; then
    echo "Updating conda to the latest version"
    ${PREFIX}/bin/conda update -qy --all
fi

if [ -n "${INSTALL_PKGS}" ]; then
    echo "Installing additional packages: ${INSTALL_PKGS}"
    ${PREFIX}/bin/conda install -qy ${INSTALL_PKGS}
fi

if [ ${CREATE_ENV} = true ]; then
    if [ -n "${ENV_NAME}" ]; then
        echo "Creating new conda environment: ${ENV_NAME}"
        ${PREFIX}/bin/conda create -qy -n ${ENV_NAME} python
        echo "Environment ${ENV_NAME} created. To activate the environment, run:"
        echo "source ${PREFIX}/bin/activate ${ENV_NAME}"
    else
        echo "Error: Environment name not provided. Use --create-env <env_name> to create a new environment."
        exit 1
    fi
fi

#Initialize conda for the first time

source ${PREFIX}/bin/activate
conda init

echo "To start using conda, close and reopen your terminal or run 'source ~/.bashrc'"
