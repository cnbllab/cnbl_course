$file = "index.html"
if (Test-Path $file) {
    $content = Get-Content $file -Raw
    if ($content -notmatch "gallery.js") {
        $content = $content -replace "</body>", "<script src='gallery.js'></script>`n</body>"
        Set-Content $file $content -Encoding UTF8
        Write-Host "Injected gallery script tag." -ForegroundColor Green
    }
    else {
        Write-Host "Script tag already present." -ForegroundColor Yellow
    }
}
else {
    Write-Host "index.html not found!" -ForegroundColor Red
}
