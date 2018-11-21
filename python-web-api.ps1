$username = "kemoly"
$password = "h0l@QueTal"
$appsrv1 = "webapp1"
$appsrv2 = "webapp2"
$webapp1 = "kemolywebapp1" #+ -join ((65..90) + (97..122) | Get-Random -Count 5 | %{[char]$_})
$webapp2 = "kemolywebapp2" #+ -join ((65..90) + (97..122) | Get-Random -Count 5 | %{[char]$_})
$location1 = "east us 2" 
$location2 = "west us"
$rg = "webapp"

Set-PSDebug -Trace 1

Remove-AzureRmResourceGroup -Name $rg -Force
New-AzureRmResourceGroup -Name $rg -Location $location1

az webapp deployment user set --user-name $username --password $password

cd D:\WPy-3702\Rest

az appservice plan create --name $appsrv1 --resource-group $rg --is-linux --location $location1 --sku B1
az webapp create --resource-group $rg --plan $appsrv1 --name $webapp1 --deployment-local-git --startup-file "startup.txt" --% --runtime "PYTHON|3.7" 
git remote add origin1 https://$username@$webapp1.scm.azurewebsites.net/$webapp1.git
git push origin1 master

az appservice plan create --name $appsrv2 --resource-group $rg --is-linux --location $location2 --sku B1
az webapp create --resource-group $rg --plan $appsrv2 --name $webapp2 --deployment-local-git --startup-file "startup.txt" --% --runtime "PYTHON|3.7" 
git remote add origin2 https://$username@$webapp2.scm.azurewebsites.net/$webapp2.git
git push origin2 master
