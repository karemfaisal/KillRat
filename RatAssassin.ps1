#Kill Rats on Your Computer
#Works with Rats with DeFault Setting
#Owned by Karem Ali 
get-process  | Get-ChildItem | select @{n='name'; e={$_.basename}} , directory | where{$_.directory  -like "*temp*" –or $_.directory -like "*appdata*"} | stop-process ;  #Scan Process and Kill Rat's Process
Set-Location C:\Users\$env:username #Choose The Current User
set-location 'Appdata\roaming\Microsoft\windows\Start Menu\Programs'
takeown /f startup ; #be The owner of startup Folder
echo y|cacls startup /p everyone:f; #get Privilege upon Startup Folder
set-location startup;
Get-ChildItem | where {$_.Name -like "*.exe*" } | Remove-Item #Remove rat from Startup Folder
#Remove Registry Entries with Value contain 0 
Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name *0*| Remove-Item
Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce *0*| Remove-Item
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Run *0*| Remove-Item
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce *0* | Remove-Item
echo "You Are Save" "By Karem Ali - IHACK "| out-file C:\Users\$env:username\desktop\report.txt
notepad c:\users\$env:username\desktop\report.txt
#There are More Improvements will take place on this Script 
