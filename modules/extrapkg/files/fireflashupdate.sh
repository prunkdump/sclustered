#!/bin/bash

########
#LICENSE                                                   
########

# Adobe Flash Player installer/updater for Mozilla Firefox. Please visit the project's website at: https://github.com/cybernova/fireflashupdate
# Copyright (C) 2018 Andrea Dari (andreadari@protonmail.com)                                   
#                                                                                                       
# This shell script is free software: you can redistribute it and/or modify                             
# it under the terms of the GNU General Public License as published by                                   
# the Free Software Foundation, either version 2 of the License, or                                     
# any later version.                                                                   
#                                                                                                       
# This program is distributed in the hope that it will be useful,                                       
# but WITHOUT ANY WARRANTY; without even the implied warranty of                                        
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                         
# GNU General Public License for more details.                                                          
#                                                                                                       
# You should have received a copy of the GNU General Public License                                     
# along with this shell script.  If not, see <http://www.gnu.org/licenses/>.


# Set Firefox's plugins dir
FIREFOX_FLASH_INSTALL_DIR=${FIREFOX_FLASH_INSTALL_DIR:-/usr/lib/mozilla/plugins}

# Setup Arch
case $(uname -m) in
  x86_64) ARCH=x86_64 ;;
    i?86) ARCH=i386 ;;
esac

# Check Adobe Flash Player's latest version from Adobe's website
VERSION=$(wget -qO- https://fpdownload.macromedia.com/pub/flashplayer/masterversion/masterversion.xml | grep -m1 "NPAPI_linux version" | cut -d \" -f 2 | tr , .)

# Error out if $VERSION is unset, e.g. because previous command failed
if [ -z "$VERSION" ]; then
  printf "Could not work out the latest version; exiting\n" >&2
  exit 1
fi

# Create plugins' destination directory if not exists
if [ ! -e "$FIREFOX_FLASH_INSTALL_DIR" ]; then
	sudo mkdir -p "$FIREFOX_FLASH_INSTALL_DIR"
fi

# Check if the current version installed is the latest
if [ -r "$FIREFOX_FLASH_INSTALL_DIR/libflashplayer.so" ]; then
  CUR_VER=$(grep -z 'FlashPlayer_' $FIREFOX_FLASH_INSTALL_DIR/libflashplayer.so | cut -d _ -f 2-5 | tr _ .)
  if [ "$CUR_VER" = "$VERSION" ]; then
    printf "The latest Flash Player ($VERSION) is already installed\n"
    exit 0
  fi
fi

# Exit on first error
set -e

# Move to /tmp for temporary files
cd /tmp

# Now get the tarball
wget "https://fpdownload.adobe.com/pub/flashplayer/pdc/$VERSION/flash_player_npapi_linux.${ARCH}.tar.gz"

# Extract the contents of the tarball to the Firefox's plugins dir
if [ "$USER" = "root" ]; then
	tar -xof flash_player_npapi_linux.${ARCH}.tar.gz -C $FIREFOX_FLASH_INSTALL_DIR libflashplayer.so
else
	sudo tar -xof flash_player_npapi_linux.${ARCH}.tar.gz -C $FIREFOX_FLASH_INSTALL_DIR libflashplayer.so 
fi

#Removing tmp files
rm flash_player_npapi_linux.${ARCH}.tar.gz

# Tell the user we are done
printf "\nFlash Player ($VERSION) installed into $FIREFOX_FLASH_INSTALL_DIR/\n"
