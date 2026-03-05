# ============================================================================
# Code Coverage Module
# ============================================================================
#
# This module adds code coverage instrumentation to your build.
# When enabled, your tests will generate coverage data that shows
# which lines of code were executed during testing.
#
# Supported backends (automatically detected):
#   1. lcov + genhtml  → Preferred, generates beautiful HTML reports
#   2. gcovr           → Alternative, also generates HTML reports
#
# Prerequisites:
#   - GCC or Clang compiler (coverage not supported on MSVC)
#   - Install lcov:  sudo apt install lcov    (Ubuntu/Debian)
#   - Or gcovr:      pip install gcovr
#
# Usage:
#   cmake --preset coverage            # Configure with coverage enabled
#   cmake --build --preset coverage    # Build with instrumentation
#   ctest --preset coverage            # Run tests to collect data
#   cmake --build --preset coverage --target coverage   # Generate report
#
# The HTML report will be at: build/coverage/coverage_report/index.html
#
# Custom targets:
#   coverage       → Generate HTML report after running tests
#   coverage_clean → Reset all coverage counters to start fresh
#
# ============================================================================

option(ENABLE_COVERAGE "Enable code coverage instrumentation" OFF)

if(ENABLE_COVERAGE)
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        # These flags tell the compiler to instrument the code for coverage tracking.
        # --coverage       : Enable coverage instrumentation (shorthand for -fprofile-arcs -ftest-coverage)
        # -fprofile-arcs   : Generate arc-based code coverage data
        # -ftest-coverage  : Generate .gcno files with source coverage info
        # -fno-inline      : Disable inlining so coverage data maps accurately to source
        set(COVERAGE_COMPILE_FLAGS --coverage -fprofile-arcs -ftest-coverage -fno-inline)
        set(COVERAGE_LINK_FLAGS --coverage)

        # Create an INTERFACE library so any target can simply link to this
        # instead of manually adding flags everywhere
        add_library(coverage_options INTERFACE)
        target_compile_options(coverage_options INTERFACE ${COVERAGE_COMPILE_FLAGS})
        target_link_options(coverage_options INTERFACE ${COVERAGE_LINK_FLAGS})

        # Look for available coverage report generators
        find_program(LCOV lcov)
        find_program(GENHTML genhtml)
        find_program(GCOVR gcovr)

        if(LCOV AND GENHTML)
            # ── lcov backend (preferred) ──────────────────────────────
            # Step 1: Capture coverage data from the build directory
            # Step 2: Filter out test/bench/dependency code (we only care about src/ and include/)
            # Step 3: Generate an HTML report with branch coverage
            add_custom_target(coverage
                COMMAND ${LCOV} --capture
                    --directory ${CMAKE_BINARY_DIR}
                    --output-file ${CMAKE_BINARY_DIR}/coverage.info
                    --rc lcov_branch_coverage=1
                COMMAND ${LCOV} --remove ${CMAKE_BINARY_DIR}/coverage.info
                    "*/test/*"       # Exclude test code
                    "*/bench/*"      # Exclude benchmark code
                    "*/examples/*"   # Exclude example code
                    "*/_deps/*"      # Exclude FetchContent dependencies
                    "*/usr/*"        # Exclude system headers
                    --output-file ${CMAKE_BINARY_DIR}/coverage_filtered.info
                    --rc lcov_branch_coverage=1
                COMMAND ${GENHTML} ${CMAKE_BINARY_DIR}/coverage_filtered.info
                    --branch-coverage
                    --output-directory ${CMAKE_BINARY_DIR}/coverage_report
                    --title "${PROJECT_NAME} Coverage Report"
                    --legend
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMENT "Generating code coverage report with lcov..."
                VERBATIM
            )

            # Convenience target to reset coverage counters without rebuilding
            add_custom_target(coverage_clean
                COMMAND ${LCOV} --directory ${CMAKE_BINARY_DIR} --zerocounters
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMENT "Clearing coverage counters..."
                VERBATIM
            )
        elseif(GCOVR)
            # ── gcovr backend (alternative) ───────────────────────────
            add_custom_target(coverage
                COMMAND ${GCOVR}
                    --root ${CMAKE_SOURCE_DIR}
                    --filter ${CMAKE_SOURCE_DIR}/src/
                    --filter ${CMAKE_SOURCE_DIR}/include/
                    --exclude ".*test.*"
                    --exclude ".*bench.*"
                    --exclude ".*example.*"
                    --html --html-details
                    --output ${CMAKE_BINARY_DIR}/coverage_report/index.html
                    --branches
                    --sort-percentage
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMENT "Generating code coverage report with gcovr..."
                VERBATIM
            )
        else()
            message(WARNING "Code coverage enabled but neither lcov+genhtml nor gcovr found. "
                "Install lcov or gcovr for coverage report generation.\n"
                "  Ubuntu/Debian: sudo apt install lcov\n"
                "  pip:           pip install gcovr")
        endif()
    elseif(MSVC)
        message(WARNING "Code coverage with MSVC requires external tools (e.g., OpenCppCoverage). "
            "Use --preset coverage on Linux/macOS for built-in support.")
    else()
        message(WARNING "Code coverage is not supported with '${CMAKE_CXX_COMPILER_ID}' compiler.")
    endif()
endif()

# ============================================================================
# Helper Function
# ============================================================================
# Call this on any target to add coverage instrumentation:
#   target_enable_coverage(my_target)
#
# Does nothing if ENABLE_COVERAGE is OFF, so it's safe to call unconditionally.
function(target_enable_coverage target)
    if(ENABLE_COVERAGE AND TARGET coverage_options)
        target_link_libraries(${target} PRIVATE coverage_options)
    endif()
endfunction()
