write-host('hola')

$accounts = az account list --query '[].[name, id]' --output tsv
Start-Transcript -LiteralPath "test.csv"
write-host('suscripción', 'cuenta', 'instanceLocation','instanceName','currency','pretaxCost','product','consumedService','subscriptionName','usageStart','usageEnd','billingPeriodId','resourceGroup') -Separator ","
for ($i = 0; $i -lt $accounts.Length; $i++) {
    $fieldsAccount = $accounts[$i].split("`t")
    az account set --subscription $fieldsAccount[1] 
    $consumo = az consumption usage list --query [].[accountName,instanceLocation,instanceName,currency,pretaxCost,product,consumedService,subscriptionName,usageStart,usageEnd,billingPeriodId,instanceId] --start-date '2018-09-01' --end-date '2018-11-16' --output tsv
    if ($consumo) {
        if ($consumo.GetType().fullname -ne "System.String") {
            foreach ($reg in $consumo) {
                #Write-Host($reg)
                $arr = $reg.split("`t")
                if ($arr[11].indexOf("/") -eq -1) {
                    $grupo = $arr[11] 
                } else {
                    $instance = $arr[11].split("/")
                    $grupo = $instance[4]
        }
                Write-Host($fieldsAccount[0], $arr[0], $arr[1],$arr[2],$arr[3],$arr[4],$arr[5],$arr[6],$arr[7],$arr[8],$arr[9],$arr[10],$grupo) -Separator ","
            }
        } else {
            Write-Host($fieldsAccount[0], "linea en blanco") -Separator ""
        }
    }
}
Stop-Transcript

Write-Host("bye")