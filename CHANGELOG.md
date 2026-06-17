# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Fixed
- Grade-change closing announcement (`'.`) missing when `noteref` or `annoref`
  is the last element in a grade-changed container (`poem`, `blockquote`, `div`,
  `epigraph`)
  ([#2877](https://redmine.sbszh.ch/issues/2877))

## [0.39] — 2026-06-17

### Fixed
- `brl:name` elements with a digit between a lowercase and uppercase letter
  (e.g. `Bride2BKate`, `Music4U`) were not recognised as CamelCase names and
  rendered incorrectly; the regex now allows optional digits before the
  uppercase letter
  ([#2690](https://redmine.sbszh.ch/issues/2690), [#28](https://github.com/sbsdev/dtbook2sbsform/issues/28))
- Stray space between grade-change announcement (`-.` / `'.`) and content when
  the first or last text node in a grade-changed container had leading or
  trailing whitespace
  ([#2743](https://redmine.sbszh.ch/issues/2743), [#27](https://github.com/sbsdev/dtbook2sbsform/issues/27))
- "ich" at end of a heading was incorrectly given the separator treatment when
  the next paragraph started with a guillemet (`»`); grade-2 contraction now
  respects block boundaries when looking ahead for punctuation
  ([#2932](https://redmine.sbszh.ch/issues/2932), [#26](https://github.com/sbsdev/dtbook2sbsform/issues/26))
- Spurious blank line before a page marker following a footnote reference
  ([#3015](https://redmine.sbszh.ch/issues/3015), [#22](https://github.com/sbsdev/dtbook2sbsform/issues/22))
- Slash in phone numbers (`brl:num role="phone"`) was dropped; it is now
  rendered as `!,` in braille, with surrounding spaces stripped
  ([#3021](https://redmine.sbszh.ch/issues/3021), [#24](https://github.com/sbsdev/dtbook2sbsform/issues/24))
- Grade-change announcements (`-.` / `'.`) missing when a page break appears
  as the first or last element in a grade-changed container (`poem`, `div`,
  `blockquote`, `epigraph`, level elements with `xml:lang="gsw"`)
  ([#2744](https://redmine.sbszh.ch/issues/2744),
  [#3048](https://redmine.sbszh.ch/issues/3048),
  [#23](https://github.com/sbsdev/dtbook2sbsform/issues/23))

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
