@echo off
setlocal EnableDelayedExpansion

echo ========================================
echo    OgreNext Build System - Debug Mode
echo ========================================
echo.

REM ========================================
REM            Python Detection
REM ========================================
set "PYTHON_CMD="

echo [1/6] Checking for Python...
python --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "PYTHON_CMD=python"
    goto :python_found
)

py --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "PYTHON_CMD=py"
    goto :python_found
)

python3 --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "PYTHON_CMD=python3"
    goto :python_found
)

REM Python not found
echo.
echo [ERROR] Python is not detected in PATH
echo.
echo Checking common installation locations...
set "FOUND_INSTALL=0"

if exist "%LOCALAPPDATA%\Programs\Python\" (
    echo [FOUND] User installation: %LOCALAPPDATA%\Programs\Python\
    set "FOUND_INSTALL=1"
)

if exist "C:\Python3*" (
    echo [FOUND] System installation: C:\Python3*
    set "FOUND_INSTALL=1"
)

if "%FOUND_INSTALL%"=="1" (
    echo.
    echo Python is installed but NOT in PATH!
    echo.
    echo Please add Python to PATH:
    echo 1. Search for "Environment Variables" in Windows
    echo 2. Edit "Path" under User variables
    echo 3. Add Python installation directory
    echo 4. Restart this terminal and try again
    echo.
    pause
    exit /b 1
) else (
    echo.
    echo Python is not installed. Please install it:
    echo 1. Go to: https://www.python.org/downloads/
    echo 2. Download Python 3.12 or higher
    echo 3. IMPORTANT: Check "Add Python to PATH" during installation
    echo 4. Restart this terminal and try again
    echo.
    pause
    exit /b 1
)

:python_found
echo [OK] Python detected: %PYTHON_CMD%
%PYTHON_CMD% --version
echo.

REM ========================================
REM             Directory Setup
REM ========================================
if not exist "external" mkdir external
if not exist "build" mkdir build

REM ========================================
REM          OgreNext Dependencies
REM ========================================
cd external

if not exist "ogre-next-deps" (
    echo [2/6] Cloning ogre-next-deps...
    git clone --recurse-submodules --shallow-submodules https://github.com/OGRECave/ogre-next-deps.git
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to clone dependencies
        cd ..
        pause
        exit /b %ERRORLEVEL%
    )
) else (
    echo [2/6] ogre-next-deps already exists
)

cd ogre-next-deps
if not exist "build" mkdir build
cd build

echo.
echo [3/6] Configuring dependencies...
cmake .. -G "Visual Studio 17 2022" -A x64
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] CMake configuration failed for dependencies
    cd ..\..\..
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [4/6] Building dependencies in Debug (this may take 10-15 minutes)...
cmake --build . --config Debug --parallel 4
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to build dependencies
    cd ..\..\..
    pause
    exit /b %ERRORLEVEL%
)

cmake --build . --target install --config Debug

cd ..\..

REM ========================================
REM              OgreNext
REM ========================================
if not exist "ogre-next" (
    echo.
    echo [5/6] Cloning ogre-next...
    git clone --branch v3.0.0 https://github.com/OGRECave/ogre-next.git
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to clone ogre-next
        cd ..
        pause
        exit /b %ERRORLEVEL%
    )
) else (
    echo [5/6] ogre-next already exists
)

cd ogre-next

REM Copy dependencies
echo Copying dependencies...
xcopy /E /I /Y ..\ogre-next-deps\build\ogredeps Dependencies

if not exist "build" mkdir build
cd build

echo.
echo Configuring OgreNext...
cmake .. -G "Visual Studio 17 2022" -A x64 ^
    -DOGRE_BUILD_SAMPLES2=OFF ^
    -DOGRE_BUILD_TESTS=OFF ^
    -DOGRE_BUILD_COMPONENT_SCENE_FORMAT=ON ^
    -DOGRE_BUILD_COMPONENT_HLMS=ON ^
    -DOGRE_BUILD_RENDERSYSTEM_D3D11=ON ^
    -DOGRE_BUILD_RENDERSYSTEM_VULKAN=OFF

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] CMake configuration failed for OgreNext
    cd ..\..\..\
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo Building OgreNext in Debug (this may take 20-30 minutes)...
cmake --build . --config Debug --parallel 4

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to build OgreNext
    cd ..\..\..
    pause
    exit /b %ERRORLEVEL%
)

REM Install OgreNext files
echo.
echo Installing OgreNext...
cmake --build . --target install --config Debug

REM Verify OGREConfig.cmake exists or create it
echo.
echo Verifying OGREConfig.cmake...
set "OGRE_CONFIG_PATH="

if exist "CMake\OGREConfig.cmake" (
    set "OGRE_CONFIG_PATH=%CD%\CMake"
)
if exist "lib\OGRE-Next\cmake\OGREConfig.cmake" (
    set "OGRE_CONFIG_PATH=%CD%\lib\OGRE-Next\cmake"
)
if exist "sdk\CMake\OGREConfig.cmake" (
    set "OGRE_CONFIG_PATH=%CD%\sdk\CMake"
)

if "%OGRE_CONFIG_PATH%"=="" (
    echo [WARNING] OGREConfig.cmake not found, creating manually...
    if not exist "CMake" mkdir CMake
    
    REM Create basic OGREConfig.cmake
    (
        echo # OGREConfig.cmake - manually generated
        echo set^(OGRE_FOUND TRUE^)
        echo set^(OGRE_VERSION "3.0.0"^)
        echo.
        echo get_filename_component^(OGRE_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH^)
        echo get_filename_component^(OGRE_PREFIX_DIR "${OGRE_CMAKE_DIR}/.." ABSOLUTE^)
        echo.
        echo set^(OGRE_INCLUDE_DIRS
        echo     "${OGRE_PREFIX_DIR}/../Components/Hlms/Common/include"
        echo     "${OGRE_PREFIX_DIR}/../Components/Hlms/Pbs/include"
        echo     "${OGRE_PREFIX_DIR}/../Components/Hlms/Unlit/include"
        echo     "${OGRE_PREFIX_DIR}/../OgreMain/include"
        echo     "${OGRE_PREFIX_DIR}/include"
        echo ^)
        echo.
        echo set^(OGRE_LIBRARY_DIRS "${OGRE_PREFIX_DIR}/lib/Debug"^)
        echo.
        echo if^(NOT TARGET OgreMain^)
        echo     add_library^(OgreMain SHARED IMPORTED^)
        echo     set_target_properties^(OgreMain PROPERTIES
        echo         IMPORTED_LOCATION "${OGRE_PREFIX_DIR}/bin/Debug/OgreMain_d.dll"
        echo         IMPORTED_IMPLIB "${OGRE_PREFIX_DIR}/lib/Debug/OgreMain_d.lib"
        echo         INTERFACE_INCLUDE_DIRECTORIES "${OGRE_INCLUDE_DIRS}"
        echo     ^)
        echo endif^(^)
        echo.
        echo set^(OGRE_LIBRARIES OgreMain^)
    ) > CMake\OGREConfig.cmake
    
    set "OGRE_CONFIG_PATH=%CD%\CMake"
    echo [OK] Created OGREConfig.cmake in: !OGRE_CONFIG_PATH!
) else (
    echo [OK] Found OGREConfig.cmake in: %OGRE_CONFIG_PATH%
)

cd ..\..\..\

REM ========================================
REM             User Project
REM ========================================
echo.
echo ========================================
echo     [6/6] Building User Project
echo ========================================
echo.

cd build

echo Configuring project...
cmake .. -G "Visual Studio 17 2022" -A x64 ^
    -DCMAKE_PREFIX_PATH="%OGRE_CONFIG_PATH%" ^
    -DOGRE_DIR="%OGRE_CONFIG_PATH%"

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] CMake configuration failed for project
    cd ..
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo Building project in Debug...
cmake --build . --config Debug --parallel 4

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to build project
    cd ..
    pause
    exit /b %ERRORLEVEL%
)

REM ========================================
REM              Copy DLLs
REM ========================================
echo.
echo ========================================
echo        Copying OgreNext DLLs
echo ========================================
echo.

set "DLL_SOURCE=..\external\ogre-next\build\bin\Debug"
set "DLL_DEST=main\Debug"

if not exist "%DLL_SOURCE%" (
    echo [WARNING] DLL source not found: %DLL_SOURCE%
    echo Trying alternative location...
    set "DLL_SOURCE=..\external\ogre-next\build\bin\RelWithDebInfo"
)

if exist "%DLL_SOURCE%" (
    if exist "%DLL_DEST%" (
        echo Copying DLLs from: %DLL_SOURCE%
        echo             to: %DLL_DEST%
        echo.
        xcopy /Y /I "%DLL_SOURCE%\*.dll" "%DLL_DEST%\"
        
        if %ERRORLEVEL% EQU 0 (
            echo.
            echo [OK] DLLs copied successfully
            echo.
            echo DLLs copied:
            dir /B "%DLL_DEST%\*.dll"
        ) else (
            echo [WARNING] DLL copy failed
        )
    ) else (
        echo [WARNING] Destination directory not found: %DLL_DEST%
    )
) else (
    echo [WARNING] Could not find OgreNext DLLs
    echo You may need to copy them manually from:
    echo   external\ogre-next\build\bin\Debug
    echo to:
    echo   build\main\Debug
)

cd ..

echo.
echo ========================================
echo            BUILD COMPLETE!
echo ========================================
echo.
echo Executable: build\main\Debug\MyGame.exe
echo.
echo To run the game:
echo   cd build\main\Debug
echo   MyGame.exe
echo.
echo Or simply:
echo   run.bat
echo.
pause