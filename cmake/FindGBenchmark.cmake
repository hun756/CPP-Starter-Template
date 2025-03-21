include(FetchContent)

FetchContent_Declare(
    googlebenchmark
    GIT_REPOSITORY https://github.com/google/benchmark.git
    GIT_TAG v1.7.1
)

set(FETCHCONTENT_QUIET OFF)

set(BENCHMARK_ENABLE_TESTING OFF CACHE BOOL "Disable benchmark testing" FORCE)
set(BENCHMARK_ENABLE_INSTALL OFF CACHE BOOL "Disable benchmark install" FORCE)
set(BENCHMARK_ENABLE_WERROR OFF CACHE BOOL "Disable treating warnings as errors" FORCE)

FetchContent_MakeAvailable(googlebenchmark)

if(TARGET benchmark)
  if(MSVC)
    target_compile_options(benchmark PRIVATE /W3 /WX-)
    target_compile_options(benchmark_main PRIVATE /W3 /WX-)
  else()
    target_compile_options(benchmark PRIVATE -Wall -Wextra -Wno-error -Wno-invalid-offsetof -Wno-error=invalid-offsetof)
    target_compile_options(benchmark_main PRIVATE -Wall -Wextra -Wno-error -Wno-invalid-offsetof -Wno-error=invalid-offsetof)
  endif()
endif()