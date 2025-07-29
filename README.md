# VMware by Broadcom Versions Dashboard

A Python script that scrapes the latest VMware product versions from official Broadcom knowledge base articles and displays them in a beautiful web dashboard.

## Features

- **Automated Scraping**: Fetches latest versions from official Broadcom sources
- **Multiple Products**: VMware Tools, ESXi, and vCenter Server versions
- **Beautiful Dashboard**: Modern, responsive web interface
- **Historical Data**: JSON storage with version history
- **GitHub Actions**: Automated hourly updates (see [GitHub Actions Guide](README_GITHUB_ACTIONS.md))

## Products Monitored

- **VMware Tools**: Latest version, release date, build number, and internal version
- **ESXi**: ESX 9.0, ESXi 8.0, and ESXi 7.0 with release names
- **vCenter Server**: vCenter 9.0, 8.0, and 7.0 versions

## Quick Start

### Prerequisites
- Python 3.7 or higher
- Internet connection

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd VMware-versions

# Install dependencies
pip install -r requirements.txt
```

### Usage
```bash
# Run the scraper
python vmware_tools_scraper.py
```

### Output Files
- `vmware-versions.json`: Historical version data
- `vmware-versions-display.html`: Web dashboard
- Debug files: `debug-*.html` for troubleshooting

## GitHub Actions Automation

This repository includes GitHub Actions that automatically run the scraper every hour. See [GitHub Actions Guide](README_GITHUB_ACTIONS.md) for detailed setup instructions.

**Features:**
- ⏰ **Scheduled**: Runs every hour automatically
- 🔄 **Manual Trigger**: Can be run manually from GitHub Actions tab
- 📝 **Auto-Commit**: Automatically commits updated files
- 📊 **Dashboard**: Always up-to-date version information

## Data Sources

All data is sourced from official Broadcom knowledge base articles:

- **VMware Tools**: [Build Numbers and Versions of VMware Tools](https://knowledge.broadcom.com/external/article/304809/build-numbers-and-versions-of-vmware-too.html)
- **ESXi Versions**: [Build Numbers and Versions of VMware ESXi](https://knowledge.broadcom.com/external/article?legacyId=2143832)
- **vCenter Versions**: [VMware vCenter Server Versions and Build Numbers](https://knowledge.broadcom.com/external/article?articleNumber=326316)

## Dashboard Features

- **Modern Design**: Beautiful gradient design with hover effects
- **Responsive**: Works on desktop, tablet, and mobile
- **Real-time Data**: Shows latest versions from official sources
- **Download Links**: Direct links to VMware Tools downloads
- **Release Names**: Complete release information for ESXi and vCenter

## Files Generated

### `vmware-versions.json`
Stores historical version data with timestamps:
```json
{
  "LastUpdated": "2025-07-29 10:14:32",
  "VMwareTools": {
    "Version": "13.0.1",
    "ReleaseDate": "07/15/2025",
    "BuildNumber": "24843032",
    "ToolInternalVersion": "13313"
  },
  "ESXi": {
    "ESX_9_0": { ... },
    "ESXi_8_0": { ... },
    "ESXi_7_0": { ... }
  },
  "vCenter": {
    "vCenter_9_0": { ... },
    "vCenter_8_0": { ... },
    "vCenter_7_0": { ... }
  }
}
```

### `vmware-versions-display.html`
Beautiful web dashboard showing:
- Latest version information for all products
- Release names and dates
- Build numbers
- Download buttons
- Responsive design

## Scheduling

### Local Scheduling

**Windows (Task Scheduler):**
1. Open Task Scheduler
2. Create Basic Task
3. Set trigger to run every hour
4. Action: Start a program
5. Program: `python`
6. Arguments: `vmware_tools_scraper.py`

**Linux/macOS (Cron):**
```bash
# Add to crontab (crontab -e)
0 * * * * cd /path/to/VMware-versions && python vmware_tools_scraper.py
```

### GitHub Actions (Recommended)
See [GitHub Actions Guide](README_GITHUB_ACTIONS.md) for automated hourly updates.

## Troubleshooting

### Common Issues

**Script fails to run:**
- Check Python version: `python --version`
- Install dependencies: `pip install -r requirements.txt`
- Verify internet connection

**No data scraped:**
- Check debug files: `debug-*.html`
- Verify URLs are accessible
- Check for website structure changes

**GitHub Actions fails:**
- Check Actions logs for errors
- Verify repository permissions
- Ensure workflow file is in correct location

### Debug Files

The script generates debug files for troubleshooting:
- `debug-tools-content.html`: VMware Tools page content
- `debug-esxi-content.html`: ESXi versions page content
- `debug-vcenter-content.html`: vCenter versions page content

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the scraper locally
5. Submit a pull request

## License

© 2025 by [www.ivobeerens.nl](https://www.ivobeerens.nl)

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review debug files
3. Check GitHub Actions logs (if using automation)
4. Open an issue on GitHub 