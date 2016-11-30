break
# #############################################################################
# Deploy Linux VM to Azure with an ARM Template
# Repo: https://github.com/timothywarner/linux
# AUTHOR:  Tim Warner
# EMAIL: timothy-warner@pluralsight.com
# TWITTER: @TechTrainerTim
# WEB: timw.info
# #############################################################################
 
# Press CTRL+M to expand/collapse regions

# The source repo
Start-Process -FilePath https://azure.microsoft.com/en-us/resources/templates/101-vm-simple-linux/

# Load up ARM template files
ise .\azuredeploy.json
ise .\azuredeploy.parameters.json

# Define new resource group container
$myRG = 'armresourcegroup201'
$myDeployment = 'myarmdeployment201'
New-AzureRmResourceGroup -Name $myRG -Location 'southcentralus'

# Deploy!
New-AzureRmResourceGroupDeployment -Name $myDeployment -ResourceGroupName $myRG  `
   -TemplateParameterFile '.\azuredeploy.parameters.json' -TemplateFile '.\azuredeploy.json'