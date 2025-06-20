# Define script location and output paths
$scriptPath = $PSScriptRoot
$toolsJsonPath = Join-Path $scriptPath "vmware-tools-versions.json"
$esxiJsonPath = Join-Path $scriptPath "vmware-esxi-versions.json"
$vcenterJsonPath = Join-Path $scriptPath "vmware-vcenter-versions.json"
$vcfJsonPath = Join-Path $scriptPath "vmware-cloud-foundation-versions.json"

# --- VMware Tools Version Scraping ---

$toolsUrl = "https://knowledge.broadcom.com/external/article/304809/build-numbers-and-versions-of-vmware-too.html"

Write-Host "Scraping VMware Tools versions from Broadcom KB..." -ForegroundColor Green

try {
    $response = Invoke-WebRequest -Uri $toolsUrl -UseBasicParsing
    $html = $response.Content

    # Find all tables
    $tablePattern = "<table[\s\S]*?<\/table>"
    $tables = [regex]::Matches($html, $tablePattern)
    Write-Host "Found $($tables.Count) tables in the HTML." -ForegroundColor Yellow
    for ($i = 0; $i -lt $tables.Count; $i++) {
        Write-Host "Table $i preview: $($tables[$i].Value.Substring(0, [Math]::Min(500, $tables[$i].Value.Length)))" -ForegroundColor Gray
    }

    $vmwareTools = @()
    
    # Process each table to find VMware Tools versions
    for ($i = 0; $i -lt $tables.Count; $i++) {
        $table = $tables[$i].Value
        
        # Look for tables that contain VMware Tools version information
        if ($table -match "VMware Tools|Tools Version|Build Number") {
            $rowPattern = "<tr[\s\S]*?<\/tr>"
            $rows = [regex]::Matches($table, $rowPattern)
            
            # Find the header row and determine column indices
            $headerCols = @()
            if ($rows.Count -gt 0) {
                $headerCols = [regex]::Matches($rows[0].Value, "<t[dh][^>]*>([\s\S]*?)<\/t[dh]>") | ForEach-Object { $_.Groups[1].Value.Trim() -replace '<.*?>','' }
            }
            
            # Clean up header columns: remove HTML entities and extra whitespace
            $headerCols = $headerCols | ForEach-Object { $_ -replace '&nbsp;', '' -replace '\s+', ' ' -replace '^\s+|\s+$', '' }

            # Find column indices for different fields
            $versionIdx = ($headerCols | ForEach-Object { $_.ToLower() }) | Select-String -Pattern "version|tools" | ForEach-Object { [array]::IndexOf($headerCols, $_.InputObject) }
            $dateIdx = ($headerCols | ForEach-Object { $_.ToLower() }) | Select-String -Pattern "date|release" | ForEach-Object { [array]::IndexOf($headerCols, $_.InputObject) }
            $buildIdx = ($headerCols | ForEach-Object { $_.ToLower() }) | Select-String -Pattern "build" | ForEach-Object { [array]::IndexOf($headerCols, $_.InputObject) }
            $internalIdx = ($headerCols | ForEach-Object { $_.ToLower() }) | Select-String -Pattern "internal" | ForEach-Object { [array]::IndexOf($headerCols, $_.InputObject) }
            
            # Set fallback indices if not found
            if ($versionIdx.Count -eq 0) { $versionIdx = 0 } else { $versionIdx = $versionIdx[0] }
            if ($dateIdx.Count -eq 0) { $dateIdx = 1 } else { $dateIdx = $dateIdx[0] }
            if ($buildIdx.Count -eq 0) { $buildIdx = 2 } else { $buildIdx = $buildIdx[0] }
            if ($internalIdx.Count -eq 0) { $internalIdx = 3 } else { $internalIdx = $internalIdx[0] }

            # Debug: Show header columns and their indices
            Write-Host "Table $i headers: $($headerCols -join ' | ')" -ForegroundColor Cyan
            Write-Host "Column indices - Version: $versionIdx, Date: $dateIdx, Build: $buildIdx, Internal: $internalIdx" -ForegroundColor Cyan

            for ($j = 1; $j -lt $rows.Count; $j++) { # skip header row
                $cols = [regex]::Matches($rows[$j].Value, "<t[dh][^>]*>([\s\S]*?)<\/t[dh]>") | ForEach-Object { $_.Groups[1].Value.Trim() -replace '<.*?>','' }
                
                # Look for VMware Tools version patterns
                if ($cols.Count -ge 2) {
                    $versionMatch = $cols -join " " | Select-String -Pattern "(VMware Tools \d+\.\d+\.\d+)" -AllMatches
                    if ($versionMatch.Matches.Count -gt 0) {
                        $toolsVersion = $versionMatch.Matches[0].Groups[1].Value
                        
                        # Extract additional information
                        $releaseDate = if ($cols.Count -gt $dateIdx) { $cols[$dateIdx] } else { "Unknown" }
                        $buildNumber = if ($cols.Count -gt $buildIdx) { $cols[$buildIdx] } else { "Unknown" }
                        $toolInternalVersion = if ($cols.Count -gt $internalIdx) { $cols[$internalIdx] } else { "Unknown" }
                        
                        # Clean up the data
                        $releaseDate = $releaseDate -replace '\s+', ' ' -replace '^\s+|\s+$', ''
                        $buildNumber = $buildNumber -replace '\s+', ' ' -replace '^\s+|\s+$', ''
                        $toolInternalVersion = $toolInternalVersion -replace '\s+', ' ' -replace '^\s+|\s+$', ''
                        
                        # Additional validation and correction
                        # If releaseDate looks like a number (internal version), try to find actual date in the row
                        if ($releaseDate -match '^\d+$' -and $releaseDate.Length -lt 6) {
                            $rowText = $cols -join " "
                            $dateMatch = $rowText | Select-String -Pattern '(\d{1,2}/\d{1,2}/\d{4})' -AllMatches
                            if ($dateMatch.Matches.Count -gt 0) {
                                $releaseDate = $dateMatch.Matches[0].Groups[1].Value
                            }
                        }
                        
                        # If buildNumber looks like internal version, try to find actual build number
                        if ($buildNumber -match '^\d+$' -and $buildNumber.Length -lt 6) {
                            $rowText = $cols -join " "
                            $buildMatch = $rowText | Select-String -Pattern '(\d{8,})' -AllMatches
                            if ($buildMatch.Matches.Count -gt 0) {
                                $buildNumber = $buildMatch.Matches[0].Groups[1].Value
                            }
                        }
                        
                        # Debug: Show extracted data for first few rows
                        if ($j -le 3) {
                            Write-Host "Row $j - Version: $toolsVersion, Date: $releaseDate, Build: $buildNumber, Internal: $toolInternalVersion" -ForegroundColor Yellow
                        }
                        
                        $vmwareTools += [PSCustomObject]@{
                            Version = $toolsVersion
                            ReleaseDate = $releaseDate
                            BuildNumber = $buildNumber
                            ToolInternalVersion = $toolInternalVersion
                        }
                    }
                }
            }
        }
    }
    
    # Remove duplicates and sort by version (newest first)
    $vmwareTools = $vmwareTools | Sort-Object Version -Unique | Sort-Object { [version]($_.Version -replace 'VMware Tools ', '') } -Descending
    
    Write-Host "Extracted $($vmwareTools.Count) VMware Tools versions" -ForegroundColor Yellow
    $vmwareTools | ConvertTo-Json -Depth 10 | Out-File -FilePath $toolsJsonPath -Encoding UTF8
    Write-Host "VMware Tools versions saved to: $toolsJsonPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to scrape VMware Tools versions: $_" -ForegroundColor Red
    # Fallback to hardcoded data if scraping fails
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
        }
    )
    $vmwareTools | ConvertTo-Json -Depth 10 | Out-File -FilePath $toolsJsonPath -Encoding UTF8
    Write-Host "Using fallback VMware Tools data" -ForegroundColor Yellow
}

# --- ESXi Version Scraping ---

$esxiUrl = "https://knowledge.broadcom.com/external/article?legacyId=2143832"

Write-Host "Scraping ESXi versions from Broadcom KB..." -ForegroundColor Green

try {
    $response = Invoke-WebRequest -Uri $esxiUrl -UseBasicParsing
    $html = $response.Content

    # Find all tables
    $tablePattern = "<table[\s\S]*?<\/table>"
    $tables = [regex]::Matches($html, $tablePattern)
    Write-Host "Found $($tables.Count) tables in the HTML." -ForegroundColor Yellow

    $esxiVersions = @()
    
    # Process each table to find ESXi version information
    for ($i = 0; $i -lt $tables.Count; $i++) {
        $table = $tables[$i].Value
        
        # Look for tables that contain ESXi version information
        if ($table -match "ESXi|Version|Build Number|Release Date") {
            $rowPattern = "<tr[\s\S]*?<\/tr>"
            $rows = [regex]::Matches($table, $rowPattern)
            
            # Find the header row and determine column indices
            $headerCols = @()
            if ($rows.Count -gt 0) {
                $headerCols = [regex]::Matches($rows[0].Value, "<t[dh][^>]*>([\s\S]*?)<\/t[dh]>") | ForEach-Object { $_.Groups[1].Value.Trim() -replace '<.*?>','' }
            }
            
            # Clean up header columns: remove HTML entities and extra whitespace
            $headerCols = $headerCols | ForEach-Object { $_ -replace '&nbsp;', '' -replace '\s+', ' ' -replace '^\s+|\s+$', '' }

            # Find column indices for different fields
            $versionIdx = ($headerCols | ForEach-Object { $_.ToLower() }) | Select-String -Pattern "version|release" | ForEach-Object { [array]::IndexOf($headerCols, $_.InputObject) }
            $releaseNameIdx = ($headerCols | ForEach-Object { $_.ToLower() }) | Select-String -Pattern "release name|name" | ForEach-Object { [array]::IndexOf($headerCols, $_.InputObject) }
            $dateIdx = ($headerCols | ForEach-Object { $_.ToLower() }) | Select-String -Pattern "date|release date" | ForEach-Object { [array]::IndexOf($headerCols, $_.InputObject) }
            $buildIdx = ($headerCols | ForEach-Object { $_.ToLower() }) | Select-String -Pattern "build" | ForEach-Object { [array]::IndexOf($headerCols, $_.InputObject) }
            $availableIdx = ($headerCols | ForEach-Object { $_.ToLower() }) | Select-String -Pattern "available|type" | ForEach-Object { [array]::IndexOf($headerCols, $_.InputObject) }
            
            # Set fallback indices if not found - use more intelligent fallbacks
            if ($versionIdx.Count -eq 0 -or $versionIdx[0] -eq -1) { 
                $versionIdx = 0
                for ($k = 0; $k -lt $headerCols.Count; $k++) {
                    if ($headerCols[$k] -match "ESXi|Version|\d+\.\d+") {
                        $versionIdx = $k
                        break
                    }
                }
            } else { $versionIdx = $versionIdx[0] }
            if ($releaseNameIdx.Count -eq 0 -or $releaseNameIdx[0] -eq -1) { 
                $releaseNameIdx = 1
                for ($k = 0; $k -lt $headerCols.Count; $k++) {
                    if ($headerCols[$k] -match "Release|Name|Update") {
                        $releaseNameIdx = $k
                        break
                    }
                }
            } else { $releaseNameIdx = $releaseNameIdx[0] }
            if ($dateIdx.Count -eq 0 -or $dateIdx[0] -eq -1) { 
                $dateIdx = 2
                for ($k = 0; $k -lt $headerCols.Count; $k++) {
                    if ($headerCols[$k] -match "Date|Release") {
                        $dateIdx = $k
                        break
                    }
                }
            } else { $dateIdx = $dateIdx[0] }
            if ($buildIdx.Count -eq 0 -or $buildIdx[0] -eq -1) { 
                $buildIdx = 3
                for ($k = 0; $k -lt $headerCols.Count; $k++) {
                    if ($headerCols[$k] -match "Build") {
                        $buildIdx = $k
                        break
                    }
                }
            } else { $buildIdx = $buildIdx[0] }
            if ($availableIdx.Count -eq 0 -or $availableIdx[0] -eq -1) { 
                $availableIdx = 4
                for ($k = 0; $k -lt $headerCols.Count; $k++) {
                    if ($headerCols[$k] -match "Available|Type|ISO|Patch") {
                        $availableIdx = $k
                        break
                    }
                }
            } else { $availableIdx = $availableIdx[0] }

            # Skip this table if any index is still -1 (invalid)
            if ($versionIdx -eq -1 -or $releaseNameIdx -eq -1 -or $dateIdx -eq -1 -or $buildIdx -eq -1 -or $availableIdx -eq -1) {
                Write-Host "Skipping table $i due to invalid column indices." -ForegroundColor Red
                continue
            }

            # Ensure dateIdx is different from releaseNameIdx
            if ($dateIdx -eq $releaseNameIdx) {
                # Try to find a different column for date
                for ($k = 0; $k -lt $headerCols.Count; $k++) {
                    if ($k -ne $releaseNameIdx -and $headerCols[$k] -match "Date") {
                        $dateIdx = $k
                        break
                    }
                }
                # If still the same, use the next column
                if ($dateIdx -eq $releaseNameIdx) {
                    $dateIdx = $releaseNameIdx + 1
                    if ($dateIdx -ge $headerCols.Count) {
                        $dateIdx = $releaseNameIdx - 1
                    }
                }
            }

            # Debug: Show header columns and their indices
            Write-Host "Table $i headers: $($headerCols -join ' | ')" -ForegroundColor Cyan
            Write-Host "Column indices - Version: $versionIdx, ReleaseName: $releaseNameIdx, Date: $dateIdx, Build: $buildIdx, Available: $availableIdx" -ForegroundColor Cyan

            for ($j = 1; $j -lt $rows.Count; $j++) { # skip header row
                $cols = [regex]::Matches($rows[$j].Value, "<t[dh][^>]*>([\s\S]*?)<\/t[dh]>") | ForEach-Object { $_.Groups[1].Value.Trim() -replace '<.*?>','' }
                
                # Look for ESXi version patterns
                if ($cols.Count -ge 2) {
                    # First try to find ESXi version in the version column
                    $esxiVersion = ""
                    if ($cols.Count -gt $versionIdx) {
                        $versionText = $cols[$versionIdx]
                        $versionMatch = $versionText | Select-String -Pattern "(ESXi \d+\.\d+[^\s]*)" -AllMatches
                        if ($versionMatch.Matches.Count -gt 0) {
                            $esxiVersion = $versionMatch.Matches[0].Groups[1].Value
                        }
                    }
                    
                    # If not found in version column, search all columns
                    if (-not $esxiVersion) {
                        $versionMatch = $cols -join " " | Select-String -Pattern "(ESXi \d+\.\d+[^\s]*)" -AllMatches
                        if ($versionMatch.Matches.Count -gt 0) {
                            $esxiVersion = $versionMatch.Matches[0].Groups[1].Value
                        }
                    }
                    
                    if ($esxiVersion) {
                        # Extract additional information
                        $releaseName = if ($cols.Count -gt $releaseNameIdx) { $cols[$releaseNameIdx] } else { $esxiVersion }
                        $releaseDate = if ($cols.Count -gt $dateIdx) { $cols[$dateIdx] } else { "Unknown" }
                        $buildNumber = if ($cols.Count -gt $buildIdx) { $cols[$buildIdx] } else { "Unknown" }
                        $availableAs = if ($cols.Count -gt $availableIdx) { $cols[$availableIdx] } else { "Unknown" }
                        
                        # Clean up the data
                        $releaseName = $releaseName -replace '\s+', ' ' -replace '^\s+|\s+$', ''
                        $releaseDate = $releaseDate -replace '\s+', ' ' -replace '^\s+|\s+$', ''
                        $buildNumber = $buildNumber -replace '\s+', ' ' -replace '^\s+|\s+$', ''
                        $availableAs = $availableAs -replace '\s+', ' ' -replace '^\s+|\s+$', ''
                        
                        # Determine major version
                        $majorVersion = if ($esxiVersion -match "8\.\d+") { "8.0" } elseif ($esxiVersion -match "7\.\d+") { "7.0" } else { "Unknown" }
                        
                        # Fix version extraction: if version is just "ESXi 8.0", "ESXi 7.0", or "ESXi 7.0.3" but releaseName has more detail, use releaseName
                        if (($esxiVersion -match "^ESXi \d+\.\d+$" -or $esxiVersion -match "^ESXi \d+\.\d+\.\d+$") -and $releaseName -match "ESXi \d+\.\d+") {
                            # Extract the full version from releaseName (e.g., "ESXi 8.0 Update 3e" -> "ESXi 8.0.3 P05")
                            if ($releaseName -match "Update \d+[a-z]") {
                                $updateMatch = $releaseName | Select-String -Pattern "Update (\d+[a-z])" -AllMatches
                                if ($updateMatch.Matches.Count -gt 0) {
                                    $updateSuffix = $updateMatch.Matches[0].Groups[1].Value
                                    # Map update suffixes to version suffixes for both 8.0 and 7.0
                                    $versionSuffix = switch ($updateSuffix) {
                                        # ESXi 8.0
                                        "3e" { "P05" }
                                        "3d" { "EP4" }
                                        "3c" { "EP3" }
                                        "3b" { "P04" }
                                        "3a" { "P03" }
                                        # ESXi 7.0
                                        "3v" { "P10" }
                                        "3u" { "P09" }
                                        "3t" { "P08" }
                                        "3s" { "P07" }
                                        "3r" { "P06" }
                                        "3q" { "P05" }
                                        "3p" { "P04" }
                                        "3o" { "P03" }
                                        "3n" { "P02" }
                                        "3m" { "P01" }
                                        default { $updateSuffix }
                                    }
                                    # If version is ESXi 7.0.3 or ESXi 8.0.3, append the patch suffix
                                    if ($esxiVersion -match "^ESXi \d+\.\d+\.\d+$") {
                                        $esxiVersion = $esxiVersion + " " + $versionSuffix
                                    } else {
                                        # For ESXi 8.0 or 7.0, keep previous logic
                                        $esxiVersion = $esxiVersion + " " + $versionSuffix
                                    }
                                }
                            }
                        }
                        
                        # Additional validation and correction
                        # If releaseDate looks like a release name (contains "Update" or "ESXi"), try to find actual date in the row
                        if ($releaseDate -match "Update|ESXi|Release") {
                            $rowText = $cols -join " "
                            # Try different date patterns
                            $dateMatch = $rowText | Select-String -Pattern '(\d{4}/\d{1,2}/\d{1,2})' -AllMatches
                            if ($dateMatch.Matches.Count -gt 0) {
                                $releaseDate = $dateMatch.Matches[0].Groups[1].Value
                            } else {
                                $dateMatch = $rowText | Select-String -Pattern '(\d{1,2}/\d{1,2}/\d{4})' -AllMatches
                                if ($dateMatch.Matches.Count -gt 0) {
                                    $releaseDate = $dateMatch.Matches[0].Groups[1].Value
                                } else {
                                    $dateMatch = $rowText | Select-String -Pattern '(\d{4}-\d{1,2}-\d{1,2})' -AllMatches
                                    if ($dateMatch.Matches.Count -gt 0) {
                                        $releaseDate = $dateMatch.Matches[0].Groups[1].Value
                                    } else {
                                        $releaseDate = "Unknown"
                                    }
                                }
                            }
                        }
                        
                        # If buildNumber looks like internal version, try to find actual build number
                        if ($buildNumber -match '^\d+$' -and $buildNumber.Length -lt 6) {
                            $rowText = $cols -join " "
                            $buildMatch = $rowText | Select-String -Pattern '(\d{8,})' -AllMatches
                            if ($buildMatch.Matches.Count -gt 0) {
                                $buildNumber = $buildMatch.Matches[0].Groups[1].Value
                            }
                        }
                        
                        # If releaseName is empty or same as version, try to extract from row
                        if (-not $releaseName -or $releaseName -eq $esxiVersion) {
                            $rowText = $cols -join " "
                            $releaseMatch = $rowText | Select-String -Pattern "(Update \d+[a-z]?|P\d+|EP\d+)" -AllMatches
                            if ($releaseMatch.Matches.Count -gt 0) {
                                $releaseName = $esxiVersion + " " + $releaseMatch.Matches[0].Groups[1].Value
                            }
                        }
                        
                        # Debug: Show extracted data for first few rows
                        if ($j -le 3) {
                            Write-Host "Row $j - Version: $esxiVersion, ReleaseName: $releaseName, Date: $releaseDate, Build: $buildNumber, Available: $availableAs" -ForegroundColor Yellow
                        }
                        
                        $esxiVersions += [PSCustomObject]@{
                            Version = $esxiVersion
                            ReleaseName = $releaseName
                            ReleaseDate = $releaseDate
                            BuildNumber = $buildNumber
                            AvailableAs = $availableAs
                            MajorVersion = $majorVersion
                        }
                    }
                }
            }
        }
    }
    
    # Remove duplicates and sort by version (newest first) with better error handling
    $esxiVersions = $esxiVersions | Sort-Object Version -Unique
    
    # Custom sorting function to handle version strings with letters
    $esxiVersions = $esxiVersions | Sort-Object {
        $versionStr = $_.Version -replace 'ESXi ', ''
        # Extract numeric parts and handle letters
        if ($versionStr -match '(\d+)\.(\d+)\.(\d+)([a-zA-Z]*)') {
            $major = [int]$matches[1]
            $minor = [int]$matches[2]
            $patch = [int]$matches[3]
            $letter = $matches[4]
            # Create sortable string: major.minor.patch.letter_priority
            $letterPriority = if ($letter -eq '') { 999 } else { [int][char]$letter }
            "$major.$minor.$patch.$letterPriority"
        } else {
            $versionStr
        }
    } -Descending
    
    Write-Host "Extracted $($esxiVersions.Count) ESXi versions" -ForegroundColor Yellow
    $esxiVersions | ConvertTo-Json -Depth 10 | Out-File -FilePath $esxiJsonPath -Encoding UTF8
    Write-Host "ESXi versions saved to: $esxiJsonPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to scrape ESXi versions: $_" -ForegroundColor Red
    # Fallback to hardcoded data if scraping fails
    $esxiVersions = @(
        @{
            Version = "ESXi 8.0 P05"
            ReleaseName = "ESXi 8.0 Update 3e"
            ReleaseDate = "2025/04/10"
            BuildNumber = "24674464"
            AvailableAs = "ISO"
            MajorVersion = "8.0"
        },
        @{
            Version = "ESXi 7.0.3 P10"
            ReleaseName = "ESXi 7.0 Update 3v"
            ReleaseDate = "2025/04/10"
            BuildNumber = "24674464"
            AvailableAs = "ISO"
            MajorVersion = "7.0"
        }
    )
    $esxiVersions | ConvertTo-Json -Depth 10 | Out-File -FilePath $esxiJsonPath -Encoding UTF8
    Write-Host "Using fallback ESXi data" -ForegroundColor Yellow
}

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
# Filter VMware Tools to only include versions with a release date in the past
$today = (Get-Date).Date
$dateFormats = @('MM/dd/yyyy', 'yyyy-MM-dd', 'dd/MM/yyyy') # Supported date formats
$releasedTools = @($vmwareTools | Where-Object {
    if ($_.ReleaseDate -eq 'Unknown') { return $false }
    $parsedDate = $null
    foreach ($format in $dateFormats) {
        try {
            $parsedDate = [datetime]::ParseExact($_.ReleaseDate, $format, [System.Globalization.CultureInfo]::InvariantCulture)
            break # Exit loop if parsing succeeds
        } catch {}
    }
    # Check if a date was parsed and if it's in the past or today
    if ($parsedDate) {
        return $parsedDate -le $today
    }
    return $false # If parsing fails, exclude the item
})

if ($releasedTools.Count -gt 0) {
    # The list is already sorted by version descending, so the first one is the latest released
    $latestTools = $releasedTools[0]
} else {
    Write-Host "Warning: Could not find a VMware Tools version with a valid past or current release date. Displaying the highest version number found." -ForegroundColor Yellow
    # Fallback to the original behavior if no released versions are found
    $latestTools = $vmwareTools[0]
}

# Get latest ESXi versions from the scraped data
function Get-LatestByDate($versions, $major) {
    $dateFormats = @('yyyy/MM/dd','yyyy-MM-dd','MM/dd/yyyy','dd/MM/yyyy')
    $filtered = $versions | Where-Object { $_.MajorVersion -eq $major -and $_.ReleaseDate -ne 'Unknown' }
    $sorted = $filtered | Sort-Object {
        $d = $_.ReleaseDate
        foreach ($fmt in $dateFormats) {
            try { return [datetime]::ParseExact($d, $fmt, $null) } catch {}
        }
        return [datetime]0
    } -Descending
    if ($sorted.Count -gt 0) {
        Write-Host ("Selected latest ESXi $($major): $($sorted[0].Version) | $($sorted[0].ReleaseName) | $($sorted[0].ReleaseDate) | $($sorted[0].BuildNumber)") -ForegroundColor Green
        return $sorted[0]
    } else {
        Write-Host ("No valid ESXi $($major) version found!") -ForegroundColor Red
        return $null
    }
}
$latestESXi80 = Get-LatestByDate $esxiVersions '8.0'
$latestESXi70 = Get-LatestByDate $esxiVersions '7.0'

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
Write-Host "  VMware ESXi: $($esxiVersions.Count)" -ForegroundColor White
Write-Host "  VMware vCenter: $($vcenterVersions.Count)" -ForegroundColor White
Write-Host "  VMware Cloud Foundation: $($vcfVersions.Count)" -ForegroundColor White
Write-Host ("=" * 60) -ForegroundColor Cyan

# Save last updated timestamp
try {
    $timestamp = Get-Date -Format "o"
    $jsonObject = @{ lastUpdated = $timestamp }
    $jsonContent = $jsonObject | ConvertTo-Json -Compress
    $lastUpdatedPath = Join-Path $scriptPath "last-updated.json"
    Set-Content -Path $lastUpdatedPath -Value $jsonContent
    Write-Host "Last updated timestamp saved to: $lastUpdatedPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to save last updated timestamp: $_" -ForegroundColor Red
}
