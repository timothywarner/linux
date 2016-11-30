break
# #############################################################################
# Deploy Linux VMs to Azure with PowerShell
# Repo: https://github.com/timothywarner/linux
# AUTHOR:  Tim Warner
# EMAIL: timothy-warner@pluralsight.com
# TWITTER: @TechTrainerTim
# WEB: timw.info
# #############################################################################
 
# Press CTRL+M to expand/collapse regions

# Variable list
$mySubscription = '150dollar'
$myResourceGroup = 'ARMResourceGroup01'
$myStorageAccount = 'armstorageaccount01'
$myLocation = 'SouthCentralUS'

Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName $mySubscription
Set-AzureRmContext -SubscriptionName $mySubscription

Get-AzureRmLocation | Sort-Object -Property Location | Select-Object -Property Location | Format-Wide -Column 2

New-AzureRmResourceGroup -Name $myResourceGroup -Location $myLocation

New-AzureRmStorageAccount -ResourceGroupName $myResourceGroup -Name $myStorageAccount -SkuName Standard_LRS -Kind Storage -Location $myLocation

Set-AzureRmCurrentStorageAccount -ResourceGroupName $myResourceGroup -AccountName $myStorageAccount

$Keys = Get-AzureRmStorageAccountKey -ResourceGroupName $myResourceGroup -Name $myStorageAccount
$storageContext = New-AzureStorageContext -StorageAccountName $myStorageAccount -StorageAccountKey $Keys[0].Value
New-AzureStorageContainer -Name 'vhds' -Context $storageContext

$mySubnet = New-AzureRmVirtualNetworkSubnetConfig -Name 'mySubnet' -AddressPrefix 10.0.0.0/24

$myVnet = New-AzureRmVirtualNetwork -Name 'myVnet' -ResourceGroupName $myResourceGroup `
     -Location $myLocation -AddressPrefix 10.0.0.0/16 -Subnet $mySubnet

$myPublicIp = New-AzureRmPublicIpAddress -Name 'myPublicIp' -ResourceGroupName $myResourceGroup `
     -Location $myLocation -AllocationMethod Dynamic

$myNIC = New-AzureRmNetworkInterface -Name "myNIC" -ResourceGroupName $myResourceGroup `
     -Location $myLocation -SubnetId $myVnet.Subnets[0].Id -PublicIpAddressId $myPublicIp.Id
     
$cred = Get-Credential -Message "Type the name and password of the local administrator account."

Get-AzureRmVMSize -Location $myLocation

$myVM = New-AzureRmVMConfig -VMName 'myLinuxVM' -VMSize 'Standard_A2'

$myVM = Set-AzureRmVMOperatingSystem -VM $myVM -ComputerName 'mylinuxvm' -Linux -Credential $cred 

Get-AzureRmVMImagePublisher -Location $myLocation | Select-Object -Property PublisherName

Get-AzureRmVMImageSku -Location $myLocation -PublisherName 'RedHat' -Offer 'RHEL'

$myVM = Set-AzureRmVMSourceImage -VM $myVM -PublisherName 'RedHat' `
     -Offer 'RHEL' -Skus '7.2' -Version 'latest'

$myVM = Add-AzureRmVMNetworkInterface -VM $myVM -Id $myNIC.Id

$myVM = Set-AzureRmVMOSDisk -VM $myVM -Name 'myOsDisk01' -VhdUri 'https://armstorageaccount01.blob.core.windows.net/vhds/myosdisk01.vhd' -CreateOption FromImage #-Linux

New-AzureRmVM -ResourceGroupName $myResourceGroup -Location $myLocation -VM $myVM

Get-AzureRmVM -ResourceGroupName $myResourceGroup