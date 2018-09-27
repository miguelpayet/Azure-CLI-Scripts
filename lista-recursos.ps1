$accounts = az account list --query '[].[name, id]' --output tsv
for ($i = 0; $i -lt $accounts.Length; $i++) {
    $fields = $accounts[$i].split("`t")
    Write-Output "------------"
    Write-Output $fields[0]
    Write-Output "------------"
    az account set --subscription $fields[1]

    $recursos = az group list --query '[].[name]' --output tsv
    if ($recursos) {
        if ($recursos.GetType().fullname -eq "System.String") {
            az resource list --resource-group $recursos --query '[].[type,name]' --output table
        } else {
            for ($j = 0; $j -lt $recursos.Length; $j++) {
                az resource list --resource-group $recursos[$j] --query '[].[type,name]' --output table
            }
        }
    }
}