file(GLOB EXAMPLE_SOURCES "*.cpp")

foreach(example_source ${EXAMPLE_SOURCES})
    get_filename_component(example_name ${example_source} NAME_WE)
    
    add_executable(${example_name} ${example_source})
    
    target_link_libraries(${example_name} 
        PRIVATE 
        ${PROJECT_NAME}
    )
endforeach()