# Get-PostNordParcelInformation

A simple PowerShell function to retrieve tracking information from the PostNord API.

## Synopsis
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

## Example:
````powershell
Get-PostNordParcelInformation -APIkey "123456789" -ShipmentID "987654321"
````

## History

1.0 - Initial Build 


## Credit

Developed by: Freddie Christiansen | [CloudPilot.no](www.cloudpilot.no)


## License

The MIT License
