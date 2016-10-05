get-process  | Get-ChildItem | select @{n='name'; e={$_.basename}} , directory | where{$_.directory  -like "*temp*" –or $_.directory -like "*appdata*"} | stop-process ;
Set-Location 'C:\Users\$env:username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs'
takeown /f startup
echo y|cacls startup /p everyone:f
set-location startup
Get-ChildItem | where {$_.Name -like "*.exe*" } | Remove-Item 