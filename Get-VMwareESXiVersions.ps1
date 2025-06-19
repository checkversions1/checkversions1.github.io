# Define script location and output path
$scriptPath = $PSScriptRoot
$jsonPath = Join-Path $scriptPath "vmware-esxi-versions.json"

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

# Combine all versions and sort by release date (newest first)
$allESXiVersions = $esxi80Versions + $esxi70Versions
$allESXiVersions = $allESXiVersions | Sort-Object { [datetime]::ParseExact($_.ReleaseDate, "yyyy/MM/dd", $null) } -Descending

# Convert to JSON and save to file
$allESXiVersions | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonPath -Encoding UTF8

# Display the latest versions for each major version
$latestESXi80 = $esxi80Versions[0]
$latestESXi70 = $esxi70Versions[0]

Write-Host "`nLatest VMware ESXi Version Information:"
Write-Host "========================================"
Write-Host "ESXi 8.0 Latest:"
Write-Host "  Version: $($latestESXi80.Version)"
Write-Host "  Release Name: $($latestESXi80.ReleaseName)"
Write-Host "  Release Date: $($latestESXi80.ReleaseDate)"
Write-Host "  Build Number: $($latestESXi80.BuildNumber)"
Write-Host "  Available As: $($latestESXi80.AvailableAs)"
Write-Host ""
Write-Host "ESXi 7.0 Latest:"
Write-Host "  Version: $($latestESXi70.Version)"
Write-Host "  Release Name: $($latestESXi70.ReleaseName)"
Write-Host "  Release Date: $($latestESXi70.ReleaseDate)"
Write-Host "  Build Number: $($latestESXi70.BuildNumber)"
Write-Host "  Available As: $($latestESXi70.AvailableAs)"
Write-Host "========================================"

Write-Host "`nVMware ESXi versions have been saved to: $jsonPath"
Write-Host "Total versions tracked: $($allESXiVersions.Count)"
