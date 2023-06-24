function Invoke-DeployCaptureServer {
    <#
    .DESCRIPTION
        Deploy the token capture setup in Azure
    .EXAMPLE
         Invoke-DeployCaptureServer -ResourceGroup CappaDonna -location eastus -vmName cappadonna -vmPublicDNSName cappadonna -pubKey ~/.ssh/id_rsa.pub
    #>
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroup,
        [Parameter(Mandatory=$false)]
        [string]$location = "eastus",
        [Parameter(Mandatory=$True)]
        [String]$vmName,
        [Parameter(Mandatory=$True)]
        [String]$vmPublicDNSName,
        [Parameter(Mandatory=$True)]
        [String]$pubKey
    )

    Write-Output "Running Commands.."
    Write-Output "az group create --name $ResourceGroup --location $location"
    az group create --name $ResourceGroup --location $location
    Start-Sleep -Seconds 5

    Write-Output "az vm create --resource-group $ResourceGroup --name $vmName --image UbuntuLTS --public-ip-sku Standard --size Standard_B1s --public-ip-address-dns-name $vmPublicDNSName --admin-username azureuser --ssh-key-values $pubKey"
    az vm create --resource-group $ResourceGroup --name $vmName --image UbuntuLTS --public-ip-sku Standard --size Standard_B1s --public-ip-address-dns-name $vmPublicDNSName --admin-username azureuser  --ssh-key-values $pubKey
    Start-Sleep -Seconds 5

    Write-Output "az vm open-port --port 80,443,8443 --resource-group $ResourceGroup --name $vmName"
    az vm open-port --port 80,443,8443 --resource-group $ResourceGroup --name $vmName
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'apt-get update && apt-get install -y git python3-pip certbot wget apt-transport-https software-properties-common screen unzip tmux npm python-pip'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'apt-get update && apt-get install -y git python3-pip certbot wget apt-transport-https software-properties-common screen unzip tmux npm python-pip'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'wget -O /home/azureuser/packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'dpkg -i /home/azureuser/packages-microsoft-prod.deb'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'dpkg -i /home/azureuser/packages-microsoft-prod.deb'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'apt-get update && apt-get install -y powershell'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'apt-get update && apt-get install -y powershell'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser git clone https://github.com/rvrsh3ll/TokenTactics.git /home/azureuser/TokenTactics'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser git clone https://github.com/rvrsh3ll/TokenTactics.git /home/azureuser/TokenTactics'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser git clone https://github.com/f-bader/TokenTacticsV2 /home/azureuser/TokenTacticsV2'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser git clone https://github.com/f-bader/TokenTacticsV2 /home/azureuser/TokenTacticsV2'
    Start-Sleep -Seconds 5

    # Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'install-module AADInternals -Force -Confirm'"
    # az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'pwsh; Install-Module AADInternals -Force -Confirm'
    # Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'certbot certonly --register-unsafely-without-email -d $vmPublicDNSName.eastus.cloudapp.azure.com --standalone --preferred-challenges http --non-interactive --agree-tos'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts "certbot certonly --register-unsafely-without-email -d $vmPublicDNSName.eastus.cloudapp.azure.com --standalone --preferred-challenges http --non-interactive --agree-tos"
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser mkdir /home/azureuser/TokenTactics/capturetokenphish/certs'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser mkdir /home/azureuser/TokenTactics/capturetokenphish/certs'
    
    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser mkdir /home/azureuser/certs'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser mkdir /home/azureuser/certs'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript 'cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/privkey.pem /home/azureuser/TokenTactics/capturetokenphish/certs/ && cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/cert.pem /home/azureuser/TokenTactics/capturetokenphish/certs/ && chown -R azureuser:azureuser /home/azureuser/'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts "cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/privkey.pem /home/azureuser/TokenTactics/capturetokenphish/certs/ && cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/cert.pem /home/azureuser/TokenTactics/capturetokenphish/certs/ && chown -R azureuser:azureuser /home/azureuser/"
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/privkey.pem /home/azureuser/certs/ && cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/cert.pem /home/azureuser/certs/ && chown -R azureuser:azureuser /home/azureuser/'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts "cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/privkey.pem /home/azureuser/certs/ && cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/cert.pem /home/azureuser/certs/ && chown -R azureuser:azureuser /home/azureuser/"
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser pip3 install -r /home/azureuser/TokenTactics/capturetokenphish/requirements.txt'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser pip3 install -r /home/azureuser/TokenTactics/capturetokenphish/requirements.txt'
    Start-Sleep -Seconds 5

    Write-Output "Cloning YOURCORS repo: 'sudo -i -u azureuser git clone --recurse-submodules https://github.com/mellosec/yourcorsanywhere.git /home/azureuser/yourcorsanywhere'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser git clone --recurse-submodules https://github.com/mellosec/yourcorsanywhere.git /home/azureuser/yourcorsanywhere'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser pip3 install -r /home/azureuser/yourcorsanywhere/capture-server/requirements.txt'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser pip3 install -r /home/azureuser/yourcorsanywhere/capture-server/requirements.txt'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser mkdir /home/azureuser/yourcorsanywhere/capture-server/certs'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser mkdir /home/azureuser/yourcorsanywhere/capture-server/certs'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/privkey.pem /home/azureuser/yourcorsanywhere/capture-server/certs/ && cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/cert.pem /home/azureuser/yourcorsanywhere/capture-server/certs/ && chown -R azureuser:azureuser /home/azureuser/'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts "cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/privkey.pem /home/azureuser/yourcorsanywhere/capture-server/certs/ && cp /etc/letsencrypt/live/$vmPublicDNSName.eastus.cloudapp.azure.com/cert.pem /home/azureuser/yourcorsanywhere/capture-server/certs/ && chown -R azureuser:azureuser /home/azureuser/"
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo chmod +x /home/azureuser/yourcorsanywhere/capture-server/capturetoken.py'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo chmod +x /home/azureuser/yourcorsanywhere/capture-server/capturetoken.py'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser tmux new-session -d -s capture'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser tmux new-session -d -s capture'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureusertmux send-keys -t capture `"cd /home/azureuser/yourcorsanywhere/capture-server`" Enter'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser tmux send-keys -t capture `"cd /home/azureuser/yourcorsanywhere/capture-server`" Enter'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser tmux send-keys -t capture `"sudo python3 /home/azureuser/yourcorsanywhere/capture-server/capturetoken.py`" Enter'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'sudo -i -u azureuser tmux send-keys -t capture `"sudo python3 /home/azureuser/yourcorsanywhere/capture-server/capturetoken.py`" Enter'
    Start-Sleep -Seconds 5

    Write-Output "az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'pwsh -c Install-Module -Name AADInternals -Force'"
    az vm run-command invoke -g $ResourceGroup -n $vmName --command-id RunShellScript --scripts 'pwsh -c Install-Module -Name AADInternals -Force'
    Start-Sleep -Seconds 5

    Write-Output "SSH into your server"
    $privateKey = $pubKey.Replace(".pub", "")

    Write-Output "SSH command 'ssh -i $privateKey azureuser@$vmPublicDNSName.eastus.cloudapp.azure.com'"
    ssh -o StrictHostKeyChecking=no-i $privateKey azureuser@$vmPublicDNSName.eastus.cloudapp.azure.com
}
