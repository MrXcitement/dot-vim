# install.ps1 -- Install the git config files

# Mike Barker <mike@thebarkers.com>
# November 8th, 2021

# Install-Item - Install a file/folder to the user's home folder
Function Install-Item([string]$source, [string]$target) {

    # Backup the source file/folder, if it exists and is not a link
    if ((Test-Path $source) -And (-Not (Test-SymbolicLink $source))) {
        # backup the file/folder
        Write-Warning "Backup $($source) $($source).backup"
        Move-Item -Path $source -Destination "$($source).backup"
    }

    # Create a symlink to the target file/folder, if it does not exist
    if (-Not (Test-Path $source)) {
        Write-Output "Linking: $($source) to $($target)"
        New-SymbolicLink $source $target | Out-Null
    }
}

# New-SymbolicLink - Create a new symbolic link file
Function New-SymbolicLink([string]$link, [string]$target) {
    New-Item -ItemType SymbolicLink -Path $link -Value $target -Force
}

# Test-Elevated - Test if the current powershell session is being run with elevated permisions
Function Test-Elevated() {
    return [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'
}

# Test-SymbolicLink - Test if the path is a symbolic link file
Function Test-SymbolicLink([string]$path) {
    $file = Get-Item $path -Force -ea SilentlyContinue
    Return [bool]($file.LinkType -eq "SymbolicLink")
}

# Verify the script is being run with elevated permisions
if (-Not (Test-Elevated)) {
    throw "This script must be run 'Elevated' as an Administrator"
}

# Install file/folders to users home directory
Install-Item "$($env:userprofile)\.vimrc" "$($PSScriptRoot)\home\.vimrc"
Install-Item "$($env:userprofile)\.vim" "$($PSScriptRoot)\home\.vim"
Install-Item "$($env:userprofile)\_vimrc" "$($PSScriptRoot)\home\.vimrc"
Install-Item "$($env:userprofile)\vimfiles" "$($PSScriptRoot)\home\.vim"

# Git clone and install the Vundle plugin manager
$bundle_path = "$Env:USERPROFILE\vimfiles\bundle"
if (-Not (Test-Path $bundle_path)) {
    git clone "https://github.com/VundleVim/Vundle.vim.git" "$($bundle_path)\Vundle.vim"
    $vim_installed = [bool] (Get-Command -ErrorAction Ignore -Type Application vim)
    if ($vim_installed) {
        vim +PluginInstall +qall
    }
}
