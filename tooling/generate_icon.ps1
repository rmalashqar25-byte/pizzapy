Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$master = New-Object System.Drawing.Bitmap 1024, 1024
$g = [System.Drawing.Graphics]::FromImage($master)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear([System.Drawing.Color]::FromArgb(217, 54, 43))

$yellow = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 211, 90))
$white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
$g.FillEllipse($yellow, 764, 92, 148, 148)
$font = New-Object System.Drawing.Font('Arial', 465, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$format = New-Object System.Drawing.StringFormat
$format.Alignment = [System.Drawing.StringAlignment]::Center
$format.LineAlignment = [System.Drawing.StringAlignment]::Center
$g.DrawString('Py', $font, $white, (New-Object System.Drawing.RectangleF(0, 0, 1024, 1024)), $format)

function Save-Icon([string]$path, [int]$size) {
    $image = New-Object System.Drawing.Bitmap $size, $size
    $graphics = [System.Drawing.Graphics]::FromImage($image)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.DrawImage($master, 0, 0, $size, $size)
    $image.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $image.Dispose()
}

$android = @{
    'mipmap-mdpi' = 48
    'mipmap-hdpi' = 72
    'mipmap-xhdpi' = 96
    'mipmap-xxhdpi' = 144
    'mipmap-xxxhdpi' = 192
}
foreach ($density in $android.Keys) {
    Save-Icon (Join-Path $root "android/app/src/main/res/$density/ic_launcher.png") $android[$density]
}

$ios = Join-Path $root 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
Get-ChildItem $ios -Filter 'Icon-App-*.png' | ForEach-Object {
    if ($_.Name -match 'Icon-App-([0-9.]+)x[0-9.]+@([0-9]+)x.png') {
        $size = [int]([double]$Matches[1] * [int]$Matches[2])
        Save-Icon $_.FullName $size
    }
}

Save-Icon (Join-Path $root 'web/icons/Icon-192.png') 192
Save-Icon (Join-Path $root 'web/icons/Icon-512.png') 512
Save-Icon (Join-Path $root 'web/icons/Icon-maskable-192.png') 192
Save-Icon (Join-Path $root 'web/icons/Icon-maskable-512.png') 512
Save-Icon (Join-Path $root 'web/favicon.png') 32

$font.Dispose()
$yellow.Dispose()
$white.Dispose()
$g.Dispose()
$master.Dispose()
