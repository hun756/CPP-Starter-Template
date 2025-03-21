include(${CMAKE_SOURCE_DIR}/cmake/FindGTest.cmake)
include(GoogleTest)

file(GLOB TEST_SOURCES "*.cpp")

foreach(test_source ${TEST_SOURCES})
    get_filename_component(test_name ${test_source} NAME_WE)
    add_executable(${test_name} ${test_source})
    target_link_libraries(${test_name}
        PRIVATE
        GTest::gtest
        GTest::gtest_main
        ${PROJECT_NAME}::${PROJECT_NAME}
    )
    
    target_compile_warnings(${test_name} PRIVATE)

    if(ENABLE_SANITIZERS)
        target_enable_sanitizers(${test_name})
    endif()
    
    if(ENABLE_COVERAGE)
        target_compile_options(${test_name} PRIVATE --coverage)
        target_link_libraries(${test_name} PRIVATE --coverage)
    endif()
    
    add_test(NAME ${test_name} COMMAND ${test_name})
    set_tests_properties(${test_name} PROPERTIES TIMEOUT 10)
endforeach()