# GitHub Actions - VMware Versions Scraper

This repository includes a GitHub Actions workflow that automatically runs the VMware versions scraper every hour.

## Workflow Details

### File: `.github/workflows/vmware-scraper.yml`

**Schedule:**
- Runs every hour at minute 0 (e.g., 1:00, 2:00, 3:00, etc.)
- Cron expression: `0 * * * *`

**Manual Trigger:**
- Can be manually triggered from the GitHub Actions tab
- Use the "workflow_dispatch" trigger

## What the Workflow Does

1. **Checkout Repository**: Gets the latest code
2. **Setup Python**: Installs Python 3.11
3. **Install Dependencies**: Installs required packages from `requirements.txt`
4. **Run Scraper**: Executes `vmware_tools_scraper.py`
5. **Commit Changes**: Automatically commits updated files:
   - `vmware-versions.json` (version history)
   - `vmware-versions-display.html` (dashboard)

## Files Updated

The workflow updates these files with the latest VMware version information:

- **`vmware-versions.json`**: Historical version data for all VMware products
- **`vmware-versions-display.html`**: Updated dashboard with latest versions

## Products Monitored

The scraper checks for updates to:

- **VMware Tools**: Latest version and build numbers
- **ESXi**: ESX 9.0, ESXi 8.0, and ESXi 7.0 versions
- **vCenter Server**: vCenter 9.0, 8.0, and 7.0 versions

## Setup Instructions

1. **Enable GitHub Actions**: Ensure Actions are enabled in your repository settings
2. **Push the Workflow**: The workflow file should be in `.github/workflows/`
3. **Monitor**: Check the Actions tab to see scheduled runs

## Manual Execution

To run the scraper manually:

1. Go to the **Actions** tab in your GitHub repository
2. Select **"VMware Versions Scraper"** workflow
3. Click **"Run workflow"** button
4. Choose the branch and click **"Run workflow"**

## Monitoring

- **Success**: New commits will be created with updated version data
- **Failure**: Check the Actions logs for any errors
- **History**: View all runs in the Actions tab

## Data Sources

The scraper pulls data from official Broadcom knowledge base articles:

- VMware Tools: [https://knowledge.broadcom.com/external/article/304809/build-numbers-and-versions-of-vmware-too.html](https://knowledge.broadcom.com/external/article/304809/build-numbers-and-versions-of-vmware-too.html)
- ESXi Versions: [https://knowledge.broadcom.com/external/article?legacyId=2143832](https://knowledge.broadcom.com/external/article?legacyId=2143832)
- vCenter Versions: [https://knowledge.broadcom.com/external/article?articleNumber=326316](https://knowledge.broadcom.com/external/article?articleNumber=326316)

## Dashboard Access

After each run, the updated dashboard is available at:
- `vmware-versions-display.html` in the repository
- Can be viewed directly in a web browser

## Troubleshooting

**Common Issues:**
- **Dependencies**: Ensure `requirements.txt` is up to date
- **Permissions**: Repository needs write permissions for the workflow
- **Rate Limiting**: GitHub Actions has usage limits for free accounts

**Debugging:**
- Check the Actions logs for detailed error messages
- Verify the scraper works locally before pushing to GitHub
- Monitor the generated files for expected updates 