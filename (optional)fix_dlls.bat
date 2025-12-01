@echo off
echo ========================================
echo  DLL Diagnostic and Fix - Debug Mode
echo ========================================
echo.

set "OGRE_BIN=external\ogre-next\build\bin\Debug"
set "GAME_DIR=build\main\Debug"

echo [1/5] Checking if game executable exists...
if not exist "%GAME_DIR%\MyGame.exe" (
    echo [ERROR] MyGame.exe not found in %GAME_DIR%
    echo Have you run build.bat?
    pause
    exit /b 1
)
echo [OK] MyGame.exe found
echo.

echo [2/5] Checking OgreNext Debug DLLs location...
if not exist "%OGRE_BIN%" (
    echo [ERROR] OgreNext Debug bin folder not found: %OGRE_BIN%
    echo.
    echo Trying alternative locations...
    
    if exist "external\ogre-next\build\bin\RelWithDebInfo" (
        echo [FOUND] Using RelWithDebInfo instead
        set "OGRE_BIN=external\ogre-next\build\bin\RelWithDebInfo"
    ) else (
        echo [ERROR] No OgreNext binaries found
        echo.
        echo You need to compile OgreNext in Debug:
        echo   cd external\ogre-next\build
        echo   cmake --build . --config Debug
        echo.
        pause
        exit /b 1
    )
)

echo [OK] OgreNext binaries found in: %OGRE_BIN%
echo.

echo [3/5] Listing available DLLs in OgreNext...
dir /B "%OGRE_BIN%\*.dll" 2>nul | find /C ".dll" > nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] No DLLs found in %OGRE_BIN%
    echo OgreNext compilation probably failed
    pause
    exit /b 1
)

echo Found DLLs:
dir /B "%OGRE_BIN%\*.dll"
echo.

echo [4/5] Checking for RenderSystem_Direct3D11 DLL...
if exist "%OGRE_BIN%\RenderSystem_Direct3D11_d.dll" (
    echo [OK] Found: RenderSystem_Direct3D11_d.dll ^(Debug version^)
) else if exist "%OGRE_BIN%\RenderSystem_Direct3D11.dll" (
    echo [OK] Found: RenderSystem_Direct3D11.dll ^(Release version^)
) else (
    echo [ERROR] RenderSystem_Direct3D11 DLL not found!
    echo.
    echo This means OgreNext didn't compile correctly.
    echo Try rebuilding OgreNext:
    echo   cd external\ogre-next\build
    echo   cmake --build . --config Debug --target RenderSystem_Direct3D11
    echo.
    pause
    exit /b 1
)
echo.

echo [5/5] Copying ALL DLLs to game directory...
echo Source: %OGRE_BIN%
echo Destination: %GAME_DIR%
echo.

xcopy /Y /I "%OGRE_BIN%\*.dll" "%GAME_DIR%\"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo  SUCCESS! DLLs Copied
    echo ========================================
    echo.
    echo DLLs now in game directory:
    dir /B "%GAME_DIR%\*.dll"
    echo.
    echo You can now run: run.bat
    echo.
) else (
    echo.
    echo [ERROR] Copy failed
    echo Check permissions and paths
    echo.
)

echo.
echo ========================================
echo  Additional Diagnostics
echo ========================================
echo.

echo Checking for common missing DLLs...
echo.

REM Check for required OgreNext DLLs
set "REQUIRED_DLLS=OgreMain RenderSystem_Direct3D11 OgreHlmsPbs OgreHlmsUnlit"

for %%D in (%REQUIRED_DLLS%) do (
    if exist "%GAME_DIR%\%%D_d.dll" (
        echo [OK] %%D_d.dll
    ) else if exist "%GAME_DIR%\%%D.dll" (
        echo [OK] %%D.dll
    ) else (
        echo [MISSING] %%D
    )
)

echo.
echo ========================================
echo  Next Steps
echo ========================================
echo.
echo 1. Try running: run.bat
echo 2. If still fails, run: build.bat again
echo 3. Check Ogre.log in the game directory for details
echo.
pause
