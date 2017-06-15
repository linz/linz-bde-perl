#!/usr/bin/perl

use warnings;
use strict;

use Test::More;
use Test::Exception;
use File::Temp qw/ tempdir /;
use File::Copy qw/ copy /;

use LINZ::Bde;

my $repo;
my $datadir = "t/data";
my $tmpdir = tempdir( '/tmp/BdeRepository.t-data-XXXX', CLEANUP => 1 );
my $level;

throws_ok {
  $repo = new LINZ::BdeRepository;
} qr/Invalid BDE repository path/, 'want a path';

throws_ok {
  $repo = new LINZ::BdeRepository('/this/directory/does/not/exist');
} qr/Invalid BDE repository path/, 'want an existing path';

ok ( $repo = new LINZ::BdeRepository($tmpdir), "can use $tmpdir as argument" );

throws_ok {
  $level = $repo->level0;
} qr|Level 0 directory .*/level_0 doesn't exist|,
  'cannot access missing level 0 dir';

mkdir $tmpdir . '/level_0' or die "mkdir failed: $!";
ok ( $level = $repo->level0, 'can get level0 when it exists' );

throws_ok {
  $level = $repo->level5;
} qr|Level 5 directory .*/level_5 doesn't exist|,
  'cannot access missing level 5 dir';

mkdir $tmpdir . '/level_5' or die "mkdir failed: $!";
ok ( $level = $repo->level5, 'can get level5 when it exists' );

is_deeply( [ $level->datasets ], [], 'level has no datasets (yet)' );
mkdir $tmpdir . '/level_5/20010911000102' or die "mkdir failed: $!";
copy($datadir.'/pab1.crs', $tmpdir.'/level_5/20010911000102/a.crs') or die "Copy failed: $!";
mkdir $tmpdir . '/level_5/20020107150005' or die "mkdir failed: $!";
copy($datadir.'/pab1.crs', $tmpdir.'/level_5/20020107150005/b.crs') or die "Copy failed: $!";
mkdir $tmpdir . '/level_5/20170615122746' or die "mkdir failed: $!";
copy($datadir.'/pab1.crs', $tmpdir.'/level_5/20170615122746/c.crs') or die "Copy failed: $!";
is_deeply( [ $level->datasets ], [], 'new datasets are not seen (yet)'); # skip ?

# Need to re-open the repository to find new directories

ok ( $repo = new LINZ::BdeRepository($tmpdir), "could open $tmpdir again" );
isa_ok ( $repo, 'LINZ::BdeRepository', 'opened repository is a BdeRepository' );
ok ( $level = $repo->level5, 'could get level5 again' );
isa_ok ( $level, 'LINZ::BdeRepository', 'level is a BdeRepository' );
is ( scalar @{$level->datasets}, 3, 'now level5 has 3 datasets' );

my $subset;
$subset = $level->before("20010912"); # will be a repository
is ( scalar @{$subset->datasets}, 1, "1 datasets are before 20010912" ); 
isa_ok ( $subset, 'LINZ::BdeRepository', 'subset is a BdeRepository' );
$subset = $level->after("20010912"); # will be a repository
is ( scalar @{$subset->datasets}, 2, "2 datasets are after 20010912" ); 
my $dset;
is ( $level->dataset("2000"), undef, 'unexisting dataset returns undef' );
ok ( $dset = $level->dataset("20020107150005"), 'existing dataset can be accessed by name' );
ok ( ! $dset->has_file("a"), "20020107150005 has no file a" );
ok ( $dset->has_file("b"), "20020107150005 has file b" );
ok ( ! $dset->has_file("c"), "20020107150005 has no file c" );

ok ( $level->last_dataset->has_file('c'), 'last dataset has file "c"' );

done_testing(23);
