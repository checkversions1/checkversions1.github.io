@echo off
echo VMware Tools Version Scraper
echo ===========================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python 3.7 or higher from https://python.org
    pause
    exit /b 1
)

REM Install dependencies if needed
echo Installing dependencies...
pip install -r requirements.txt >nul 2>&1

REM Run the scraper
echo.
echo Running VMware Tools version scraper...
python vmware_tools_scraper.py

REM Check if script ran successfully
if errorlevel 1 (
    echo.
    echo Error: Script failed to run properly
    pause
    exit /b 1
) else (
    echo.
    echo Script completed successfully!
    echo.
    echo Generated files:
    echo - vmware-tools-versions.json (version history)
    echo - vmware-tools-display.html (web display)
    echo.
    echo You can open vmware-tools-display.html in your browser to view the results.
    echo.
    pause
) 