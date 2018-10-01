Write-Output('inicio')

function Procesar-Nsg{
    
    Param(
    [parameter(Mandatory=$true)]
    $nsg
    )

    Write-Output("---nsg---")
    az network nsg show --name $nsg --resource-group $grupo --output table
    Write-Output("---reglas---")
    az network nsg rule list -g $grupo --nsg-name $nsg --output table
}

function Procesar-Grupo {

    Param(
    [parameter(position=1, Mandatory=$true)]
    [System.String] 
    $grupo
    )

    $nsg = az network nsg list -g $grupo --query [].name --output tsv
    if ($nsg) {
        if ($nsg.GetType().fullname -eq "System.String") {
            Procesar-Nsg($nsg)
        } else {
            for ($k = 0; $k -lt $nsg.Length; $k++) {
                Procesar-Nsg($nsg[$k])
            }
        }
    }
}

$accounts = az account list --query '[].[name, id]' --output tsv
for ($i = 0; $i -lt $accounts.Length; $i++) {
    $fieldsAccount = $accounts[$i].split("`t")    
    Write-Output("---cuenta---")
    az account set --subscription $fieldsAccount[1] 
    az account show --output table
    Write-Output("---vnet---")
    az network vnet list --output table
    $grupos = az group list --query [].name --output tsv
    if ($grupos) {
        if ($grupos.GetType().fullname -eq "System.String") {
            Procesar-Grupo($grupos)   
        } else {
            for ($j = 0; $j -lt $grupos.Length; $j++) {
                Procesar-Grupo($grupos[$j])
            }
        }
    }
}

Write-Output('fin')