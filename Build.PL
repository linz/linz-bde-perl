#!usr/bin/perl
################################################################################
#
# LINZ Bde Perl package
#
# Copyright 2011-2017 Crown copyright (c)
# Land Information New Zealand and the New Zealand Government.
# All rights reserved
#
# This program is released under the terms of the new BSD license. See the 
# LICENSE file for more information.
#
################################################################################
use strict;
use warnings;

use Config;
use lib '.';
use inc::MyBuilder;

my $requires = {
    'IO::Zlib'      => 0,
    'File::Which'   => 0,
};

my $version = '1.2.0';
if ( `which git` && -d '.git' ) {
  $version = `git describe`;
  chop($version);
}

my $build =  inc::MyBuilder->new(
    module_name        => 'LINZ::Bde',
    license            => 'bsd',
    dist_author        => 'LINZ',
    dist_abstract      => 'Perl package for managing LINZ BDE files and repositories',
    dist_version       => $version,
    sign               => 1,
    requires           => $requires,
    create_makefile_pl => 'small',
);

$build->create_build_script;
