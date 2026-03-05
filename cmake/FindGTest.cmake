# ============================================================================
# DEPRECATED: This file has been superseded by Dependencies.cmake
# ============================================================================
#
# Google Test is now managed through cmake/Dependencies.cmake which provides
# a unified dependency management system with these improvements:
#   - Updated to Google Test v1.15.2
#   - GIT_SHALLOW for faster downloads
#   - FIND_PACKAGE_ARGS to prefer system-installed versions
#   - GMock support enabled by default
#
# If you were including this file directly, update your CMakeLists.txt:
#   OLD: include(${CMAKE_SOURCE_DIR}/cmake/FindGTest.cmake)
#   NEW: include(${CMAKE_SOURCE_DIR}/cmake/Dependencies.cmake)
#        setup_googletest()
#
# This file is kept for backward compatibility and will be removed in a
# future release.
# ============================================================================

message(DEPRECATION "FindGTest.cmake is deprecated. Use Dependencies.cmake instead: "
    "include(\${CMAKE_SOURCE_DIR}/cmake/Dependencies.cmake) and call setup_googletest()")

include(${CMAKE_CURRENT_LIST_DIR}/Dependencies.cmake)
setup_googletest()
