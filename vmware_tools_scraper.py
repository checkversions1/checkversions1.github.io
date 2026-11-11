#!/usr/bin/env python3
"""
VMware Tools and ESXi Version Scraper
This script scrapes the latest VMware Tools and ESXi versions from the Broadcom knowledge base
and updates a JSON file with version information.
"""

import requests
import json
import html as html_lib
import re
from datetime import datetime
from pathlib import Path
import sys
from typing import Dict, Optional, List
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class VMwareVersionScraper:
    def __init__(self, output_path: str = "vmware-versions.json", 
                 web_page_path: str = "vmware-versions.html"):
        self.output_path = output_path
        self.web_page_path = web_page_path
        
        # URLs for different VMware products
        self.tools_url = "https://knowledge.broadcom.com/external/article/304809/build-numbers-and-versions-of-vmware-too.html"
        self.esxi_url = "https://knowledge.broadcom.com/external/article?legacyId=2143832"
        self.vcenter_url = "https://knowledge.broadcom.com/external/article?articleNumber=326316"
        

    
    def get_timestamp(self) -> str:
        """Get current timestamp in ISO format."""
        return datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    def scrape_tools_version_info(self) -> Optional[Dict]:
        """
        Scrape the latest VMware Tools version from the Broadcom knowledge base.
        
        Returns:
            Dict containing version information or None if failed
        """
        try:
            logger.info(f"Fetching VMware Tools version information from: {self.tools_url}")
            
            # Make HTTP request
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            }
            response = requests.get(self.tools_url, headers=headers, timeout=30)
            response.raise_for_status()
            
            logger.info("Successfully retrieved VMware Tools webpage content")
            
            # Save debug content
            with open("debug-tools-content.html", "w", encoding="utf-8") as f:
                f.write(response.text)
            logger.info("Saved VMware Tools debug content to debug-tools-content.html")
            
            # Parse the HTML content
            content = response.text
            
            # Extract version information using multiple patterns
            version_info = self._extract_tools_version_data(content)
            
            if version_info:
                version_info.update({
                    "LastUpdated": self.get_timestamp(),
                    "SourceUrl": self.tools_url
                })
                return version_info
            else:
                logger.warning("Could not parse VMware Tools version information from the webpage")
                return None
                
        except requests.RequestException as e:
            logger.error(f"Error fetching VMware Tools version: {e}")
            return None
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return None
    
    def scrape_esxi_version_info(self) -> Optional[Dict]:
        """
        Scrape the latest ESXi versions from the Broadcom knowledge base.
        
        Returns:
            Dict containing ESXi version information or None if failed
        """
        try:
            logger.info(f"Fetching ESXi version information from: {self.esxi_url}")
            
            # Make HTTP request
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            }
            response = requests.get(self.esxi_url, headers=headers, timeout=30)
            response.raise_for_status()
            
            logger.info("Successfully retrieved ESXi webpage content")
            
            # Save debug content
            with open("debug-esxi-content.html", "w", encoding="utf-8") as f:
                f.write(response.text)
            logger.info("Saved ESXi debug content to debug-esxi-content.html")
            
            # Parse the HTML content
            content = response.text
            
            # Extract version information using multiple patterns
            version_info = self._extract_esxi_version_data(content)
            
            if version_info:
                version_info.update({
                    "LastUpdated": self.get_timestamp(),
                    "SourceUrl": self.esxi_url
                })
                return version_info
            else:
                logger.warning("Could not parse ESXi version information from the webpage")
                return None
                
        except requests.RequestException as e:
            logger.error(f"Error fetching ESXi version: {e}")
            return None
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return None
    
    def scrape_vcenter_version_info(self) -> Optional[Dict]:
        """
        Scrape the latest vCenter versions from the Broadcom knowledge base.
        
        Returns:
            Dict containing vCenter version information or None if failed
        """
        try:
            logger.info(f"Fetching vCenter version information from: {self.vcenter_url}")
            
            # Make HTTP request
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            }
            response = requests.get(self.vcenter_url, headers=headers, timeout=30)
            response.raise_for_status()
            
            logger.info("Successfully retrieved vCenter webpage content")
            
            # Save debug content
            with open("debug-vcenter-content.html", "w", encoding="utf-8") as f:
                f.write(response.text)
            logger.info("Saved vCenter debug content to debug-vcenter-content.html")
            
            # Parse the HTML content
            content = response.text
            
            # Extract version information using multiple patterns
            version_info = self._extract_vcenter_version_data(content)
            
            if version_info:
                version_info.update({
                    "LastUpdated": self.get_timestamp(),
                    "SourceUrl": self.vcenter_url
                })
                return version_info
            else:
                logger.warning("Could not parse vCenter version information from the webpage")
                return None
                
        except requests.RequestException as e:
            logger.error(f"Error fetching vCenter version: {e}")
            return None
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return None
    
    def _split_sections(self, content: str) -> Dict[str, str]:
        """
        Split the Broadcom KB article into sections keyed by their <h3> heading text.
        The article uses <h3 id="..."><u>Heading Text</u>...</h3> for each version
        section, followed by the table for that version.

        Returns:
            Dict mapping heading text (e.g. "vCenter 9.0") to the HTML between that
            heading and the next one.
        """
        headings = list(re.finditer(r'<h3[^>]*>(.*?)</h3>', content, re.DOTALL | re.IGNORECASE))
        sections: Dict[str, str] = {}
        for i, heading in enumerate(headings):
            # Headings may include a trailing "back to top" link (e.g. "🔝") after the title text.
            title = re.sub(r'<[^>]+>', '', heading.group(1)).replace('\U0001f51d', '').strip()
            start = heading.end()
            end = headings[i + 1].start() if i + 1 < len(headings) else len(content)
            sections[title] = content[start:end]
        return sections

    def _first_data_row_cells(self, section_html: str) -> Optional[List[str]]:
        """
        Extract the text of each <td> in the first <tr> of the first <tbody> found
        in section_html. If a cell's text is wrapped in an <a> link, the link text
        is used (this is how build numbers/release notes links are formatted).

        Returns:
            List of cell text values, or None if no row could be found.
        """
        tbody_match = re.search(r'<tbody[^>]*>(.*?)</tbody>', section_html, re.DOTALL | re.IGNORECASE)
        body = tbody_match.group(1) if tbody_match else section_html

        row_match = re.search(r'<tr[^>]*>(.*?)</tr>', body, re.DOTALL | re.IGNORECASE)
        if not row_match:
            return None

        cells = []
        for td_match in re.finditer(r'<td[^>]*>(.*?)</td>', row_match.group(1), re.DOTALL | re.IGNORECASE):
            cell_html = td_match.group(1)
            link_match = re.search(r'<a[^>]*>(.*?)</a>', cell_html, re.DOTALL | re.IGNORECASE)
            text = link_match.group(1) if link_match else cell_html
            text = re.sub(r'<[^>]+>', '', text).strip()
            cells.append(text)

        return cells if cells else None

    def _extract_tools_version_data(self, content: str) -> Optional[Dict]:
        """
        Extract VMware Tools version data from HTML content.

        The first table on the page lists the latest versions, with the first
        data row being: Version | Release Date | Build Number | Internal Tools Version.

        Args:
            content: HTML content to parse

        Returns:
            Dict with version information or None if parsing fails
        """
        try:
            table_match = re.search(r'<table[^>]*>.*?</table>', content, re.DOTALL | re.IGNORECASE)
            if not table_match:
                logger.warning("Could not find VMware Tools version table")
                return None

            cells = self._first_data_row_cells(table_match.group(0))
            if not cells or len(cells) < 4:
                logger.warning("Could not parse VMware Tools version information from the webpage")
                return None

            version = re.sub(r'(?i)^VMware Tools\s*', '', cells[0]).strip()
            release_date = cells[1].strip()
            build_number = cells[2].strip()
            tool_internal_version = cells[3].strip()

            logger.info(f"Found VMware Tools version: {version}")
            logger.info(f"Found VMware Tools release date: {release_date}")
            logger.info(f"Found VMware Tools build number: {build_number}")
            logger.info(f"Found VMware Tools internal version: {tool_internal_version}")

            if version:
                return {
                    "Version": version,
                    "ReleaseDate": release_date,
                    "BuildNumber": build_number,
                    "ToolInternalVersion": tool_internal_version
                }

            return None

        except Exception as e:
            logger.error(f"Error parsing VMware Tools version data: {e}")
            return None
    
    def _extract_esxi_version_data(self, content: str) -> Optional[Dict]:
        """
        Extract ESXi version data from HTML content.

        Each version section is a <h3> heading followed by a table whose first
        data row is: Version | Release Name | Release Date | Build Number | Available as.

        Args:
            content: HTML content to parse

        Returns:
            Dict with ESXi version information or None if parsing fails
        """
        try:
            logger.info("Starting ESXi version data extraction")
            sections = self._split_sections(content)
            esxi_versions = {}

            # Heading text -> dict key. All of these sections share the same
            # 5-column table layout.
            targets = {
                "ESX 9.1": "ESX_9_1",
                "ESX 9.0": "ESX_9_0",
                "ESXi 8.0": "ESXi_8_0",
                "ESXi 7.0": "ESXi_7_0",
            }

            for heading, version_key in targets.items():
                section_content = sections.get(heading)
                if not section_content:
                    logger.warning(f"Could not find section for {version_key}")
                    continue

                cells = self._first_data_row_cells(section_content)
                if not cells or len(cells) < 5:
                    logger.warning(f"Could not extract row data for {version_key}")
                    continue

                version, release_name, release_date, build_number, available_as = cells[:5]

                esxi_versions[version_key] = {
                    "Version": version,
                    "ReleaseName": release_name,
                    "ReleaseDate": release_date,
                    "BuildNumber": build_number,
                    "AvailableAs": available_as
                }

                logger.info(f"Found {version_key} version: {version}")
                logger.info(f"Found {version_key} release name: {release_name}")
                logger.info(f"Found {version_key} release date: {release_date}")
                logger.info(f"Found {version_key} build number: {build_number}")
                logger.info(f"Found {version_key} availability: {available_as}")

            return esxi_versions if esxi_versions else None

        except Exception as e:
            logger.error(f"Error parsing ESXi version data: {e}")
            return None
    
    def _extract_vcenter_version_data(self, content: str) -> Optional[Dict]:
        """
        Extract vCenter version data from HTML content.

        vCenter 9.x sections have a 3-column table (Version | Release Date | Build).
        vCenter Server 8.0/7.0 sections have a 5-column table
        (Release name | Version | Release Date | Build/Release Notes | MOB/vpxd.log).

        Args:
            content: HTML content to parse

        Returns:
            Dict with vCenter version information or None if parsing fails
        """
        try:
            sections = self._split_sections(content)
            vcenter_versions = {}

            # Heading text -> (dict key, whether the table has a Release name column first)
            targets = [
                ("vCenter 9.1", "vCenter_9_1", False),
                ("vCenter 9.0", "vCenter_9_0", False),
                ("vCenter Server 8.0", "vCenter_8_0", True),
                ("vCenter Server 7.0", "vCenter_7_0", True),
            ]

            for heading, version_key, has_release_name in targets:
                section_content = sections.get(heading)
                if not section_content:
                    logger.warning(f"Could not find section for {version_key}")
                    continue

                cells = self._first_data_row_cells(section_content)
                if not cells:
                    logger.warning(f"Could not extract row data for {version_key}")
                    continue

                if has_release_name:
                    if len(cells) < 4:
                        logger.warning(f"Could not extract row data for {version_key}")
                        continue
                    release_name, version, release_date, build_number = cells[:4]
                    vcenter_data = {
                        "Version": version,
                        "ReleaseName": release_name,
                        "ReleaseDate": release_date,
                        "BuildNumber": build_number
                    }
                    logger.info(f"Found {version_key} release name: {release_name}")
                else:
                    if len(cells) < 3:
                        logger.warning(f"Could not extract row data for {version_key}")
                        continue
                    version, release_date, build_number = cells[:3]
                    vcenter_data = {
                        "Version": version,
                        "ReleaseDate": release_date,
                        "BuildNumber": build_number
                    }

                vcenter_versions[version_key] = vcenter_data

                logger.info(f"Found {version_key} version: {version}")
                logger.info(f"Found {version_key} release date: {release_date}")
                logger.info(f"Found {version_key} build number: {build_number}")

            return vcenter_versions if vcenter_versions else None

        except Exception as e:
            logger.error(f"Error parsing vCenter version data: {e}")
            return None
    
    def update_json_file(self, tools_info: Dict, esxi_info: Dict, vcenter_info: Dict) -> bool:
        """
        Update the JSON file with new version information.
        
        Args:
            tools_info: Dictionary containing VMware Tools version information
            esxi_info: Dictionary containing ESXi version information
            vcenter_info: Dictionary containing vCenter version information
            
        Returns:
            True if successful, False otherwise
        """
        try:
            # Create the new entry
            new_entry = {
                "LastUpdated": self.get_timestamp(),
                "VMwareTools": tools_info,
                "ESXi": esxi_info,
                "vCenter": vcenter_info
            }
            
            # Write new data to file (overwriting existing content)
            with open(self.output_path, 'w', encoding='utf-8') as f:
                json.dump(new_entry, f, indent=2, ensure_ascii=False)
            
            logger.info(f"Overwrote JSON file: {self.output_path}")
            return True
            
        except Exception as e:
            logger.error(f"Error updating JSON file: {e}")
            return False
    
    @staticmethod
    def _iso_date(value: str) -> str:
        """Normalise the KB date formats (YYYY/MM/DD, YYYY-MM-DD, MM/DD/YYYY) to YYYY-MM-DD."""
        if not value:
            return ""
        for fmt in ("%Y/%m/%d", "%Y-%m-%d", "%m/%d/%Y"):
            try:
                return datetime.strptime(value.strip(), fmt).strftime("%Y-%m-%d")
            except ValueError:
                continue
        return ""

    @staticmethod
    def _pretty_date(iso: str, fallback: str) -> str:
        """Format an ISO date as '12 Oct 2026', or return the raw value if it could not be parsed."""
        if not iso:
            return fallback or "Date not found"
        d = datetime.strptime(iso, "%Y-%m-%d")
        return f"{d.day} {d.strftime('%b %Y')}"

    def _release_cell(self, info: Dict, product_label: str, prefixes: List[str]) -> str:
        """Render one ESX or vCenter cell of the release matrix."""
        esc = html_lib.escape
        if not info or not info.get('Version'):
            return (f'<div class="cell" role="cell"><span class="cell-product">{esc(product_label)}</span>'
                    '<p class="missing">Not found in the Broadcom KB on the last run.</p></div>')

        def strip(text: str) -> str:
            for p in prefixes:
                if text.startswith(p):
                    return text[len(p):]
            return text

        version = strip(info.get('Version', ''))
        release = strip(info.get('ReleaseName', '') or '')
        title, subtitle = (release, version) if release and release != version else (version, '')
        build = info.get('BuildNumber', '')
        iso = self._iso_date(info.get('ReleaseDate', ''))
        available = info.get('AvailableAs', '')

        parts = [f'<div class="cell" role="cell" data-date="{iso}">',
                 f'<span class="cell-product">{esc(product_label)}</span>',
                 '<div class="cell-head">',
                 f'<h3 class="release">{esc(title)}</h3>']
        if available:
            parts.append(f'<span class="kind" title="Available as">{esc(available)}</span>')
        parts.append('</div>')
        if subtitle:
            parts.append(f'<p class="version">{esc(subtitle)}</p>')
        parts.append('<div class="build-row">'
                     f'<span class="build" title="Build number">{esc(build)}</span>'
                     f'<button type="button" class="copy" data-copy="{esc(build)}" '
                     f'aria-label="Copy build {esc(build)}">Copy</button></div>')
        parts.append(f'<p class="date"><time datetime="{iso}">'
                     f'{esc(self._pretty_date(iso, info.get("ReleaseDate", "")))}</time>'
                     '<span class="age"></span></p>')
        parts.append('</div>')
        return "".join(parts)

    def create_html_display(self, tools_info: Dict, esxi_info: Dict, vcenter_info: Dict) -> bool:
        """
        Create an HTML display page with the version information.

        Args:
            tools_info: Dictionary containing VMware Tools version information
            esxi_info: Dictionary containing ESXi version information
            vcenter_info: Dictionary containing vCenter version information

        Returns:
            True if successful, False otherwise
        """
        try:
            esc = html_lib.escape
            last_updated = self.get_timestamp()
            tools = tools_info or {}
            esxi_info = esxi_info or {}
            vcenter_info = vcenter_info or {}

            # Release lines, newest first: (line, ESX key, vCenter key, note)
            lines = [
                ("9.1", "ESX_9_1", "vCenter_9_1", ""),
                ("9.0", "ESX_9_0", "vCenter_9_0", ""),
                ("8.0", "ESXi_8_0", "vCenter_8_0", ""),
                ("7.0", "ESXi_7_0", "vCenter_7_0", "General support ended October 2025"),
            ]

            rows = []
            for line, esx_key, vc_key, note in lines:
                note_html = f'<span class="line-note">{esc(note)}</span>' if note else ''
                rows.append(
                    '<div class="line" role="row">'
                    f'<div class="spine" role="rowheader"><span class="line-no">{line}</span>{note_html}</div>'
                    + self._release_cell(esxi_info.get(esx_key, {}), "ESX / ESXi", ["ESXi ", "ESX "])
                    + self._release_cell(vcenter_info.get(vc_key, {}), "vCenter Server", ["vCenter Server "])
                    + '</div>')

            tools_iso = self._iso_date(tools.get('ReleaseDate', ''))
            tools_build = esc(tools.get('BuildNumber', ''))
            if tools.get('Version'):
                tools_html = f"""
    <div class="tools-body" data-date="{tools_iso}">
      <dl class="tools-facts">
        <div><dt>Version</dt><dd><span class="big">{esc(tools.get('Version', ''))}</span></dd></div>
        <div><dt>Build</dt><dd><span class="big">{tools_build}</span>
          <button type="button" class="copy" data-copy="{tools_build}" aria-label="Copy build {tools_build}">Copy</button></dd></div>
        <div><dt>Internal version</dt><dd>{esc(tools.get('ToolInternalVersion', ''))}</dd></div>
        <div><dt>Released</dt><dd><span><time datetime="{tools_iso}">{esc(self._pretty_date(tools_iso, tools.get('ReleaseDate', '')))}</time><span class="age"></span></span></dd></div>
      </dl>
      <a class="download" href="https://packages-prod.broadcom.com/tools/releases/latest/windows/" target="_blank" rel="noopener">Download for Windows</a>
    </div>"""
            else:
                tools_html = '<div class="tools-body"><p class="missing">Not found in the Broadcom KB on the last run.</p></div>'

            year = datetime.now().year
            html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>VMware Versions</title>
<meta name="description" content="Latest ESX, vCenter Server and VMware Tools builds, read from the Broadcom knowledge base.">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@500;600;700&family=Barlow:wght@400;500;600&display=swap" rel="stylesheet">
<style>{self._DASHBOARD_CSS}</style>
</head>
<body>
<main class="page">
  <header class="masthead">
    <div>
      <h1>VMware versions</h1>
      <p class="lede">The latest ESX, vCenter Server and VMware Tools builds for each release line, read from the Broadcom knowledge base.</p>
    </div>
    <p class="checked">Last checked<br><time datetime="{esc(last_updated.replace(' ', 'T'))}">{esc(last_updated)}</time></p>
  </header>

  <section class="matrix" role="table" aria-label="Latest builds per release line">
    <div class="matrix-head" role="row">
      <span role="columnheader"><span class="sr-only">Release line</span></span>
      <span role="columnheader">ESX / ESXi</span>
      <span role="columnheader">vCenter Server</span>
    </div>
    {''.join(rows)}
  </section>

  <section class="tools" aria-labelledby="tools-title">
    <h2 id="tools-title">VMware Tools</h2>
    {tools_html}
  </section>

  <p class="legend"><span class="dot" aria-hidden="true"></span>Released in the last 30 days</p>

  <footer class="footer">
    <p>Sources: <a href="{esc(self.tools_url)}" target="_blank" rel="noopener">VMware Tools builds</a>,
      <a href="{esc(self.esxi_url)}" target="_blank" rel="noopener">ESX builds</a> and
      <a href="{esc(self.vcenter_url)}" target="_blank" rel="noopener">vCenter Server builds</a> on knowledge.broadcom.com.</p>
    <p>&copy; {year} <a href="https://www.ivobeerens.nl" target="_blank" rel="noopener">www.ivobeerens.nl</a></p>
  </footer>
</main>
<div class="toast" role="status" aria-live="polite"></div>
<script>{self._DASHBOARD_JS}</script>
</body>
</html>
"""
            with open(self.web_page_path, 'w', encoding='utf-8') as f:
                f.write(html_content)

            logger.info(f"Created HTML display page: {self.web_page_path}")
            return True

        except Exception as e:
            logger.error(f"Error creating HTML display: {e}")
            return False

    _DASHBOARD_CSS = """
:root {
  --bg: #E9EEF2; --panel: #FFFFFF; --ink: #14243A; --muted: #56677A;
  --rule: #CFD8E0; --spine: #1D3A5F; --spine-ink: #E4ECF4; --spine-muted: #A9BCCF;
  --new: #C77700; --link: #1F5FA8; --on-link: #FFFFFF; --kind-bg: #E2E9F0;
  color-scheme: light;
}
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    --bg: #0E1A29; --panel: #15243A; --ink: #E3EAF1; --muted: #9AABBD;
    --rule: #263A52; --spine: #0A1320; --spine-ink: #E3EAF1; --spine-muted: #8296AB;
    --new: #F2A900; --link: #84B6EE; --on-link: #0A1320; --kind-bg: #1F3350;
    color-scheme: dark;
  }
}
:root[data-theme="dark"] {
  --bg: #0E1A29; --panel: #15243A; --ink: #E3EAF1; --muted: #9AABBD;
  --rule: #263A52; --spine: #0A1320; --spine-ink: #E3EAF1; --spine-muted: #8296AB;
  --new: #F2A900; --link: #84B6EE; --on-link: #0A1320; --kind-bg: #1F3350;
  color-scheme: dark;
}
* { box-sizing: border-box; margin: 0; padding: 0; }
body {
  background: var(--bg); color: var(--ink);
  font-family: "Barlow", system-ui, sans-serif; font-size: 1rem; line-height: 1.5;
  font-variant-numeric: tabular-nums; -webkit-font-smoothing: antialiased;
}
a { color: var(--link); text-underline-offset: 0.18em; }
a:focus-visible, button:focus-visible { outline: 2px solid var(--link); outline-offset: 2px; border-radius: 2px; }
.sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip: rect(0 0 0 0); white-space: nowrap; }

.page { max-width: 1080px; margin: 0 auto; padding: 56px 24px 40px; }

.masthead { display: flex; justify-content: space-between; align-items: flex-end; gap: 24px; margin-bottom: 36px; }
.masthead h1 {
  font-family: "Barlow Condensed", sans-serif; font-weight: 700;
  font-size: clamp(2.6rem, 6vw, 4rem); line-height: 0.95; letter-spacing: -0.01em;
}
.lede { margin-top: 12px; max-width: 52ch; color: var(--muted); font-size: 1.0625rem; }
.checked { text-align: right; color: var(--muted); font-size: 0.875rem; line-height: 1.35; white-space: nowrap; }
.checked time { color: var(--ink); font-weight: 600; font-size: 1rem; }

/* Release matrix: one row per release line, ESX and vCenter side by side */
.matrix { background: var(--panel); border: 1px solid var(--rule); border-radius: 6px; overflow: hidden; }
.matrix-head, .line { display: grid; grid-template-columns: 148px 1fr 1fr; }
.matrix-head { background: var(--spine); color: var(--spine-muted); font-weight: 500; font-size: 0.9375rem; }
.matrix-head > span { padding: 12px 28px; }
.line + .line { border-top: 1px solid var(--rule); }
.line + .line .spine { box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.08); }

.spine { background: var(--spine); color: var(--spine-ink); padding: 18px 20px 20px 24px; display: flex; flex-direction: column; gap: 6px; }
.line-no {
  font-family: "Barlow Condensed", sans-serif; font-weight: 600;
  font-size: 4.25rem; line-height: 0.9; letter-spacing: -0.02em;
}
.line-note { font-size: 0.8125rem; line-height: 1.3; color: var(--spine-muted); max-width: 13ch; }

.cell { position: relative; padding: 22px 28px; min-width: 0; }
.cell + .cell { border-left: 1px solid var(--rule); }
.cell-product { display: none; color: var(--muted); font-size: 0.875rem; font-weight: 500; margin-bottom: 4px; }
.cell-head { display: flex; align-items: baseline; justify-content: space-between; gap: 12px; }
.release { font-size: 1.1875rem; font-weight: 600; line-height: 1.25; }
.kind { flex: none; font-size: 0.8125rem; font-weight: 500; color: var(--muted); background: var(--kind-bg); padding: 1px 8px; border-radius: 3px; }
.version { color: var(--muted); font-size: 0.9375rem; margin-top: 2px; }
.build-row { display: flex; align-items: baseline; gap: 12px; margin-top: 10px; }
.build, .big {
  font-family: "Barlow Condensed", sans-serif; font-weight: 600;
  font-size: 1.875rem; line-height: 1.05; letter-spacing: 0.01em;
}
.copy {
  font: inherit; font-size: 0.875rem; font-weight: 500; color: var(--link);
  background: none; border: 0; padding: 2px 0; cursor: pointer;
  text-decoration: underline; text-decoration-color: transparent; text-underline-offset: 0.18em;
}
.copy:hover { text-decoration-color: currentColor; }
.date { margin-top: 8px; color: var(--muted); font-size: 0.9375rem; }
.age:not(:empty)::before { content: ", "; }
.is-new::before {
  content: ""; position: absolute; left: 0; top: 24px; width: 4px; height: 28px;
  background: var(--new); border-radius: 0 2px 2px 0;
}
.is-new .age { color: var(--ink); font-weight: 600; }
.missing { color: var(--muted); font-style: italic; }

/* VMware Tools strip */
.tools {
  margin-top: 24px; background: var(--panel); border: 1px solid var(--rule); border-radius: 6px;
  display: grid; grid-template-columns: 148px 1fr; overflow: hidden;
}
.tools h2 {
  background: var(--spine); color: var(--spine-ink); padding: 20px 20px 20px 24px;
  font-family: "Barlow Condensed", sans-serif; font-weight: 600; font-size: 1.625rem; line-height: 1.05;
}
.tools-body { position: relative; padding: 20px 28px; display: flex; align-items: center; justify-content: space-between; gap: 20px 32px; flex-wrap: wrap; }
.tools-facts { display: flex; flex-wrap: wrap; gap: 8px 40px; }
.tools-facts dt { color: var(--muted); font-size: 0.875rem; }
.tools-facts dd { font-weight: 500; font-size: 1.0625rem; display: flex; align-items: baseline; gap: 10px; min-height: 2rem; align-items: flex-end; }
.download {
  flex: none; font-weight: 600; text-decoration: none; color: var(--on-link); background: var(--link);
  padding: 10px 18px; border-radius: 4px;
}
.download:hover { text-decoration: underline; }

.legend { margin-top: 16px; color: var(--muted); font-size: 0.875rem; display: flex; align-items: center; gap: 8px; }
.legend .dot { width: 4px; height: 16px; background: var(--new); border-radius: 1px; }

.footer { margin-top: 40px; padding-top: 18px; border-top: 1px solid var(--rule); color: var(--muted); font-size: 0.875rem; }
.footer p { max-width: 75ch; }
.footer p + p { margin-top: 4px; }

.toast {
  position: fixed; left: 50%; bottom: 24px; transform: translate(-50%, 12px); opacity: 0;
  background: var(--spine); color: var(--spine-ink); padding: 8px 16px; border-radius: 4px; font-weight: 500;
  transition: opacity .18s ease, transform .18s ease; pointer-events: none;
}
.toast.show { opacity: 1; transform: translate(-50%, 0); }

@media (max-width: 760px) {
  .page { padding: 32px 16px; }
  .masthead { flex-direction: column; align-items: flex-start; margin-bottom: 24px; }
  .checked { text-align: left; }
  .matrix-head { display: none; }
  .line { grid-template-columns: 1fr; }
  .spine { flex-direction: row; align-items: baseline; gap: 14px; padding: 10px 16px; }
  .line-no { font-size: 2.75rem; }
  .line-note { max-width: none; }
  .cell { padding: 18px 16px; }
  .cell + .cell { border-left: 0; border-top: 1px solid var(--rule); }
  .cell-product { display: block; }
  .tools { grid-template-columns: 1fr; }
  .tools h2 { padding: 12px 16px; }
  .tools-body { padding: 18px 16px; }
  .tools-facts { gap: 12px 28px; }
}
@media (prefers-reduced-motion: reduce) { .toast { transition: none; } }
"""

    _DASHBOARD_JS = """
(function () {
  var DAY = 86400000, today = new Date(); today.setHours(0, 0, 0, 0);
  document.querySelectorAll('[data-date]').forEach(function (el) {
    var iso = el.getAttribute('data-date'); if (!iso) return;
    var p = iso.split('-'), d = new Date(+p[0], +p[1] - 1, +p[2]);
    var days = Math.round((today - d) / DAY), text;
    if (days < 0) return;
    if (days === 0) text = 'today';
    else if (days === 1) text = 'yesterday';
    else if (days < 60) text = days + ' days ago';
    else if (days < 730) text = Math.round(days / 30.44) + ' months ago';
    else text = Math.floor(days / 365.25) + ' years ago';
    var age = el.querySelector('.age'); if (age) age.textContent = text;
    if (days <= 30) el.classList.add('is-new');
  });
  var toast = document.querySelector('.toast'), timer;
  function show(msg) {
    toast.textContent = msg; toast.classList.add('show');
    clearTimeout(timer); timer = setTimeout(function () { toast.classList.remove('show'); }, 1800);
  }
  var FAIL = 'Copy failed. Select the build number and copy it manually.';
  document.querySelectorAll('.copy').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var value = btn.getAttribute('data-copy');
      var done = function () {
        btn.textContent = 'Copied'; show('Copied build ' + value);
        setTimeout(function () { btn.textContent = 'Copy'; }, 1800);
      };
      if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(value).then(done, function () { show(FAIL); });
      } else {
        var ta = document.createElement('textarea'); ta.value = value; document.body.appendChild(ta);
        ta.select();
        try { document.execCommand('copy') ? done() : show(FAIL); } catch (e) { show(FAIL); }
        ta.remove();
      }
    });
  });
})();
"""
    
    def run(self) -> bool:
        """
        Main execution method.
        
        Returns:
            True if successful, False otherwise
        """
        logger.info("=== VMware Versions Scraper ===")
        logger.info(f"Starting version check at {self.get_timestamp()}")
        
        # Get the latest VMware Tools version information
        tools_info = self.scrape_tools_version_info()
        
        # Get the latest ESXi version information
        esxi_info = self.scrape_esxi_version_info()
        
        # Get the latest vCenter version information
        vcenter_info = self.scrape_vcenter_version_info()
        
        if tools_info:
            logger.info(f"Latest VMware Tools Version: {tools_info['Version']}")
            logger.info(f"Release Date: {tools_info['ReleaseDate']}")
            logger.info(f"Build Number: {tools_info['BuildNumber']}")
            logger.info(f"Tool Internal Version: {tools_info['ToolInternalVersion']}")
        
        if esxi_info:
            for version_key, version_data in esxi_info.items():
                if isinstance(version_data, dict) and "Version" in version_data:
                    logger.info(f"Latest {version_key}: {version_data['Version']}")
                    logger.info(f"Release Date: {version_data['ReleaseDate']}")
                    logger.info(f"Build Number: {version_data['BuildNumber']}")
                    logger.info(f"Available As: {version_data['AvailableAs']}")
        
        if vcenter_info:
            for version_key, version_data in vcenter_info.items():
                if isinstance(version_data, dict) and "Version" in version_data:
                    logger.info(f"Latest {version_key}: {version_data['Version']}")
                    logger.info(f"Release Date: {version_data['ReleaseDate']}")
                    logger.info(f"Build Number: {version_data['BuildNumber']}")
        
        if tools_info or esxi_info or vcenter_info:
            # Update JSON file
            if self.update_json_file(tools_info or {}, esxi_info or {}, vcenter_info or {}):
                logger.info("✓ JSON file updated successfully")
            else:
                logger.error("✗ Failed to update JSON file")
                return False
            
            # Create HTML display
            if self.create_html_display(tools_info or {}, esxi_info or {}, vcenter_info or {}):
                logger.info("✓ HTML display page created successfully")
                logger.info("You can open the HTML file in your browser to view the results")
            else:
                logger.error("✗ Failed to create HTML display")
                return False
            
            return True
        else:
            logger.error("✗ Failed to retrieve any version information")
            return False


def main():
    """Main function to run the scraper."""
    import argparse
    
    parser = argparse.ArgumentParser(description='VMware Versions Scraper')
    parser.add_argument('--output', '-o', default='vmware-versions.json',
                       help='Path for the JSON file (default: vmware-versions.json)')
    parser.add_argument('--webpage', '-w', default='vmware-versions.html',
                       help='Path for the HTML display page (default: vmware-versions.html)')
    
    args = parser.parse_args()
    
    scraper = VMwareVersionScraper(output_path=args.output, web_page_path=args.webpage)
    
    success = scraper.run()
    
    if success:
        logger.info(f"Script completed at {scraper.get_timestamp()}")
        sys.exit(0)
    else:
        logger.error("Script failed")
        sys.exit(1)


if __name__ == "__main__":
    main() 