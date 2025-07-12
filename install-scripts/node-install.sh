#!/bin/bash
# --- Function to check if a command exists ---
command_exists () {
  type "$1" &> /dev/null ;
}

source_nvm () {
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh" 
  fi
}

if ! command_exists nvm; then
	echo "Installing NVM"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
source_nvm()
nvm install 22.6.0
