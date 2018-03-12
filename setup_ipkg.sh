#!/usr/bin/env sh

# All credit goes to https://github.com/trepmag/ds213j-optware-bootstrap
# Some modifications (logging, mostly) made by me (@chbrown)

## Create optware root directory ##
# mkdir /volume1/@optware
# mkdir /opt
# mount -o bind /volume1/@optware /opt

FEED=http://ipkg.nslu2-linux.org/feeds/optware/cs08q1armel/cross/unstable
PACKAGES_PATH=$(mktemp -d)/Packages
curl -sS "$FEED/Packages" > "$PACKAGES_PATH"
>&2 printf 'Downloaded "Packages" listing to %s\n' "$PACKAGES_PATH"

IPKG_FILENAME=$(awk '/^Filename: ipkg-opt/ {print $2}' "$PACKAGES_PATH")
# The "ipkg-opt*.ipk" file is a gzipped tarball that contains three entries:
# ./debian-binary, ./data.tar.gz, and ./control.tar.gz
# The "data.tar.gz" entry is another tarball, which contains files in ./opt/{bin,etc,lib,share} subdirectories.
# We unpack these directly into the filesystem under /opt/{bin,etc,lib,share}
>&2 printf 'Unpacking "data.tar.gz" from .ipk directly into filesystem...\n'
curl -sS "$FEED/$IPKG_FILENAME" | tar -Oxvf - ./data.tar.gz | tar -C / -xvf -

mkdir -p /opt/etc/ipkg
IPKG_CONFIG=/opt/etc/ipkg/feeds.conf
printf 'src cross %s\n' "$FEED" > "$IPKG_CONFIG"
>&2 printf 'Initialized/reset ipkg config at %s\n' "$IPKG_CONFIG"
