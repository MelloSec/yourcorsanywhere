[CmdletBinding()]
param (
    [Parameter()]
    $Key,
    [Parameter()]
    $SecretKey
)

if (-not (Get-Module AWSPowerShell)) {
	Import-Module AWSPowerShell -Force
}

$AccessKey = "$Key"
$SecretAccessKey = "$SecretKey"
$ProfileName = "PwshDeploy"
$NameTag = @{ Key="Name"; Value="LuridArray" }
$TagSpec = New-Object Amazon.EC2.Model.TagSpecification
$TagSpec.ResourceType = "instance"
$TagSpec.Tags.Add($NameTag)
$UserDataScript = Get-Content -Raw ".\lure-setup.sh"
$UserData = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($UserDataScript))

# Get the first keypair in your account for deployment
# $keyPairList = aws ec2 describe-key-pairs | ConvertFrom-Json
# $firstKey = $keyPairList.KeyPairs[0].KeyName

# Create one
$keyPair = New-EC2KeyPair -KeyName LuridArray | Out-File -FilePath ~/.ssh/LuridArray.pem
$keyPairId = $keyPair.KeyPairId




# Deployment Parameters including VM size, image, tags and the User Data from the variable above
$EC2InstanceDeploymentParameters = @{
    ImageId = "ami-09e67e426f25ce0d7"
    InstanceType = "t2.nano"
    # SubnetId = "subnet_luridarray"
    # KeyName = "LuridArray"
    KeyName = $keyPairId
    MinCount = "1"
    MaxCount = "1"
    Region = "us-east-1"
    TagSpecification = $TagSpec
    UserData = $UserData
}

#Setup Credential
Write-Output "Setting up credential object"
Set-AWSCredential -AccessKey $AccessKey -SecretAccessKey $SecretAccessKey -StoreAs $ProfileName

#Use Credential
Write-Output "Setting profile creds"
Set-AWSCredential -ProfileName $ProfileName

#Deploy Instance
Write-Output "Deploying Instance.."
$InstanceInfo = New-EC2Instance @EC2InstanceDeploymentParameters

Write-Host "Here is your EC2 Instance Deployment Information"
$InstanceInfo.Instances | Format-Table @{Label="Instance Name"; Expression={$_.Tag.Value}},InstanceId,InstanceType,PrivateIPAddress,Platform

# Wait for the instance to be ready
Start-Sleep -Seconds 30

# Get AWS EC2 instance
$instance = aws ec2 describe-instances --filters "Name=tag:Name,Values=LuridArray" | ConvertFrom-Json

# Get Security Group of EC2 instance
$sg = $instance.Reservations.Instances.SecurityGroups.GroupId

# Web Ports
$ports = @(80,443)
foreach ($port in $ports) {
    aws ec2 authorize-security-group-ingress --group-id $sg --protocol tcp --port $port --cidr 0.0.0.0/0
}

# SSH for your public IP
$IP = iwr https://ipinfo.io/ip
$cidr = $IP.Content+"/32"

Write-Output "You're IP Address is $Ip"
aws ec2 authorize-security-group-ingress --group-id $sg --protocol tcp --port 22 --cidr $cidr






























# $EC2InstanceDeploymentParameters = @{
#     ImageId = "ami-09e67e426f25ce0d7"
#     InstanceType = "t2.nano"
#     SecurityGroupId = "sg-id","sg-id2","sg-id3"
#     SubnetId = "subnet-id"
#     KeyName = "keypair"
#     MinCount = "1"
#     MaxCount = "1"
#     Region = "us-west-2"
#     TagSpecification = $TagSpec
#     UserData = $UserData
# }

# #Setup Credential
# Set-AWSCredential -AccessKey $AccessKey -SecretAccessKey $SecretAccessKey -StoreAs $ProfileName

# #Use Credential
# Set-AWSCredential -ProfileName $ProfileName

# #Deploy Instance
# $InstanceInfo = New-EC2Instance @EC2InstanceDeploymentParameters

# Write-Host "Here is your EC2 Instance Deployment Information"
# $InstanceInfo.Instances | Format-Table @{Label="Instance Name"; Expression={$_.Tag.Value}},InstanceId,InstanceType,PrivateIPAddress,Platform
