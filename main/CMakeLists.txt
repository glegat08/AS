# Collect main source files
file(GLOB_RECURSE MAIN_SOURCES "src/*.cpp")

# If no src/ folder, use root cpp files
if(NOT MAIN_SOURCES)
    file(GLOB MAIN_SOURCES "*.cpp")
endif()

# Create executable
add_executable(MyGame ${MAIN_SOURCES})

# Link engine library
target_link_libraries(MyGame PRIVATE MyEngineLib)

# Windows: Copy OgreNext DLLs
if(WIN32)
    message(STATUS "Configuring DLL copy for Debug/Release...")
    
    # OgreNext components to copy
    set(OGRE_COMPONENTS
        OgreMain
        OgreHlmsPbs
        OgreHlmsUnlit
        OgreMeshLodGenerator
        OgreOverlay
        RenderSystem_Direct3D11
        RenderSystem_GL3Plus
    )
    
    # Copy DLLs for each component
    foreach(COMPONENT ${OGRE_COMPONENTS})
        if(TARGET ${COMPONENT})
            add_custom_command(TARGET MyGame POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                    $<TARGET_FILE:${COMPONENT}>
                    $<TARGET_FILE_DIR:MyGame>
                COMMENT "Copying ${COMPONENT} DLL"
            )
            message(STATUS "  -> Will copy ${COMPONENT}")
        endif()
    endforeach()
    
    # Find OgreNext build directory
    get_filename_component(OGRE_BUILD_DIR "${CMAKE_PREFIX_PATH}" DIRECTORY)
    get_filename_component(OGRE_BUILD_DIR "${OGRE_BUILD_DIR}" DIRECTORY)
    set(OGRE_BIN_DIR "${OGRE_BUILD_DIR}/bin")
    
    if(EXISTS "${OGRE_BIN_DIR}")
        message(STATUS "OgreNext bin directory: ${OGRE_BIN_DIR}")
        
        # Copy all DLLs from the appropriate config directory
        add_custom_command(TARGET MyGame POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_directory
                "${OGRE_BIN_DIR}/$<CONFIG>"
                $<TARGET_FILE_DIR:MyGame>
            COMMENT "Copying OgreNext DLLs from ${OGRE_BIN_DIR}/$<CONFIG>"
        )
    else()
        message(WARNING "OgreNext bin directory not found: ${OGRE_BIN_DIR}")
        message(WARNING "You may need to manually copy DLLs from:")
        message(WARNING "  external/ogre-next/build/bin/Debug or Release")
        message(WARNING "to:")
        message(WARNING "  build/main/Debug or Release")
    endif()
endif()

# Set as startup project in Visual Studio
set_property(DIRECTORY ${CMAKE_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT MyGame)

message(STATUS "MyGame executable configured")