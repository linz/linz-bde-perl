#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail
shopt -s failglob inherit_errexit

cd "$(dirname "$0")"

perl Build.PL
./Build manifest
./Build distmeta
perl Makefile.PL

# Append custom rules
cat <<EOF >> Makefile
deb:
	dpkg-buildpackage -b -us -uc

check: test
EOF
