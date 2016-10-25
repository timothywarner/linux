#region Connect to Your Azure Subscription
# ARM
$defaultStorageAccount = 'itedgestorage'
$defaultResourceGroup = 'ITEdgeRG'

Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName '150dollar'
Set-AzureRmCurrentStorageAccount -ResourceGroupName $defaultResourceGroup -StorageAccountName $defaultStorageAccount 
Set-AzureRmContext -SubscriptionName '150dollar'

#endregion

#region Onboard an Azure Linux VM

# onboarding doc
Start-Process -FilePath https://azure.microsoft.com/en-us/documentation/articles/automation-dsc-onboarding/

# This doesn't seem to work (GRRR)
Register-AzureRmAutomationDscNode -AutomationAccountName 'itedgedsc' `
 -AzureVMName 'itedgelinux1' -ResourceGroupName 'ITEdgeRG' `
 -NodeConfigurationName 'SampleConfig1.demo' -Verbose

# Try this ARM template instead:
Start-Process -FilePath https://azure.microsoft.com/en-us/documentation/templates/dsc-extension-azure-automation-pullserver/

# Or do a manual registration from inside the Linux Azure VM:
cd /opt/microsoft/dsc/Scripts
sudo ./Register.py <accountkey> <accountURL>

#endregion



