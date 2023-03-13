function load_module_sf
{
<#
.Synopsis
This script automates loading modules. sf stands for single (.psm1) file

.Description 

This script automates loading modules. Give him path to .psm1 file and everything happends automaticly


.Parameter plik
give there a path to file for examle C:\scripts\make_manifest\make_manifest.psm1




.Example
load_module_sf -plik C:\scripts\make_manifest\make_manifest.psm1

#>
param
(
[Parameter(Mandatory=$True)]
 [String]$plik
)
$snp= $plik.LastIndexOf('\')
$lnp = $plik.IndexOf('.')

$noc = $plik.Substring($snp+1,($lnp-$snp-1))
$noc


$gdzie = $env:PSModulePath -split ";"


$mnamod=$gdzie[0] + "\" + $noc + "\"

mkdir $mnamod
$mnamod
Copy-Item $plik -Destination $mnamod -Force


}

function load_module_mf
{
<#
.Synopsis
This script automates loading modules. mf stands for multiple files. Script copies all files to the module folder

.Description 

This script automates loading modules. Give him path to folder file and every *.ps* file will copy to the module folder. To make it work you have to have a manifest file in your directory


.Parameter folder
give there a path to folder for examle C:\scripts\myscripts




.Example
load_module_mf -folder C:\scripts\myscripts


#>
param
(
[Parameter(Mandatory=$True)]
 [String]$folder
)
$snp= $folder.LastIndexOf('\')
$lnp = $folder.Length

$noc = $folder.Substring($snp+1,($lnp-$snp-1))
$noc


$gdzie = $env:PSModulePath -split ";"


$mnamod=$gdzie[0] + "\" + $noc + "\"

$mnamod

mkdir $mnamod

$files = ls $folder  | select -Property Name | where -Property Name -Like "*.ps*" |Out-String -Stream

$files

$f = $files | where {$_ -like "*.ps*"}

for ($i = 0 ; $i -lt $f.Length ; $i++)
{
 if ($f[$i] -like "*.ps1")
 {$f[$i] = $f[$i].Substring(0,$f[$i].LastIndexOf('s') +2)}
 else
 {$f[$i] = $f[$i].Substring(0,$f[$i].LastIndexOf('s') +3)}  
}


for ($i = 0; $i -lt $f.Length ; $i++) 
{
$pth = $folder + "\" + $f[$i]
$pth

Copy-Item $pth -Destination $mnamod -Force
}

#$snp= $pth.LastIndexOf('\') + 1

#Copy-Item $plik -Destination $mnamod -Force
}