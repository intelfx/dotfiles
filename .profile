#!/bin/sh

# /etc/profile overwrites $PATH set from pam_env.so
echo ":: Setting up \$PATH"
PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"
export PATH

echo ":: Setting up ~/.thumbnails"
mkdir -pv "/tmp/${USER}-thumbnails"
rm -rf ~/.thumbnails
ln -vsf "/tmp/${USER}-thumbnails" ~/.thumbnails
