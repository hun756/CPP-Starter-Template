#[=======================================================================[
#  DOCUMENTATION MODULE
#
#  This module configures and sets up Doxygen documentation generation.
#  It checks for Doxygen's presence and creates a custom 'docs' target
#  that can be built with: cmake --build . --target docs
#]=======================================================================]

# Ensure Doxygen is available on the system
if(NOT DOXYGEN_FOUND)
    message(FATAL_ERROR "Doxygen is needed to build the documentation.")
endif()

# Configure Doxygen from our template file
set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in)
set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

# Process the template file, replacing any @VAR@ placeholders with CMake variables
configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)

# Create the documentation target, using DOCS_TARGET_NAME if set, otherwise default to 'docs'
if(NOT DEFINED DOCS_TARGET_NAME)
    set(DOCS_TARGET_NAME "docs")
endif()
add_custom_target(${DOCS_TARGET_NAME}
    COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating API documentation with Doxygen"
    VERBATIM
)