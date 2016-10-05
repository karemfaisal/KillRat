#Kill Rats on Your Compute 
#Works with Rats with DeFault Setting
#Owned by Karem Ali , IHACk
get-process  | Get-ChildItem | select @{n='name'; e={$_.basename}} , directory | where{$_.directory  -like "*temp*" –or $_.directory -like "*appdata*"} | stop-process ;  #Scan Process and Kill Rat's Process
Set-Location C:\Users\$env:username
set-location 'Appdata\roaming\Microsoft\windows\Start Menu\Programs'
takeown /f startup ;
echo y|cacls startup /p everyone:f;
set-location startup;
Get-ChildItem | where {$_.Name -like "*.exe*" } | Remove-Item #Remove rat from Startup Folder