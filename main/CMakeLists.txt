# Collecte les fichiers sources du main
file(GLOB_RECURSE MAIN_SOURCES "src/*.cpp")

# Crée l'exécutable
add_executable(MyGame
    ${MAIN_SOURCES}
)

# Lie ton moteur (qui inclut déjà Ogre)
target_link_libraries(MyGame PRIVATE 
    MyEngineLib
)

# Copie les DLLs nécessaires (Windows)
if(WIN32)
    add_custom_command(TARGET MyGame POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:OgreMain>
        $<TARGET_FILE_DIR:MyGame>
    )
    
    # Si tu as d'autres composants Ogre, ajoute-les ici
    add_custom_command(TARGET MyGame POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:OgreOverlay>
        $<TARGET_FILE_DIR:MyGame>
    )
endif()

# Définit le projet de démarrage pour Visual Studio
set_property(DIRECTORY ${CMAKE_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT MyGame)