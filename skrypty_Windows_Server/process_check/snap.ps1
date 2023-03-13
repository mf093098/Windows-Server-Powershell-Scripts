
function make_snaps
{ 
<#
.Synopsis
This script makes a snapshot of processes, of computers in active directory and saves it to xml file named after computername. 
.Description 
This script makes a snapshot of processes, of computers in active directory and saves it to xml file named after computername. 

If you don't give any parameter about hosts it makes snaps of all computers in active directory.

If you would like to get snapshots from specyfic hosts you have to change parameter -all to false and write names of computers to hosts param

Or if you have a pattern of computernames from which you would like to get info you have write for example *graf to hostslike parameter

.Parameter pth
Select a path for files to save
.Parameter all
Boolean deafault set to true, which defines if you would like to get info from all pc's in active directory
.Parameter $hosts 
String[] where you can put specific names of pc's, from which you would like to get information


.Parameter hostslike
String where you put info like in filters. For example if you have a lot of computers name like musicmachine1, musicmachine2 etc you write *musicmachi* and you get info only from them


.Example
make_snaps -pth C:\ -all false -hostslike *musicmach*

#>
param

( [Parameter(Mandatory=$True)]
[string]$pth,
  [Boolean]$all = $true,
  [string[]]$hosts,
  [string]$hostslike
)

if (!(Test-Path -PathType Container $pth))
{
 New-Item -ItemType Directory -Path $pth
}



if ($all -eq $true)
{
$adcom= Get-ADComputer -Filter *
$computernames = Get-ADComputer -Filter * | Select-Object -Property name
for ([int] $i = 0 ; $i -lt $computernames.count ; $i++)

{
 
 echo $adcom[$i].name
 echo " "
 $gdzie = $pth + "\" + $adcom[$i].name + ".xml"
 #Get-Process -ComputerName $t
 invoke-command  -ComputerName $adcom[$i].name -ScriptBlock {Get-Process} | Export-Clixml -Path $gdzie
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
 $gdzie = $pth + "\" + $adcom[$i].name + ".xml"
 #Get-Process -ComputerName $t
 invoke-command  -ComputerName $adcom[$i].name -ScriptBlock {Get-Process} | Export-Clixml -Path $gdzie
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
 $gdzie = $pth +  "\" + $adcom.name + ".xml"
 #Get-Process -ComputerName $t
 invoke-command  -ComputerName $adcom.name -ScriptBlock {Get-Process} | Export-Clixml -Path $gdzie
 #$t
 echo "  "
}
}
}


}