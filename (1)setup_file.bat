@echo off
echo ========================================
echo  Project Structure Setup
echo ========================================
echo.

echo Creating directory structure...

REM Create lib structure
if not exist "lib" mkdir lib
if not exist "lib\include" mkdir lib\include
if not exist "lib\src" mkdir lib\src

REM Create main structure  
if not exist "main" mkdir main
if not exist "main\src" mkdir main\src

echo.
echo Moving files to correct locations...

REM Move Engine files to lib
if exist "Engine.h" (
    echo Moving Engine.h to lib\include\
    move /Y "Engine.h" "lib\include\" >nul
)

if exist "Engine.cpp" (
    echo Moving Engine.cpp to lib\src\
    move /Y "Engine.cpp" "lib\src\" >nul
)

REM Move main.cpp to main
if exist "main.cpp" (
    echo Moving main.cpp to main\src\
    move /Y "main.cpp" "main\src\" >nul
)

echo.
echo Creating CMakeLists.txt files...

REM Create lib CMakeLists.txt
if not exist "lib\CMakeLists.txt" (
    echo Creating lib\CMakeLists.txt
    (
        echo # Collect all source and header files
        echo file^(GLOB_RECURSE LIB_SOURCES "src/*.cpp"^)
        echo file^(GLOB_RECURSE LIB_HEADERS "include/*.h"^)
        echo.
        echo # Create static library
        echo add_library^(MyEngineLib STATIC
        echo     ${LIB_SOURCES}
        echo     ${LIB_HEADERS}
        echo ^)
        echo.
        echo # Public include directory
        echo target_include_directories^(MyEngineLib PUBLIC
        echo     ${CMAKE_CURRENT_SOURCE_DIR}/include
        echo ^)
        echo.
        echo # Link OgreNext libraries
        echo if^(TARGET OgreMain^)
        echo     target_link_libraries^(MyEngineLib PUBLIC OgreMain^)
        echo     message^(STATUS "Linked: OgreMain"^)
        echo endif^(^)
        echo.
        echo if^(TARGET OgreHlmsPbs^)
        echo     target_link_libraries^(MyEngineLib PUBLIC OgreHlmsPbs^)
        echo     message^(STATUS "Linked: OgreHlmsPbs"^)
        echo endif^(^)
        echo.
        echo if^(TARGET OgreHlmsUnlit^)
        echo     target_link_libraries^(MyEngineLib PUBLIC OgreHlmsUnlit^)
        echo     message^(STATUS "Linked: OgreHlmsUnlit"^)
        echo endif^(^)
        echo.
        echo # Include OgreNext headers
        echo if^(OGRE_INCLUDE_DIRS^)
        echo     target_include_directories^(MyEngineLib PUBLIC ${OGRE_INCLUDE_DIRS}^)
        echo endif^(^)
        echo.
        echo # Visual Studio organization
        echo source_group^("Header Files" FILES ${LIB_HEADERS}^)
        echo source_group^("Source Files" FILES ${LIB_SOURCES}^)
    ) > "lib\CMakeLists.txt"
)

REM Create main CMakeLists.txt
if not exist "main\CMakeLists.txt" (
    echo Creating main\CMakeLists.txt
    (
        echo # Collect main source files
        echo file^(GLOB_RECURSE MAIN_SOURCES "src/*.cpp"^)
        echo.
        echo # Create executable
        echo add_executable^(MyGame ${MAIN_SOURCES}^)
        echo.
        echo # Link engine library
        echo target_link_libraries^(MyGame PRIVATE MyEngineLib^)
        echo.
        echo # Windows: Copy OgreNext DLLs
        echo if^(WIN32^)
        echo     message^(STATUS "Configuring DLL copy..."^)
        echo     
        echo     # OgreNext components
        echo     set^(OGRE_COMPONENTS
        echo         OgreMain
        echo         OgreHlmsPbs
        echo         OgreHlmsUnlit
        echo         RenderSystem_Direct3D11
        echo     ^)
        echo     
        echo     foreach^(COMPONENT ${OGRE_COMPONENTS}^)
        echo         if^(TARGET ${COMPONENT}^)
        echo             add_custom_command^(TARGET MyGame POST_BUILD
        echo                 COMMAND ${CMAKE_COMMAND} -E copy_if_different
        echo                     $^<TARGET_FILE:${COMPONENT}^>
        echo                     $^<TARGET_FILE_DIR:MyGame^>
        echo             ^)
        echo         endif^(^)
        echo     endforeach^(^)
        echo     
        echo     # Copy all DLLs from bin directory
        echo     get_filename_component^(OGRE_BUILD_DIR "${CMAKE_PREFIX_PATH}" DIRECTORY^)
        echo     get_filename_component^(OGRE_BUILD_DIR "${OGRE_BUILD_DIR}" DIRECTORY^)
        echo     set^(OGRE_BIN_DIR "${OGRE_BUILD_DIR}/bin"^)
        echo     
        echo     if^(EXISTS "${OGRE_BIN_DIR}"^)
        echo         add_custom_command^(TARGET MyGame POST_BUILD
        echo             COMMAND ${CMAKE_COMMAND} -E copy_directory
        echo                 "${OGRE_BIN_DIR}/$^<CONFIG^>"
        echo                 $^<TARGET_FILE_DIR:MyGame^>
        echo         ^)
        echo     endif^(^)
        echo endif^(^)
        echo.
        echo # Set as startup project
        echo set_property^(DIRECTORY ${CMAKE_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT MyGame^)
    ) > "main\CMakeLists.txt"
)

echo.
echo ========================================
echo  Structure Setup Complete!
echo ========================================
echo.
echo Directory structure:
echo   lib/
echo     include/   ^(Engine.h^)
echo     src/       ^(Engine.cpp^)
echo     CMakeLists.txt
echo   main/
echo     src/       ^(main.cpp^)
echo     CMakeLists.txt
echo.
echo You can now run build.bat
echo.
pause