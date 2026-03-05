# ============================================================================
# Test Configuration
# ============================================================================
# This file builds all unit tests using Google Test framework.
#
# How it works:
# 1. Downloads Google Test automatically via FetchContent (see Dependencies.cmake)
# 2. Finds all .cpp files in this directory — each one becomes a test executable
# 3. Links each test to GTest, GMock, and our main project library
# 4. Registers tests with CTest for `ctest` command support
#
# Adding a new test:
#   Simply create a new .cpp file in this directory (e.g., MyFeatureTest.cpp)
#   and it will be automatically picked up on the next cmake configure.
#
# Running tests:
#   ctest --preset debug                    # Run all tests
#   ctest --preset debug -R "ModuleA"       # Run only ModuleA tests
#   ctest --preset debug --output-on-failure  # Show output for failed tests
#   ./build/debug/bin/ModuleATest           # Run a specific test directly
# ============================================================================

# Load Google Test via our unified dependency manager
# This will download GTest if not already available, or use a system-installed version
include(${CMAKE_SOURCE_DIR}/cmake/Dependencies.cmake)
setup_googletest()

# GoogleTest module provides gtest_discover_tests() which is superior to
# plain add_test() — it automatically discovers individual test cases
include(GoogleTest)

# Automatically find all test source files in this directory.
# CONFIGURE_DEPENDS ensures CMake re-runs when you add/remove test files.
file(GLOB TEST_SOURCES CONFIGURE_DEPENDS "*.cpp")

# Build each test file as a separate executable
foreach(test_source ${TEST_SOURCES})
    # Extract filename without extension to use as the test target name
    # e.g., "ModuleATest.cpp" → "ModuleATest"
    get_filename_component(test_name ${test_source} NAME_WE)

    # Create an executable for this test
    add_executable(${test_name} ${test_source})

    # Link necessary libraries:
    # - GTest::gtest       → Core Google Test framework
    # - GTest::gtest_main  → Provides main() so you don't have to write one
    # - GTest::gmock       → Google Mock for creating mock objects
    # - ${PROJECT_NAME}    → Our main library (the code being tested)
    target_link_libraries(${test_name}
        PRIVATE
        GTest::gtest
        GTest::gtest_main
        GTest::gmock
        ${PROJECT_NAME}::${PROJECT_NAME}
    )

    # Apply the same strict compiler warnings as the main library
    target_compile_warnings(${test_name} PRIVATE)

    # Enable sanitizers for tests too — this is where runtime errors
    # are most likely to be caught (ASan, UBSan, etc.)
    if(ENABLE_SANITIZERS)
        target_enable_sanitizers(${test_name})
    endif()

    # Enable code coverage instrumentation for this test.
    # Coverage data from test runs shows which source lines are exercised.
    target_enable_coverage(${test_name})

    # Register test cases with CTest using Google Test's discovery mechanism.
    # This automatically finds all TEST() and TEST_F() macros and registers
    # them individually, so you can run specific tests by name.
    gtest_discover_tests(${test_name}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        PROPERTIES
            TIMEOUT 30       # Kill test if it takes longer than 30 seconds
            LABELS "unit"    # Label for filtering: ctest -L unit
    )
endforeach()