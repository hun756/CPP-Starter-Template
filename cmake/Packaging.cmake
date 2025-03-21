set(CPACK_PACKAGE_VENDOR "Your Organization")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_DESCRIPTION}")
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")

set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
set(CPACK_GENERATOR "TGZ;ZIP")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Your Name <your.email@example.com>")

if(UNIX AND NOT APPLE)
    set(CPACK_GENERATOR ${CPACK_GENERATOR} DEB)
endif()

if(WIN32)
    set(CPACK_GENERATOR ${CPACK_GENERATOR} NSIS)
    set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
    set(CPACK_NSIS_MODIFY_PATH ON)
endif()

if(APPLE)
    set(CPACK_GENERATOR ${CPACK_GENERATOR} productbuild)
endif()

include(CPack)