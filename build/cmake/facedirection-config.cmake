# facedirection CMake config file
#
# This file sets the following variables:
# facedirection_FOUND - Always TRUE.
# facedirection_INCLUDE_DIRS - Directories containing the facedirection include files.
# facedirection_IDL_DIRS - Directories containing the facedirection IDL files.
# facedirection_LIBRARIES - Libraries needed to use facedirection.
# facedirection_DEFINITIONS - Compiler flags for facedirection.
# facedirection_VERSION - The version of facedirection found.
# facedirection_VERSION_MAJOR - The major version of facedirection found.
# facedirection_VERSION_MINOR - The minor version of facedirection found.
# facedirection_VERSION_REVISION - The revision version of facedirection found.
# facedirection_VERSION_CANDIDATE - The candidate version of facedirection found.

message(STATUS "Found facedirection-1.0.0")
set(facedirection_FOUND TRUE)

find_package(<dependency> REQUIRED)

#set(facedirection_INCLUDE_DIRS
#    "C:/Program Files/facedirection/include/facedirection-1"
#    ${<dependency>_INCLUDE_DIRS}
#    )
#
#set(facedirection_IDL_DIRS
#    "C:/Program Files/facedirection/include/facedirection-1/idl")
set(facedirection_INCLUDE_DIRS
    "C:/Program Files/facedirection/include/"
    ${<dependency>_INCLUDE_DIRS}
    )
set(facedirection_IDL_DIRS
    "C:/Program Files/facedirection/include//idl")


if(WIN32)
    set(facedirection_LIBRARIES
        "C:/Program Files/facedirection/components/lib/facedirection.lib"
        ${<dependency>_LIBRARIES}
        )
else(WIN32)
    set(facedirection_LIBRARIES
        "C:/Program Files/facedirection/components/lib/facedirection.dll"
        ${<dependency>_LIBRARIES}
        )
endif(WIN32)

set(facedirection_DEFINITIONS ${<dependency>_DEFINITIONS})

set(facedirection_VERSION 1.0.0)
set(facedirection_VERSION_MAJOR 1)
set(facedirection_VERSION_MINOR 0)
set(facedirection_VERSION_REVISION 0)
set(facedirection_VERSION_CANDIDATE )

