# ============================================================================
# Modern C++ Project Template - CMake Build Configuration
# ============================================================================
#
# This CMakeLists.txt file configures the build process for a modern C++
# project with the following features:
#
# - C++20 standard support
# - Configurable version information
# - Support for tests, examples, benchmarks, and documentation
# - Compiler warnings and sanitizers for quality assurance
# - Code coverage instrumentation and HTML report generation
# - Shared/static library support with proper symbol visibility
# - Package configuration for easy integration in other projects
#
# QUICK START:
#   cmake --preset debug            # Configure with debug preset
#   cmake --build --preset debug    # Build the project
#   ctest --preset debug            # Run tests
#
# CLASSIC USAGE:
#   mkdir build && cd build
#   cmake ..
#   cmake --build .
#
# CONFIGURATION OPTIONS:
#   -DBUILD_SHARED_LIBS=ON|OFF     - Build shared libraries instead of static
#   -DBUILD_EXAMPLES=ON|OFF        - Build example programs
#   -DBUILD_TESTS=ON|OFF           - Build and enable tests
#   -DBUILD_BENCHMARKS=ON|OFF      - Build benchmarking programs
#   -DENABLE_COVERAGE=ON|OFF       - Enable code coverage reporting
#   -DENABLE_SANITIZERS=ON|OFF     - Enable sanitizers in debug builds
#   -DENABLE_PCH=ON|OFF            - Enable precompiled headers
#   -DENABLE_LTO=ON|OFF            - Enable Link Time Optimization
#
# ============================================================================

# CMake 3.21+ is required for:
#   - PROJECT_IS_TOP_LEVEL variable (automatically set)
#   - Better FetchContent integration with FIND_PACKAGE_ARGS
#   - Improved preset support
cmake_minimum_required(VERSION 3.21)

# ============================================================================
# Project Version Control
# ============================================================================
# Change these values when releasing a new version.
# Follow Semantic Versioning (https://semver.org/):
#   MAJOR - breaking API changes
#   MINOR - new features, backward compatible
#   PATCH - bug fixes, backward compatible
set(PROJECT_VERSION_MAJOR 0)
set(PROJECT_VERSION_MINOR 1)
set(PROJECT_VERSION_PATCH 0)
set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

# Define the project with metadata
# These values are used by CPack, Doxygen, and install targets
project(cpp_project_template
    VERSION ${PROJECT_VERSION}
    DESCRIPTION "Modern C++ Project Template"
    HOMEPAGE_URL "https://github.com/hun756/CPP-Starter-Template"
    LANGUAGES CXX C
)

# ============================================================================
# Top-Level Project Settings
# ============================================================================
# PROJECT_IS_TOP_LEVEL is automatically set by CMake 3.21+
# When this project is the root (not included via add_subdirectory),
# we enable developer-friendly settings
if(PROJECT_IS_TOP_LEVEL)
    # Generate compile_commands.json for IDE and tool support
    # (Used by clang-tidy, clangd, VS Code, etc.)
    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

    # Organize targets into folders in IDEs like Visual Studio
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)
endif()

# ============================================================================
# Build Configuration Options
# ============================================================================
# These can be set using -D flags when running cmake, or via CMakePresets.json.
# Example: cmake .. -DBUILD_SHARED_LIBS=ON -DENABLE_SANITIZERS=ON
option(BUILD_SHARED_LIBS "Build shared libraries instead of static" OFF)
option(BUILD_EXAMPLES "Build example programs demonstrating library usage" ON)
option(BUILD_TESTS "Build unit tests (requires Google Test)" ON)
option(BUILD_BENCHMARKS "Build performance benchmark programs" OFF)
option(ENABLE_SANITIZERS "Enable sanitizers (ASan, UBSan) in debug builds" OFF)
option(ENABLE_PCH "Enable precompiled headers to speed up compilation" OFF)
option(ENABLE_LTO "Enable Link Time Optimization for release builds" OFF)

# ============================================================================
# Output Directory Configuration
# ============================================================================
# Place all build artifacts in organized directories for easy access.
# This avoids hunting for binaries scattered across the build tree.
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)  # Static libraries (.a, .lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)  # Shared libraries (.so, .dll)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)  # Executables (.exe)

# ============================================================================
# C++ Standard Configuration
# ============================================================================
set(CMAKE_CXX_STANDARD 20)           # Use C++20 features
set(CMAKE_CXX_STANDARD_REQUIRED ON)  # Fail if compiler doesn't support C++20
set(CMAKE_CXX_EXTENSIONS OFF)        # Use -std=c++20, not -std=gnu++20

# ============================================================================
# Include Custom CMake Modules
# ============================================================================
# Our cmake/ directory contains reusable modules for different concerns.
# Each module handles one aspect of the build configuration.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(CompilerWarnings)    # Strict compiler warning flags (GCC, Clang, MSVC)
include(Sanitizers)          # Runtime error detection (ASan, UBSan, TSan, MSan)
include(StaticAnalyzers)     # Static analysis tools (cppcheck, clang-tidy, IWYU)
include(LTO)                 # Link Time Optimization for smaller/faster binaries
include(Coverage)            # Code coverage instrumentation and report generation
include(Packaging)           # CPack packaging (DEB, RPM, NSIS, ZIP, TGZ)

# ============================================================================
# Generated Configuration Headers
# ============================================================================
# Process Config.h.in to create a header with version info.
# This lets your C++ code access the project version at compile time:
#   #include "configs/ProjectConfig.h"
#   std::cout << cpp_project_template_VERSION << std::endl;
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/configs/Config.h.in"
    "${CMAKE_CURRENT_BINARY_DIR}/generated/configs/ProjectConfig.h"
)

# GenerateExportHeader creates proper DLL export/import macros.
# This is essential for building shared libraries on Windows and
# for controlling symbol visibility on all platforms.
include(GenerateExportHeader)

# ============================================================================
# Library Target
# ============================================================================
# Collect all source files for the library, excluding main.cpp.
# CONFIGURE_DEPENDS tells CMake to re-run if files are added/removed
# (Note: This has a small cost on configure time, but prevents build issues)
file(GLOB_RECURSE LIB_SOURCES CONFIGURE_DEPENDS "src/*.cpp")
list(FILTER LIB_SOURCES EXCLUDE REGEX ".*main\\.cpp$")

# Create the main library target.
# BUILD_SHARED_LIBS controls whether this is a static or shared library.
add_library(${PROJECT_NAME} ${LIB_SOURCES})

# Create a namespaced alias so consumers can use:
#   target_link_libraries(my_target PRIVATE cpp_project_template::cpp_project_template)
# This works the same whether the library is found via find_package() or add_subdirectory()
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# Generate the export header for shared library symbol visibility.
# When building a shared library, only symbols marked with cpp_project_template_EXPORT
# will be visible. This follows the "hidden by default" best practice.
#
# Usage in your headers:
#   #include "cpp_project_template/Export.h"
#   class cpp_project_template_EXPORT MyClass { ... };
generate_export_header(${PROJECT_NAME}
    EXPORT_FILE_NAME "${CMAKE_CURRENT_BINARY_DIR}/generated/${PROJECT_NAME}/Export.h"
    EXPORT_MACRO_NAME ${PROJECT_NAME}_EXPORT
    STATIC_DEFINE ${PROJECT_NAME}_STATIC
)

# Apply strict compiler warnings to catch potential issues early
target_compile_warnings(${PROJECT_NAME} PRIVATE)

# Enable runtime sanitizers for catching memory errors, undefined behavior, etc.
if(ENABLE_SANITIZERS)
    target_enable_sanitizers(${PROJECT_NAME})
endif()

# Enable code coverage instrumentation (only effective with --preset coverage)
target_enable_coverage(${PROJECT_NAME})

# Precompiled headers can significantly speed up compilation for large projects.
# Add your most frequently used standard library headers here.
if(ENABLE_PCH)
    target_precompile_headers(${PROJECT_NAME} PRIVATE
        <algorithm>
        <functional>
        <map>
        <memory>
        <string>
        <string_view>
        <vector>
    )
endif()

# Set library properties for versioning and symbol visibility
set_target_properties(${PROJECT_NAME} PROPERTIES
    VERSION ${PROJECT_VERSION}         # Full version (e.g., libfoo.so.0.1.0)
    SOVERSION ${PROJECT_VERSION_MAJOR} # ABI version (e.g., libfoo.so.0)
    POSITION_INDEPENDENT_CODE ON       # Required for shared libraries
    EXPORT_NAME ${PROJECT_NAME}        # Name used in exported CMake targets
    CXX_VISIBILITY_PRESET hidden       # Hide all symbols by default
    VISIBILITY_INLINES_HIDDEN ON       # Also hide inline function symbols
)

# Configure include directories with generator expressions.
# BUILD_INTERFACE: paths used when building this project
# INSTALL_INTERFACE: paths used when this library is installed and consumed
target_include_directories(${PROJECT_NAME} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>       # Public headers
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/generated>     # Generated headers
    $<INSTALL_INTERFACE:include>                                  # After installation
)

# When building as a static library, define the STATIC macro so the
# export header knows not to use __declspec(dllexport/dllimport) on Windows
target_compile_definitions(${PROJECT_NAME} PUBLIC
    $<$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>:${PROJECT_NAME}_STATIC>
)

# ============================================================================
# Main Executable
# ============================================================================
# Create a standalone executable that links to our library.
# The output name is set to match the project name (without the _exe suffix).
add_executable(${PROJECT_NAME}_exe src/main.cpp)
target_link_libraries(${PROJECT_NAME}_exe PRIVATE ${PROJECT_NAME})
set_target_properties(${PROJECT_NAME}_exe PROPERTIES OUTPUT_NAME ${PROJECT_NAME})

# ============================================================================
# Optional Subdirectories
# ============================================================================
# Each subdirectory is conditionally included based on build options.
# This keeps build times fast when you only need specific components.

# Example programs showing how to use the library
if(BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

# Unit tests with Google Test framework
if(BUILD_TESTS)
    enable_testing()       # Enable CTest integration
    add_subdirectory(test)
endif()

# API documentation with Doxygen (only if Doxygen is installed)
# Generate docs with: cmake --build . --target cpp_project_template_docs
find_package(Doxygen)
if(DOXYGEN_FOUND)
    set(DOCS_TARGET_NAME "${PROJECT_NAME}_docs")
    add_subdirectory(docs)
endif()

# Performance benchmarks with Google Benchmark
if(BUILD_BENCHMARKS)
    add_subdirectory(bench)
endif()

# ============================================================================
# Installation Configuration
# ============================================================================
# This section configures how the project is installed on the system.
# After building, run: cmake --install build/ --prefix /usr/local
#
# The installed package can then be used by other CMake projects:
#   find_package(cpp_project_template REQUIRED)
#   target_link_libraries(your_target PRIVATE cpp_project_template::cpp_project_template)

# GNUInstallDirs provides standard installation directory variables
# (CMAKE_INSTALL_BINDIR, CMAKE_INSTALL_LIBDIR, CMAKE_INSTALL_INCLUDEDIR)
include(GNUInstallDirs)

# Install the library and executable
install(TARGETS ${PROJECT_NAME} ${PROJECT_NAME}_exe
    EXPORT ${PROJECT_NAME}Targets
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}     # Executables go to bin/
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}     # Shared libs go to lib/
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}     # Static libs go to lib/
)

# Install public header files (preserving directory structure)
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install the generated configuration header with version info
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/generated/configs/ProjectConfig.h"
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/configs
)

# Install the generated export header for shared library support
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/generated/${PROJECT_NAME}/Export.h"
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
)

# Install CMake targets file so other projects can find_package() us
install(EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# Generate and install package configuration files.
# These files allow other CMake projects to find and use this library
# with find_package(cpp_project_template)
include(CMakePackageConfigHelpers)
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/configs/${PROJECT_NAME}Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# Generate version compatibility file.
# SameMajorVersion means consumers can use any 0.x.y version with this library
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

# Install the CMake config and version files
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)