Set-Alias -name p -value Ping-Host
Set-Alias -name logged-in -value Get-Logged-In-User
Set-Alias -name my-ip -value Get-My-IP-Address

## Function: p [*hostname] [count]
## Replacement for ping. An optional count parameter can be supplied. If none is given, the ping will run indefinetly. 
function Ping-Host {
	param($computername,$count)
	if($count){
		Test-Connection $computername -count $count
	} else {
		while (1) {
  			Test-Connection $computername -count 1
     			Start-Sleep -seconds 1
		}
	}
	
}

## Function: logged-in [computername]
## Return the current logged-in user of a remote machine.
function Get-Logged-In-User {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)]
		[string[]]$computername
	)
	foreach ($pc in $computername){
		$logged_in = Get-WMIObject -class 
		$name = $logged_in
		"{0}: {1}" -f $pc,$name
	}
}

## Function: my-ip
## Lookup internal and external IP address for local machine.
function Get-My-IP-Address {
	$internal = Get-NetIPAddress -AddressFamily IPv4 | select -Expand IPAddress
	echo "Internal: $internal"
	$external = curl -s ifconfig.me
	echo "External: $external"
}
