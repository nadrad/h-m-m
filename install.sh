#!/bin/bash

HMM_PATH="$(dirname $0)/h-m-m"
MINIMUM_REQUIREMENTS="MINIMUM REQUIREMENTS: PHP 7+ and one of these three must exist on PATH: xclip, xsel or wl-clipboard\n"
DESTINATION_DIR="/usr/local/bin"

# Test if /usr/local/bin exists. If not fallback to /usr/bin
if [ ! -d "$DESTINATION_DIR" ]; then
    DESTINATION_DIR="/usr/bin"
fi

# If h-m-m doesn't exist in the same directory as this script, tries to download from github repository
if [ ! -f "$HMM_PATH" ]; then

    if [[ $(curl --write-out '%{http_code}' --silent https://raw.githubusercontent.com/nadrad/h-m-m/main/h-m-m --output /dev/null) == 200 ]]; then
        curl --silent https://raw.githubusercontent.com/nadrad/h-m-m/main/h-m-m --output /tmp/h-m-m

        if [ $? -ne 0 ]; then
            echo -e "ERROR: Could not download h-m-m\n"
            exit 1
        fi

        HMM_PATH="/tmp/h-m-m"
    else
        echo -e "ERROR: Online repository not available or Internet is down\n"
        exit 1
    fi
fi

echo -e "\n> Installer for h-m-m\n"

# Test if php is on PATH
if ! command -v php &> /dev/null ;then
    echo -e "ERROR: php executable not found on PATH. Installation cancelled.\n";
    echo -e $MINIMUM_REQUIREMENTS
    exit 1
fi

# Test if xclip, xsel or wl-clipboard are on PATH
if ! command -v xclip &> /dev/null && ! command -v xsel &> /dev/null && ! command -v wl-clipboard &> /dev/null ;then
    echo -e "ERROR: xclip, xsel or wl-clipboard must exist on PATH. Installation cancelled.\n";
    echo -e $MINIMUM_REQUIREMENTS
    exit 1
fi

# Ask for user confirmation to install the script
echo -e "This script will install h-m-m on $DESTINATION_DIR and make it executable.\n"
echo -e "Proceed (y/N)?"

read a

if [[ ! "$a" =~ ^(y|Y) ]] ;then
    echo -e "Installation cancelled."
    exit 125
fi

# Ask for user confirmation to overwrite if the script is already installed
if test -f "$DESTINATION_DIR/h-m-m"; then
    echo -e "The file $DESTINATION_DIR/h-m-m already exist.\n"
    echo -e "Overwrite (y/N)?"

    read a

    if [[ ! "$a" =~ ^(y|Y) ]] ;then
        echo -e "Installation cancelled."
        exit 125
    fi
fi

# Copy the script
sudo cp $HMM_PATH $DESTINATION_DIR/h-m-m

if [ $? -ne 0 ]; then
   echo -e "ERROR: Could not copy h-m-m to $DESTINATION_DIR\n"
   exit 1
fi

# Delete temporary file, if exists.
rm -f /tmp/h-m-m

# Make the copied file executable
sudo chmod +x $DESTINATION_DIR/h-m-m

if [ $? -ne 0 ]; then
   echo -e "ERROR: Could not make the script $DESTINATION_DIR/h-m-m executable.\n"
   exit 1
fi

echo -e "\nSUCCESS! h-m-m installed.\n"
