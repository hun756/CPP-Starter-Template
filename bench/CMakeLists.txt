include(${CMAKE_SOURCE_DIR}/cmake/FindGBenchmark.cmake)

file(GLOB BENCH_SOURCES "*.cpp")

foreach(bench_source ${BENCH_SOURCES})
    get_filename_component(bench_name ${bench_source} NAME_WE)
    add_executable(${bench_name} ${bench_source})
    target_link_libraries(${bench_name}
        PRIVATE
        ${PROJECT_NAME}
        benchmark::benchmark
    )
    
    if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        target_compile_options(${bench_name} PRIVATE -O3)
    elseif(MSVC)
        target_compile_options(${bench_name} PRIVATE /O2)
    endif()
endforeach()
