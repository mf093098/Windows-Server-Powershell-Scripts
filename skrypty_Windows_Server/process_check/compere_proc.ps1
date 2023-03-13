

function compare_proc
{
<#
.Synopsis
This script allows you to compare pereviously made snaps of processes with current state of machine

.Description 
This script allows you to compare pereviously made snaps of processes with current state of machine

It's prefereble to use xml files made with "make_snaps" funcintion made by me

You can compare multiple pc's with multiple files.


.Parameter pcname
There you can write name of pc's from your active directory, that you would like to compare

.Parameter pth_to_file
There you write paths to xml files, that contain snapshot

.Example
compareproc -pcname siedemjeden -pth_to_file C:\siedemjeden.xml

#>

param
([Parameter(Mandatory=$True)]
[string[]]$pcname,
[Parameter(Mandatory=$True)]
[string[]]$pth_to_file
)

if ( ( Test-Path -Path $pth_to_file -PathType Leaf) -and ($pth_to_file -like "*.xml")) {

for ($i = 0; $i -lt $pcname.Length ; $i++)
{
$org = $pth_to_file[$i]
$pcn = $pcname[$i]
echo " "
echo $pcn
Compare-Object -ReferenceObject (Import-Clixml $org) -DifferenceObject (invoke-command  -ComputerName $pcn -ScriptBlock {Get-Process}) -Property name 
}


}
else
{
 echo "Give me path to file that exists!! It must be xml"

}
}

