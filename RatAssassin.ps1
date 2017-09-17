#Kill Rats on Your Compute 
#Works with Rats with DeFault Setting
#Owned by Karem Ali 

#There are More Improvements will take place on this Script 

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(

   [Security.Principal.WindowsBuiltInRole] “Administrator”))

{

 Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”

 Pause
 Break

}

function conn ($type)
{
    $ListeningPort = @()

    $GetPorts =  netstat -nao | Select-String $type

     Foreach ($Port in $GetPorts)  #convert text output of netstat into object so we can handle it in powershell
     {

        $a = $Port -split '\s+'

        $Ports = New-Object System.Object

        $Ports | Add-Member -MemberType NoteProperty -Name 'BoundIP:Port' -Value $a[1]
        $Ports | Add-Member -MemberType NoteProperty -Name 'Local address' -Value $a[2]
        $Ports | Add-Member -MemberType NoteProperty -Name 'foregin address' -Value $a[3] 
        $Ports | Add-Member -MemberType NoteProperty -Name 'Statu' -Value $a[4]
        $Ports | Add-Member -MemberType NoteProperty -Name 'PID' -Value $a[5]

        $ListeningPort += $Ports

    }
    $owners = @{}
    gwmi win32_process |% {$owners[$_.handle] = $_.getowner().user}

    foreach( $p in $ListeningPort.pid )
        {

            get-process | select processname,Id,@{l="Owner";e={$owners[$_.id.tostring()]}} | where{$_.Id -like $p -and $_.Owner -like "$env:username"} | Stop-Process
 
        }
}


get-process  | Get-ChildItem | select @{n='name'; e={$_.basename}} , directory | where{$_.directory  -like "*temp*" –or $_.directory -like "*appdata*"} | stop-process ;  #Scan Process and Kill Rat's Process
Set-Location C:\Users\$env:username #Choose The Current User
set-location 'Appdata\roaming\Microsoft\windows\Start Menu\Programs'
takeown /f startup ; #be The owner of startup Folder
echo y|cacls startup /p everyone:f; #get Privilege upon Startup Folder
set-location startup;
Get-ChildItem | where {$_.Name -like "*.exe*" -or $_.Name -like "*.vbs*" } | Remove-Item #Remove rat from Startup Folder


# Remove Registry Keys Which associated to the Malware

$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$obj = (Get-ItemProperty -Path $path)
foreach ($o in  $obj.PSobject.Properties) { if( $o.Value -like "*temp*" -or $o.Name.Length -eq "32" ) { Remove-ItemProperty -Path $path -Name $o.name}}


$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
$obj = (Get-ItemProperty -Path $path)
foreach ($o in  $obj.PSobject.Properties) { if( $o.Value -like "*temp*" -or $o.Name.Length -eq "32") { Remove-ItemProperty -Path $path -Name $o.name}}

$path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
$obj = (Get-ItemProperty -Path $path)
foreach ($o in  $obj.PSobject.Properties) { if( $o.Value -like "*temp*" -or $o.Name.Length -eq "32") { Remove-ItemProperty -Path $path -Name $o.name}}

$path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
$obj = (Get-ItemProperty -Path $path)
foreach ($o in  $obj.PSobject.Properties) { if( $o.Value -like "*temp*" -or $o.Name.Length -eq "32") { Remove-ItemProperty -Path $path -Name $o.name}}



#Disable Windows Script Host to Disable Vbs from Working

$path = "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings"
$valid = Test-Path $path 
if ( $valid -eq $false)
    {

            new-item -Path $path

    }

New-ItemProperty -Path $path -Name Enabled -Value 0 -PropertyType DWORD 


#Stop Processes Which set a communication With another Device 
 conn("established")
 conn("syn_sent")
 Start-Sleep -Seconds 1  #syn_sent disappear from netstat for 5 seconds before rat send another syn if reciever wasn't online
 conn("syn_sent")
 Start-Sleep -Seconds 2
 conn("syn_sent")
 Start-Sleep -Seconds 3
 conn("syn_sent")
 Start-Sleep -Seconds 4

 #Kill Wscript process
 Get-Process | where{$_.name -eq "wscript"} | Stop-Process
 Get-Process | where{$_.name -eq "cscript"} | Stop-Process


#Search Scheduled Tasks 
$task = Get-ScheduledTask | Get-ScheduledTaskInfo |  sort taskname  |where{$_.TaskPath -like "\"}

foreach($obj in $task)
    {
      #  $obj.TaskName
     #  (Get-ScheduledTask -TaskName $obj.taskname).Triggers
     $execute = (Get-ScheduledTask -TaskName $obj.taskname).Actions.Execute
        if(  $execute -like "*Windows*" -or $execute -like "*Program File*" -or $execute -like "*%ProgramFiles(x86)%*" -or $execute -like "*%ProgramFiles%*" )
            {
                
            }
            else{
            $obj.TaskName
            Disable-ScheduledTask  -TaskName $obj.TaskName
            }

    }


 #End of The Script
echo "You Are Save" "By Karem Ali  "| out-file C:\Users\$env:username\desktop\report.txt
notepad c:\users\$env:username\desktop\report.txt
