################################################################################
#
# LINZ Bde Perl package
#
# Copyright 2017 Crown copyright (c)
# Land Information New Zealand and the New Zealand Government.
# All rights reserved
#
# This program is released under the terms of the new BSD license. See the
# LICENSE file for more information.
#
################################################################################
package inc::MyBuilder;

use base qw(Module::Build);

sub new
{
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    return $self;
}

sub substitute_id {
    my $self = shift;
    my $file = shift;
    open(FILE, "<$file") || die "Can't process '$file': $!";
    my @lines = <FILE>;
    close(FILE);
    my @newlines;
    my $updated = 0;
    my $version = $self->dist_version;
    foreach(@lines) {
       my $matched = $_ =~ s/\$Id\$/VERSION: $version/g;
       $updated++ if $matched;
       push(@newlines,$_);
    }
    if ($updated) {
        open(FILE, ">$file.new") || die "Can't write to '$file': $!";
        print FILE @newlines;
        close(FILE);
        rename "$file.new", $file;
    }
}

sub process_pm_files {
    my $self = shift;
    my $files = $self->find_pm_files;

    return unless keys %$files;

    my $lib_dir = File::Spec->catdir($self->blib, 'lib/LINZ');
    File::Path::mkpath( $lib_dir );

    foreach my $filepath (keys %$files) {
        my $file = File::Basename::basename($filepath);
        my $to_file = File::Spec->catfile($lib_dir, $file);

        my $result = $self->copy_if_modified(
            from    => $filepath,
            to      => $to_file,
            flatten => 'flatten'
        ) || next;

        $self->substitute_id($result);
    }
}

1;
