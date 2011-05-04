#!usr/bin/perl
################################################################################
#
# $Id$
#
# LINZ Bde Perl package
#
# Copyright 2011 Crown copyright (c)
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
use Module::Build;

my $requires = {
    'IO::Zlib'      => 0,
    'File::Which'   => 0,
};

my $build =  Module::Build->new(
    module_name        => 'LINZ::Bde',
    license            => 'bsd',
    dist_author        => 'LINZ',
    dist_abstract      => 'Perl package for managing LINZ BDE files and repositories',
    dist_version_from  => 'VERSION',
    sign               => 1,
    requires           => $requires,
);

$build->create_build_script;
