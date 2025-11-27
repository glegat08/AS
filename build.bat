@echo off
echo ========================================
echo  Build Script pour projet Ogre
echo ========================================

REM Crée le dossier build s'il n'existe pas
if not exist build mkdir build
cd build

echo.
echo Configuration avec CMake...
cmake .. -G "Visual Studio 17 2022" -A x64

if %ERRORLEVEL% NEQ 0 (
    echo Erreur lors de la configuration CMake
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo Compilation en mode Release...
cmake --build . --config Release

if %ERRORLEVEL% NEQ 0 (
    echo Erreur lors de la compilation
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ========================================
echo  Build terminé avec succès !
echo  Exécutable: build\Release\MyGame.exe
echo ========================================
pause
```

**Structure du projet :**
```
MonProjet/
├── CMakeLists.txt
├── build.bat
└── src/
    └── main.cpp