![Alt text](https://github.com/WiredPulse/Invoke-GhostLog/blob/master/Images/Header.png?raw=true "Optional Title")<br>
<br>

# Invoke-GhostLog
Removal of certain event logs within a Windows OS

# Usage <br>
1. Open a PowerShell window and lauch Event Viewer and build an XML query to use. You may want to do this on another system instead of the target.
```powershell
PS C:> eventvwr
```
2. Create a filter on the log you want to alter. Note: In the below example, we are querying for all events, except event ID 4625, that have triggered in the last 7 days.
![Alt text](https://github.com/WiredPulse/Invoke-GhostLog/blob/master/Images/eventvwr.png?raw=true "Optional Title")

3. Click the XML tab and copy the text circled in red.
![Alt text](https://github.com/WiredPulse/Invoke-GhostLog/blob/master/Images/eventvwr2.png?raw=true "Optional Title")

4. Paste the text from the above step in Notepad and make the below change. Note: If not doing the example, use the link at the bottom of the screen to alter the comparison operator accordingly.
```powershell
# Current
[System[TimeCreated[timediff(@SystemTime) &lt;= 604800000

# What it needs to change to
[System[TimeCreated[timediff(@SystemTime) <= 604800000
```
5. Get a System level Powershell window <br>

6. Copy the changed data from step 4

7. Dot source and run Invoke-GhostLog, using the changed data from step 4 as the filter
```powershell
PS C:> . .\Invoke-GhostLog
PS C:> Invoke-GhostLog -log Security -filter "[System[TimeCreated[timediff(@SystemTime) <= 604800000"
```

# Building XML queries
https://blogs.technet.microsoft.com/heyscriptingguy/2014/06/06/understanding-xml-and-xpath/


