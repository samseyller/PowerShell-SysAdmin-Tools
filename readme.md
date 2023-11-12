# PowerShell SysAdmin Tools

A collection of useful PowerShell functions contained in **sysadmin-tools.psm1**. These functions can be loaded automatically when you start PowerShell by adding the follwing line to your PowerShell profle.

    Import-Module -Name C:\location\to\file\sysadmin-tools.psm1

To locate your PowerShell Profle, you can run the following command:

    $Profile

Alternatively, you may copy individual functions into your Profile as desired.

## PowerShell Terminal Personalization

### Welcome Script

Displays a welcome message when the prompt is opened. The message will adjust based on the current time of day. If you would like to be greeted by name, find the following line and enter your name:

    $myName = ""

### Terminal Window Title

Adjusts the text displayed in the Title of the Terminal Window. By default, it will display the current version of PowerShell. The following line can be adjusted to display whatever you would like:

    $default_window_title = "PowerShell "+$host.Version

### Customized Prompt

By default, the PowerShell prompt displays "PS", the current path, and the ">" symbol. The prompt function in **sysadmin-tools.psm1** will override this default behavior, allowing the prompt to be customized.

By adjusting the variables found in the **prompt** function, you can customize the appearance of the prompt in the following ways:

+ Set **$CustomizePrompt** to toggle all customizations on/off.
+ Set **$CurrentFolderOnly** to toggle whether the full path or just the current directory is displayed.
+ Set **$ReplaceHomeDir** to determine if the user's home directory path will be displayed as a symbol.
+ **$HomeDirSymbol** - Choose the symbol that will be displayed if $ReplaceHomeDir=1
+ **$PathColor** - Choose the color for the path.
+ **$PromptSymbol** - Choose the symbol that follows the path.
+ **$PromptSymbolColor** - Choose the color for the symbol.

Here is an example where the path is modified to show the Current Directory Only:

![Screenshot displaying example of CurrentFolderOnly customization](screenshots\Prompt-Customization-CurrentFolderOnly.jpg)

Here is an example of replacing the Home Directory Path with a **~** symbol:

![Screenshot displaying example of ReplaceHomeDir customization](screenshots\Prompt-Customization-ReplaceHomeDir.jpg)

## Included Functions

All of the functions are referenced below by their alias. The alias is a shortened version of the function name and are defined at the top of sysadmin-tools.psm1. They can also be called by their long function name, which complies with PowerShell's cmdlet naming scheme.

### Directory Size

Calculates the size of a directory, including all sub-folders and sub-files. Prints in human-readable figures such as 123.45 GB or 35.79 MB. Optinally, you may use the -bytes flag to return the raw size in bytes. If the -NoRecurse flag is set, the function will return only return the size of files in the specified folder (excluding sub-folders and files).

Usage:

    dir-size [path] -bytes -NoRecurse

Examples:

    > dir-size .\Downloads\
    4.87 GB

    > dir-size -NoRecurse .\Downloads\
    711.78 MB

    > dir-size -NoRecurse -bytes .\Downloads\
    746358215

### (P)ing

A replacemnt for the ping command. An optional count parameter can be supplied. If none is given, the ping will run indefinetly. The ping can be stopped at anytime by pressing any key. The Window Title will display the current status and the hostname being pinged.

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
