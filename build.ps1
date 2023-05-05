<# .SYNOPSIS #>
param (
    # Path to install build files to
    [String]$InstallPath = "$(Get-Location)/output",
    # Build in realease mode
    [Switch]$Release = $false,
    # Clean cmake cache
    [Switch]$Clean = $false
)

function CmakeOption {
    param (
        [Parameter(Mandatory, HelpMessage = 'Specify an option to convert')]
        $option
    )
    if ($option) { return "ON" }
    return "OFF"
}

function toUnixPath {
    param (
        [Parameter(ValueFromPipeline, Mandatory, HelpMessage = 'Specify a path to convert')]
        [String]
        $Path
    )

    return $path -Replace '\\','/'
}

$BuildDir = "$PSScriptRoot/build"

if ($Clean) {
    if (Test-Path -Path $BuildDir) { Remove-Item -Recurse -Force $BuildDir }
    if (Test-Path -Path "$InstallPath/Release") { Remove-Item -Recurse -Force -Path "$InstallPath/Release" }
    if (Test-Path -Path "$InstallPath/Debug") { Remove-Item -Recurse -Force -Path "$InstallPath/Debug" }
}

$BuildType = if ($Release) { "Release" } else { "Debug" }

cmake -S $PSScriptRoot -B "$BuildDir/$buildType" -G Ninja -DCMAKE_INSTALL_PREFIX="$InstallPath/$buildType" `
    -DCMAKE_BUILD_TYPE="$BuildType"
cmake --build "$BuildDir/$BuildType" --config $BuildType --target install

return $LASTEXITCODE
