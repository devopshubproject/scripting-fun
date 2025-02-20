# Variables
# Prompt user for inputs
$SiteName = Read-Host "Enter the IIS Website Name"
$SitePath = "C:\inetpub\wwwroot\$SiteName"
$BindingHost = Read-Host "Enter the Hostname (e.g., ladvik.local)"
$BindingPort = Read-Host "Enter the Port (default: 443)" -Default 443
$SSLThumbprint = Read-Host "Enter the SSL Certificate Thumbprint"

# Install IIS if not installed
if (-not (Get-WindowsFeature -Name Web-Server).Installed) {
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
}

# Create site folder if it doesn't exist
if (!(Test-Path -Path $SitePath)) {
    New-Item -ItemType Directory -Path $SitePath -Force
}

# Copy deployment files (update source path accordingly)
Copy-Item -Path "C:\DeploymentSource\*" -Destination $SitePath -Recurse -Force

# Check if the website exists, if not, create it
if (-not (Get-WebSite -Name $SiteName -ErrorAction SilentlyContinue)) {
    New-WebSite -Name $SiteName -PhysicalPath $SitePath -Port $BindingPort -HostHeader $BindingHost
} else {
    Write-Host "Website '$SiteName' already exists. Skipping creation."
}

# Configure SSL binding
$existingBinding = Get-WebBinding -Name $SiteName -Protocol https -ErrorAction SilentlyContinue
if (!$existingBinding) {
    New-WebBinding -Name $SiteName -IPAddress "*" -Port $BindingPort -HostHeader $BindingHost -Protocol https
    New-ItemProperty "IIS:\SslBindings\0.0.0.0!$BindingPort!$BindingHost" -Name CertificateThumbprint -Value $SSLThumbprint -PropertyType String -Force
}

# Restart IIS site
Restart-WebAppPool -Name $SiteName
Start-WebSite -Name $SiteName

Write-Host "IIS Website Deployment Completed: $SiteName"
