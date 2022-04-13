# Query to get meta data of an instance within Azure

$metaData = Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Proxy $Null -Uri "http://169.254.169.254/metadata/instance?api-version=2021-01-01"
$metaDataJSON = $metaData | ConvertTo-Json -Depth 6

# print the metaDataJSON
Write-Output $metaDataJSON

# to get the location from compute part 
$location = $metaData.compute.location

Write-Output $location

# to get the particular private ip address from metaData output
$privateIpAddress = $metaData.network.interface.ipv4.ipAddress.privateIpAddress

Write-Output "PrivateIpAddress is  - $($privateIpAddress)"
