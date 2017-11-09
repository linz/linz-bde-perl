#!/usr/bin/perl
################################################################################
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
use IO::Compress::Gzip qw/ gzip $GzipError /;
use File::Temp qw/ tempdir /;

use LINZ::Bde;

my $tmpdir = tempdir( '/tmp/BdeFile.t-data-XXXX', CLEANUP => 1 );

# LINZ::BdeFile functions

my $bde;
my $datadir = "t/data";

ok ( $bde = LINZ::BdeFile->open("${datadir}/pab1.crs"),
  'BdeFile->open accepts full relative path' );

throws_ok {
  $bde = LINZ::BdeFile->open("pab1.crs");
} qr/Invalid BDE file/, 'BdeFile->open throws on non-existent file';

ok( LINZ::BdeFile::set_bde_path("${datadir}"),
 'BdeFile::set_bde_path returns success');

ok ( $bde = LINZ::BdeFile->open("pab1.crs"),
  'BdeFile->open uses previously set bde_path' );

ok ( $bde = LINZ::BdeFile->open("pab1"),
  'BdeFile->open accepts argument without .crs extension' );

gzip $datadir."/pab1.crs" => $tmpdir."/pab1-comp.crs.gz"
            or die "gzip failed: $GzipError\n";

ok ( $bde = LINZ::BdeFile->open($tmpdir."/pab1-comp.crs.gz"),
  'BdeFile->open can open .crs.gz compressed files' );
is ( $bde->name, 'pab1-comp', 'does not include .crs.gz extension to name' );

ok( LINZ::BdeFile::set_bde_path(${tmpdir}), "set_bde_path to ${tmpdir}");
ok ( $bde = LINZ::BdeFile->open("pab1-comp"),
  'BdeFile->open accepts argument witout .crs.gz extension' );

is ( $bde->path, "${tmpdir}/pab1-comp.crs.gz", 'knows relative path' );
is ( $bde->table, 'crs_parcel_bndry', 'reads table from file' );
is ( $bde->start_time, '2016-06-01 17:12:25', 'reads start_time from file' );
is ( $bde->end_time, '2016-06-01 17:12:25', 'reads end_time from file');

TODO: {
  local $TODO = "https://github.com/linz/linz-bde-perl/issues/19";
  is_deeply ( [ $bde->archive_files ], [], 'checks archives from file');
}

# TODO: test archive_files when opening from BdeRepository/BdeDataset

is_deeply ( [ $bde->fields ],
            [ 'pri_id', 'sequence', 'lin_id', 'reversed', 'audit_id' ],
            'reads fields from file' );
is_deeply ( [ $bde->fields ], [ $bde->output_fields ],
            'all fields are read by default' );

ok ( $bde->output_fields('fake'), 'non-matching output field names are accepted' );
is_deeply ( [ $bde->output_fields ], [ 'fake' ], 'non-matching output field names are remembered' );

# Check data reading

my $data = $bde->data;
is_deeply ( scalar $data, undef, 'no data until ->next is called' );
ok ( $bde->next, "iterates to next record" );
$data = $bde->data;
is_deeply ( scalar $data, [ '' ], 'no data when with matching output_fields' );
ok ( $bde->output_fields('pri_id'), 'matching output field names are accepted' );
ok ( $bde->next, "iterates to next record (2)" );
$data = $bde->data;
is_deeply ( scalar $data, [ '' ], 'changing output_fields after ->next has no effect' );
ok ( $bde->close(), "bde file can be closed successfully" );

$bde = LINZ::BdeFile->open("pab1-comp");
ok ( $bde->output_fields('audit_id', 'pri_id'), 'output_fields accept multiple arguments' );
$bde->next; $data = $bde->data;
is_deeply ( scalar $data, [ '80401148', '4457326' ], 'output_fields determined data output' );
$bde->next; $data = $bde->data;
is_deeply ( scalar $data, [ '80401149', '4457326' ], 'second record' );
$bde->next; $data = $bde->data;
is_deeply ( scalar $data, [ '80401150', '4457326' ], 'third record' );
is ( $bde->next, 0, "->next returns 0 at end of file" );

# Mock a bde_copy command
my $fn = $tmpdir."/bde_copy";
open(my $fh, ">", $fn) or die "Can not create $fn";
print $fh "#!/bin/sh\necho \$\@ > $tmpdir/bde_copy_out\n( echo 1\necho 2\necho 3\n ) > \$4";
close ($fh);
chmod 0755, $fn;
$ENV{'PATH'} = $tmpdir . ':' . $ENV{'PATH'};

$bde->copy( 'out' );
my $cmdline = `cat $tmpdir/bde_copy_out`;
chop($cmdline);
is ( $cmdline, "-o audit_id:pri_id $tmpdir/pab1-comp.crs.gz out out.log",
     'invoked bde_copy correctly' );
unlink "$tmpdir/bde_copy_out";

$fh = $bde->pipe({'log_file' => '/tmp/log'});
ok ( $fh );
my @lines;
while (<$fh>) {
  chop;
  push @lines, $_;
};
is ( $lines[0], 1 );
is ( $lines[1], 2 );
is ( $lines[2], 3 );
close($fh);
$cmdline = `cat $tmpdir/bde_copy_out`;
chop($cmdline);
like ( $cmdline, qr|-o audit_id:pri_id $tmpdir/pab1-comp.crs.gz [^ ]* /tmp/log|,
     'invoked bde_copy correctly for pipe' );
unlink "$tmpdir/bde_copy_out";

done_testing(36);
