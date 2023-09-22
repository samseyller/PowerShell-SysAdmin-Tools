# PowerShell SysAdmin Tools

A collection of useful PowerShell functions contained in **sysadmin-tools.psm1**. These functions can be loaded automatically when you start PowerShell by adding the follwing line to your PowerShell profle.

    Import-Module -Name C:\location\to\file\sysadmin-tools.psm1

To locate your PowerShell Profle, you can run the following command:

    $Profile

## Included Functions

### (P)ing

A replacemnt for ping. An optional count parameter can be supplied. If none is given, the ping will run indefinetly.

Usage:

    p [hostname*] [count]

### Logged In

Retrieves the current logged in user from a remote computer.

Usage:

    logged-in [computername]

### My IP

Lookup internal and external IP address for local machine. Can return multiple internal IP addresses if multiple interfaces are present. External IP is returned from an external website.

Usage:

    my-ip

**An asterisk indicates a mandatory parameter of a function*
