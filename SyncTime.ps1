chcp 65001 > $null
# Set UTF-8 output encoding to display emojis correctly
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ⚠️ Ensure script runs with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Host "❗ Please run this script as Administrator."
    exit
}

# 🕒 Step 1: Run w32tm /stripchart and collect the output
$ntpServer = "time.windows.com"
Write-Host "🌐 Querying NTP server: $ntpServer..."
$output = w32tm /stripchart /computer:$ntpServer /samples:1 /dataonly

# 🔍 Step 2: Parse the offset value from the output
$offsetLine = $output | Select-String -Pattern "^\d{2}:\d{2}:\d{2},\s+[+-]\d+\.\d+"
if (-not $offsetLine) {
    Write-Host "❌ Offset line not found. Check NTP server connectivity or output format."
    exit
}

$offsetValue = ($offsetLine -split ",\s*")[1] -replace "s", ""
$offsetSeconds = [double]$offsetValue

Write-Host "🧮 Offset value: $offsetSeconds seconds"

# 🧭 Step 3: Calculate the new system time and set it
$currentTime = Get-Date
$newTime = $currentTime.AddSeconds($offsetSeconds)

Write-Host "🕑 Current system time: $currentTime"
Write-Host "⏩ New adjusted time:   $newTime"

try {
    Set-Date -Date $newTime
    Write-Host "✅ System time updated successfully!"
}
catch {
    Write-Host "❌ Failed to set system time. Are you running as Administrator?"
}
