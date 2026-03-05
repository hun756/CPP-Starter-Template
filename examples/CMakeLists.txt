# ============================================================================
# Example Applications
# ============================================================================
# This file builds all example programs that demonstrate how to use your library.
# Each example is built as a standalone executable linked to the main library.
#
# Adding a new example:
#   Simply create a new .cpp file in this directory (e.g., advanced_usage.cpp)
#   and it will be automatically built as an executable named "advanced_usage".
#   No need to modify this CMakeLists.txt file.
#
# Running examples:
#   ./build/debug/bin/example1
#   ./build/debug/bin/example2
# ============================================================================

# Find all example source files in this directory.
# CONFIGURE_DEPENDS ensures CMake re-runs when you add/remove example files,
# so you never have to manually update this file.
file(GLOB EXAMPLE_SOURCES CONFIGURE_DEPENDS "*.cpp")

# Build each example file as a separate executable
foreach(example_source ${EXAMPLE_SOURCES})
    # Extract filename without extension to use as the executable name
    # e.g., "example1.cpp" → "example1"
    get_filename_component(example_name ${example_source} NAME_WE)

    # Create an executable for this example
    add_executable(${example_name} ${example_source})

    # Link to our project library.
    # PRIVATE means these dependencies are only for building this example,
    # not for anything that might link to it (which is unlikely for examples).
    # The :: syntax uses the ALIAS target, which works the same way
    # as if you had used find_package() to find this library.
    target_link_libraries(${example_name}
        PRIVATE
        ${PROJECT_NAME}::${PROJECT_NAME}
    )

    # Apply the same strict compiler warnings for consistent code quality
    target_compile_warnings(${example_name} PRIVATE)

    # Enable sanitizers for examples too — good practice to catch issues
    # in example code before users copy it into their own projects
    if(ENABLE_SANITIZERS)
        target_enable_sanitizers(${example_name})
    endif()

    # You can add example-specific settings here, such as:
    # - target_compile_definitions(${example_name} PRIVATE MY_DEFINE=1)
    # - target_include_directories(${example_name} PRIVATE extra/path)
    # - target_link_libraries(${example_name} PRIVATE some_other_lib)
endforeach()