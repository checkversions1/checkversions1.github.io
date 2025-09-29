# AI Agents for VMware Version Scraper

This document describes the AI agents available for this VMware version scraper repository and their capabilities.

## Repository Overview

This repository contains a Python-based scraper that automatically fetches the latest VMware product versions from Broadcom's knowledge base and generates both JSON data and HTML dashboard displays.

## Available Agents

### 1. VMware Version Scraper Agent

**Purpose**: Automatically scrape and update VMware product version information

**Capabilities**:
- Scrapes VMware Tools versions from Broadcom knowledge base
- Extracts ESXi versions (ESX 9.0, ESXi 8.0, ESXi 7.0) with release names and availability types
- Fetches vCenter Server versions (9.0, 8.0, 7.0) with release information
- Generates structured JSON output with version details
- Creates modern HTML dashboard for version visualization
- Handles different HTML table structures for each product line
- Robust error handling and logging

**Key Features**:
- **Row-based extraction**: Ensures data consistency by extracting complete table rows
- **Release name mapping**: Correctly maps version numbers to human-readable release names
- **Availability type detection**: Identifies whether products are available as "Patch", "ISO", or "Version"
- **Automatic updates**: Can be run via GitHub Actions or manually
- **Debug output**: Saves HTML content for troubleshooting

**Usage**:
```bash
python3 vmware_tools_scraper.py
```

**Output Files**:
- `vmware-versions.json`: Structured version data
- `vmware-versions.html`: Web dashboard
- `debug-*-content.html`: Debug HTML files for troubleshooting

### 2. Data Validation Agent

**Purpose**: Validate and verify scraped data accuracy

**Capabilities**:
- Validates JSON structure and required fields
- Checks version number formats and consistency
- Verifies release dates are properly formatted
- Ensures build numbers are numeric
- Validates availability types are correct ("Patch", "ISO", "Version")
- Cross-references data with source HTML for accuracy

**Validation Rules**:
- Version numbers must follow VMware naming conventions
- Release dates must be in YYYY/MM/DD or YYYY-MM-DD format
- Build numbers must be numeric
- AvailableAs must be one of: "Patch", "ISO", "Version"
- Release names must be human-readable strings

### 3. HTML Dashboard Generator Agent

**Purpose**: Create modern, responsive web dashboards

**Capabilities**:
- Generates responsive HTML with modern CSS styling
- Creates version cards for each VMware product
- Includes download links and source references
- Mobile-friendly design with responsive grid layout
- Professional styling with gradients and hover effects
- Automatic timestamp display for last updates

**Design Features**:
- Clean, modern interface with card-based layout
- Color-coded sections for different product types
- Responsive design for mobile and desktop
- Professional VMware/Broadcom branding colors
- Interactive elements with hover effects

### 4. Error Handling and Logging Agent

**Purpose**: Comprehensive error handling and logging

**Capabilities**:
- Detailed logging with timestamps and log levels
- Graceful handling of network timeouts and connection errors
- HTML parsing error recovery
- Data extraction failure handling
- Debug information capture
- Progress tracking and status reporting

**Log Levels**:
- INFO: Normal operation and progress updates
- WARNING: Non-critical issues that don't stop execution
- ERROR: Critical failures that prevent data extraction

## Agent Integration

### GitHub Actions Integration

The scraper can be integrated with GitHub Actions for automated updates:

```yaml
name: Update VMware Versions
on:
  schedule:
    - cron: '0 6 * * *'  # Daily at 6 AM UTC
  workflow_dispatch:

jobs:
  update-versions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.9'
      - name: Install dependencies
        run: pip install -r requirements.txt
      - name: Run scraper
        run: python3 vmware_tools_scraper.py
      - name: Commit changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add vmware-versions.json vmware-versions.html
          git commit -m "Update VMware versions" || exit 0
          git push
```

### Manual Execution

For manual updates or testing:

```bash
# Run the scraper
python3 vmware_tools_scraper.py

# Run with custom output files
python3 vmware_tools_scraper.py --output custom-versions.json --webpage custom-dashboard.html
```

## Data Structure

### JSON Output Format

```json
{
  "LastUpdated": "2025-09-29 18:49:04",
  "VMwareTools": {
    "Version": "13.0.5",
    "ReleaseDate": "09/29/2025",
    "BuildNumber": "24843032",
    "ToolInternalVersion": "13314",
    "LastUpdated": "2025-09-29 18:49:04",
    "SourceUrl": "https://knowledge.broadcom.com/external/article/304809/build-numbers-and-versions-of-vmware-too.html"
  },
  "ESXi": {
    "ESX_9_0": {
      "Version": "ESX 9.0.0.0100",
      "ReleaseName": "ESX 9.0.0.0100",
      "ReleaseDate": "2025/07/15",
      "BuildNumber": "24813472",
      "AvailableAs": "Patch"
    },
    "ESXi_8_0": {
      "Version": "ESXi 8.0 P06",
      "ReleaseDate": "2025/07/29",
      "BuildNumber": "24859861",
      "AvailableAs": "Version",
      "ReleaseName": "ESXi 8.0 Update 3g"
    },
    "ESXi_7_0": {
      "Version": "ESXi 7.0.3 EP14",
      "ReleaseName": "ESXi 7.0 Update 3w",
      "ReleaseDate": "2025/07/15",
      "BuildNumber": "24784741",
      "AvailableAs": "Patch"
    }
  },
  "vCenter": {
    "vCenter_9_0": {
      "Version": "9.0.0.0",
      "ReleaseDate": "2025-06-17",
      "BuildNumber": "24755230"
    },
    "vCenter_8_0": {
      "Version": "8.0.3.00600",
      "ReleaseDate": "2025-07-29",
      "BuildNumber": "24853646",
      "ReleaseName": "vCenter Server 8.0 Update 3g"
    },
    "vCenter_7_0": {
      "Version": "7.0.3.02400",
      "ReleaseDate": "2025-05-20",
      "BuildNumber": "24730281",
      "ReleaseName": "vCenter Server 7.0 Update 3v"
    }
  }
}
```

## Troubleshooting

### Common Issues

1. **Network Timeouts**: The scraper includes retry logic and timeout handling
2. **HTML Structure Changes**: Debug HTML files are saved for analysis
3. **Data Extraction Failures**: Comprehensive logging helps identify issues
4. **Version Format Changes**: Flexible regex patterns handle various formats

### Debug Information

- Check `debug-*-content.html` files for raw HTML content
- Review console output for detailed logging
- Verify JSON structure matches expected format
- Test individual URL access for connectivity issues

## Future Enhancements

### Planned Agent Capabilities

1. **Notification Agent**: Send alerts when new versions are detected
2. **Comparison Agent**: Track version changes over time
3. **API Agent**: Provide REST API endpoints for version data
4. **Integration Agent**: Connect with VMware vCenter for version validation
5. **Analytics Agent**: Generate usage statistics and trends

### Potential Integrations

- VMware vRealize Operations Manager
- VMware vCenter Server
- Third-party monitoring tools
- CI/CD pipelines for automated testing
- Documentation generation systems

## Contributing

When contributing to this repository:

1. Test changes with the debug HTML files
2. Verify JSON output structure
3. Check HTML dashboard rendering
4. Update this agents.md file for new capabilities
5. Follow the existing logging and error handling patterns

## Support

For issues or questions:
- Check the debug HTML files for parsing issues
- Review the console logs for detailed error information
- Verify network connectivity to Broadcom knowledge base
- Test with different Python versions if needed

---

*This agents.md file documents the AI agents and capabilities for the VMware Version Scraper repository. Last updated: 2025-09-29*