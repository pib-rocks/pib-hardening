#region SkriptContent
<#
.SYNOPSIS
     pip hardening by FB Pro GmbH
.DESCRIPTION
      pip hardening by FB Pro GmbH
.NOTES
     File Name : pip.hardening.ps1
     Author : Tim Spreier – FB-Pro.com
.EXAMPLE
     Run this script as Administrator .\pip.hardening.ps1 -verbose
.INPUTTYPE
     N/A
.RETURNVALUE
    The script outputs True / False for the successful configurations in the Workplace_install_yyMMdd_HHmm.txt file.
.COMPONENT
     Windows

.List

#>
#endregion

#---------------------------------------------------------------------------------------------

#region Logs
# Path for storing the log files          
$LogPfad = "~/tmp"            
            
# Generate date. This example creates one log file per day            
$Datum = get-date -f yyMMdd_HHmm           
            
# Check and create LogFile if not available            
if (!(Test-Path ("$LogPfad\$Datum" + "_LogFile.txt")))            
    {            
       # Creating the LogFile            
       $Logfile = (New-Item ("$LogPfad\$Datum" + "_LogFile.txt") -ItemType File -Force).FullName            
                   
       # Heading for the LogFile             
       Add-Content $Logfile ("Installation start: $(get-date -Format "dddd dd. MMMM yyyy HH:mm:ss") `n").ToUpper()            
            
       # Insert blank lines            
       Add-Content $Logfile "`n"            
                  
       # Generate column header           
       $LogInhalt = "{0,-25}{1,-12}{2,-90}{3}" -f "Date","No","Description","Result"            
                   
       # Add heading to the log file            
       Add-Content $Logfile $LogInhalt            
    }            
else            
    {            
        # If logfile already exists, add file to $Logfile variable             
        $Logfile = (Get-Item ("$LogPfad\$Datum" + "_LogFile.txt")).FullName            
            
    }  

          
            
function write-LogRecord            
    {            
        param            
            (     
                [ValidateNotNullOrEmpty()]               
                [String]$No,            
                [ValidateNotNullOrEmpty()]            
                [String]$Text,
                [ValidateNotNullOrEmpty()] 
                [String]$Boolean           
            )            
                    
        # Generating the timestamp for the individual log lines           
        $TimeStamp = get-date -Format "[dd.MM.yyyy HH:mm:ss]"            
                    
        # Format and assemble content accordingly             
        $LogInhalt = "{0,-25}{1,-12}{2,-90}{3}" -f $TimeStamp,$No,$Text,$Boolean            
            
        # Add to LogFile           
        Add-Content $Logfile $LogInhalt            
    }            

#Color
function Write-ColorOutput($ForegroundColor)
{
    # save the current color
    $fc = $host.UI.RawUI.ForegroundColor

    # set the new color
    $host.UI.RawUI.ForegroundColor = $ForegroundColor

    # output
    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }

    # restore the original color
    $host.UI.RawUI.ForegroundColor = $fc
}

#----------------------Variable---------------------------#

$i = 0
#endregion

#---------------------------------------------------------------------------------------------

#region Logging

function Logging {
    param (
        [switch]$Condition = "true",
        [int]$Index = 0,
        [string]$Message = "XYZ"
    )

    if ($Condition) {
        write-LogRecord -No "I$Index" -Text $Message -Boolean $Condition
        Write-Output $Message | Write-ColorOutput green 
    }
    else {
        write-LogRecord -No "I$Index" -Text $Message -Boolean $Condition
        Write-Output $Message | Write-ColorOutput red
    }
}

# Beispielaufruf mit benutzerdefiniertem Index und Text
#$i = 42
#$boolean = true
#$message = "Custom installation message"
#Logging -Condition:$boolean -Index $i -Message $message



#endregion

#---------------------------------------------------------------------------------------------

#region Test-PathExistence

function Test-PathExistence {
    param (
        [string]$Path
    )

    if (Test-Path -Path $Path) {
        return $true
    } else {
        return $false
    }
}

#$exists = Test-PathExistence -Path "C:\Dein\Pfad\Hier"

#endregion

#---------------------------------------------------------------------------------------------

#region apt-get update

apt-get update

#endregion

#---------------------------------------------------------------------------------------------

#region 1.1.1.1 Ensure mounting of cramfs filesystems is disabled (Automated)

# Define the path to the Bash scripts
$testScriptPath=".\1.1.1.1\Ensure_cramfs_kernel_module_is_not_available_Test.sh"
$setScriptPath=".\1.1.1.1\Ensure_cramfs_kernel_module_is_not_available_Set.sh"

# Execute the test script
$testResult= bash -c "bash $testScriptPath"
$status=$?
$value = "false"

# Check the result of the test script
if ( $status -eq $value ) {
    # Execute the set script
    bash -c "bash $setScriptPath" 
    $boolean = $true
    $message = "The set script is executed."
}
else {
    $boolean = $true
    $message = "The test script did not return a status of $value. The set script will not be executed."
}

Logging -Condition $boolean -Index $i -Message $message
$i++
#endregion

#---------------------------------------------------------------------------------------------

#region 1.1.2.2 Ensure nodev option set on /tmp partition (Automated)

# Define the path to the Bash scripts
$setScriptPath=".\1.1.2.2\add_nodev_to_tmp.sh"


    # Execute the set script
    bash -c "bash $setScriptPath" 
    $boolean = $true
    $message = "The set script add_nodev_to_tmp is executed."


Logging -Condition $boolean -Index $i -Message $message
$i++

#---------------------------------------------------------------------------------------------

#region 1.1.2.3 Ensure noexec option set on /tmp partition (Automated)

# Define the path to the Bash scripts 
$setScriptPath=".\1.1.2.3\add_noexec_to_tmp.sh"


    # Execute the set script
    bash -c "bash $setScriptPath" 
    $boolean = $true
    $message = "The set script add_noexec_to_tmp is executed."


Logging -Condition $boolean -Index $i -Message $message
$i++

#---------------------------------------------------------------------------------------------

#region 1.1.2.4 Ensure nosuid option set on /tmp partition (Automated)

# Define the path to the Bash scripts 
$setScriptPath=".\1.1.2.4\add_nosuid_to_tmp.sh"


    # Execute the set script
    bash -c "bash $setScriptPath" 
    $boolean = $true
    $message = "The set script add_nosuid_to_tmp is executed."


Logging -Condition $boolean -Index $i -Message $message
$i++

#---------------------------------------------------------------------------------------------

#region 1.1.3.2 Ensure nodev option set on /var partition (Automated)
 
# Define the path to the Bash scripts  
$setScriptPath=".\1.1.3.2\add_nodev_to_var.sh"


    # Execute the set script
    bash -c "bash $setScriptPath" 
    $boolean = $true
    $message = "The set script add_nodev_to_var is executed."


Logging -Condition $boolean -Index $i -Message $message
$i++

#---------------------------------------------------------------------------------------------

#region 1.1.3.3 Ensure nosuid option set on /var partition (Automated)
 
# Define the path to the Bash scripts  
$setScriptPath=".\1.1.3.3\add_nosuid_to_var.sh"


    # Execute the set script
    bash -c "bash $setScriptPath" 
    $boolean = $true
    $message = "The set script add_nosuid_to_var is executed."


Logging -Condition $boolean -Index $i -Message $message
$i++

#---------------------------------------------------------------------------------------------

#region apt purge

#1.5.2 Ensure prelink is not installed (Automated)              ->  prelink
#2.1.4.1 Ensure ntp access control is configured (Automated)    ->  ntp
#2.1.4.2 Ensure ntp is configured with authorized timeserver (Manual)   ->  ntp
#2.1.4.3 Ensure ntp is running as user ntp (Automated)          ->  ntp
#2.1.4.4 Ensure ntp is enabled and running (Automated)          ->  ntp
#2.2.2 Ensure Avahi Server is not installed (Automated)         ->  avahi-daemon
#2.2.4 Ensure DHCP Server is not installed (Automated)          ->  isc-dhcp-server
#2.2.5 Ensure LDAP server is not installed (Automated)          ->  slapd
#2.2.6 Ensure NFS is not installed (Automated)                  ->  nfs-kernel-server
#2.2.7 Ensure DNS Server is not installed (Automated)           ->  bind9
#2.2.8 Ensure FTP Server is not installed (Automated)           ->  vsftpd
#2.2.9 Ensure HTTP server is not installed (Automated)          ->  apache2
#2.2.10 Ensure IMAP and POP3 server are not installed (Automated)-> dovecot-imapd & dovecot-pop3d
#2.2.11 Ensure Samba is not installed (Automated)               ->  samba
#2.2.12 Ensure HTTP Proxy Server is not installed (Automated)   ->  squid
#2.2.13 Ensure SNMP Server is not installed (Automated)         ->  snmp
#2.2.14 Ensure NIS Server is not installed (Automated)          ->  nis
#2.3.1 Ensure NIS Client is not installed (Automated)           ->  nis
#2.3.2 Ensure rsh client is not installed (Automated)           ->  rsh-client
#2.3.3 Ensure talk client is not installed (Automated)          ->  talk
#2.3.4 Ensure telnet client is not installed (Automated)        ->  telnet
#2.3.5 Ensure LDAP client is not installed (Automated)          ->  ldap-utils
#2.3.6 Ensure RPC is not installed (Automated)                  ->  rpcbind
#3.5.1.2 Ensure iptables-persistent is not installed with ufw (Automated)   ->  iptables-persistent
#3.5.3.1.2 Ensure nftables is not installed with iptables (Automated)       ->  nftables



# Function to remove a package
function Remove-Package {
    param(
        [string]$Package
    )

    # Check if the package is installed
    $status = dpkg -l | Select-String -Pattern $Package

    if (-not $status) {
        $boolean = $true
        $message = "The $Package package was not installed."
    }
    else {
        # Remove the package
        apt purge -y $Package
        $boolean = $true
        $message = "The $Package package was removed."
    }

    # Log the removal status
    Logging -Condition $boolean -Index $i -Message $message



}

# Create an array of package names
$packageNames = @("prelink", "ntp", "avahi-daemon", "isc-dhcp-server", "slapd", "nfs-kernel-server", "bind9", "vsftpd", "apache2", "dovecot-imapd", "dovecot-pop3d", "samba", "squid", "snmp", "nis", "rsh-client", "talk", "telnet", "ldap-utils", "rpcbind", "iptables-persistent", "nftables")

# Loop through each package in the array
foreach ($packageName in $packageNames) {
    # Call the function to remove the package
    Remove-Package -Package $packageName
        $i++
}


#endregion


#---------------------------------------------------------------------------------------------

#region 1.5.3 Ensure Automatic Error Reporting is not enabled (Automated)

$status = systemctl is-active apport.service | grep '^active'

if ($status -eq 'active') {
                apt purge -y apport
                $boolean = true
				$message = "The apport package was removed."
             
}
else {
    			$boolean = true
				$message = "The apport package was not installed."  
}

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region apt install

#1.6.1.1 Ensure AppArmor is installed (Automated)                   ->  apparmor
#2.1.1.1 Ensure a single time synchronization daemon is in use (Automated)           ->  chrony
#3.5.1.1 Ensure ufw is installed (Automated)                        ->  ufw
#4.2.1.1.1 Ensure systemd-journal-remote is installed (Automated)   ->  systemd-journal-remote
#4.2.2.1 Ensure rsyslog is installed (Automated)                    ->  rsyslog
#5.3.1 Ensure sudo is installed (Automated)                         ->  sudo

# Function to install a package
function Install-Package {
    param(
        [string]$Package
    )

    # Check if the package is installed
    $status = dpkg -l | Select-String -Pattern $Package

    if (-not $status) {
        # install the package
        apt install -y $package
        $boolean = $true
        $message = "The $package package has been installed."
    }
    else {
        $boolean = $true
        $message = "The $package package was installed."
    }

    # Log the removal status
    Logging -Condition $boolean -Index $i -Message $message
    $i++

    # Increment the global counter
    $global:i++
}

# Create an array of package names
$packageNames = @("apparmor", "chrony", "ufw", "audispd-plugins", "systemd-journal-remote", "rsyslog", "sudo" )

# Loop through each package in the array
foreach ($packageName in $packageNames) {
    # Call the function to remove the package
    Install-Package -Package $packageName
}


#endregion

#---------------------------------------------------------------------------------------------

#region 1.4.2 Ensure permissions on bootloader config are configured (Automated)

$path = "/boot/grub/grub.cfg"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    	$path = "/boot/grub/grub.cf"
        $exists = Test-PathExistence -Path $path
        if($exists){
        chown root:root /boot/grub/grub.cfg
        chmod u-wx,go-rwx /boot/grub/grub.cf
        $boolean = $true
        $message = "Permissions is set on your grub configuration."  
        }
        else {
        $boolean = $true
        $message = "$path does not exist."
        }
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 1.6.1.2 Ensure AppArmor is enabled in the bootloader configuration (Automated)

# Path to the text file
$path = "/etc/default/grub"

$exists = Test-PathExistence -Path $path

# Line to be appended
$line = "GRUB_CMDLINE_LINUX=apparmor=1 security=apparmor"
    if ($exists) {
    # Appending the line to the file
    Add-Content -Path $path -Value $line
    update-grub
    $boolean = true
    $message = "Appending the line to the file $path." 
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion


#---------------------------------------------------------------------------------------------

#region 1.7.1 Ensure message of the day is configured properly (Automated)

#1.7.4 Ensure permissions on /etc/motd are configured (Automated)

$path = "/etc/motd"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #motd can be removed
    rm /etc/motd
    $boolean = true
    $message = "motd has been removed"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 1.7.5 Ensure permissions on /etc/issue are configured (Automated)

$path = "/etc/issue"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons on /etc/issue
    chown root:root $(readlink -e /etc/issue)
    chmod u-x,go-wx $(readlink -e /etc/issue)
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 1.7.6 Ensure permissions on /etc/issue.net are configured (Automated)

$path = "/etc/issue.net"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons on /etc/issue.net
    chown root:root $(readlink -e /etc/issue.net)
    chmod u-x,go-wx $(readlink -e /etc/issue.net)
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 4.2.1.1.4 Ensure journald is not configured to recieve logs from a remote client (Automated)

    if (systemctl list-unit-files --type=socket | grep -q 'systemd-journal-remote.socket') {
 
            if (systemctl is-enabled systemd-journal-remote.socket) {
                $boolean = $true
                $message = "Systemd-journal-remote.socket service already deactivated."  }
            else {
                systemctl --now disable systemd-journal-remote.socket
                $boolean = $true
                $message = "Systemd-journal-remote.socket service is deactivated."
                }
        }
    else {
        $boolean = $true
        $message = "systemd-journal-remote.socket does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 4.2.1.3 Ensure journald is configured to compress large log files (Automated)

# Path to the text file
$path = "/etc/systemd/journald.conf"

$exists = Test-PathExistence -Path $path

# Line to be appended
$line = "Compress=yes"
    if ($exists) {
    # Appending the line to the file
    Add-Content -Path $path -Value $line
    systemctl restart systemd-journald
    $boolean = true
    $message = "Appending the line to the file $path." 
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 2.1.2.3 Ensure chrony is enabled and running (Automated)

$status = systemctl is-enabled chrony.service | grep 'enabled'
if ($status -eq 'enabled') {
                
				$status = systemctl is-active chrony.service | grep 'active'
             if ($status -eq 'active') {
                
                $boolean = true
				$message = "chrony.service was enabled and active"
             
}
else {
		systemctl unmask chrony.service
		systemctl --now enable chrony.service
    				$boolean = true
				$message = "chrony.service was enabled but not active"  
}
}
else {
		systemctl unmask chrony.service
		systemctl --now enable chrony.service
    				$boolean = true
				$message = "chrony.service was not enabled and not active"  
}


Logging -Condition $boolean -Index $i -Message $message


$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 4.2.2.2 Ensure rsyslog service is enabled (Automated)

   if (!(systemctl is-enabled rsyslog)) {
            systemctl --now enable rsyslog
                $boolean = $true
                $message = "Systemd-journal-remote.socket service already deactivated."  

        }
    else {
        $boolean = $true
        $message = "rsyslog service already activated."
    }


Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 5.1.1 Ensure cron daemon is enabled and running (Automated)

   if (!(systemctl is-enabled rsyslog)) {
            systemctl --now enable rsyslog
                $boolean = $true
                $message = "Systemd-journal-remote.socket service already deactivated."  

        }
    else {
        $boolean = $true
        $message = "rsyslog service already activated."
    }


Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 5.1.2 Ensure permissions on /etc/crontab are configured (Automated)

$path = "/etc/crontab"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/crontab
    chmod og-rwx /etc/crontab
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 5.1.3 Ensure permissions on /etc/cron.hourly are configured (Automated)

$path = "/etc/cron.hourly"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/cron.hourly/
    chmod og-rwx /etc/cron.hourly/
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 5.1.4 Ensure permissions on /etc/cron.daily are configured (Automated)

$path = "/etc/cron.daily"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/cron.daily/
    chmod og-rwx /etc/cron.daily/
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 5.1.6 Ensure permissions on /etc/cron.monthly are configured (Automated)

$path = "/etc/cron.monthly"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/cron.monthly/
    chmod og-rwx /etc/cron.monthly/
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 5.1.7 Ensure permissions on /etc/cron.d are configured (Automated)

$path = "/etc/cron.d"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/cron.d/
    chmod og-rwx /etc/cron.d/
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 5.1.8 Ensure cron is restricted to authorized users (Automated)

$path = "/etc/cron.deny"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    rm /etc/cron.deny
    touch /etc/cron.allow
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$path = "/etc/cron.allow"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chmod g-wx,o-rwx /etc/cron.allow
    chown root:root /etc/cron.allow
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 5.1.9 Ensure at is restricted to authorized users (Automated)

$path = "/etc/at.deny"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    rm /etc/at.deny
    touch /etc/at.allow
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$path = "/etc/at.allow"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chmod g-wx,o-rwx /etc/at.allow
    chown root:root /etc/at.allow
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured (Automated)

$path = "/etc/ssh/sshd_config"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/ssh/sshd_config
    chmod og-rwx /etc/ssh/sshd_config
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 5.2.12 Ensure SSH X11 forwarding is disabled (Automated)

# Define the path to the Bash scripts
$testScriptPath=".\5.2.12\Ensure_SSH_X11_forwarding_is_disabled_Test.sh"
$setScriptPath=".\5.2.12\Ensure_SSH_X11_forwarding_is_disabled_Set.sh"

# Execute the test script
$testResult= bash -c "bash $testScriptPath"
$status=$?
$value = "false"

# Check the result of the test script
if ( $status -eq $value ) {
    # Execute the set script
    bash -c "bash $setScriptPath" 
    $boolean = $true
    $message = "The set script is executed."
}
else {
    $boolean = $true
    $message = "The test script did not return a status of $value. The set script will not be executed."
}

Logging -Condition $boolean -Index $i -Message $message
$i++
#endregion

#---------------------------------------------------------------------------------------------

#region 6.1.1 Ensure permissions on /etc/passwd are configured (Automated)

$path = "/etc/passwd"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/passwd
    chmod u-x,go-wx /etc/passwd
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 6.1.2 Ensure permissions on /etc/passwd- are configured (Automated)

$path = "/etc/passwd-"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/passwd-
    chmod u-x,go-wx /etc/passwd-
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 6.1.3 Ensure permissions on /etc/group are configured (Automated)

$path = "/etc/group"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/group
    chmod u-x,go-wx /etc/group
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 6.1.4 Ensure permissions on /etc/group- are configured (Automated)

$path = "/etc/group-"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/group-
    chmod u-x,go-wx /etc/group-
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

#region 6.1.5 Ensure permissions on /etc/shadow are configured (Automated)

$path = "/etc/group-"

$exists = Test-PathExistence -Path $path

    if ($exists) {
    #Set permissons 
    chown root:root /etc/group-
    chmod u-x,go-wx /etc/group-
    $boolean = true
    $message = "Permissions on $path is set"  
    }
    else {
        $boolean = $true
        $message = "$path does not exist."
    }

Logging -Condition $boolean -Index $i -Message $message

$i++

#endregion

#---------------------------------------------------------------------------------------------

