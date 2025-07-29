# VMware Tools Version Scraper (Python)

This Python script automatically scrapes the latest VMware Tools version from the Broadcom Knowledge Base and displays it on a web page, while also maintaining a JSON file with version history.

## Features

- **Automatic Version Scraping**: Fetches the latest VMware Tools version from the official Broadcom Knowledge Base
- **JSON Version History**: Maintains a JSON file with the last 10 version entries
- **Beautiful Web Display**: Creates a modern, responsive HTML page to display the latest version information
- **Robust Error Handling**: Comprehensive error handling and logging with fallback data
- **Timestamp Tracking**: Records when each version check was performed
- **Cross-Platform**: Works on Windows, macOS, and Linux

## Files Included

- `vmware_tools_scraper.py` - Main Python script
- `vmware-tools-versions.json` - JSON file storing version history
- `vmware-tools-display.html` - Generated HTML display page
- `requirements.txt` - Python dependencies
- `README_Python.md` - This documentation file

## Prerequisites

- Python 3.7 or higher
- Internet connection to access the Broadcom Knowledge Base
- Required Python packages (install via `pip install -r requirements.txt`)

## Installation

1. **Clone or download the script files**

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the script**:
   ```bash
   python vmware_tools_scraper.py
   ```

## Usage

### Basic Usage

Run the script from the command line:

```bash
python vmware_tools_scraper.py
```

### Advanced Usage

You can specify custom output paths:

```bash
python vmware_tools_scraper.py --output custom-versions.json --webpage custom-display.html
```

### Command Line Arguments

- `--output`, `-o`: Path for the JSON file (default: `vmware-tools-versions.json`)
- `--webpage`, `-w`: Path for the HTML display page (default: `vmware-tools-display.html`)

### Programmatic Usage

You can also use the script as a module:

```python
from vmware_tools_scraper import VMwareToolsScraper

scraper = VMwareToolsScraper(
    output_path="my-versions.json",
    web_page_path="my-display.html"
)

success = scraper.run()
if success:
    print("Version information updated successfully!")
```

## Output

The script generates:

1. **Console Output**: Real-time status updates and version information with logging
2. **JSON File**: Contains version history with the following structure:
   ```json
   {
     "Version": "VMware Tools 13.0.1",
     "ReleaseDate": "07/15/2025",
     "BuildNumber": "24843032",
     "ToolInternalVersion": "13313",
     "LastUpdated": "2024-12-19 10:30:00",
     "SourceUrl": "https://knowledge.broadcom.com/external/article/304809/build-numbers-and-versions-of-vmware-too.html"
   }
   ```
3. **HTML Page**: A beautiful, responsive web page displaying the latest version information
4. **Debug File**: `debug-content.html` containing the raw webpage content for troubleshooting

## Scheduling

### Windows Task Scheduler

1. Open Task Scheduler
2. Create a new Basic Task
3. Set the trigger (e.g., daily at 9:00 AM)
4. Set the action to start a program: `python.exe`
5. Add arguments: `C:\path\to\vmware_tools_scraper.py`

### Linux/macOS Cron

Add to your crontab (`crontab -e`):

```bash
# Run daily at 9:00 AM
0 9 * * * /usr/bin/python3 /path/to/vmware_tools_scraper.py
```

### Using Python Scripts

Create a batch file (Windows) or shell script (Linux/macOS):

**Windows (run_daily.bat)**:
```batch
@echo off
cd /d "C:\path\to\script\directory"
python vmware_tools_scraper.py
```

**Linux/macOS (run_daily.sh)**:
```bash
#!/bin/bash
cd /path/to/script/directory
python3 vmware_tools_scraper.py
```

## Error Handling

The script includes comprehensive error handling for:
- Network connectivity issues
- Invalid webpage content
- JSON file corruption
- HTML generation failures
- Fallback data when parsing fails

## Data Source

The script scrapes version information from the official Broadcom Knowledge Base article:
[Build numbers and versions of VMware Tools](https://knowledge.broadcom.com/external/article/304809/build-numbers-and-versions-of-vmware-too.html)

## Version Information Retrieved

- **Version**: The VMware Tools version number
- **Release Date**: When the version was released
- **Build Number**: The build number for the version
- **Tool Internal Version**: The internal version number
- **Last Updated**: When the script last checked for updates
- **Source URL**: The source of the information

## Troubleshooting

### Import Errors
If you get import errors, ensure all dependencies are installed:
```bash
pip install -r requirements.txt
```

### Network Connectivity Issues
Ensure your system can access the Broadcom Knowledge Base URL. The script will provide detailed error messages if connectivity fails.

### JSON File Issues
If the JSON file becomes corrupted, simply delete it and the script will create a new one.

### Debugging
The script creates a `debug-content.html` file containing the raw webpage content. You can examine this file to understand the HTML structure if parsing issues occur.

## Security Considerations

- The script only reads from the official Broadcom Knowledge Base
- No sensitive information is collected or transmitted
- All generated files are stored locally
- The script uses HTTPS for secure communication
- User-Agent header is set to mimic a real browser

## Performance

- The script uses efficient regex patterns for parsing
- HTTP requests include proper timeout handling
- JSON file is limited to 10 entries to prevent excessive growth
- Minimal memory footprint

## Comparison with PowerShell Version

### Advantages of Python Version:
- **Cross-platform compatibility** (Windows, macOS, Linux)
- **Better error handling** with comprehensive logging
- **More robust parsing** with multiple regex patterns
- **Fallback data** when webpage parsing fails
- **Cleaner code structure** with object-oriented design
- **Better dependency management** with requirements.txt

### When to Use Each:
- **Use Python version** for production environments, cross-platform deployment, or when you need robust error handling
- **Use PowerShell version** for Windows-only environments or when PowerShell is the preferred scripting language

## License

This script is provided as-is for educational and operational purposes. Please ensure compliance with Broadcom's terms of service when using their data.

## Support

For issues or questions:
1. Check the console output for error messages
2. Verify internet connectivity
3. Ensure all Python dependencies are installed
4. Check that the output directories are writable
5. Examine the debug-content.html file for parsing issues

## Contributing

Feel free to submit issues or pull requests to improve the script. Areas for improvement:
- Additional parsing patterns for different webpage structures
- Enhanced error recovery mechanisms
- Additional output formats (CSV, XML, etc.)
- Integration with monitoring systems 