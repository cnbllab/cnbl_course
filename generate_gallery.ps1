# Script to generate gallery.js from the 'gallery' folder
# UPDATED for Slideshow/Carousel version using external template

$galleryPath = ".\gallery"
$jsFile = ".\gallery.js"
$templateFile = ".\gallery.template.js"

# Check if gallery folder exists
if (-not (Test-Path $galleryPath)) {
    Write-Host "Error: 'gallery' folder not found." -ForegroundColor Red
    exit
}

# Check if template file exists
if (-not (Test-Path $templateFile)) {
    Write-Host "Error: 'gallery.template.js' not found." -ForegroundColor Red
    exit
}

# Generate the new array from files
$newArrayContent = "// Auto-generated gallery data`n"
$newArrayContent += "// Generated on $(Get-Date)`n"
$newArrayContent += "const galleryImages = [`n"

$files = Get-ChildItem -Path $galleryPath -Include *.jpg, *.jpeg, *.png, *.gif -Recurse
foreach ($file in $files) {
    $relativePath = "gallery/" + $file.Name
    $caption = $file.BaseName
    $newArrayContent += "    { src: `"$relativePath`", caption: `"$caption`" },`n"
}

$newArrayContent += "];`n`n"

# API to read template
$logicContent = Get-Content -Path $templateFile -Raw

# Combine and write
$finalContent = $newArrayContent + $logicContent
Set-Content -Path $jsFile -Value $finalContent -Encoding UTF8

Write-Host "Successfully updated gallery.js with $($files.Count) images (Slideshow Mode)." -ForegroundColor Cyan
