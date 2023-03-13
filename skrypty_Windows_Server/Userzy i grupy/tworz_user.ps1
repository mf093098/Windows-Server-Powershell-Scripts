
function create-txt-user{
<#
.Synopsis
Tworz wielu użytkowników z pliku tekstowego
.Description 
Tworz wielu użytkowników z pliku tekstowego
Zasada Tworzenia:
W dowolnym pliku txt powinny się znależć następujące informacje
Imię
Nazwisko
Grupa do której użytkownik ma należeć
Numer telefonu
Adres E-mail
Opis
profil mobily -> wpisujemy t bądź cokolwiek innego

Każda informacja poza pierwszą musi być poprzedzona Enterem. Między następnymi użytkownikami nie występuje przerwa.  Działa jedynie dla Takich parametrów jak powyżej. Między użytkownikami musi być pozostawiona linijka przerwy

.Parameter Plik
Tu podaj ścieżkę do pliku
.Example
tworz_user -plik C:\plik.txt -pth_to_groups_folder C:\Grupy\

#>
param(
 [Parameter(Mandatory=$True)]
 [String]$plik,
 [Parameter(Mandatory=$True)]
 [String]$pth_to_groups_folders
 
)
[int] $licz = 0
foreach($line in Get-Content $plik) {
   if($line -match $regex) 
   {


     $n=$line
     $licz= $licz+1 
     
     if($licz -eq 1){$imie =$n}
     if($licz -eq 2){$nazwisko =$n}
     if($licz -eq 3){$grupa =$n}
     if($licz -eq 4) {$telefon=$n}
     if($licz -eq 5) {$poczta=$n}
     if($licz -eq 6){$opis =$n}
     if($licz -eq 7) {$pm = $n

     $opis = $imie + " " + $nazwisko + " " + $opis
     
     $imie

     $nazwisko
     $grupa
     $telefon
     $poczta
      $opis
     echo  " "
     echo "To taki user"
     echo " "
     $nazwausera= $imie.Substring(0,3) + $nazwisko.Substring(0,4) + $telefon.Substring(0,2) + $telefon.Substring(7,2)
     echo $nazwausera 
     echo "+++++++++++++++++++ "
     $dlugosc = $nazwisko.Length
     
     if ($nazwisko.Length -gt $telefon.Length)
     {
     for ([int] $i = 0 ; $i -lt $nazwisko.Length  ; $i++)
        {
          if ($i -gt 8)
          {
          $haslo= $haslo + $nazwisko.Substring($i,1)
          }
          else
          {
           $haslo =$haslo + $nazwisko.Substring($i,1) + $telefon.Substring($i,1)
          }
        }
     }
     else 
     {for ([int] $i = 0 ; $i -lt $telefon.Length  ; $i++)
        {
          if ($i -gt ($nazwisko.Length - 1))
          {
          $haslo= $haslo + $telefon.Substring($i,1)
          }
          else
          {
           $haslo =$haslo + $nazwisko.Substring($i,1) + $telefon.Substring($i,1)
          }
        }
        
     }
     $haslo = $haslo + "!!"
     $haslo 
     $Groupexist = Get-ADGroup -Identity $grupa
     if ($Groupexist -ne $null)
     {
        if (Test-Path -PathType Container $pth_to_groups_folders)
{
 $folder = $pth_to_groups_folders + $grupa + "\" + $nazwausera
 mkdir $folder

}
     }
     New-AdUser -Name $nazwausera -Accountpassword  (ConvertTo-SecureString $haslo -AsPlainText -Force) -ChangePasswordAtLogon $True -Description $opis -EmailAddress $poczta -GivenName $imie -Surname $nazwisko -MobilePhone $telefon -UserPrincipalName ($nazwausera +".@inzynierka.local") -enabled $True 
     if ($grupa -eq "szef") 
     {
      
     }
     else{Add-ADGroupMember -Identity $grupa -Members $nazwausera} 

     if ($pm -eq "t")
     {
     $hostname = hostname
     $hostname
     $share =  $nazwausera + "=" + $folder 
     net share "$share" /GRANT:$nazwausera,full
     echo " net share "$share" /GRANT:$nazwausera,full" 
     Set-ADUser -Identity $nazwausera -ProfilePath \\$hostname\$nazwausera}

     $haslo = ""
     
     echo " "
     $licz= 0
     }
   }
   
}
}

function create-txt-group{
<#
.Synopsis
Tworz wiele grup z pliku tekstowego
.Description 
Tworz wiele grup z pliku tekstowego
Zasada Tworzenia:
W dowolnym pliku txt wypisujemy nazwy grup, które chcemy utworzyć

Przykład pliku:
Grupa1
Grupa2
Grupa3

Każda informacja poza pierwszą musi być poprzedzona Enterem. 

.Parameter Plik
Tu podaj ścieżkę do pliku
.Example
tworz_grupy -plik C:\plik.txt

#>

[CmdletBinding()]
param(
 [Parameter(Mandatory=$True)][String]$gdzie,
 [Parameter(Mandatory=$True)][String[]]$plik

)

begin{}
process{
foreach($line in Get-Content $plik) {
   if($line -match $regex) 
   {
     $n=$line
      
     New-ADGroup -Name $n -GroupScope Global
     $finalpath = $gdzie+"\"+$n
     mkdir "$finalpath"
     $prawo= $n + ":(RX)"
     
    icacls $finalpath /grant:r "$prawo"  /t

   }
 
}
}
end{}

}