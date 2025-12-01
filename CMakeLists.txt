cmake_minimum_required(VERSION 3.14)
project(MyOgreNextProject)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Afficher les chemins de recherche pour debug
message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
message(STATUS "OGRE_DIR: ${OGRE_DIR}")

# Trouver OgreNext (le nom du package peut être OGRE ou OGRE-Next)
find_package(OGRE QUIET CONFIG)

if(NOT OGRE_FOUND)
    message(STATUS "Package OGRE non trouvé, recherche de OGRE-Next...")
    find_package(OGRE-Next CONFIG)
endif()

if(NOT OGRE_FOUND)
    message(FATAL_ERROR 
        "OgreNext non trouvé!\n"
        "Vérifie que:\n"
        "1. OgreNext a été compilé (external/ogre-next/build/)\n"
        "2. CMAKE_PREFIX_PATH ou OGRE_DIR pointe vers le bon dossier\n"
        "3. Le fichier OGREConfig.cmake existe\n"
        "\n"
        "Chemins actuels:\n"
        "  CMAKE_PREFIX_PATH = ${CMAKE_PREFIX_PATH}\n"
        "  OGRE_DIR = ${OGRE_DIR}\n"
    )
endif()

message(STATUS "OgreNext trouvé: ${OGRE_CONFIG}")
message(STATUS "Composants OGRE disponibles: ${OGRE_COMPONENTS}")

# Ajoute les sous-projets
add_subdirectory(lib)
add_subdirectory(main)