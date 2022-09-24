#!/bin/bash

HMM_PATH=$(dirname "$0")/h-m-m
MINIMUM_REQUIREMENTS="MINIMUM REQUIREMENTS: PHP 7+ and one of these three must exist on PATH: xclip, xsel or wl-clipboard."
DESTINATION_DIR=/usr/local/bin

# Detect if user is using a Mac
if [[ $OSTYPE == '^darwin' ]];then
    MINIMUM_REQUIREMENTS="MINIMUM REQUIREMENTS: PHP 7+ and one of these three must exist on. PATH: brew, xclip, xsel."    
fi

# Test if /usr/local/bin exists. If not fallback to /usr/bin
if [ ! -d "$DESTINATION_DIR" ]; then
    DESTINATION_DIR=/usr/bin
fi

# If h-m-m doesn't exist in the same directory as this script, tries to download from github repository
if [ ! -f "$HMM_PATH" ]; then
    if [ "$(curl --write-out '%{http_code}' --silent https://raw.githubusercontent.com/nadrad/h-m-m/main/h-m-m --output /tmp/h-m-m)" = "200" ]; then
        HMM_PATH=/tmp/h-m-m
    else
        printf "ERROR: Could not download h-m-m\n"
        exit 1
    fi
fi

printf "\n> Installer for h-m-m\n\n"

# Test if php is on PATH
if ! command -v php > /dev/null 2>&1;then
    printf "ERROR: php executable not found on PATH. Installation cancelled.\n";
    printf "%s\n" "$MINIMUM_REQUIREMENTS"
    exit 1
fi

# Test if xclip, xsel or wl-clipboard are on PATH
if ! command -v xclip > /dev/null 2>&1 && ! command -v xsel > /dev/null 2>&1 && ! command -v wl-clipboard > /dev/null 2>&1 ;then
    # Detect if user has homebrew installed
    if [[ $OSTYPE == "darwin"* ]]; then
        if command -v brew > /dev/null 2>&1; then
            printf "Homebrew is detected on this Mac. Would you like the script to install xclip, and xsel?\n"
            printf "Proceed (y/N)?"
            read -r a </dev/tty

            printf "\n"

            if ! printf "%s" "$a" | grep -q "^[yY]"; then
                printf "Installation cancelled.\n"
                exit 125
            fi

            if ! brew install xclip; then
                printf "ERROR: Error using homebrew to install xclip!\n"
                exit 1
            fi
            
            if ! brew install xsel; then
                printf "ERROR: Error using homebrew to install xsel!"
                exit 1
            fi
        else
            printf "ERROR: brew, xclip, xsel or wl-clipboard must exist on PATH. Installation cancelled.\n";
            printf "%s\n" "$MINIMUM_REQUIREMENTS"
            exit 1
        fi
    else
        printf "ERROR: xclip, xsel or wl-clipboard must exist on PATH. Installation cancelled.\n";
        printf "%s\n" "$MINIMUM_REQUIREMENTS"
        exit 1
    fi
fi

# Ask for user confirmation to install the script
printf "This script will install h-m-m on %s and make it executable.\n" "$DESTINATION_DIR"
printf "Proceed (y/N)?"

read -r a </dev/tty

printf "\n"

if ! printf "%s" "$a" | grep -q "^[yY]"; then
    printf "Installation cancelled.\n"
    exit 125
fi

# Ask for user confirmation to overwrite if the script is already installed
if test -f "$DESTINATION_DIR/h-m-m"; then
    printf "The file %s/h-m-m already exist.\n" "$DESTINATION_DIR"
    printf "Overwrite (y/N)?"

    read -r a </dev/tty

    printf "\n"

    if ! printf "%s" "$a" | grep -q "^[yY]"; then
        printf "Installation cancelled.\n"
        exit 125
    fi
fi

# Copy the script
if ! sudo cp "$HMM_PATH" "$DESTINATION_DIR/h-m-m"; then
   printf "ERROR: Could not copy h-m-m to %s\n" "$DESTINATION_DIR"
   exit 1
fi

# Delete temporary file, if exists.
rm -f /tmp/h-m-m

# Make the copied file executable
if ! sudo chmod +x "$DESTINATION_DIR/h-m-m"; then
   printf "ERROR: Could not make the script %s/h-m-m executable.\n" "$DESTINATION_DIR"
   exit 1
fi

printf "\nSUCCESS! h-m-m installed.\n"
