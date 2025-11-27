cmake_minimum_required(VERSION 3.14)
project(MyOgreProject)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Télécharge et compile Ogre
include(FetchContent)

FetchContent_Declare(
    OGRE
    GIT_REPOSITORY https://github.com/OGRECave/ogre.git
    GIT_TAG v14.2.5
    GIT_SHALLOW TRUE
)

# Options Ogre
set(OGRE_BUILD_SAMPLES OFF CACHE BOOL "" FORCE)
set(OGRE_BUILD_TOOLS OFF CACHE BOOL "" FORCE)
set(OGRE_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(OGRE_BUILD_RENDERSYSTEM_D3D9 OFF CACHE BOOL "" FORCE)
set(OGRE_BUILD_RENDERSYSTEM_D3D11 ON CACHE BOOL "" FORCE)
set(OGRE_BUILD_RENDERSYSTEM_GL ON CACHE BOOL "" FORCE)
set(OGRE_BUILD_COMPONENT_OVERLAY ON CACHE BOOL "" FORCE)

message(STATUS "Téléchargement et configuration d'Ogre...")
FetchContent_MakeAvailable(OGRE)

# Ajoute les sous-projets
add_subdirectory(lib)
add_subdirectory(main)