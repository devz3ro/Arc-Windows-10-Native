function CommandExists {
    param(
        [string]$command
    )
    $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
}

function Xdelta3Installed {
    Get-Command xdelta3 -ErrorAction SilentlyContinue
}

function Get-FileMD5 {
    param (
        [string]$filePath
    )
    $md5 = [System.Security.Cryptography.MD5]::Create()
    $fileStream = [System.IO.File]::OpenRead($filePath)
    $hashBytes = $md5.ComputeHash($fileStream)
    $fileStream.Close()
    $hashString = [BitConverter]::ToString($hashBytes) -replace '-', ''
    return $hashString.ToLower()
}

$scriptDirectory = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }

$patchBase64 = @"
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
"@

$patchFilePath = Join-Path -Path $scriptDirectory -ChildPath "patch_file.xdelta3"
[IO.File]::WriteAllBytes($patchFilePath, [Convert]::FromBase64String($patchBase64))

if (-not (CommandExists "choco")) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."
    
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    refreshenv
} else {
    Write-Host "Chocolatey is already installed. Skipping installation."
}

$installedXdelta3 = $false

if (-not (Xdelta3Installed)) {
    Write-Host "xdelta3 is not installed. Installing xdelta3..."
    
    choco install xdelta3 -y
    
    $installedXdelta3 = $true
} else {
    Write-Host "xdelta3 is already installed. Skipping installation."
}

if ($installedXdelta3 -and (CommandExists "xdelta3")) {
    Write-Host "xdelta3 installation verified."
} elseif (-not (CommandExists "xdelta3")) {
    Write-Host "xdelta3 installation failed."
    exit 1
}

$fileUrl = "https://releases.arc.net/windows/ArcInstaller.exe"
$outputPath = Join-Path -Path $scriptDirectory -ChildPath "ArcInstaller.exe"

Write-Host "Downloading file from $fileUrl to $outputPath..."
Invoke-WebRequest -Uri $fileUrl -OutFile $outputPath

$expectedMd5 = "f11ec680a74142d3a5ccd89bcf6b99fb"
$actualMd5 = Get-FileMD5 -filePath $outputPath

Write-Host "Expected v1.2.0.0 MD5: $expectedMd5"
Write-Host "Found MD5: $actualMd5"

if ($actualMd5 -eq $expectedMd5) {
    Write-Host "MD5 checksum verification passed."
    $patchedOutputPath = Join-Path -Path $scriptDirectory -ChildPath "patched_output.exe"
    $finalOutputPath = Join-Path -Path $scriptDirectory -ChildPath "ArcInstaller-1.0.0.0.exe"
    & xdelta3 -d -s $outputPath $patchFilePath $patchedOutputPath
    Rename-Item -Path $patchedOutputPath -NewName $finalOutputPath

    $finalExpectedMd5 = "19d292132925e6ddd808e273fd0fea85"
    $finalActualMd5 = Get-FileMD5 -filePath $finalOutputPath

    Write-Host "Expected v1.0.0.0 MD5: $finalExpectedMd5"
    Write-Host "Found MD5: $finalActualMd5"

    if ($finalActualMd5 -eq $finalExpectedMd5) {
        Write-Host "MD5 checksum verification passed for ArcInstaller-1.0.0.0.exe."
        Remove-Item $patchFilePath
        Remove-Item $outputPath
    } else {
        Write-Host "MD5 checksum verification failed for ArcInstaller-1.0.0.0.exe. Expected: $finalExpectedMd5, Got: $finalActualMd5"
        Remove-Item $patchFilePath
        Remove-Item $outputPath
        exit 1
    }
} else {
    Write-Host "MD5 checksum verification failed. Expected: $expectedMd5, Got: $actualMd5"
    Remove-Item $patchFilePath
    Remove-Item $outputPath
    exit 1
}
