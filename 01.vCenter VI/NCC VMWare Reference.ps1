
================================================================================================================================================
# Cluster & Host
================================================================================================================================================
#region

$cluster = Get-Cluster -Name NM_VMWC
$cluster | Get-VMHost
# Name                 ConnectionState PowerState NumCpu CpuUsageMhz CpuTotalMhz   MemoryUsageGB   MemoryTotalGB Version
# ----                 --------------- ---------- ------ ----------- -----------   -------------   ------------- -------
# 192.168.101.15       Connected       PoweredOn      16        1098       33520          20.833          94.462   6.7.0

$esx = $cluster | Get-VMHost
$ds = Get-Datastore -VMHost $esx | Where-Object {$_.Type -eq "VMFS"}

Get-Datastore -VMHost $esx

$cluster | Select @{N="VCname";E={$cluster.Uid.Split(':@')[1]}},
    @{N="DCname";E={(Get-Datacenter -Cluster $cluster).Name}},
    @{N="Clustername";E={$cluster.Name}},
    @{N="Total Physical Memory (MB)";E={($esx | Measure-Object -Property MemoryTotalMB -Sum).Sum}},
    @{N="Configured Memory MB";E={($esx | Measure-Object -Property MemoryUsageMB -Sum).Sum}},
    @{N="Available Memroy (MB)";E={($esx | Measure-Object -InputObject {$_.MemoryTotalMB - $_.MemoryUsageMB} -Sum).Sum}},
    @{N="Total CPU (Mhz)";E={($esx | Measure-Object -Property CpuTotalMhz -Sum).Sum}},
    @{N="Configured CPU (Mhz)";E={($esx | Measure-Object -Property CpuUsageMhz -Sum).Sum}},
    @{N="Available CPU (Mhz)";E={($esx | Measure-Object -InputObject {$_.CpuTotalMhz - $_.CpuUsageMhz} -Sum).Sum}},
    @{N="Total Disk Space (MB)";E={($ds | where {$_.Type -eq "VMFS"} | Measure-Object -Property CapacityMB -Sum).Sum}},
    @{N="Configured Disk Space (MB)";E={($ds | Measure-Object -InputObject {$_.CapacityMB - $_.FreeSpaceMB} -Sum).Sum}},
    @{N="Available Disk Space (MB)";E={($ds | Measure-Object -Property FreeSpaceMB -Sum).Sum}}

# VCname                     : 192.168.50.16
# DCname                     : Datacenter
# Clustername                : NM_VMWC
# Total Physical Memory (MB) : 96729.5390625
# Configured Memory MB       : 21332
# Available Memroy (MB)      : 75397.5390625
# Total CPU (Mhz)            : 33520
# Configured CPU (Mhz)       : 1934
# Available CPU (Mhz)        : 31586
# Total Disk Space (MB)      : 907520
# Configured Disk Space (MB) : 592061
# Available Disk Space (MB)  : 315459


#================================================================================================================================================
Get-Cluster NM_VMWC | Get-Vm | Where {$_.PowerState -eq 'PoweredOn'} | Select Name, Host, NumCpu, MemoryMB

#endregion

================================================================================================================================================
# VM Resource 변경
================================================================================================================================================
#region

#endregion
$VM = Get-VM -Name AutoFullClone1
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec[] (1)
$spec.deviceChange[0] = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "remove"
$spec.deviceChange[0].device = $VM.ExtensionData.Config.Hardware.Device | Where-Object {$_.DeviceInfo.Label -eq "네트워크 어댑터 2"}
$VM.ExtensionData.ReconfigVM_Task($spec)
================================================================================================================================================
# >> VM IPAddress
Get-VM | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}
Get-Cluster "Web-Cluster-*" | Get-VM | Select Name, Host, @{N="IP Address";E={@($_.guest.IPAddress[0])}}

================================================================================================================================================
# VM 여러 정보들 >> Get-VM
================================================================================================================================================
#region

Get-VM | Sort | Get-View -Property @('Name', 'Config.GuestFullName', 'Guest.GuestFullName', 'Snapshot.RootSnapshotList') | Select -Property Name, @{N='ConfiguredOS';E={$_.Config.GuestFullName -replace ' ', ''}},  @{N='RunningOS';E={$_.Guest.GuestFullName}}, @{N='SnapShot';E={$_.Snapshot.RootSnapshotList.Name}}

Get-VM | Sort | Get-View -Property @('Name', 'Config.GuestFullName', 'Guest.GuestFullName', 'Snapshot.RootSnapshotList') | Select -Property Name, @{N='ConfiguredOS';E={$_.Config.GuestFullName -replace ' ', ''}},  @{N='RunningOS';E={$_.Guest.GuestFullName}}, @{N='SnapShot';E={$_.Snapshot.RootSnapshotList.Name}} | Where-Object {($_.Snapshot.Length -eq 0) -and ($_.ConfiguredOS -eq 'MicrosoftWindows10(64비트)')}
Get-VM | Sort | Get-View -Property @('Guest.GuestFullName') | Select -Property Name, @{N='RunningOS';E={$_.Guest.GuestFullName}}

# Name           ConfiguredOS             RunningOS                  SnapShot
# ----           ------------             ---------                  --------
# AutoFullClone1 MicrosoftWindows10(64비트) Microsoft Windows 10(64비트)
# ManualVM1      MicrosoftWindows10(64비트) Microsoft Windows 10(64비트)
# TESTVM         MicrosoftWindows10(64비트)
# Win10-Link01   MicrosoftWindows10(64비트) Microsoft Windows 10(64비트)
# Win10-Link02   MicrosoftWindows10(64비트) Microsoft Windows 10(64비트)
# Win10-Link03   MicrosoftWindows10(64비트) Microsoft Windows 10(64비트)

Get-VM | Select-Object -Property Name, VMHost, @{N = 'Cluster';E={$_.VMHost.Parent}}, @{N = 'Folder';E={$_.Folder.Name}}, @{N = 'SnapShot';E={$_.ExtensionData.Snapshot}} | Where-Object {($_.Folder -ne '{replicafolder}') -and ($_.Snapshot.Length -ne 0)}
Get-VM | Select-Object -Property Name, VMHost, @{N = 'Cluster';E={$_.VMHost.Parent}}, @{N = 'Folder';E={$_.Folder.Name}}, @{N = 'SnapShot';E={$_.ExtensionData.Snapshot}} | Where-Object {($_.Folder -ne 'VMwareViewComposerReplicaFolder') -and ($_.Snapshot.Length -ne 0)}

#endregion
================================================================================================================================================
# Get-Template
================================================================================================================================================

Get-Template | Sort | Get-View -Property @('Name', 'Config.GuestFullName') | Select -Property Name, @{N='ConfiguredOS';E={$_.Config.GuestFullName -replace ' ', ''}} | Where-Object {$_.ConfiguredOS -eq 'MicrosoftWindows10(64비트)'}

================================================================================================================================================
# Get-ResourcePool
================================================================================================================================================

Get-ResourcePool -Location NM_VMWC | Select Parent, Name, @{N='ResourcePoolPath';E={'/Datacenter/host/NM_VMWC' + '/' + $_.Name}}

================================================================================================================================================
# Get-Datastore
================================================================================================================================================

Get-Datastore | Select Name, Accessible, @{N='DatastorePath';E={'/Datacenter/host/NM_VMWC' + '/' + $_.Name}} | Where-Object {$_.Accessible -eq 'True'}

