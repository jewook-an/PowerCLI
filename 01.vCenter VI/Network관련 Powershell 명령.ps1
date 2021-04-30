
#===============================================================================================================================
# Get-VirtualNetwork
#===============================================================================================================================
PS C:\WINDOWS\system32> Get-VirtualNetwork
#region
<#
Name                                               NetworkType
----                                               -----------
VM Network                                         Network
VM Network2                                        Network
VM Network2                                        Network
VM Network                                         Network
#>
#-------------------------- Example 1 --------------------------
$networks = Get-VirtualNetwork
#Retrieves all virtual networks on a vCenter server system.
#-------------------------- Example 2 --------------------------
$networks = Get-VirtualNetwork -Name 'VM*'
#Retrieves all virtual networks whose names begin with 'VM'.
#-------------------------- Example 3 --------------------------
$networks = Get-VirtualNetwork -NetworkType Distributed
#Retrieves all distributed networks on the vCenter server system.
#-------------------------- Example 4 --------------------------
$networks = Get-VirtualNetwork -Id 'network_id'
#Retrieves a virtual network by Id.

#endregion
PS C:\WINDOWS\system32> (Get-VirtualNetwork).ExtensionData
#region Sample Data
<#

Summary             : VMware.Vim.NetworkSummary
Host                : {HostSystem-host-28}
Vm                  : {}
Name                : test
LinkedView          :
Parent              : Folder-group-n25
CustomValue         : {}
OverallStatus       : green
ConfigStatus        : green
ConfigIssue         : {}
EffectiveRole       : {-1}
Permission          : {}
DisabledMethod      : {}
RecentTask          : {}
DeclaredAlarmState  : {}
TriggeredAlarmState : {}
AlarmActionsEnabled : True
Tag                 : {}
Value               : {}
AvailableField      : {}
MoRef               : Network-network-1997
Client              : VMware.Vim.VimClientImpl

Summary             : VMware.Vim.NetworkSummary
Host                : {HostSystem-host-28}
Vm                  : {VirtualMachine-vm-244, VirtualMachine-vm-251, VirtualMachine-vm-1188, VirtualMachine-vm-1193...}
Name                : VM Network
LinkedView          :
Parent              : Folder-group-n25
CustomValue         : {}
OverallStatus       : green
ConfigStatus        : green
ConfigIssue         : {}
EffectiveRole       : {-1}
Permission          : {}
DisabledMethod      : {}
RecentTask          : {}
DeclaredAlarmState  : {}
TriggeredAlarmState : {}
AlarmActionsEnabled : True
Tag                 : {}
Value               : {}
AvailableField      : {}
MoRef               : Network-network-30
Client              : VMware.Vim.VimClientImpl

Summary             : VMware.Vim.NetworkSummary
Host                : {HostSystem-host-28}
Vm                  : {}
Name                : VM Network2
LinkedView          :
Parent              : Folder-group-n25
CustomValue         : {}
OverallStatus       : green
ConfigStatus        : green
ConfigIssue         : {}
EffectiveRole       : {-1}
Permission          : {}
DisabledMethod      : {}
RecentTask          : {}
DeclaredAlarmState  : {}
TriggeredAlarmState : {}
AlarmActionsEnabled : True
Tag                 : {}
Value               : {}
AvailableField      : {}
MoRef               : Network-network-305
Client              : VMware.Vim.VimClientImpl

Summary             : VMware.Vim.NetworkSummary
Host                : {HostSystem-host-28}
Vm                  : {VirtualMachine-vm-1942}
Name                : test001
LinkedView          :
Parent              : Folder-group-n25
CustomValue         : {}
OverallStatus       : green
ConfigStatus        : green
ConfigIssue         : {}
EffectiveRole       : {-1}
Permission          : {}
DisabledMethod      : {}
RecentTask          : {}
DeclaredAlarmState  : {}
TriggeredAlarmState : {}
AlarmActionsEnabled : True
Tag                 : {}
Value               : {}
AvailableField      : {}
MoRef               : Network-network-1998
Client              : VMware.Vim.VimClientImpl

Summary             : VMware.Vim.NetworkSummary
Host                : {HostSystem-host-1903}
Vm                  : {}
Name                : VM Network2
LinkedView          :
Parent              : Folder-group-n1900
CustomValue         : {}
OverallStatus       : green
ConfigStatus        : green
ConfigIssue         : {}
EffectiveRole       : {-1}
Permission          : {}
DisabledMethod      : {}
RecentTask          : {}
DeclaredAlarmState  : {}
TriggeredAlarmState : {}
AlarmActionsEnabled : True
Tag                 : {}
Value               : {}
AvailableField      : {}
MoRef               : Network-network-1905
Client              : VMware.Vim.VimClientImpl

Summary             : VMware.Vim.NetworkSummary
Host                : {HostSystem-host-1903}
Vm                  : {VirtualMachine-vm-1910, VirtualMachine-vm-1911, VirtualMachine-vm-1946, VirtualMachine-vm-1948...}
Name                : VM Network
LinkedView          :
Parent              : Folder-group-n1900
CustomValue         : {}
OverallStatus       : green
ConfigStatus        : green
ConfigIssue         : {}
EffectiveRole       : {-1}
Permission          : {}
DisabledMethod      : {}
RecentTask          : {}
DeclaredAlarmState  : {}
TriggeredAlarmState : {}
AlarmActionsEnabled : True
Tag                 : {}
Value               : {}
AvailableField      : {}
MoRef               : Network-network-1906
Client              : VMware.Vim.VimClientImpl

#>
#endregion
((Get-VirtualNetwork).ExtensionData).VM
((Get-VirtualNetwork).ExtensionData) | SELECT moref, VM
(Get-VirtualNetwork).ExtensionData[0]
#===============================================================================================================================
# Get-VMHostNetworkAdapter
#===============================================================================================================================
PS C:\WINDOWS\system32> Get-VMHostNetworkAdapter
#region

<#
Name       Mac               DhcpEnabled IP              SubnetMask      DeviceName
----       ---               ----------- --              ----------      ----------
vmnic0     dc:f4:01:e7:ba:a4 False                                           vmnic0
vmnic1     dc:f4:01:e7:ba:a5 False                                           vmnic1
vmnic2     dc:f4:01:e7:ba:a6 False                                           vmnic2
vmnic3     dc:f4:01:e7:ba:a7 False                                           vmnic3
vmnic4     b0:26:28:7a:12:f0 False                                           vmnic4
vmnic5     b0:26:28:7a:12:f1 False                                           vmnic5
vmk0       b0:26:28:7a:12:f1 False       192.168.101.15  255.255.255.0         vmk0
vmnic0     dc:f4:01:e7:b9:18 False                                           vmnic0
vmnic1     dc:f4:01:e7:b9:19 False                                           vmnic1
vmnic2     dc:f4:01:e7:b9:1a False                                           vmnic2
vmnic3     dc:f4:01:e7:b9:1b False                                           vmnic3
vmnic4     b0:26:28:79:db:00 False                                           vmnic4
vmnic5     b0:26:28:79:db:01 False                                           vmnic5
vmk0       b0:26:28:79:db:01 False       192.168.101.16  255.255.255.0         vmk0
#>
    #-------------------------- Example 1 --------------------------
    Get-VMHostNetworkAdapter -VMKernel
    #Retrieves information about about all VMKernel network adapters on servers that you are connected to.
    #-------------------------- Example 2 --------------------------
    $myVMHost = Get-VMHost -Name MyVMHost
    Get-VMHostNetworkAdapter -VMHost $myVMHost -Physical
    #Retrieves all physical network adapters on the specified host.
    #-------------------------- Example 3 --------------------------
    $myVDSwitch = Get-VDSwitch -Name MyVDSwitch
    Get-VMHostNetworkAdapter -VirtualSwitch $myVDSwitch -VMKernel
    #Retrieves all VMKernel network adapters connected to the specified virtual switch.
    #-------------------------- Example 4 --------------------------
    Get-VDPortGroup -Name MyVDPortGroup | Get-VMHostNetworkAdapter
    #Retrieves VMHost network adapters by a specified distributed port group.
    #-------------------------- Example 5 --------------------------
    $myVirtualSwitch = Get-VirtualSwitch -Name MyVirtualSwitch
    Get-VMHostNetworkAdapter -VirtualSwitch $myVirtualSwitch
    #Retrieves physical VMHost network adapters by a specified standard virtual switch.

PS C:\WINDOWS\system32> Get-VMHostNetworkAdapter -VMHost 192.168.101.15
<#
Name       Mac               DhcpEnabled IP              SubnetMask      DeviceName
----       ---               ----------- --              ----------      ----------
vmnic0     dc:f4:01:e7:ba:a4 False                                           vmnic0
vmnic1     dc:f4:01:e7:ba:a5 False                                           vmnic1
vmnic2     dc:f4:01:e7:ba:a6 False                                           vmnic2
vmnic3     dc:f4:01:e7:ba:a7 False                                           vmnic3
vmnic4     b0:26:28:7a:12:f0 False                                           vmnic4
vmnic5     b0:26:28:7a:12:f1 False                                           vmnic5
vmk0       b0:26:28:7a:12:f1 False       192.168.101.15  255.255.255.0         vmk0
#>

#endregion
PS C:\WINDOWS\system32> (Get-VMHostNetwork -VMHost 192.168.101.15)
#region
<#
HostName     DomainName   DnsFro ConsoleGateway  ConsoleGatewayD DnsAddress
mDhcp                  evice
--------     ----------   ------ --------------  --------------- ----------
localhost                 False                                  {8.8.8.8, 168.126...
#>
#endregion
PS C:\WINDOWS\system32> (Get-VMHostNetworkAdapter -VMHost 192.168.101.15).ExtensionData
#region Sample Data

Key                                   : key-vim.host.PhysicalNic-vmnic0
Device                                : vmnic0
Pci                                   : 0000:18:00.0
Driver                                : ntg3
LinkSpeed                             :
ValidLinkSpecification                : {VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo...}
Spec                                  : VMware.Vim.PhysicalNicSpec
WakeOnLanSupported                    : False
Mac                                   : dc:f4:01:e7:ba:a4
FcoeConfiguration                     : VMware.Vim.FcoeConfig
VmDirectPathGen2Supported             : False
VmDirectPathGen2SupportedMode         :
ResourcePoolSchedulerAllowed          : True
ResourcePoolSchedulerDisallowedReason :
AutoNegotiateSupported                : True
EnhancedNetworkingStackSupported      : False
EnsInterruptSupported                 :
RdmaDevice                            :

Key                                   : key-vim.host.PhysicalNic-vmnic1
Device                                : vmnic1
Pci                                   : 0000:18:00.1
Driver                                : ntg3
LinkSpeed                             :
ValidLinkSpecification                : {VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo...}
Spec                                  : VMware.Vim.PhysicalNicSpec
WakeOnLanSupported                    : False
Mac                                   : dc:f4:01:e7:ba:a5
FcoeConfiguration                     : VMware.Vim.FcoeConfig
VmDirectPathGen2Supported             : False
VmDirectPathGen2SupportedMode         :
ResourcePoolSchedulerAllowed          : True
ResourcePoolSchedulerDisallowedReason :
AutoNegotiateSupported                : True
EnhancedNetworkingStackSupported      : False
EnsInterruptSupported                 :
RdmaDevice                            :

Key                                   : key-vim.host.PhysicalNic-vmnic2
Device                                : vmnic2
Pci                                   : 0000:19:00.0
Driver                                : ntg3
LinkSpeed                             :
ValidLinkSpecification                : {VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo...}
Spec                                  : VMware.Vim.PhysicalNicSpec
WakeOnLanSupported                    : False
Mac                                   : dc:f4:01:e7:ba:a6
FcoeConfiguration                     : VMware.Vim.FcoeConfig
VmDirectPathGen2Supported             : False
VmDirectPathGen2SupportedMode         :
ResourcePoolSchedulerAllowed          : True
ResourcePoolSchedulerDisallowedReason :
AutoNegotiateSupported                : True
EnhancedNetworkingStackSupported      : False
EnsInterruptSupported                 :
RdmaDevice                            :

Key                                   : key-vim.host.PhysicalNic-vmnic3
Device                                : vmnic3
Pci                                   : 0000:19:00.1
Driver                                : ntg3
LinkSpeed                             :
ValidLinkSpecification                : {VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo...}
Spec                                  : VMware.Vim.PhysicalNicSpec
WakeOnLanSupported                    : False
Mac                                   : dc:f4:01:e7:ba:a7
FcoeConfiguration                     : VMware.Vim.FcoeConfig
VmDirectPathGen2Supported             : False
VmDirectPathGen2SupportedMode         :
ResourcePoolSchedulerAllowed          : True
ResourcePoolSchedulerDisallowedReason :
AutoNegotiateSupported                : True
EnhancedNetworkingStackSupported      : False
EnsInterruptSupported                 :
RdmaDevice                            :

Key                                   : key-vim.host.PhysicalNic-vmnic4
Device                                : vmnic4
Pci                                   : 0000:3b:00.0
Driver                                : bnxtnet
LinkSpeed                             :
ValidLinkSpecification                : {VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo}
Spec                                  : VMware.Vim.PhysicalNicSpec
WakeOnLanSupported                    : False
Mac                                   : b0:26:28:7a:12:f0
FcoeConfiguration                     : VMware.Vim.FcoeConfig
VmDirectPathGen2Supported             : False
VmDirectPathGen2SupportedMode         :
ResourcePoolSchedulerAllowed          : True
ResourcePoolSchedulerDisallowedReason :
AutoNegotiateSupported                : True
EnhancedNetworkingStackSupported      : False
EnsInterruptSupported                 :
RdmaDevice                            :

Key                                   : key-vim.host.PhysicalNic-vmnic5
Device                                : vmnic5
Pci                                   : 0000:3b:00.1
Driver                                : bnxtnet
LinkSpeed                             : VMware.Vim.PhysicalNicLinkInfo
ValidLinkSpecification                : {VMware.Vim.PhysicalNicLinkInfo, VMware.Vim.PhysicalNicLinkInfo}
Spec                                  : VMware.Vim.PhysicalNicSpec
WakeOnLanSupported                    : False
Mac                                   : b0:26:28:7a:12:f1
FcoeConfiguration                     : VMware.Vim.FcoeConfig
VmDirectPathGen2Supported             : False
VmDirectPathGen2SupportedMode         :
ResourcePoolSchedulerAllowed          : True
ResourcePoolSchedulerDisallowedReason :
AutoNegotiateSupported                : True
EnhancedNetworkingStackSupported      : False
EnsInterruptSupported                 :
RdmaDevice                            :

Device    : vmk0
Key       : key-vim.host.VirtualNic-vmk0
Portgroup : Management Network
Spec      : VMware.Vim.HostVirtualNicSpec
Port      : key-vim.host.PortGroup.Port-33554436

#endregion
PS C:\WINDOWS\system32> Get-VMHostNetworkAdapter -VMHost (Get-VMHost -Name 192.168.101.15) -VMKernel | Select Name, Mac, DhcpEnabled, IP, SubnetMask, DeviceName
#region
<#
Name        : vmk0
Mac         : b0:26:28:7a:12:f1
DhcpEnabled : False
IP          : 192.168.101.15
SubnetMask  : 255.255.255.0
DeviceName  : vmk0
#>
#endregion
#===============================================================================================================================
# Get-VirtualSwitch
#===============================================================================================================================
PS C:\WINDOWS\system32> Get-VirtualSwitch
#region

<#
Name                           NumPorts   Mtu   Notes
----                           --------   ---   -----
vSwitch0                       6656       1500
vSwitch1                       6656       1500
vSwitch0                       6656       1500
#>

#endregion
#===============================================================================================================================
# Get-NetworkAdapter
#===============================================================================================================================
PS C:\WINDOWS\system32> Get-NetworkAdapter -vm Win10-Link01
#region

<#
Name                 Type       NetworkName  MacAddress         WakeOnLan
Enabled
----                 ----       -----------  ----------         ---------
네트워크 어댑터 1           Vmxnet3    VM Network   00:50:56:90:82:27       True
#>
#-------------------------- Example 1 --------------------------
    Get-NetworkAdapter -VM MyVM
    #Retrieves the network adapters added to the the MyVM virtual machine.
#-------------------------- Example 2 --------------------------
    $myVDPortgroup = Get-VDPortGroup -Name "MyVDPortGroup"
    $myNetworkAdapters = Get-NetworkAdapter -RelatedObject $myVDPortgroup
    #Retrieves all network adapters connected to the specified port group and stores them in the myNetworkAdapters variable.
#---------------------------------------------------------------
New-NetworkAdapter
Remove-NetworkAdapter
Set-NetworkAdapter
#---------------------------------------------------------------
PS C:\WINDOWS\system32> Get-NetworkAdapter -vm Win10-Link01 | Select *
<#
MacAddress       : 00:50:56:90:82:27
WakeOnLanEnabled : True
NetworkName      : VM Network
Type             : Vmxnet3
ParentId         : VirtualMachine-vm-1944
Parent           : Win10-Link01
Uid              : /VIServer=vsphere.local\administrator@192.168.50.16:443/VirtualMachine=VirtualMachine-vm-1944/NetworkAdapter=4000/
ConnectionState  : Connected, GuestControl, StartConnected
ExtensionData    : VMware.Vim.VirtualVmxnet3
Id               : VirtualMachine-vm-1944/4000
Name             : 네트워크 어댑터 1
#>

#endregion
#===============================================================================================================================
# Get-VirtualPortGroup
#===============================================================================================================================
Get-VirtualPortGroup
Get-VirtualPortGroup -VMHost 192.168.101.15
#region
<#
Name                      Key                            VLanId PortBinding NumPorts
----                      ---                            ------ ----------- --------
test001                   key-vim.host.PortGroup-test001 0
test                      key-vim.host.PortGroup-test    0
VM Network2               key-vim.host.PortGroup-VM N... 0
VM Network                key-vim.host.PortGroup-VM N... 0
Management Network        key-vim.host.PortGroup-Mana... 0
VM Network2               key-vim.host.PortGroup-VM N... 0
VM Network                key-vim.host.PortGroup-VM N... 0
Management Network        key-vim.host.PortGroup-Mana... 0
#>
#endregion
PS C:\WINDOWS\system32> Get-VirtualPortGroup -VMHost 192.168.101.15 | Where-Object {$_.vLanId -ge 80}
#region
<#
Name                      Key                            VLanId PortBinding NumPorts
----                      ---                            ------ ----------- --------
Service-VLAN0081          key-vim.host.PortGroup-Serv... 81
Service Network_701       key-vim.host.PortGroup-Serv... 701
#>
#endregion
#===============================================================================================================================
# ETC
#===============================================================================================================================
PS C:\WINDOWS\system32> Get-VMHost | Select $_.ExtensionData.Config.Network.Vnic
#region
<#
Name                 ConnectionState PowerState NumCpu CpuUsageMhz CpuTotalMhz   MemoryUsageGB   MemoryTotalGB Version
----                 --------------- ---------- ------ ----------- -----------   -------------   ------------- -------
192.168.101.15       Connected       PoweredOn      16        4097       33520          25.712          94.462   6.7.0
192.168.101.16       Connected       PoweredOn      16         178       33520          15.892          94.462   6.7.0
#>
#endregion
PS C:\WINDOWS\system32> Get-VMHost | Select @{N='Nic';E={$_.ExtensionData.Config.Network.Vnic}}
#region
<#
Nic
---
VMware.Vim.HostVirtualNic
VMware.Vim.HostVirtualNic
#>
#endregion
PS C:\WINDOWS\system32> Get-VMHost | Select @{N='Nic';E={$_.ExtensionData.Config.Network.Vnic.Spec.Ip.IpAddress}}
#region
<#
Nic
---
192.168.101.15
192.168.101.16
#>
#endregion
PS C:\WINDOWS\system32> Get-VMHost | Select @{N='Nic';E={$_.ExtensionData.Config.Network.Vnic.Spec}}
#region
<#
Nic
---
VMware.Vim.HostVirtualNicSpec
VMware.Vim.HostVirtualNicSpec
#>
#endregion
PS C:\WINDOWS\system32> Get-VMHost | Select @{N='Nic';E={$_.ExtensionData.Config.Network.Vnic.Spec.Ip}}
#region
<#
Nic
---
VMware.Vim.HostIpConfig
VMware.Vim.HostIpConfig
#>
#endregion
PS C:\WINDOWS\system32> Get-VMHost -PipelineVariable esx | ForEach-Object -Process {
    $esxcli = Get-EsxCli -VMHost $esx -V2
    $esxcli.network.nic.list.Invoke() |
    Add-Member -MemberType NoteProperty -Name VMHost -Value $esx.Name -PassThru
}
#region Return Data
<#
AdminStatus : Up
Description : Broadcom Corporation NetXtreme BCM5720 Gigabit Ethernet
Driver      : ntg3
Duplex      : Half
Link        : Down
LinkStatus  : Down
MACAddress  : dc:f4:01:e7:ba:a4
MTU         : 1500
Name        : vmnic0
PCIDevice   : 0000:18:00.0
Speed       : 0
VMHost      : 192.168.101.15

AdminStatus : Up
Description : Broadcom Corporation NetXtreme BCM5720 Gigabit Ethernet
Driver      : ntg3
Duplex      : Half
Link        : Down
LinkStatus  : Down
MACAddress  : dc:f4:01:e7:ba:a5
MTU         : 1500
Name        : vmnic1
PCIDevice   : 0000:18:00.1
Speed       : 0
VMHost      : 192.168.101.15

AdminStatus : Up
Description : Broadcom Corporation NetXtreme BCM5720 Gigabit Ethernet
Driver      : ntg3
Duplex      : Half
Link        : Down
LinkStatus  : Down
MACAddress  : dc:f4:01:e7:ba:a6
MTU         : 1500
Name        : vmnic2
PCIDevice   : 0000:19:00.0
Speed       : 0
VMHost      : 192.168.101.15

AdminStatus : Up
Description : Broadcom Corporation NetXtreme BCM5720 Gigabit Ethernet
Driver      : ntg3
Duplex      : Half
Link        : Down
LinkStatus  : Down
MACAddress  : dc:f4:01:e7:ba:a7
MTU         : 1500
Name        : vmnic3
PCIDevice   : 0000:19:00.1
Speed       : 0
VMHost      : 192.168.101.15

AdminStatus : Up
Description : Broadcom Limited BCM57416 NetXtreme-E 10GBASE-T RDMA Ethernet Controller
Driver      : bnxtnet
Duplex      : Half
Link        : Down
LinkStatus  : Down
MACAddress  : b0:26:28:7a:12:f0
MTU         : 1500
Name        : vmnic4
PCIDevice   : 0000:3b:00.0
Speed       : 0
VMHost      : 192.168.101.15

AdminStatus : Up
Description : Broadcom Limited BCM57416 NetXtreme-E 10GBASE-T RDMA Ethernet Controller
Driver      : bnxtnet
Duplex      : Full
Link        : Up
LinkStatus  : Up
MACAddress  : b0:26:28:7a:12:f1
MTU         : 1500
Name        : vmnic5
PCIDevice   : 0000:3b:00.1
Speed       : 10000
VMHost      : 192.168.101.15

AdminStatus : Up
Description : Broadcom Corporation NetXtreme BCM5720 Gigabit Ethernet
Driver      : ntg3
Duplex      : Half
Link        : Down
LinkStatus  : Down
MACAddress  : dc:f4:01:e7:b9:18
MTU         : 1500
Name        : vmnic0
PCIDevice   : 0000:18:00.0
Speed       : 0
VMHost      : 192.168.101.16

AdminStatus : Up
Description : Broadcom Corporation NetXtreme BCM5720 Gigabit Ethernet
Driver      : ntg3
Duplex      : Half
Link        : Down
LinkStatus  : Down
MACAddress  : dc:f4:01:e7:b9:19
MTU         : 1500
Name        : vmnic1
PCIDevice   : 0000:18:00.1
Speed       : 0
VMHost      : 192.168.101.16

AdminStatus : Up
Description : Broadcom Corporation NetXtreme BCM5720 Gigabit Ethernet
Driver      : ntg3
Duplex      : Half
Link        : Down
LinkStatus  : Down
MACAddress  : dc:f4:01:e7:b9:1a
MTU         : 1500
Name        : vmnic2
PCIDevice   : 0000:19:00.0
Speed       : 0
VMHost      : 192.168.101.16

AdminStatus : Up
Description : Broadcom Corporation NetXtreme BCM5720 Gigabit Ethernet
Driver      : ntg3
Duplex      : Half
Link        : Down
LinkStatus  : Down
MACAddress  : dc:f4:01:e7:b9:1b
MTU         : 1500
Name        : vmnic3
PCIDevice   : 0000:19:00.1
Speed       : 0
VMHost      : 192.168.101.16

AdminStatus : Up
Description : Broadcom Limited BCM57416 NetXtreme-E 10GBASE-T RDMA Ethernet Controller
Driver      : bnxtnet
Duplex      : Half
Link        : Down
LinkStatus  : Down
MACAddress  : b0:26:28:79:db:00
MTU         : 1500
Name        : vmnic4
PCIDevice   : 0000:3b:00.0
Speed       : 0
VMHost      : 192.168.101.16

AdminStatus : Up
Description : Broadcom Limited BCM57416 NetXtreme-E 10GBASE-T RDMA Ethernet Controller
Driver      : bnxtnet
Duplex      : Full
Link        : Up
LinkStatus  : Up
MACAddress  : b0:26:28:79:db:01
MTU         : 1500
Name        : vmnic5
PCIDevice   : 0000:3b:00.1
Speed       : 10000
VMHost      : 192.168.101.16

#>
#endregion

PS C:\WINDOWS\system32> Get-Cluster | Select-Object -Property Name,HAEnabled,
@{Name='HostMonitoring';Expression={$_.ExtensionData.Configuration.DasConfig.HostMonitoring}},
@{Name='AdmissionControlPolicyCpuFailoverResourcesPercent';Expression={$_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.CpuFailoverResourcesPercent}},
@{Name='HeartbeatDatastore';Expression={(Get-View -Id $_.ExtensionData.Configuration.DasConfig.HeartbeatDatastore).Name}}
#region
<#
Name                                              : NM_VMWC
HAEnabled                                         : False
HostMonitoring                                    : enabled
AdmissionControlPolicyCpuFailoverResourcesPercent : 100
HeartbeatDatastore                                :
.....
#>
#endregion