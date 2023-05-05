$ErrorActionPreference = "Stop"

function checkPublishable() {
    param(
        [Parameter(Mandatory)]
        [String]$PackageName,
        [Parameter(Mandatory)]
        [String]$PackageVersion
    )

    $publishedVersions = $(npm info $PackageName versions | ConvertFrom-JSON)
    return !($publishedVersions -contains $PackageVersion)
}

# Install package first
npm i --ignore-scripts

# Check if there are uncommitted changes
$fileNum = git status --porcelain
if($fileNum.length -gt 0)
{
    echo "Commit changes, first!"
    return $false
}

# Get package name and version that are going to be published
$packageName = (Get-Content package.json) -join "`n" | ConvertFrom-Json | Select -ExpandProperty "name"
$version = (Get-Content package.json) -join "`n" | ConvertFrom-Json | Select -ExpandProperty "version"

# Get existing versions of the package
if(!(checkPublishable -PackageName $PackageName -PackageVersion $Version)) {
    Write-Host "$PackageName version $Version has already been published"
    return $false
}

# Check if build passes.
./Build.ps1 -InstallPath .
$status = $LASTEXITCODE
./Build.ps1 -InstallPath . -Release -Addon
$status = $status -or $LASTEXITCODE
if($status -ne 0)
{
    echo "Build failed. Please fix the errors and try again."
    return $false
}

# If tag and package version are valid, then tag it
$tag = "v$Version"
git tag $tag -m "Version $Version"
git push origin --tags
npm publish

return $true
