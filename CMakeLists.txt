cmake_minimum_required(VERSION 3.14)
project(MyGame)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Afficher les chemins de recherche pour debug
message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
message(STATUS "OGRE_DIR: ${OGRE_DIR}")

# Trouver OgreNext (le nom du package peut être OGRE ou OGRE-Next)
find_package(OGRE QUIET CONFIG)

if(NOT OGRE_FOUND)
    message(STATUS "Ogre package not found, searching OGRE-Next...")
    find_package(OGRE-Next CONFIG)
endif()

if(NOT OGRE_FOUND)
    message(FATAL_ERROR 
        "OgreNext not found!\n"
        "Verify:\n"
        "1. OgreNext has been compiled (external/ogre-next/build/)\n"
        "2. CMAKE_PREFIX_PATH or OGRE_DIR seeking the right folder\n"
        "3. OGREConfig.cmake exist\n"
        "\n"
        "Actual paths:\n"
        "  CMAKE_PREFIX_PATH = ${CMAKE_PREFIX_PATH}\n"
        "  OGRE_DIR = ${OGRE_DIR}\n"
    )
endif()

message(STATUS "OgreNext found: ${OGRE_CONFIG}")
message(STATUS "Available OGRE components: ${OGRE_COMPONENTS}")

# Ajoute les sous-projets
add_subdirectory(lib)
add_subdirectory(main)