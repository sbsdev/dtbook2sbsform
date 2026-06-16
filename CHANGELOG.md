# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Fixed
- Spurious blank line before a page marker following a footnote reference
  ([#3015](https://redmine.sbszh.ch/issues/3015), [#22](https://github.com/sbsdev/dtbook2sbsform/issues/22))
- Slash in phone numbers (`brl:num role="phone"`) was dropped; it is now
  rendered as `!,` in braille, with surrounding spaces stripped
  ([#3021](https://redmine.sbszh.ch/issues/3021), [#24](https://github.com/sbsdev/dtbook2sbsform/issues/24))
- Grade-1 announcement (`-.`) missing when a page break appears before the
  first heading in a Swiss German (`xml:lang="gsw"`) section
  ([#3048](https://redmine.sbszh.ch/issues/3048), [#23](https://github.com/sbsdev/dtbook2sbsform/issues/23))

## [0.38] — 2026-06-05

### Changed
- Minimum Java version raised from 11 to 21

## [0.37] — 2026-06-04

### Fixed
- Incorrect `-t` → `-m` replacement for the `ver` contraction

## [0.36] — 2026-05-20

### Changed
- Migrated build system from Ant to Maven; all dependencies on Maven Central
- Added GitHub Actions release workflow (build, test, Debian package, GitHub release)
- Replaced `liblouis-saxon-extension` with `liblouis-java` from Maven Central
- Migrated all UTFX tests to XSpec; 60 tests now pass

## [0.35] — 2026-01-06

### Fixed
- Added missing newline in a macro definition

## [0.34]

### Changed
- Updated macro definitions: `level2`, `level3`, `blockquote`, `bridgehead`,
  and list types (`pl`, `ul`, `ol`) — indentation, spacing, and TOC parameters
  ([#3179](https://redmine.sbszh.ch/issues/3179))
