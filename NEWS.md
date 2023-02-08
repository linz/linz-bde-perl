# X.Y.Z (YYYY-MM-DD)

## Removed

- Drop Ubuntu 18.04 support after
  [GitHub dropped their runner support](https://github.com/actions/runner-images/issues/6002).

# 1.4.1 (2022-05-02)

## Fixed

- Force pushing changes to origin remote

# 1.4.0 (2022-03-07)

## Added

- Support for Ubuntu 20.04/LTS

## Enhanced

- Quality improvements

# 1.3.1 (2021-12-07)

## Added

- Github test action and badge (#57)
- Add package building and publishing steps (#60)

## Enhanced

- Forward port package build improvements (#56)

# 1.2.0 (2019-09-09)

## Added

## Enhanced

- Temporary files are now prefixed and removed on exit (#50)

# 1.1.1 (2019-08-08)

## Fixed

- Perl 5.26 support ("Experimental push on scalar now forbidden" error)

# 1.1.0 (2019-02-28)

## Added

- Bde::pipe method (#23)

## Fixed

- Ensure failures in `bde_copy` are reported by `Bde::copy` method (#40)
- `BdeFile::archive_files` method (#19)
