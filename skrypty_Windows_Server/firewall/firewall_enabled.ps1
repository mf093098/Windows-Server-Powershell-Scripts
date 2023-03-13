

function check_firewall_enabled
{
<#
.Synopsis
This script allows you to chceck if on computers in active directory firewall is active

.Description 

This script allows you to chceck if on computers in active directory firewall is active.

You will see name of the machine and status of their's firewall 


.Parameter all
Deafultly set to true. Get's all pc's from AD. If you would like to use hosts, or hostlike you will have to write -all false

.Parameter hosts
You can have info from specific hosts

.Parameter hostslike
You can have info from computers, that have names similar to pattern 


.Example
check_firewall_enabled -all false -hostslike *graph*

#>
param 
(
 [Boolean]$all = $true,
 [string[]]$hosts,
 [string]$hostslike
)

if($all -eq $true)
{
    $adcom= Get-ADComputer -Filter *
$computernames = Get-ADComputer -Filter * | Select-Object -Property name
for ([int] $i = 0 ; $i -lt $computernames.count ; $i++)

{
 
 echo $adcom[$i].name
 echo " "

 #Get-Process -ComputerName $t
 netsh -r $adcom[$i].name advfirewall show all state
 #$t
 echo "  "
}
}
else 
{
if (-not ([string]::IsNullOrEmpty($hostslike)))
{

$adcom=Get-ADComputer -Filter * | where -Property Name -like $hostslike
$computernames = Get-ADComputer -Filter * | Select-Object -Property name
for ([int] $i = 0 ; $i -lt $computernames.count ; $i++)

{
 echo $adcom[$i].name
 echo " "

 #Get-Process -ComputerName $t
 netsh -r $adcom[$i].name advfirewall show all state
 #$t

 echo "  "
}
}
else{
for ($i =0; $i -lt $hosts.length ; $i++)
{
 $adcom=Get-ADComputer -Filter * | where -Property Name -eq $hosts[$i]
 echo $adcom.name
 echo " "

 #Get-Process -ComputerName $t
 netsh -r $adcom[$i].name advfirewall show all state
 #$t
 echo "  "
}
}
}


}