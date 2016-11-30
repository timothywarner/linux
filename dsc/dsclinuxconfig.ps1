Find-Module -Name nx

Install-Module -Name nx -Verbose

Get-DscResource -Name nx*

Get-DscResource -Name nxFile | Select-Object -ExpandProperty Properties

Set-Location -Path 'C:\Users\Tim\Desktop\linux'

ise .\sampleconfig1.ps1

ise .\SampleConfig1\localhost.mof

Configuration ExampleConfiguration {

    Import-DscResource -Module nx

    Node  "linux1" {
        nxFile ExampleFile {

            DestinationPath = "/tmp/example"
            Contents = "Hello world! `n"
            Ensure = "Present"
            Type = "File"
        }

    }
}

ExampleConfiguration -OutputPath:"C:\temp"

Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value *

Set-Item -Path WSMan:\localhost\Client\AllowUnencrypted -Value $true

$Node = "linux1"
$Credential = Get-Credential -UserName:"root" -Message:"Enter Linux Root Password:"

#Ignore SSL certificate validation
$opt = New-CimSessionOption -UseSsl:$false -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true

#Options for a trusted SSL certificate
$opt = New-CimSessionOption -UseSsl:$false 
$Sess=New-CimSession -Credential:$credential -ComputerName:$Node -Port:5986 -Authentication:basic -SessionOption:$opt -OperationTimeoutSec:90

Start-DscConfiguration -Path:"C:\temp" -CimSession:$Sess -Wait -Verbose

# contrast with Azure Automation DSC

Start-Process -FilePath https://portal.azure.com

ise .\onboardlinuxvm.ps1