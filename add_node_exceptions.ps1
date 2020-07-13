If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}

Write-Host "Excluding appdata NPM folder and Node.JS install folder from Windows Defender."
Add-MpPreference -ExclusionPath ([System.Environment]::ExpandEnvironmentVariables("%APPDATA%\npm\"))
Add-MpPreference -ExclusionPath (Get-ItemProperty "HKLM:SOFTWARE\Node.js" | Select-Object -Property InstallPath)

Write-Host "Excluding node related executables from Windows Defender."
# TODO: Clean up. Do I need .exe? Do I need full path? Can't find a real answer. Brute forcing works though the security risk is real.
# Maybe don't run this in an enterprise environment. Fork if you have a good answer :)
("node", "node.exe", "Expo XDE.exe", "yarn", "yarn.exe") | foreach { Add-MpPreference -ExclusionProcess $_ }
