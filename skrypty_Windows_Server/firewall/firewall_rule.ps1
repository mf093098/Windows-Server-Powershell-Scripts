

function firewall_add_rule{
<#
.Synopsis
This script allows you to set firewall rule to multiple pc's

.Description 

This script allows you to set firewall rule to multiple pc's
 
.Parameter name
Type name of your firewall rule

.Parameter dir
Inbound or Outbound

.Parameter action
Deny or Allow

.Parameter protocole
for example tcp

.parameter localport
port that you will deny or allow


.Parameter all
Deafultly set to true. Get's all pc's from AD. If you would like to use hosts, or hostlike you will have to write -all false

.Parameter hosts
You can have info from specific hosts

.Parameter hostslike
You can have info from computers, that have names similar to pattern 


.Example
firewall_port -name "my_rule" -dir Inbound -action allow -protocole TCP -localport 80
#>

param(
[Parameter(Mandatory=$True)]
[string]$name,
[Parameter(Mandatory=$True)]
[string]$dir,
[Parameter(Mandatory=$True)]
[string]$action,
[Parameter(Mandatory=$True)]
[string]$protocole,
[Parameter(Mandatory=$True)]
[int]$localport,
[Boolean]$all = $true,
[string[]]$hosts,
[string]$hostslike
)

if($all -eq $True)
{
$adcom= Get-ADComputer -Filter *
$computernames = Get-ADComputer -Filter * | Select-Object -Property name
for ([int] $i = 0 ; $i -lt $computernames.count ; $i++)

    {


    $comp = $adcom[$i].name
    $comp
    netsh -r $comp advfirewall firewall add rule name=$name dir=$dir action=$action protocol=$protocole localport=$localport


    }
}
else
{
    if (-not ([string]::IsNullOrEmpty($hostslike)))
        {

            $adcom=Get-ADComputer -Filter * | where -Property Name -like $hostslike
            $computernames = Get-ADComputer -Filter * | where -Property Name -like $hostslike | Select-Object -Property name
            for ([int] $i = 0 ; $i -lt $computernames.count ; $i++)
                {
                    $comp = $adcom[$i].name
                    $comp
                    netsh -r $comp advfirewall firewall add rule name=$name dir=$dir action=$action protocol=$protocole
                }

        }
    else 
        {
            for ($i =0; $i -lt $hosts.length ; $i++)
                {
                    $adcom=Get-ADComputer -Filter * | where -Property Name -eq $hosts[$i]
                    $comp = $adcom[$i].name
                    $comp
                    netsh -r $comp advfirewall firewall add rule name=$name dir=$dir action=$action protocol=$protocole
                    echo " "
                    
                }
        }
}






}


