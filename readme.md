# PowerShell SysAdmin Tools

A collection of useful PowerShell functions contained in **sysadmin-tools.psm1**. These functions can be loaded automatically when you start PowerShell by adding the follwing line to your PowerShell profle.

    Import-Module -Name C:\location\to\file\sysadmin-tools.psm1

To locate your PowerShell Profle, you can run the following command:

    $Profile

## Included Functions

### dir-size

Calculates the size of a directory, including all sub-folders and sub-files. Prints in human-readable figures such as 123.45 GB or 35.79 MB. Optinally, you may use the -bytes flag to return the raw size in bytes.

Usage:

    dir-size [path]

### (P)ing

A replacemnt for ping. An optional count parameter can be supplied. If none is given, the ping will run indefinetly.

Usage:

    p [hostname] [count*]

### Logged In

Retrieves the current logged in user from a remote computer.

Usage:

    logged-in [computername]

### My IP

Lookup internal and external IP address for local machine. Can return multiple internal IP addresses if multiple interfaces are present. External IP is returned from an external website.

Usage:

    my-ip

**An asterisk indicates an optional parameter of a function*
