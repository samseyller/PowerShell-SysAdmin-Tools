# Function Alias Definitions
Set-Alias -name p -value Ping-Host
Set-Alias -name logged-in -value Get-Logged-In-User
Set-Alias -name my-ip -value Get-My-IP-Address
Set-Alias -name welcome -value Get-Welcome-Message

## Input your name for the welcome script
$myName = ""

## Default window title for your terminal 
$default_window_title = "PowerShell "+$host.Version


## Function: p [*hostname] [count]
## Replacement for ping. An optional count parameter can be supplied. If none is given, the ping will run indefinetly. 
function Ping-Host {
	param($computername,$count)
	$host.ui.rawui.windowtitle="Pinging: "+ $computername
	if($count){
		Test-Connection $computername -count $count
		$host.ui.rawui.windowtitle=$default_window_title
	} else {
		do {
			Ping-Host-Worker $computername 1
			Start-Sleep -seconds 1
		} until ([System.Console]::KeyAvailable)
		$host.ui.rawui.windowtitle=$default_window_title
	}
}

function Ping-Host-Worker($computername,$count) {
	try {
		$test = Test-Connection $computername -ErrorAction Stop -count $count
		$test
		if($test[0].status -eq "Success"){
			# $host.ui.rawui.windowtitle= "`u{1F600} Pinging: "+ $computername         # Happy Face
			$host.ui.rawui.windowtitle= "`u{1F7E2} Pinging: "+ $computername     # Green Circle
		} else {
			# $host.ui.rawui.windowtitle= "`u{1F620} Pinging: "+ $computername     # Angry Face
			$host.ui.rawui.windowtitle= "`u{1F534} Pinging: "+ $computername         # Red Circle
		}
	}
	catch [System.Net.NetworkInformation.PingException]{
		Write-Host "`u{1F534}" $_.Exception.Message
		# $host.ui.rawui.windowtitle= "`u{1F620} Pinging: "+ $computername     # Angry Face
		$host.ui.rawui.windowtitle= "`u{1F534} Pinging: "+ $computername         # Red Circle
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
	$internal = Get-NetIPAddress -AddressFamily IPv4 | Select-Object -Expand IPAddress
	Write-Host "Internal: $internal"
	$external = curl -s ifconfig.me
	Write-Host "External: $external"
}


## Function welcome
## Prints a welcome message dependant on the time of day. 
function Get-Welcome-Message {
	$currentTime = Get-Date
	$hour = $currentTime.Hour

	if ($hour -lt 12) {
		if($myName){Write-Host "Good morning, $myName!"}else{Write-Host "Good morning!"}
	} elseif ($hour -ge 12 -and $hour -lt 18) {
		if($myName){Write-Host "Good afternoon, $myName!"}else{Write-Host "Good afternoon!"}
	} else {
		if($myName){Write-Host "Good evening, $myName!"}else{Write-Host "Good evening!"}
	}
}


## Set Window Title 
$host.ui.rawui.windowtitle=$default_window_title

## Print Welcome Message
Get-Welcome-Message
