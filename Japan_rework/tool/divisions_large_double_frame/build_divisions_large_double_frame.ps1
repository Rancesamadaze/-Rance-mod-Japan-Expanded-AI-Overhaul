param(
    [string]$SourceDir = $PSScriptRoot,
    [string]$OutputDir = (Join-Path $PSScriptRoot "output"),
    [int]$FrameWidth = 0,
    [int]$FrameHeight = 0,
    [double]$Brightness = 1.18,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

function Copy-Frame {
    param(
        [System.Drawing.Bitmap]$Source,
        [System.Drawing.Bitmap]$Target,
        [int]$OffsetX,
        [double]$BrightnessMultiplier
    )

    for ($y = 0; $y -lt $Source.Height; $y++) {
        for ($x = 0; $x -lt $Source.Width; $x++) {
            $pixel = $Source.GetPixel($x, $y)
            $red = [Math]::Min(255, [int][Math]::Round($pixel.R * $BrightnessMultiplier))
            $green = [Math]::Min(255, [int][Math]::Round($pixel.G * $BrightnessMultiplier))
            $blue = [Math]::Min(255, [int][Math]::Round($pixel.B * $BrightnessMultiplier))
            $targetPixel = [System.Drawing.Color]::FromArgb($pixel.A, $red, $green, $blue)
            $Target.SetPixel($x + $OffsetX, $y, $targetPixel)
        }
    }
}

function Resize-Nearest {
    param(
        [System.Drawing.Image]$Image,
        [int]$Width,
        [int]$Height
    )

    $resized = New-Object System.Drawing.Bitmap($Width, $Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($resized)
    try {
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighSpeed
        $graphics.DrawImage($Image, 0, 0, $Width, $Height)
    }
    finally {
        $graphics.Dispose()
    }

    return $resized
}

$resolvedSourceDir = [System.IO.Path]::GetFullPath($SourceDir)
$resolvedOutputDir = [System.IO.Path]::GetFullPath($OutputDir)

if (-not (Test-Path -LiteralPath $resolvedSourceDir -PathType Container)) {
    throw "Source directory does not exist: $resolvedSourceDir"
}

if (($FrameWidth -lt 0) -or ($FrameHeight -lt 0)) {
    throw "FrameWidth and FrameHeight must be positive, or 0 to use each source image's size."
}

if (($FrameWidth -eq 0) -xor ($FrameHeight -eq 0)) {
    throw "FrameWidth and FrameHeight must be set together. Use 0 for both to keep each source image's size."
}

New-Item -ItemType Directory -Force -Path $resolvedOutputDir | Out-Null

$images = Get-ChildItem -LiteralPath $resolvedSourceDir -File -Filter "*.png" |
    Where-Object { $_.FullName -notlike (Join-Path $resolvedOutputDir "*") }

foreach ($image in $images) {
    $outputName = $image.Name -replace "_left_half_4x(?=\.png$)", ""
    $outputPath = Join-Path $resolvedOutputDir $outputName

    if ((Test-Path -LiteralPath $outputPath) -and -not $Force) {
        Write-Host "Skipped existing output: $outputPath"
        continue
    }

    $sourceImage = [System.Drawing.Image]::FromFile($image.FullName)
    $frame = $null
    $doubleFrame = $null

    try {
        $targetFrameWidth = $FrameWidth
        $targetFrameHeight = $FrameHeight

        if ($targetFrameWidth -eq 0 -and $targetFrameHeight -eq 0) {
            $targetFrameWidth = $sourceImage.Width
            $targetFrameHeight = $sourceImage.Height
        }

        if ($sourceImage.Width -eq $targetFrameWidth -and $sourceImage.Height -eq $targetFrameHeight) {
            $frame = New-Object System.Drawing.Bitmap($sourceImage)
        }
        else {
            $frame = Resize-Nearest -Image $sourceImage -Width $targetFrameWidth -Height $targetFrameHeight
            Write-Host "Resized frame to ${targetFrameWidth}x${targetFrameHeight}: $($image.FullName)"
        }

        $targetWidth = $targetFrameWidth * 2
        $targetHeight = $targetFrameHeight
        $doubleFrame = New-Object System.Drawing.Bitmap($targetWidth, $targetHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        Copy-Frame -Source $frame -Target $doubleFrame -OffsetX 0 -BrightnessMultiplier 1.0
        Copy-Frame -Source $frame -Target $doubleFrame -OffsetX $targetFrameWidth -BrightnessMultiplier $Brightness

        $doubleFrame.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        Write-Host "Wrote: $outputPath"
    }
    finally {
        if ($null -ne $doubleFrame) {
            $doubleFrame.Dispose()
        }
        if ($null -ne $frame) {
            $frame.Dispose()
        }
        $sourceImage.Dispose()
    }
}
