@echo off
echo ========================================
echo         Running MyGame (Debug)
echo ========================================
echo.

if not exist "build\main\Debug\MyGame.exe" (
    echo [ERROR] MyGame.exe not found!
    echo.
    echo Have you built the project yet?
    echo Run build.bat first.
    echo.
    pause
    exit /b 1
)

echo Starting MyGame...
echo.

cd build\main\Debug
MyGame.exe

cd ..\..\..

echo.
echo Game closed.
pause
