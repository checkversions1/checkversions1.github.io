# Define script location and output paths
$scriptPath = $PSScriptRoot
$toolsJsonPath = Join-Path $scriptPath "vmware-tools-versions.json"
$esxiJsonPath = Join-Path $scriptPath "vmware-esxi-versions.json"
$vcenterJsonPath = Join-Path $scriptPath "vmware-vcenter-versions.json"
$vcfJsonPath = Join-Path $scriptPath "vmware-cloud-foundation-versions.json"

# Define all VMware Tools versions
$vmwareTools = @(
    @{
        Version = "VMware Tools 12.5.2"
        ReleaseDate = "05/12/2025"
        BuildNumber = "24697584"
        ToolInternalVersion = "12450"
    },
    @{
        Version = "VMware Tools 12.5.1"
        ReleaseDate = "03/25/2025"
        BuildNumber = "24649672"
        ToolInternalVersion = "12449"
    },
    @{
        Version = "VMware Tools 12.5.0"
        ReleaseDate = "10/08/2024"
        BuildNumber = "24276846"
        ToolInternalVersion = "12448"
    },
    @{
        Version = "VMware Tools 12.4.5"
        ReleaseDate = "06/07/2024"
        BuildNumber = "23787635"
        ToolInternalVersion = "12421"
    },
    @{
        Version = "VMware Tools 12.4.0"
        ReleaseDate = "03/21/2024"
        BuildNumber = "23259341"
        ToolInternalVersion = "12416"
    },
    @{
        Version = "VMware Tools 12.3.5"
        ReleaseDate = "10/26/2023"
        BuildNumber = "22544099"
        ToolInternalVersion = "12389"
    },
    @{
        Version = "VMware Tools 12.3.0"
        ReleaseDate = "08/31/2023"
        BuildNumber = "22234872"
        ToolInternalVersion = "12384"
    },
    @{
        Version = "VMware Tools 12.2.5"
        ReleaseDate = "06/13/2023"
        BuildNumber = "21855600"
        ToolInternalVersion = "12357"
    },
    @{
        Version = "VMware Tools 12.2.0"
        ReleaseDate = "03/07/2023"
        BuildNumber = "21223074"
        ToolInternalVersion = "12352"
    },
    @{
        Version = "VMware Tools 12.1.5"
        ReleaseDate = "11/29/2022"
        BuildNumber = "20735119"
        ToolInternalVersion = "12325"
    }
)

# Define ESXi 8.0 versions (latest first)
$esxi80Versions = @(
    @{
        Version = "ESXi 8.0 P05"
        ReleaseName = "ESXi 8.0 Update 3e"
        ReleaseDate = "2025/04/10"
        BuildNumber = "24674464"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.3 EP4"
        ReleaseName = "ESXi 8.0 Update 3d"
        ReleaseDate = "2025/03/04"
        BuildNumber = "24585383"
        AvailableAs = "Patch"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0 Update 2d"
        ReleaseName = "ESXi 8.0 Update 2d"
        ReleaseDate = "2025/03/04"
        BuildNumber = "24585300"
        AvailableAs = "Patch"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.3 EP3"
        ReleaseName = "ESXi 8.0 Update 3c"
        ReleaseDate = "2024/12/12"
        BuildNumber = "24414501"
        AvailableAs = "Patch"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.0e"
        ReleaseName = "ESXi 8.0e"
        ReleaseDate = "2025/03/11"
        BuildNumber = "24569005"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.3 P04"
        ReleaseName = "ESXi 8.0 Update 3b"
        ReleaseDate = "2024/09/17"
        BuildNumber = "24280767"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.3"
        ReleaseName = "ESXi 8.0 Update 3"
        ReleaseDate = "2024/06/25"
        BuildNumber = "24022510"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.2 EP2"
        ReleaseName = "ESXi 8.0 Update 2c"
        ReleaseDate = "2024/05/21"
        BuildNumber = "23825572"
        AvailableAs = "Patch"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.1 U1d"
        ReleaseName = "ESXi 8.0 Update 1d"
        ReleaseDate = "2024/03/05"
        BuildNumber = "23299997"
        AvailableAs = "Patch"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.2 P03"
        ReleaseName = "ESXi 8.0 Update 2b"
        ReleaseDate = "2024/02/29"
        BuildNumber = "23305546"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.2"
        ReleaseName = "ESXi 8.0 Update 2"
        ReleaseDate = "2023/09/21"
        BuildNumber = "22380479"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.1 P02"
        ReleaseName = "ESXi 8.0 Update 1c"
        ReleaseDate = "2023/07/27"
        BuildNumber = "22088125"
        AvailableAs = "Patch"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.1 EP1"
        ReleaseName = "ESXi 8.0 Update 1a"
        ReleaseDate = "2023/06/01"
        BuildNumber = "21813344"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.1"
        ReleaseName = "ESXi 8.0 Update 1"
        ReleaseDate = "2023/04/18"
        BuildNumber = "21495797"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.0 EP2"
        ReleaseName = "ESXi 8.0c"
        ReleaseDate = "2023/03/30"
        BuildNumber = "21493926"
        AvailableAs = "Patch"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.0 P01"
        ReleaseName = "ESXi 8.0b"
        ReleaseDate = "2023/02/14"
        BuildNumber = "21203435"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.0 EP1"
        ReleaseName = "ESXi 8.0a"
        ReleaseDate = "2022/12/08"
        BuildNumber = "20842819"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    },
    @{
        Version = "ESXi 8.0.0"
        ReleaseName = "ESXi 8.0 GA"
        ReleaseDate = "2022/10/11"
        BuildNumber = "20513097"
        AvailableAs = "ISO"
        MajorVersion = "8.0"
    }
)

# Define ESXi 7.0 versions (latest first)
$esxi70Versions = @(
    @{
        Version = "ESXi 7.0.3 P10"
        ReleaseName = "ESXi 7.0 Update 3v"
        ReleaseDate = "2025/04/10"
        BuildNumber = "24674464"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.3 P09"
        ReleaseName = "ESXi 7.0 Update 3u"
        ReleaseDate = "2025/03/04"
        BuildNumber = "24585383"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.3 P08"
        ReleaseName = "ESXi 7.0 Update 3t"
        ReleaseDate = "2024/12/12"
        BuildNumber = "24414501"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.3 P07"
        ReleaseName = "ESXi 7.0 Update 3s"
        ReleaseDate = "2024/09/17"
        BuildNumber = "24280767"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.3 P06"
        ReleaseName = "ESXi 7.0 Update 3r"
        ReleaseDate = "2024/06/25"
        BuildNumber = "24022510"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.3 P05"
        ReleaseName = "ESXi 7.0 Update 3q"
        ReleaseDate = "2024/05/21"
        BuildNumber = "23825572"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.3 P04"
        ReleaseName = "ESXi 7.0 Update 3p"
        ReleaseDate = "2024/03/05"
        BuildNumber = "23299997"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.3 P03"
        ReleaseName = "ESXi 7.0 Update 3o"
        ReleaseDate = "2024/02/29"
        BuildNumber = "23305546"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.3 P02"
        ReleaseName = "ESXi 7.0 Update 3n"
        ReleaseDate = "2023/12/12"
        BuildNumber = "23000000"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.3 P01"
        ReleaseName = "ESXi 7.0 Update 3m"
        ReleaseDate = "2023/09/21"
        BuildNumber = "22380479"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.3"
        ReleaseName = "ESXi 7.0 Update 3"
        ReleaseDate = "2023/07/27"
        BuildNumber = "22088125"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.2 P06"
        ReleaseName = "ESXi 7.0 Update 2f"
        ReleaseDate = "2023/06/01"
        BuildNumber = "21813344"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.2 P05"
        ReleaseName = "ESXi 7.0 Update 2e"
        ReleaseDate = "2023/04/18"
        BuildNumber = "21495797"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.2 P04"
        ReleaseName = "ESXi 7.0 Update 2d"
        ReleaseDate = "2023/03/30"
        BuildNumber = "21493926"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.2 P03"
        ReleaseName = "ESXi 7.0 Update 2c"
        ReleaseDate = "2023/02/14"
        BuildNumber = "21203435"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.2 P02"
        ReleaseName = "ESXi 7.0 Update 2b"
        ReleaseDate = "2022/12/08"
        BuildNumber = "20842819"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.2 P01"
        ReleaseName = "ESXi 7.0 Update 2a"
        ReleaseDate = "2022/10/11"
        BuildNumber = "20513097"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.2"
        ReleaseName = "ESXi 7.0 Update 2"
        ReleaseDate = "2022/09/15"
        BuildNumber = "20328353"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.1 P05"
        ReleaseName = "ESXi 7.0 Update 1e"
        ReleaseDate = "2022/08/25"
        BuildNumber = "20191270"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.1 P04"
        ReleaseName = "ESXi 7.0 Update 1d"
        ReleaseDate = "2022/07/12"
        BuildNumber = "19898904"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.1 P03"
        ReleaseName = "ESXi 7.0 Update 1c"
        ReleaseDate = "2022/05/19"
        BuildNumber = "19482537"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.1 P02"
        ReleaseName = "ESXi 7.0 Update 1b"
        ReleaseDate = "2022/03/15"
        BuildNumber = "19193900"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.1 P01"
        ReleaseName = "ESXi 7.0 Update 1a"
        ReleaseDate = "2022/01/27"
        BuildNumber = "18905247"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.1"
        ReleaseName = "ESXi 7.0 Update 1"
        ReleaseDate = "2021/12/07"
        BuildNumber = "18426014"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.0 P05"
        ReleaseName = "ESXi 7.0d"
        ReleaseDate = "2021/11/09"
        BuildNumber = "18128368"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.0 P04"
        ReleaseName = "ESXi 7.0c"
        ReleaseDate = "2021/09/28"
        BuildNumber = "17867351"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.0 P03"
        ReleaseName = "ESXi 7.0b"
        ReleaseDate = "2021/08/17"
        BuildNumber = "17630552"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.0 P02"
        ReleaseName = "ESXi 7.0a"
        ReleaseDate = "2021/06/29"
        BuildNumber = "17325551"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.0 P01"
        ReleaseName = "ESXi 7.0 Express Patch 1"
        ReleaseDate = "2021/05/25"
        BuildNumber = "17168206"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    },
    @{
        Version = "ESXi 7.0.0"
        ReleaseName = "ESXi 7.0 GA"
        ReleaseDate = "2021/04/02"
        BuildNumber = "16850804"
        AvailableAs = "ISO"
        MajorVersion = "7.0"
    }
)

# Process VMware Tools versions
Write-Host "Processing VMware Tools versions..." -ForegroundColor Green
$vmwareTools = $vmwareTools | Sort-Object { [datetime]::ParseExact($_.ReleaseDate, "MM/dd/yyyy", $null) } -Descending
$vmwareTools | ConvertTo-Json -Depth 10 | Out-File -FilePath $toolsJsonPath -Encoding UTF8

# Process ESXi versions
Write-Host "Processing VMware ESXi versions..." -ForegroundColor Green
$allESXiVersions = $esxi80Versions + $esxi70Versions
$allESXiVersions = $allESXiVersions | Sort-Object { [datetime]::ParseExact($_.ReleaseDate, "yyyy/MM/dd", $null) } -Descending
$allESXiVersions | ConvertTo-Json -Depth 10 | Out-File -FilePath $esxiJsonPath -Encoding UTF8

# --- vCenter Server Version Scraping ---

$vcenterUrl = "https://knowledge.broadcom.com/external/article?articleNumber=326316"

Write-Host "Scraping vCenter Server versions from Broadcom KB..." -ForegroundColor Green

try {
    $response = Invoke-WebRequest -Uri $vcenterUrl -UseBasicParsing
    $html = $response.Content

    # Find all tables
    $tablePattern = "<table[\s\S]*?<\/table>"
    $tables = [regex]::Matches($html, $tablePattern)
    Write-Host "Found $($tables.Count) tables in the HTML." -ForegroundColor Yellow
    for ($i = 0; $i -lt $tables.Count; $i++) {
        Write-Host "Table $i preview: $($tables[$i].Value.Substring(0, [Math]::Min(500, $tables[$i].Value.Length)))" -ForegroundColor Gray
    }

    $vcenterVersions = @()
    # Table 0: vCenter 8.0, Table 1: vCenter 7.0
    foreach ($tableIdx in 0,1) {
        if ($tables.Count -gt $tableIdx) {
            $table = $tables[$tableIdx].Value
            $rowPattern = "<tr[\s\S]*?<\/tr>"
            $rows = [regex]::Matches($table, $rowPattern)
            for ($j = 1; $j -lt $rows.Count; $j++) { # skip header row
                $cols = [regex]::Matches($rows[$j].Value, "<t[dh][^>]*>([\s\S]*?)<\/t[dh]>") | ForEach-Object { $_.Groups[1].Value.Trim() -replace '<.*?>','' }
                if ($cols.Count -ge 4) {
                    $vcenterVersions += [PSCustomObject]@{
                        Version = $cols[1]
                        ReleaseName = $cols[0]
                        ReleaseDate = $cols[2]
                        BuildNumber = $cols[3]
                        MajorVersion = if ($tableIdx -eq 0) { '8.0' } else { '7.0' }
                    }
                }
            }
        }
    }
    # Sort by version and date (newest first)
    $vcenterVersions = $vcenterVersions | Sort-Object { $_.MajorVersion }, { $_.Version }, { [datetime]::Parse($_.ReleaseDate) } -Descending
    Write-Host "Extracted $($vcenterVersions.Count) vCenter versions" -ForegroundColor Yellow
    $vcenterVersions | ConvertTo-Json -Depth 10 | Out-File -FilePath $vcenterJsonPath -Encoding UTF8
    Write-Host "vCenter Server versions saved to: $vcenterJsonPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to scrape vCenter Server versions: $_" -ForegroundColor Red
    $vcenterVersions = @()
}

# --- VMware Cloud Foundation Version Scraping ---

$vcfUrl = "https://knowledge.broadcom.com/external/article/314608/correlating-vmware-cloud-foundation-vers.html"

Write-Host "Scraping VMware Cloud Foundation versions from Broadcom KB..." -ForegroundColor Green

try {
    $response = Invoke-WebRequest -Uri $vcfUrl -UseBasicParsing
    $html = $response.Content

    # Find all tables
    $tablePattern = "<table[\s\S]*?<\/table>"
    $tables = [regex]::Matches($html, $tablePattern)
    Write-Host "Found $($tables.Count) tables in the HTML." -ForegroundColor Yellow
    for ($i = 0; $i -lt $tables.Count; $i++) {
        Write-Host "Table $i preview: $($tables[$i].Value.Substring(0, [Math]::Min(500, $tables[$i].Value.Length)))" -ForegroundColor Gray
    }

    $vcfVersions = @()
    
    # Process each table to find VCF versions
    for ($i = 0; $i -lt $tables.Count; $i++) {
        $table = $tables[$i].Value
        
        # Look for tables that contain VCF version information
        if ($table -match "VCF|Cloud Foundation|vCenter|ESXi") {
            $rowPattern = "<tr[\s\S]*?<\/tr>"
            $rows = [regex]::Matches($table, $rowPattern)
            
            # Find the header row and determine the Release Date column index
            $headerCols = @()
            if ($rows.Count -gt 0) {
                $headerCols = [regex]::Matches($rows[0].Value, "<t[dh][^>]*>([\s\S]*?)<\/t[dh]>") | ForEach-Object { $_.Groups[1].Value.Trim() -replace '<.*?>','' }
            }
            $releaseDateIdx = ($headerCols | ForEach-Object { $_.ToLower() }) | Select-String -Pattern "date" | ForEach-Object { [array]::IndexOf($headerCols, $_.InputObject) }
            if ($releaseDateIdx.Count -eq 0) { $releaseDateIdx = 2 } # fallback to 3rd col if not found
            else { $releaseDateIdx = $releaseDateIdx[0] }

            for ($j = 1; $j -lt $rows.Count; $j++) { # skip header row
                $cols = [regex]::Matches($rows[$j].Value, "<t[dh][^>]*>([\s\S]*?)<\/t[dh]>") | ForEach-Object { $_.Groups[1].Value.Trim() -replace '<.*?>','' }
                
                # Look for VCF version patterns (e.g., 5.2.1.2, 5.1.2, 5.0.1, etc.)
                if ($cols.Count -ge 2) {
                    # First try to match 4-part version (e.g., 5.2.1.2)
                    $versionMatch = $cols -join " " | Select-String -Pattern "(\d+\.\d+\.\d+\.\d+)" -AllMatches
                    if ($versionMatch.Matches.Count -eq 0) {
                        # If no 4-part version, try 3-part version (e.g., 5.2.1)
                        $versionMatch = $cols -join " " | Select-String -Pattern "(\d+\.\d+\.\d+)" -AllMatches
                    }
                    
                    if ($versionMatch.Matches.Count -gt 0) {
                        $vcfVersion = $versionMatch.Matches[0].Groups[1].Value
                        
                        # Filter out non-VCF versions (like vCenter Server versions)
                        if ($vcfVersion -match "^(3|4|5)\.\d+" -and $vcfVersion -notmatch "^(6|7|8)\.\d+") {
                            # Extract build number from the text
                            $buildMatch = $cols -join " " | Select-String -Pattern "Build\s+(\d+)" -AllMatches
                            $buildNumber = if ($buildMatch.Matches.Count -gt 0) { $buildMatch.Matches[0].Groups[1].Value } else { "Unknown" }
                            
                            # Extract additional information if available
                            $releaseName = $cols[0]
                            $releaseDate = if ($cols.Count -gt $releaseDateIdx) { $cols[$releaseDateIdx] } else { "Unknown" }
                            # If releaseDate is empty or not a valid date, try to extract from the row using regex
                            if (-not $releaseDate -or $releaseDate -eq "Unknown" -or $releaseDate -notmatch '\d{4}-\d{2}-\d{2}' -and $releaseDate -notmatch '\d{2} [A-Za-z]{3} \d{4}') {
                                $rowText = $cols -join " "
                                $dateMatch = $rowText | Select-String -Pattern '(\d{4}-\d{2}-\d{2})' -AllMatches
                                if ($dateMatch.Matches.Count -gt 0) {
                                    $releaseDate = $dateMatch.Matches[0].Groups[1].Value
                                } else {
                                    $dateMatch = $rowText | Select-String -Pattern '(\d{2} [A-Za-z]{3} \d{4})' -AllMatches
                                    if ($dateMatch.Matches.Count -gt 0) {
                                        $releaseDate = $dateMatch.Matches[0].Groups[1].Value
                                    } else {
                                        $releaseDate = "Unknown"
                                    }
                                }
                            }
                            
                            # Determine major version
                            $majorVersion = if ($vcfVersion -match "^(\d+)\.\d+") { $matches[1] } else { "Unknown" }
                            
                            $vcfVersions += [PSCustomObject]@{
                                Version = $vcfVersion
                                ReleaseName = $releaseName
                                ReleaseDate = $releaseDate
                                BuildNumber = $buildNumber
                                MajorVersion = $majorVersion
                            }
                        }
                    }
                }
            }
        }
    }
    
    # Remove duplicates and sort by version (newest first)
    $vcfVersions = $vcfVersions | Sort-Object Version -Unique | Sort-Object { [version]$_.Version } -Descending
    
    Write-Host "Extracted $($vcfVersions.Count) VCF versions" -ForegroundColor Yellow
    $vcfVersions | ConvertTo-Json -Depth 10 | Out-File -FilePath $vcfJsonPath -Encoding UTF8
    Write-Host "VMware Cloud Foundation versions saved to: $vcfJsonPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to scrape VMware Cloud Foundation versions: $_" -ForegroundColor Red
    $vcfVersions = @()
}

# Display summary information
$latestTools = $vmwareTools[0]
$latestESXi80 = $esxi80Versions[0]
$latestESXi70 = $esxi70Versions[0]

# Get latest vCenter versions from the scraped data
$latestVCenter80 = $vcenterVersions | Where-Object { $_.Version -match "^8\." } | Select-Object -First 1
$latestVCenter70 = $vcenterVersions | Where-Object { $_.Version -match "^7\." } | Select-Object -First 1

# Get latest VCF version from the scraped data
$latestVCF = $vcfVersions | Select-Object -First 1

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "VMware Version Information Summary" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan

Write-Host ""
Write-Host "VMware Tools Latest:" -ForegroundColor Yellow
Write-Host "  Version: $($latestTools.Version)" -ForegroundColor White
Write-Host "  Release Date: $($latestTools.ReleaseDate)" -ForegroundColor White
Write-Host "  Build Number: $($latestTools.BuildNumber)" -ForegroundColor White
Write-Host "  Tool Internal Version: $($latestTools.ToolInternalVersion)" -ForegroundColor White

Write-Host ""
Write-Host "VMware ESXi 8.0 Latest:" -ForegroundColor Yellow
Write-Host "  Version: $($latestESXi80.Version)" -ForegroundColor White
Write-Host "  Release Name: $($latestESXi80.ReleaseName)" -ForegroundColor White
Write-Host "  Release Date: $($latestESXi80.ReleaseDate)" -ForegroundColor White
Write-Host "  Build Number: $($latestESXi80.BuildNumber)" -ForegroundColor White
Write-Host "  Available As: $($latestESXi80.AvailableAs)" -ForegroundColor White

Write-Host ""
Write-Host "VMware ESXi 7.0 Latest:" -ForegroundColor Yellow
Write-Host "  Version: $($latestESXi70.Version)" -ForegroundColor White
Write-Host "  Release Name: $($latestESXi70.ReleaseName)" -ForegroundColor White
Write-Host "  Release Date: $($latestESXi70.ReleaseDate)" -ForegroundColor White
Write-Host "  Build Number: $($latestESXi70.BuildNumber)" -ForegroundColor White
Write-Host "  Available As: $($latestESXi70.AvailableAs)" -ForegroundColor White

if ($latestVCenter80) {
    Write-Host ""
    Write-Host "VMware vCenter Server 8.0 Latest:" -ForegroundColor Yellow
    Write-Host "  Version: $($latestVCenter80.Version)" -ForegroundColor White
    Write-Host "  Release Name: $($latestVCenter80.ReleaseName)" -ForegroundColor White
    Write-Host "  Release Date: $($latestVCenter80.ReleaseDate)" -ForegroundColor White
    Write-Host "  Build Number: $($latestVCenter80.BuildNumber)" -ForegroundColor White
}

if ($latestVCenter70) {
    Write-Host ""
    Write-Host "VMware vCenter Server 7.0 Latest:" -ForegroundColor Yellow
    Write-Host "  Version: $($latestVCenter70.Version)" -ForegroundColor White
    Write-Host "  Release Name: $($latestVCenter70.ReleaseName)" -ForegroundColor White
    Write-Host "  Release Date: $($latestVCenter70.ReleaseDate)" -ForegroundColor White
    Write-Host "  Build Number: $($latestVCenter70.BuildNumber)" -ForegroundColor White
}

if ($latestVCF) {
    Write-Host ""
    Write-Host "VMware Cloud Foundation Latest:" -ForegroundColor Yellow
    Write-Host "  Version: $($latestVCF.Version)" -ForegroundColor White
    Write-Host "  Release Name: $($latestVCF.ReleaseName)" -ForegroundColor White
    Write-Host "  Release Date: $($latestVCF.ReleaseDate)" -ForegroundColor White
    Write-Host "  Build Number: $($latestVCF.BuildNumber)" -ForegroundColor White
}

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "Files Generated:" -ForegroundColor Cyan
Write-Host "  VMware Tools: $toolsJsonPath" -ForegroundColor White
Write-Host "  VMware ESXi: $esxiJsonPath" -ForegroundColor White
Write-Host "  VMware vCenter: $vcenterJsonPath" -ForegroundColor White
Write-Host "  VMware Cloud Foundation: $vcfJsonPath" -ForegroundColor White
Write-Host ""
Write-Host "Total versions tracked:" -ForegroundColor Cyan
Write-Host "  VMware Tools: $($vmwareTools.Count)" -ForegroundColor White
Write-Host "  VMware ESXi: $($allESXiVersions.Count)" -ForegroundColor White
Write-Host "  VMware vCenter: $($vcenterVersions.Count)" -ForegroundColor White
Write-Host "  VMware Cloud Foundation: $($vcfVersions.Count)" -ForegroundColor White
Write-Host ("=" * 60) -ForegroundColor Cyan
