param(
    [string]$SourceDir = (Join-Path $PSScriptRoot "..\..\gfx\interface\counters\divisions_large"),
    [string]$OutputDir = (Join-Path $PSScriptRoot "output"),
    [string]$Filter = "Rance_JAP_M*.png",
    [int]$ExpectedWidth = 152,
    [int]$ExpectedHeight = 42,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$resolvedSourceDir = [System.IO.Path]::GetFullPath($SourceDir)
$resolvedOutputDir = [System.IO.Path]::GetFullPath($OutputDir)

if (-not (Test-Path -LiteralPath $resolvedSourceDir -PathType Container)) {
    throw "Source directory does not exist: $resolvedSourceDir"
}

if ($ExpectedWidth -le 0 -or $ExpectedHeight -le 0) {
    throw "ExpectedWidth and ExpectedHeight must be positive."
}

New-Item -ItemType Directory -Force -Path $resolvedOutputDir | Out-Null

$images = Get-ChildItem -LiteralPath $resolvedSourceDir -File -Filter $Filter | Sort-Object Name

if ($images.Count -eq 0) {
    throw "No source images matched '$Filter' in $resolvedSourceDir"
}

foreach ($image in $images) {
    $outputPath = Join-Path $resolvedOutputDir $image.Name

    if ((Test-Path -LiteralPath $outputPath) -and -not $Force) {
        Write-Host "Skipped existing output: $outputPath"
        continue
    }

    $sourceImage = [System.Drawing.Image]::FromFile($image.FullName)
    $leftHalf = $null
    $graphics = $null

    try {
        if ($sourceImage.Width -ne $ExpectedWidth -or $sourceImage.Height -ne $ExpectedHeight) {
            throw "Unexpected image size for $($image.FullName): $($sourceImage.Width)x$($sourceImage.Height), expected ${ExpectedWidth}x${ExpectedHeight}"
        }

        $targetWidth = [int]($sourceImage.Width / 2)
        $targetHeight = $sourceImage.Height
        $leftHalf = New-Object System.Drawing.Bitmap($targetWidth, $targetHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        $graphics = [System.Drawing.Graphics]::FromImage($leftHalf)

        $sourceRect = New-Object System.Drawing.Rectangle(0, 0, $targetWidth, $targetHeight)
        $targetRect = New-Object System.Drawing.Rectangle(0, 0, $targetWidth, $targetHeight)
        $graphics.DrawImage($sourceImage, $targetRect, $sourceRect, [System.Drawing.GraphicsUnit]::Pixel)

        $leftHalf.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        Write-Host "Wrote: $outputPath"
    }
    finally {
        if ($null -ne $graphics) {
            $graphics.Dispose()
        }
        if ($null -ne $leftHalf) {
            $leftHalf.Dispose()
        }
        $sourceImage.Dispose()
    }
}
