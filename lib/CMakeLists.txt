# Collect all source and header files
file(GLOB_RECURSE LIB_SOURCES "src/*.cpp")
file(GLOB_RECURSE LIB_HEADERS "include/*.h")

# If no src/ folder structure, use root
if(NOT LIB_SOURCES)
    file(GLOB LIB_SOURCES "*.cpp")
endif()

if(NOT LIB_HEADERS)
    file(GLOB LIB_HEADERS "*.h")
endif()

# Create static library
add_library(MyEngineLib STATIC
    ${LIB_SOURCES}
    ${LIB_HEADERS}
)

# Public include directory
target_include_directories(MyEngineLib PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}  # For flat structure
)

# Link OgreNext libraries
# OgreNext uses modern CMake targets
if(TARGET OgreMain)
    target_link_libraries(MyEngineLib PUBLIC OgreMain)
    message(STATUS "Linked: OgreMain")
endif()

if(TARGET OgreHlmsPbs)
    target_link_libraries(MyEngineLib PUBLIC OgreHlmsPbs)
    message(STATUS "Linked: OgreHlmsPbs")
endif()

if(TARGET OgreHlmsUnlit)
    target_link_libraries(MyEngineLib PUBLIC OgreHlmsUnlit)
    message(STATUS "Linked: OgreHlmsUnlit")
endif()

if(TARGET OgreOverlay)
    target_link_libraries(MyEngineLib PUBLIC OgreOverlay)
    message(STATUS "Linked: OgreOverlay")
endif()

# Fallback: use OGRE_LIBRARIES if targets not available
if(NOT TARGET OgreMain AND OGRE_LIBRARIES)
    target_link_libraries(MyEngineLib PUBLIC ${OGRE_LIBRARIES})
    message(STATUS "Linked: ${OGRE_LIBRARIES}")
endif()

# Include OgreNext headers
if(OGRE_INCLUDE_DIRS)
    target_include_directories(MyEngineLib PUBLIC ${OGRE_INCLUDE_DIRS})
    message(STATUS "OgreNext includes: ${OGRE_INCLUDE_DIRS}")
endif()

# Visual Studio source organization
source_group("Header Files" FILES ${LIB_HEADERS})
source_group("Source Files" FILES ${LIB_SOURCES})

message(STATUS "MyEngineLib configured with ${LIB_SOURCES}")