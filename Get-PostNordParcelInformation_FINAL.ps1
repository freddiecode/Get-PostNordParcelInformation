<#
.Synopsis
   A simple PowerShell function to retrieve tracking information from the PostNord API.
.PARAMETER APIKey
   You'll need a API-key to call the API. You can easily obtain a API-key by register for a "Free plan" by visiting
   https://developer.postnord.com. 
.PARAMETER ShipmentID
    A string with your parcels shipping ID/Number.
.EXAMPLE
   Get-PostNordParcelInformation -APIkey "123456789" -ShipmentID "987654321"
.EXAMPLE2
   $MyArray = "123456789", "987654321"
   $MyArray | ForEach-Object {Get-PostNordParcelInformation -APIKey "888888888" -ShipmentID $_}
.EXAMPLE2
   Get-PostNordParcelInformation -APIKey "123456789" -ShipmentID "987654321" | Select-Object ShipmentID, Status, DeliveryDate
.LINK
   www.cloudpilot.no // Freddie Christiansen (freddie@cloudpilot.no) - 2020
#>
function Get-PostNordParcelInformation
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (

        [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your API key)")]
        [Alias('Key')]
        [string[]]$APIKey,

        [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        HelpMessage = "Shipment or Item identifier)")]
        [Alias('Shipment number')]
        [string[]]$ShipmentID
    )

    Begin
    {
    }
    Process
    {
        try{


            $URL = "https://api2.postnord.com/rest/shipment/v1/trackandtrace/findByIdentifier.json?"
            
            $Request = $URL + "apikey=" + $APIKey + "&id=" + $ShipmentID + "&locale=en"        

            $Get = Invoke-RestMethod -ContentType "application/json" -Uri $Request

            $Response = $Get.TrackingInformationResponse.shipments | ConvertTo-Json | ConvertFrom-Json

            $Shipment = $Response | Select-Object -Property *

            $TimeObject = $Shipment | ForEach-Object {if ($_.deliveryDate -ne $null) {[datetime]::Parse($_.deliveryDate)} else {$_}}

            $Final = @()

            $ParcelProperties = [ordered]@{

                ShipmentID = $Shipment.shipmentId
                Status = ($Shipment.status).substring(0,1).toupper()+($Shipment.status).substring(1).tolower()
                StatusBody = $Shipment.statusText.body
                StatusHeader = $Shipment.statusText.header
                DeliveryDate = $TimeObject
                AssessedWeight = $Shipment.assessedWeight.value+ " " +$Shipment.assessedWeight.unit
                AssessedVolume = $Shipment.assessedVolume.value+ " "+$Shipment.assessedVolume.unit
                Service = $Shipment.service.code+ " "+$Shipment.service.name
                AssessedNumberOfItems = $Shipment.assessedNumberOfItems
                Consignee = $Shipment.consignee.address.postCode+ " "+($Shipment.consignee.address.city).substring(0,1).toupper()+($Shipment.consignee.address.city).substring(1).tolower()+ ", "+$Shipment.consignee.address.country+ ", "+$Shipment.consignee.address.countryCode
                Consignor = ($Shipment.consignor.name).substring(0,1).toupper()+($Shipment.consignor.name).substring(1).tolower()
                ReturnParty = ($Shipment.returnParty.name).substring(0,1).toupper()+($Shipment.returnParty.name).substring(1).tolower()+", "+($Shipment.returnParty.address.street1).substring(0,1).toupper()+($Shipment.returnParty.address.street1).substring(1).tolower()+", "+$Shipment.returnParty.address.postCode+ " "+($Shipment.returnParty.address.city).substring(0,1).toupper()+($Shipment.returnParty.address.city).substring(1).tolower()+ ", "+$Shipment.returnParty.address.country+ ", "+$Shipment.returnParty.address.countryCode
                CustomerNumbers = $Shipment.customerNumbers
                ShipmentReferences = $Shipment.shipmentReferences.name+ ": "+$Shipment.shipmentReferences.value+ ", "+$Shipment.shipmentReferences.type
                AdditionalServices =  $Shipment.additionalServices
                SplitStatuses = $Shipment.splitStatuses
                
            
                }
                    

            $Final += New-Object -TypeName PSObject -Property $ParcelProperties


            Write-Output $Final
        
            }
        
            catch{
        

        Write-Error "Something isn't working as it should. Please check your API-key, Shipment ID and try again." -Category InvalidData

            }
    }
  
    End
    {
    }
    
        
}

  

   

    