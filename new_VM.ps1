#script in french to create virtual machine on Hyper-V
#include Disk creation

$name = read-host "Nom de la VM"
$hdd = Read-Host "Type de VHDX: (dyn)amic / (dif)ferencing" #should add static too
[Int64]$RAM=4GB
$PROC = 6
$Version = "8.0"
$Gen = "2.0"
[bool]$Virt = $true
$Switchname = "External"
$path= "C:\Hyper-V"
$paging = "E:\hyper-v"
$parent = "C:\Hyper-V\parent2019.vhdx"
[Int64]$Size = 4GB

Do {
$RAMGB = $RAM/1024/1024/1024
$SizeGB = $Size/1024/1024/1024
echo " "
echo "Options:"
echo "chemin: $path\$name, $PROC CPU, $RAMGB GB RAM, Paging&snapshot: $paging\$name, Virtualisation inbriquée: $Virt"
if ($hdd -eq "dyn") {echo " Taille du disque dynamique : $SizeGB GB"}else{echo " Emplacement du parent : $parent"}
$go = Read-Host "Continuer avec ces valeurs? o/n"
if (($go -eq "o") -or ($go -eq "oui") -or ($go -eq "y") -or ($go -eq "yes"))
{
if ($hdd -eq "dif"){
New-VHD -Path $Path\$name\$name.vhdx -ParentPath $parent -Differencing
}else{
New-VHD -Path $Path\$name\$name.vhdx -SizeBytes $Size -Dynamic
}
New-VM -Name $name -MemoryStartupBytes $RAM -SwitchName $Switchname -VHDPath $Path\$name\$name.vhdx -Path $Path\$name\ -Version $Version -Generation $Gen
Set-VM -VMName $name -ProcessorCount $PROC -SmartPagingFilePath "$paging\$name" -SnapshotFileLocation "$paging\$name"
Set-VMProcessor -VMName $name -ExposeVirtualizationExtensions $Virt
if ($Virt){
Set-VMNetworkAdapter -VMName $name -MacAddressSpoofing on
}
break
}else{
$temppath= read-host "Chemin de la VM"
if($temppath) {$path = $temppath}
$tempPROC = read-host "Nombre de CPU"
if($tempPROC) {$PROC = $tempPROC}
[Int64]$tempRAM = 1GB*(read-host "Taille de la mémoire en GB")
if($tempRAM) {[Int64]$RAM = [Int64]$tempRAM}
$temppaging = read-host "Chemin du paging et des snapshot"
if($temppaging) {$paging = $temppaging}
$tempVirt = read-host "Virtualisation imbriquée true/false"
if($tempVirt -eq "false") {[bool]$Virt = $false}else {[bool]$Virt = $true}
if ($hdd -eq "dyn"){
$tempSize = 1GB*(read-host "Taille du disque dynamique en GB")
if($tempSize) {[Int64]$Size = [Int64]$tempSize}
}else {
$tempparent = read-host "Emplacement du disque parent"
if($tempparent) {$tempparent = $parent}
}
echo " "
}
}while (($go -ne "o") -or ($go -ne "oui") -or ($go -ne "y") -or ($go -ne "yes"))
