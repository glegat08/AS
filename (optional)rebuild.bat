@echo off
echo ========================================
echo  Quick Rebuild - Your Project Only
echo ========================================
echo.

if not exist "build" (
    echo [ERROR] Build directory does not exist
    echo Run build.bat first to create it
    pause
    exit /b 1
)

cd build

echo [1/3] Reconfiguring CMake to detect new files...
cmake ..
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] CMake reconfiguration failed
    cd ..
    pause
    exit /b 1
)

echo.
echo [2/3] Rebuilding Debug version...
cmake --build . --config Debug --parallel 4

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Debug build failed
    cd ..
    pause
    exit /b 1
)

echo.
echo [OK] Debug build successful
echo.

echo [3/3] Checking for Release build...
if exist "main\Release" (
    echo Release directory exists, rebuilding Release too...
    cmake --build . --config Release --parallel 4
    
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Release build successful
    ) else (
        echo [WARNING] Release build failed (not critical)
    )
) else (
    echo No Release build found, skipping
)

cd ..

echo.
echo ========================================
echo  Rebuild Complete!
echo ========================================
echo.
echo Debug executable: build\main\Debug\MyGame.exe
echo.
echo Run with: run.bat
echo.
pause