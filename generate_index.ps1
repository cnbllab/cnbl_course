# Script to generate certificates.js from the folder structure

# Check if user pasted "Certificates" folder inside "certificates" folder
if (Test-Path ".\certificates\Certificates") {
    $rootPath = ".\certificates\Certificates"
    $webRoot = "certificates/Certificates"
}
else {
    $rootPath = ".\certificates"
    $webRoot = "certificates"
}

$outputFile = ".\certificates.js"

# Check if certificates folder exists
if (-not (Test-Path $rootPath)) {
    Write-Host "Error: '$rootPath' folder not found. Please create it and add certificates first." -ForegroundColor Red
    exit
}

# Start the JS file content
$jsContent = "// Auto-generated certificate data`n"
$jsContent += "const participants = [`n"

# Function to process files
function Process-Directory ($dirName, $categoryName) {
    $dirPath = Join-Path $rootPath $dirName
    if (Test-Path $dirPath) {
        $files = Get-ChildItem -Path $dirPath -Filter *.pdf
        foreach ($file in $files) {
            $name = $file.BaseName
            # Escape backslashes for JS strings and ensure forward slashes for URLs
            $relativePath = "$webRoot/$dirName/" + $file.Name
            
            # Add to JS content
            $global:jsContent += "    { name: `"$name`", category: `"$categoryName`", file: `"$relativePath`" },`n"
        }
        Write-Host "Processed $($files.Count) certificates in $categoryName" -ForegroundColor Green
    }
    else {
        Write-Host "Warning: Directory '$dirName' not found in $rootPath" -ForegroundColor Yellow
    }
}

# Process each category
Process-Directory "Offline_Partcipants" "Offline Participant"
Process-Directory "Online_Partcipants" "Online Participant"
Process-Directory "Speakers" "Speaker"
Process-Directory "Volunteers" "Volunteer"

# Close the array and add standard logic
$jsContent += "];`n`n"
$jsContent += "const searchInput = document.getElementById('searchInput');`n"
$jsContent += "const resultsContainer = document.getElementById('resultsContainer');`n`n"

$jsContent += "searchInput.addEventListener('input', function(e) {`n"
$jsContent += "    const query = e.target.value.toLowerCase().trim();`n"
$jsContent += "    `n"
$jsContent += "    if (query.length < 2) {`n"
$jsContent += "        resultsContainer.innerHTML = '<p class=`"no-results`">Start typing to search for your certificate...</p>';`n"
$jsContent += "        return;`n"
$jsContent += "    }`n`n"

$jsContent += "    const filtered = participants.filter(person => `n"
$jsContent += "        person.name.toLowerCase().includes(query)`n"
$jsContent += "    );`n`n"

$jsContent += "    displayResults(filtered);`n"
$jsContent += "});`n`n"

$jsContent += "function displayResults(results) {`n"
$jsContent += "    if (results.length === 0) {`n"
$jsContent += "        resultsContainer.innerHTML = '<p class=`"no-results`">No certificates found matching that name.</p>';`n"
$jsContent += "        return;`n"
$jsContent += "    }`n`n"

# Use backtick here for JS template literal
$jsContent += "    const html = results.map(person => ``" + "`n"
$jsContent += "        <div class=`"cert-item`">`n"
$jsContent += "            <div class=`"cert-info`">`n"
$jsContent += "                <h4>`${person.name}</h4>`n"
$jsContent += "                <span>`${person.category}</span>`n"
$jsContent += "            </div>`n"
$jsContent += "            <a href=`"`${person.file}`" download class=`"download-btn`">`n"
$jsContent += "                <i class=`"fas fa-download`"></i> Download`n"
$jsContent += "            </a>`n"
$jsContent += "        </div>`n"
$jsContent += "    ``).join('');`n`n"

$jsContent += "    resultsContainer.innerHTML = html;`n"
$jsContent += "}`n"

# Write to file
Set-Content -Path $outputFile -Value $jsContent -Encoding UTF8
Write-Host "Successfully generated '$outputFile'" -ForegroundColor Cyan
