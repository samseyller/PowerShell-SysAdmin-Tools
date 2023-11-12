# Function Alias Definitions
Set-Alias -name dir-size -value Get-Directory-Size
Set-Alias -name p -value Ping-Host
Set-Alias -name logged-in -value Get-Logged-In-User
Set-Alias -name my-ip -value Get-My-IP-Address
Set-Alias -name welcome -value Get-Welcome-Message

## Input your name for the welcome script
$myName = ""

## Default window title for your terminal 
$default_window_title = "PowerShell "+$host.Version

# Customizes the appearance of the PowerShell Prompt. Adjust the variables below to change how the path is displayed, the prompt symbol, and the colors. 
function prompt {
	# BEGIN CUSTOMIZATION #
	$CustomizePrompt = 1 	# Set this value to '0' if you do not want the prompt to be customized. 
	$CurrentFolderOnly = 0 	# Set to "0" to print full path. Set to "1" to print current folder only. 
	$ReplaceHomeDir = 1		# Set to "1" to replace the user's home directory with a symbol. 
	$HomeDirSymbol = "~"		# Choose the symbol to represent the user's home directory
	$PathColor = "DarkGray" 	# Choose the color for the path. 
	$PromptSymbol = ">"		# Choose the symbol that follows the path.
	$PromptSymbolColor = "Green" 	# Choose the color of this symbol. 
	# END CUSTOMIZATION #

	# Return null if we do not want the prompt to be modified. 
	if(! $CustomizePrompt){
		return $Null
	}

	# Initialize PromptPath
	$PromptPath = "$PWD"

	# Replaces the user's home directory path with a symbol, if set above
	if($ReplaceHomeDir){
		if($PromptPath -like "$HOME*"){
			$PromptPath = $PromptPath -replace [regex]::Escape($HOME), $HomeDirSymbol
		}
	}

	# Displays only the current folder from the path, if set above
	if($CurrentFolderOnly){
		$PromptPath = "$PromptPath".Split('\')[-1]
	}

	# Write the prompt path
	Write-Host $PromptPath -NoNewline -ForegroundColor $PathColor
	# Write the prompt symbol
	Write-Host $PromptSymbol -NoNewline -ForegroundColor $PromptSymbolColor
	return " "
}

## Convert file sizes into human readable format
function Format-FileSize {
    param (
        [float]$size
    )
    $units = "B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
    $index = 0
    while ($size -ge 1024 -and $index -lt $units.Length) {
        $size /= 1024
        $index++
    }
    return "{0:N2} {1}" -f $size, $units[$index]
}

## dir-size [*path]
## Calculate the size of a directory, including all sub-files and folders.
function Get-Directory-Size {
	param ([string]$path,[switch]$bytes,[switch]$NoRecurse)
	
	if($NoRecurse){
		$size = (Get-ChildItem -Force $path | Measure-Object -Property Length -Sum).Sum
	} else {
		$size = (Get-ChildItem -Recurse -Force $path | Measure-Object -Property Length -Sum).Sum
	}
		
	if($bytes){
		Write-Host $size
	} else {
		Write-Host (Format-FileSize $size)
	}
}

## Function: p [*hostname] [count]
## Replacement for ping. An optional count parameter can be supplied. If none is given, the ping will run indefinetly. 
function Ping-Host {
	param($computername,$count)
	$host.ui.rawui.windowtitle="Pinging: "+ $computername
	if($count){
		for($c=1; $c -le $count; $c++){
			Ping-Host-Worker $computername
			if($c -ne $count) {Start-Sleep -seconds 1}
			if([System.Console]::KeyAvailable){break}			# Break if user presses any key
		}
	} else {
		do {
			Ping-Host-Worker $computername
			Start-Sleep -seconds 1
		} until ([System.Console]::KeyAvailable)				# Stop if user presses any key
	}
	$host.ui.rawui.windowtitle=$default_window_title
}

function Ping-Host-Worker($computername) {
	$PingSuccessSymbol = "`u{1F7E2}"	# Green Circle
	$PingFailSymbol = "`u{1F534}"		# Red Circle
	try {
		$test = Test-Connection $computername -ErrorAction Stop -count 1					# Ping Function
		$test | Select-Object Address,Latency,Status										# Ping Output Displayed
		
		if($test[0].status -eq "Success"){
			$host.ui.rawui.windowtitle= $PingSuccessSymbol+" Pinging: "+ $computername     	# Update Window Title
		} else {
			$host.ui.rawui.windowtitle= $PingFailSymbol+" Pinging: "+ $computername     	# Update Window Title
		}
	}
	catch [System.Net.NetworkInformation.PingException]{
		Write-Host $_.Exception.Message -ForegroundColor Red							# Display Exception
		$host.ui.rawui.windowtitle= $PingFailSymbol+" Pinging: "+ $computername     	# Update Window Title
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
		$logged_in = (Get-WMIObject win32_computersystem -COMPUTER $pc).username	# Retrieves the username of the remote user
		$name = $logged_in.split("\")[1]											# Strips the domain prefix from the username
		"{0}: {1}" -f $pc,$name														# Prints the PC and Username
	}
}


## Function: my-ip
## Lookup internal and external IP address for local machine.
function Get-My-IP-Address {
	# Look up internal IP addresses using Get-NetIPAddress
	$internal = Get-NetIPAddress -AddressFamily IPv4 | Select-Object -Expand IPAddress
	Write-Host "Internal: $internal"
	# Look up external IP addresses by querying ifconfig.me
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
