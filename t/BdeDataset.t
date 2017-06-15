#!/usr/bin/perl
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

use warnings;
use strict;

use Test::More;
use Test::Exception;
use File::Temp qw/ tempdir /;
use File::Copy qw/ copy /;

use LINZ::Bde;

my $dset;
my $datadir = "t/data";
my $tmpdir = tempdir( '/tmp/BdeDataset.t-data-XXXX', CLEANUP => 1 );

throws_ok {
  $dset = new LINZ::BdeDataset;
} qr/Invalid LINZ::BdeDataset path/, 'want a path';

throws_ok {
  $dset = new LINZ::BdeDataset('/this/directory/does/not/exist');
} qr/Invalid LINZ::BdeDataset path/, 'want an existing path';

throws_ok {
  $dset = new LINZ::BdeDataset($datadir);
} qr/Invalid LINZ::BdeDataset level/, 'want a level';

throws_ok {
  $dset = new LINZ::BdeDataset($datadir, 8);
} qr/Invalid LINZ::BdeDataset level/, 'want a level of 0 or 5';

ok ( $dset = new LINZ::BdeDataset($datadir, 0), "can use $datadir as level 0 dataset" );
is( $dset->level, 0, 'trusts level to be the passed one (0)');
is_deeply(scalar $dset->files, ['pab1'], 'finds pab1 file in dataset (0)');

ok ( $dset = new LINZ::BdeDataset($datadir, 5), "can use $datadir as level 5 dataset" );
is( $dset->level, 5, 'trusts level to be the passed one (5)');
is_deeply(scalar $dset->files, ['pab1'], 'finds pab1 file in dataset (5)');

copy($datadir.'/pab1.crs', $tmpdir.'/pab1.crs') or die "Copy failed: $!";
copy($datadir.'/pab1.crs', $tmpdir.'/pab2.crs') or die "Copy failed: $!";
ok ( $dset = new LINZ::BdeDataset($tmpdir, 5), 'can use $tmpdir as level 5 dataset' );
is_deeply(scalar $dset->files, ['pab1','pab2'], "finds pab1 and pab2 file in dataset $tmpdir");
ok ( $dset->has_file("pab1"), "has file pab1" );
ok ( $dset->has_file("pab2"), "has file pab2" );
ok ( ! $dset->has_file("pab2.crs"), "has_file does not want .crs suffix" );
ok ( ! $dset->has_file("never"), "hasn't file never" );

ok ( my $bdefile = $dset->open("pab1"), 'can open file from dataset' );
is ( $bdefile->table, 'crs_parcel_bndry', 'opened file is what we expected' );
 
done_testing(18);
