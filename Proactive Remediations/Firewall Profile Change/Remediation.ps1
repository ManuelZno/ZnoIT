Start-Transcript -Path C:\Windows\Logs\Software\SetCreatonNetworksPrivate.log -Append

$WLANName = "EnterNameHere"
$LANName = "EnterNameHere"


$WLAN = Get-NetAdapter -Physical | Where-Object {$_.PhysicalMediaType -eq 'Native 802.11' -or $_.PhysicalMediaType -eq 'Wireless LAN' -or $_.PhysicalMediaType -eq 'Wireless WAN'}
Write-Output "WLAN Connection:"
$WLAN

$LAN = Get-NetAdapter -Physical | Where-Object {$_.PhysicalMediaType -eq '802.3'}

Write-Output ""
Write-Output "LAN Connection:"
$LAN

Write-Output "Check which connection is up"

if($WLAN.Status -eq 'Up')
{
    Write-Output "WLAN in up."

    Write-Output "Get the Netconnection profile"
    $Profile = Get-NetConnectionProfile

    Write-Output "Profile Info for WLAN:"
    $Profile

    Write-Output "Only Change Network Info if Name = '$WLANName'"

    If($Profile.Name -contains $WLANName) {
        if($Profile.NetworkCategory -eq 'Private') {
            Write-Output "Profile $($Profile.Name) is already Private."
        } else {
            Write-Output "Setting Profile to Private."
            Set-NetConnectionProfile -InterfaceIndex $Profile.InterfaceIndex -NetworkCategory Private
        }        
    }
}
else
{
    Write-Output "WLAN is not up."
}

if($LAN.Status -eq 'Up')
{
    Write-Output "LAN in up."
    Write-Output "Get the Netconnection profile"
    $Profile = Get-NetConnectionProfile

    Write-Output "Profile Info for LAN:"
    $Profile

    Write-Output "Only Change Network Info if Name = '$LANName'"

    If($Profile.Name -Contains $LANName) {
        if($Profile.NetworkCategory -eq 'Private') {
            Write-Output "Profile $($Profile.Name) is already Private."
        } else {
            Write-Output "Setting Profile to Private."
            Set-NetConnectionProfile -InterfaceIndex $Profile.InterfaceIndex -NetworkCategory Private
        }        
    }
}
else
{
    Write-Output "LAN is not up."
}

Stop-Transcript