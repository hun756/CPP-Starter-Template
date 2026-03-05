# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CMakePresets.json with debug, release, coverage, and CI presets
- GitHub Actions CI pipeline (Linux GCC/Clang, macOS, Windows MSVC)
- Code coverage support with lcov/gcovr integration
- Coverage.cmake module with `coverage` and `coverage_clean` targets
- Dependencies.cmake unified dependency management module
- GenerateExportHeader for proper shared library symbol visibility
- Dependabot configuration for automated dependency updates
- GitHub Issue/PR templates (bug report, feature request)
- `.editorconfig` for cross-editor consistency
- CONTRIBUTING.md and CODE_OF_CONDUCT.md
- CHANGELOG.md following Keep a Changelog format
- Sanitizer CI jobs (ASan+UBSan, TSan)

### Changed
- Bumped minimum CMake version to 3.21
- Updated Google Test to v1.15.2
- Updated Google Benchmark to v1.9.1
- Modernized clang-tidy configuration with expanded checks
- Test discovery now uses `gtest_discover_tests` instead of `add_test`
- GLOB patterns use `CONFIGURE_DEPENDS` for automatic rebuild on file changes
- Library uses `CXX_VISIBILITY_PRESET hidden` for proper symbol management

### Fixed
- Fixed broken `Config.h.in` CMake variable substitution syntax
- Removed unused `src/CMakeLists.txt` that conflicted with root GLOB

## [0.1.0] - 2024-01-01

### Added
- Initial project template with C++20 support
- Google Test and Google Benchmark integration
- Compiler warnings for GCC, Clang, and MSVC
- Sanitizer support (ASan, UBSan, TSan, MSan, LSan)
- Static analyzer support (cppcheck, clang-tidy, include-what-you-use)
- LTO support
- CPack packaging configuration
- Doxygen documentation support
- Professional `.clang-format` configuration
- Comprehensive `.gitignore`
