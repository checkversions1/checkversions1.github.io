#!/bin/bash

echo "VMware Tools Version Scraper"
echo "==========================="
echo

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed or not in PATH"
    echo "Please install Python 3.7 or higher"
    exit 1
fi

# Install dependencies if needed
echo "Installing dependencies..."
pip3 install -r requirements.txt > /dev/null 2>&1

# Run the scraper
echo
echo "Running VMware Tools version scraper..."
python3 vmware_tools_scraper.py

# Check if script ran successfully
if [ $? -eq 0 ]; then
    echo
    echo "Script completed successfully!"
    echo
    echo "Generated files:"
    echo "- vmware-tools-versions.json (version history)"
    echo "- vmware-versions.html (web display)"
    echo
    echo "You can open vmware-versions.html in your browser to view the results."
    echo
else
    echo
    echo "Error: Script failed to run properly"
    exit 1
fi 