# BDE repository

A BDE repository consists of a directory with sub folders `level_0` and
`level_5` containing respectively the full and incremental update files.
Each folder contains sub folders for each update, which are named according to 
the time of the update as YYYYMMDDhhmmss.  Within each folder the files for
each table are named xxx.crs.gz, where xxx is a code for the table.

The "time of the update" of a folder would match the oldest
time written in the START header of any contained file.

## Archives

The repository may also contain subfolders `level_0_archive` and
`level_5_archive`.  These contain additional data files which contain
data that is part of the table, but is not included in the files retrieved
from [Landonline](http://www.linz.govt.nz/land/landonline).

These hold data from the tables that is assumed to never change (historic
data), and for efficiency is not included in the extract.  These files are
called xxx.yyy where yyy is an arbitrary continuation of the file name.
If yyy ends ".gz" the file is assumed to be gzipped.  If it contains a
string ".YYYYMMDDhhmmss." then it will be included with updates after
that date.

