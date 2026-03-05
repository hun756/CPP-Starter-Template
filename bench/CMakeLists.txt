# ============================================================================
# Benchmark Configuration
# ============================================================================
# This file builds all performance benchmark executables using Google Benchmark.
#
# How it works:
# 1. Downloads Google Benchmark via FetchContent (see Dependencies.cmake)
# 2. Finds all .cpp files in this directory — each becomes a benchmark executable
# 3. Links each benchmark to Google Benchmark and our main project library
# 4. Applies maximum optimization flags regardless of build type
#
# Adding a new benchmark:
#   Create a new .cpp file in this directory (e.g., MyFeatureBench.cpp)
#   and it will be automatically picked up on the next cmake configure.
#
# Running benchmarks:
#   cmake --preset relwithdebinfo && cmake --build --preset relwithdebinfo
#   ./build/relwithdebinfo/bin/StringProcessorBench
#   ./build/relwithdebinfo/bin/CalculatorBench --benchmark_format=json
#
# Useful benchmark flags:
#   --benchmark_filter=<regex>       Run only matching benchmarks
#   --benchmark_format=json|csv      Output format for CI integration
#   --benchmark_repetitions=N        Run each benchmark N times
#   --benchmark_min_time=5           Minimum time per benchmark (seconds)
# ============================================================================

# Load Google Benchmark via our unified dependency manager
include(${CMAKE_SOURCE_DIR}/cmake/Dependencies.cmake)
setup_googlebenchmark()

# Automatically find all benchmark source files
# CONFIGURE_DEPENDS ensures CMake re-runs when you add/remove benchmark files
file(GLOB BENCH_SOURCES CONFIGURE_DEPENDS "*.cpp")

# Build each benchmark file as a separate executable
foreach(bench_source ${BENCH_SOURCES})
    # Extract filename without extension for the target name
    # e.g., "StringProcessorBench.cpp" → "StringProcessorBench"
    get_filename_component(bench_name ${bench_source} NAME_WE)

    add_executable(${bench_name} ${bench_source})

    # Link to our project library and Google Benchmark.
    # benchmark::benchmark_main provides the main() function
    # so you only need to write BENCHMARK() macros in your files.
    target_link_libraries(${bench_name}
        PRIVATE
        ${PROJECT_NAME}::${PROJECT_NAME}
        benchmark::benchmark
        benchmark::benchmark_main
    )

    # Apply compiler warnings for code quality
    target_compile_warnings(${bench_name} PRIVATE)

    # Always use maximum optimization for benchmarks
    # Benchmarking with -O0 gives misleading results!
    if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        target_compile_options(${bench_name} PRIVATE -O3)
    elseif(MSVC)
        target_compile_options(${bench_name} PRIVATE /O2)
    endif()
endforeach()
