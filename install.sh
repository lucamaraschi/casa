#!/bin/sh
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# check if user has git installed and propose to install if not installed
if [ -d "/Library/Developer/CommandLineTools" ]; then
        echo "You already have the Command Line Tools. Continuing with the next steps..."
else
        XCODE_MESSAGE="$(osascript -e 'tell app "System Events" to display dialog "Please click install when Command Line Developer Tools appears"')"
        if [ "$XCODE_MESSAGE" = "button returned:OK" ]; then
            xcode-select --install
        else
            echo "You have cancelled the installation, please rerun the installer."
            # you have forgotten to exit here
            exit
        fi
fi

until [ -d "/Library/Developer/CommandLineTools" ]; do
        printf '.' > /dev/tty
	sleep 3
done
echo ""

echo "Xcode CLI tools OK"

echo "Installinc nixpkg"
curl -L https://nixos.org/nix/install > /tmp/install-nix.sh
sh /tmp/install-nix.sh --darwin-use-unencrypted-nix-store-volume

# Hack to use nixpkg directly
echo "/Users/lucamaraschi/.nix-profile/etc/profile.d/nix.sh" >> ~/.profile
. /Users/lucamaraschi/.nix-profile/etc/profile.d/nix.sh

# Install cachix
echo "Installing cachix..."
nix-env -iA cachix -f https://cachix.org/api/v1/install

echo '=========> OK <========='
