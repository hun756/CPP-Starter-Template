file(GLOB EXAMPLE_SOURCES "*.cpp")

foreach(example_source ${EXAMPLE_SOURCES})
    get_filename_component(example_name ${example_source} NAME_WE)
    
    add_executable(${example_name} ${example_source})
    
    target_link_libraries(${example_name} 
        PRIVATE 
        ${PROJECT_NAME}::${PROJECT_NAME}
    )
    
    target_compile_warnings(${example_name} PRIVATE)

    if(ENABLE_SANITIZERS)
        target_enable_sanitizers(${example_name})
    endif()
endforeach()