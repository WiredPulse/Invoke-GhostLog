![Alt text](https://github.com/WiredPulse/Invoke-GhostLog/blob/master/Images/Header.png?raw=true "Optional Title")<br>
<br>

# Invoke-GhostLog
Removal of certain event logs within a Windows OS

# Usage <br>
1. Open a PowerShell window and lauch Event Viewer and build an XML query to use. You may want to do this on another system instead of the target.
```powershell
PS C:> eventvwr
```
2. Create a filter on the log you want to alter. In the below example, we are querying for any event ID 4625 that have triggered in the last 7 days.
![Alt text](https://github.com/WiredPulse/Invoke-GhostLog/blob/master/Images/eventvwr.png?raw=true "Optional Title")

Get a system Powershell window <br>
2. Open your local Event Viewer in order to build an XML query to use
```powershell
PS C:> eventvwr
```
3. 

Execute the script <br>
```powershell

```

# Building XML queries
https://blogs.technet.microsoft.com/heyscriptingguy/2014/06/06/understanding-xml-and-xpath/


