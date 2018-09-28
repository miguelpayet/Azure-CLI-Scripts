write-host('hola')

function Procesar-Linea($consumo) {
    $fieldsConsumo = $consumo.split("`t")
    if ($fieldsConsumo[11].indexOf("/") -eq -1) {
        $grupo = $fieldsConsumo[11] 
    } else {
        $fieldsInstance = $fieldsConsumo[11].split("/")
        $grupo = $fieldsInstance[4]
    }
    Write-Host($fieldsAccount[0],$fieldsConsumo[0],$fieldsConsumo[1],$fieldsConsumo[2],$fieldsConsumo[3],$fieldsConsumo[4],$fieldsConsumo[5],$fieldsConsumo[6],$fieldsConsumo[7],$fieldsConsumo[8],$fieldsConsumo[9],$fieldsConsumo[10],$grupo) -Separator ","
}

$accounts = az account list --query '[].[name, id]' --output tsv
Start-Transcript -LiteralPath "test.txt"
write-host('cuenta','accountName','instanceLocation','instanceName','currency','pretaxCost','product','consumedService','subscriptionName','usageStart','usageEnd','billingPeriodId','resourceGroup') -Separator ","
for ($i = 0; $i -lt $accounts.Length; $i++) {
    $fieldsAccount = $accounts[$i].split("`t")
    az account set --subscription $fieldsAccount[1] 
    $consumo = az consumption usage list --query [].[accountName,instanceLocation,instanceName,currency,pretaxCost,product,consumedService,subscriptionName,usageStart,usageEnd,billingPeriodId,instanceId] --output tsv --start-date '2018-01-01' --end-date '2018-01-31'
    if ($consumo) {
        if ($consumo.GetType().fullname -eq "System.String") {
            Procesar-Linea($consumo)
        } else {
            for ($j = 0; $j -lt $consumo.Length; $j++) {
                if ($consumo[$j]) {
                    Procesar-Linea($consumo[$j])                   
                }
            }
        }
    } else {
        Write-Host($fieldsAccount[0],"","","","",0,"","","","","","","") -Separator ","
    }
}
Stop-Transcript
