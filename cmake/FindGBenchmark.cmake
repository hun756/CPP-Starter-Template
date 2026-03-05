# ============================================================================
# DEPRECATED: This file has been superseded by Dependencies.cmake
# ============================================================================
#
# Google Benchmark is now managed through cmake/Dependencies.cmake which
# provides a unified dependency management system with these improvements:
#   - Updated to Google Benchmark v1.9.1
#   - GIT_SHALLOW for faster downloads
#   - FIND_PACKAGE_ARGS to prefer system-installed versions
#   - Automatic compiler warning suppression for third-party code
#
# If you were including this file directly, update your CMakeLists.txt:
#   OLD: include(${CMAKE_SOURCE_DIR}/cmake/FindGBenchmark.cmake)
#   NEW: include(${CMAKE_SOURCE_DIR}/cmake/Dependencies.cmake)
#        setup_googlebenchmark()
#
# This file is kept for backward compatibility and will be removed in a
# future release.
# ============================================================================

message(DEPRECATION "FindGBenchmark.cmake is deprecated. Use Dependencies.cmake instead: "
    "include(\${CMAKE_SOURCE_DIR}/cmake/Dependencies.cmake) and call setup_googlebenchmark()")

include(${CMAKE_CURRENT_LIST_DIR}/Dependencies.cmake)
setup_googlebenchmark()