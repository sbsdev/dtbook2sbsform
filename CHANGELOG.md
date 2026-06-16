# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Fixed
- Blank line inserted before `pagenum` that immediately follows a `noteref`,
  causing a spurious paragraph break in the braille output
  ([#3015](https://redmine.sbszh.ch/issues/3015),
  [#22](https://github.com/sbsdev/dtbook2sbsform/issues/22))
  — close [#3015](https://redmine.sbszh.ch/issues/3015) when deployed

## [0.38] — 2026-06-05

### Changed
- Minimum Java version raised from 11 to 21
- Refactored `LouisTranslateFunction` and `LineBreaker` to use Java 21 idioms
  (pattern matching, try-with-resources, `ConcurrentHashMap`, `String.transform()`)

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
