# Collecte tous les fichiers sources et headers
file(GLOB_RECURSE LIB_SOURCES "src/*.cpp")
file(GLOB_RECURSE LIB_HEADERS "include/*.h")

# Crée une bibliothèque statique
add_library(MyEngineLib STATIC
    ${LIB_SOURCES}
    ${LIB_HEADERS}
)

# Spécifie le dossier include public
target_include_directories(MyEngineLib PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Lie Ogre à ta bibliothèque
target_link_libraries(MyEngineLib PUBLIC 
    OgreMain 
    OgreOverlay
)

# Permet d'accéder aux headers d'Ogre depuis ta lib
target_include_directories(MyEngineLib PUBLIC
    ${OGRE_INCLUDE_DIRS}
)

# Organisation dans Visual Studio (optionnel mais pratique)
source_group("Header Files" FILES ${LIB_HEADERS})
source_group("Source Files" FILES ${LIB_SOURCES})