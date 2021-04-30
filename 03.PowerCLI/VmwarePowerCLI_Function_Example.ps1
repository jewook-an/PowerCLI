$ModuleManifestName = 'VmwarePowerCLI.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

connect-viserver -server '192.168.50.16' -user 'administrator@vsphere.local' -password 'P@$$w0rd' -force

# get-view -viewtype clustercomputeresource | select Name, @{N="VMs";E={(get-view -viewtype virtualmachine -SearchRoot $_.moref -Filter @{"Config.Template"="False"}).Count} }, @{ N="Templates";E={$clname=$_.name; ($clusters | ? {$_.Name -eq $clname}).Count } }
# $VM = Get-VM -name "W10-ID1-005"
# $vmstat = "" | Select VmName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin
# $vmstat.VmName = $vm.name
# $statcpu = Get-Stat -Entity ($vm)-start (get-date).AddDays(-30) -Finish (get-date).AddDays(-1) -MaxSamples 10000 -stat cpu.usage.average -CPU:$false
# $statmem = Get-Stat -Entity ($vm)-start (get-date).AddDays(-30) -Finish (get-date).AddDays(-1) -MaxSamples 10000 -stat mem.usage.average
# $cpu = $statcpu | Measure-Object -Property value -Average -Maximum -Minimum
# $mem = $statmem | Measure-Object -Property value -Average -Maximum -Minimum

# $vmstat.CPUMax = $cpu.Maximum
# $vmstat.CPUAvg = $cpu.Average
# $vmstat.CPUMin = $cpu.Minimum
# $vmstat.MemMax = $mem.Maximum
# $vmstat.MemAvg = $mem.Average
# $vmstat.MemMin = $mem.Minimum
# Write-Host $vmstat

#get-vm "W10-ID1-005" | get-networkadapter

$VMName = "W10-ID1-002"
$NetworkName = get-vm "W10-ID1-005" | get-networkadapter | Select NetworkName

function GetPortgroupConnectionState
{
	param(
		$VMName,
		$NetworkName
	)
	return get-vm $VMName | get-networkadapter | where {$_.NetworkName -eq $NetworkName} | select ConnectionState
}

function ChangePortgroup
{
	param(
		$VMName,
		$NetworkName,
		$Order
	)

	$index = 1
	$networkAdapters = get-vm $VMName | get-networkadapter

	foreach($networkAdapter in $networkAdapters)
	{
		if($index -eq $order)
		{
			get-vm $VMName | get-networkadapter -name $networkAdapter.name | set-networkadapter -networkname $NetworkName -Confirm:$false -Connected:$true -StartConnected:$true

		}
		$index++
	}
}

function GetHost_MinimumVMCount_ByClusterId
{
	param(
		$id
	)

	$ret = "" | select Name, Id, NumVM

	$minimumHostName = ""
	$minimumNumVM = 999999
	$minimumHostId = ""

	$hosts = Get-VMHost -location (Get-Cluster -id $id) | Select Name, Id, ConnectionState, @{N="Cluster";E={Get-Cluster -VMHost $_}}, @{N="NumVM";E={($_ |Get-VM).Count}}, @{N="PoweredOnNumVM";E={($_ |Get-VM | where {$_.PowerState -eq "PoweredOn"}).Count}}, @{N="PoweredOffNumVM";E={($_ |Get-VM | where {$_.PowerState -eq "PoweredOff"}).Count}} | Sort NumVM
	foreach($hostItem in $hosts)
	{
		if($hostItem.NumVM -lt $minimumNumVM)
		{
			if($hostItem.ConnectionState -eq "Connected")
			{
				$minimumHostName = $hostItem.Name
				$minimumHostId = $hostItem.Id
				$minimumNumVM = $hostItem.NumVM
			}

		}
	}

	$ret.Name = $minimumHostName
	$ret.Id = $minimumHostId
	$ret.NumVM = $minimumNumVM

	return $ret
}
# $clusID = "ClusterComputeResource-domain-c61"
# Write-Host "`$VMName value : $VMName"
# Write-Host "`$NetworkName value : $NetworkName.NetworkName"
# Write-Host "`$clusID value : $clusID"
# GetPortgroupConnectionState $VMName $NetworkName.NetworkName
# GetHost_MinimumVMCount_ByClusterId $clusID
# Write-Host "`GetPortgroupConnectionState($VMName, $NetworkName)"


# get-vm "W10-ID1-005" | get-networkadapter | where {$_.NetworkName -eq "VM Network"} | select ConnectionState
# get-vm "Windows10Pro-x64" | get-networkadapter | where {$_.NetworkName -eq "VM Network"} | select ConnectionState

function GetVMID
{
	param(
		$VMName
	)

	$ret = "" | select ID
	$ret.ID = ""

	try
	{
		$vmObj = Get-VM $VMName -ErrorAction Stop
		$ret.ID = $vmObj.ID
	}
	catch
	{
	}
	return $ret
}


function CheckExistVMByName
{
	param(
		$VMName
	)

	$ret = "" | select Exist
	$ret.Exist = 0

	if(Get-VM -Name $VMName) {$ret.Exist = 1}
	return $ret
}
function GetVMHostByVMName
{
	param($VMName)

	$ret = "" | select Name, Id
	$vmHost = (Get-VM $VMName | Get-VMHost | Select Name, Id)
	$ret.Name = $vmHost.Name
	$ret.Id = $vmHost.Id
	return $ret
}
function GetHost_MinimumVMCount_ByClusterName
{
	param(
		$Name
	)

	return GetHost_MinimumVMCount_ByClusterId (Get-Cluster -name $Name).id
}

# GetHost_MinimumVMCount_ByClusterName "NM_VMWC"
# GetHost_MinimumVMCount_ByClusterId "ClusterComputeResource-domain-c61"

function GetDatastore_MaximumFreeSize_ByDatastoreIdList
{
	param(
		$DatastoreIdList
	)

	$ret = "" | select Name, Id, FreeSizeGB

	$maximumDatastoreName = ""
	$maximumDatastoreId = ""
	$maximumDatastoreFreeSizeGB = 0

	$datastoreIdItems = $DatastoreIdList -csplit ";"
	foreach($datastoreIdItem in $datastoreIdItems)
	{
		$datastoreObj = Get-Datastore -id $datastoreIdItem

		if($datastoreObj.FreeSpaceGB -gt $maximumDatastoreFreeSizeGB)
		{
			$maximumDatastoreName = $datastoreObj.Name
			$maximumDatastoreId = $datastoreObj.Id
			$maximumDatastoreFreeSizeGB = $datastoreObj.FreeSpaceGB
		}
	}

	$ret.Name = $maximumDatastoreName
	$ret.Id = $maximumDatastoreId
	$ret.FreeSizeGB = $maximumDatastoreFreeSizeGB

	return $ret
}
function GetDatastore_MaximumFreeSize_ByDatastoreNameList
{
	param(
		$DatastoreNameList
	)

	$datastoreIdList = ""
	$datastoreNameItems = $DatastoreNameList -csplit ";"
	for($i=0; $i -lt $datastoreNameItems.length; $i++)
	{
		$datastoreIdList = $datastoreIdList + (Get-Datastore -name $datastoreNameItems[$i]).id

		if($i -lt $datastoreNameItems.length-1)
		{
			$datastoreIdList = $datastoreIdList + ";"
		}
	}

	return GetDatastore_MaximumFreeSize_ByDatastoreIdList "$datastoreIdList"
}


function GetDataStoreIDList
{
	$DatastoreIdLists = ""

	$DatastoreIdList = Get-Datastore | Select Id

	for ($i = 0; $i -lt $DatastoreIdList.Count; $i++) {
		$DatastoreIdLists = $DatastoreIdList.id + ";"
	}
	return $DatastoreIdLists
}

function GetDataStoreNameList
{
	$DatastoreNameLists = ""

	$DatastoreNameList = Get-Datastore | Select Name

    for ($i = 0; $i -lt $DatastoreNameList.Count; $i++)
    {
        if($i -lt $DatastoreNameList.length-1)
		{
            $DatastoreNameLists = $DatastoreNameList.name + ";"
        }
        else
        {
            $DatastoreNameLists = $DatastoreNameList.name
        }
	}
	return $DatastoreNameLists
}

$DatastoreIdLists = GetDataStoreIDList
$DatastoreNameLists = GetDataStoreNameList
# $DatastoreIdList = Get-Datastore | Select Id
# for ($i = 0; $i -lt $DatastoreIdList.Count; $i++) {
#     $DatastoreIdLists = $DatastoreIdList.id + ";"
# }

#GetDatastore_MaximumFreeSize_ByDatastoreIdList $DatastoreIdLists
GetDatastore_MaximumFreeSize_ByDatastoreNameList $DatastoreNameLists