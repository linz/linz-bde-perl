#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail
shopt -s failglob inherit_errexit

PERL=perl

cd `dirname $0`

${PERL} Build.PL
./Build manifest
./Build distmeta
${PERL} Makefile.PL

# Append custom rules
cat <<EOF >> Makefile
deb:
	dpkg-buildpackage -b -us -uc

check: test
EOF
