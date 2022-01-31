#!/usr/bin/env bash

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
