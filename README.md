# VMware Tools Version Tracker

This repository automatically tracks and displays the latest VMware Tools versions. The information is updated every 4 hours using GitHub Actions and displayed using GitHub Pages.

## Features

- Automatically fetches latest VMware Tools version information every 4 hours
- Displays the most recent version in a clean, modern web interface
- Maintains version history in JSON format
- Hosted on GitHub Pages for easy access

## Setup

1. Enable GitHub Pages in your repository settings:
   - Go to Settings > Pages
   - Set Source to "GitHub Actions"

2. The site will be available at: `https://<username>.github.io/<repository-name>/`

## Local Development

To run the website locally:

```powershell
cd versions
python server.py
# or
node server.js
```

Then visit `http://localhost:8000` in your browser.

## Automatic Updates

The version information is automatically updated every 4 hours using GitHub Actions. You can also trigger an update manually by:
1. Going to the Actions tab
2. Selecting "Update VMware Tools Versions"
3. Clicking "Run workflow"

## Data

The version information is stored in `vmware-tools-versions.json` and is automatically updated by the GitHub Action workflow. 