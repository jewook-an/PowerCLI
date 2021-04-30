================================================================================================================================================
$global:DefaultHVServers | Select *

# ServiceUri    : https://192.168.101.70/view-vlsi/sdk
# RefCount      : 1
# User          : administrator
# Domain        : namurnd
# Id            : /ViewServer=administrator@192.168.101.70/
# SessionSecret : c58bcd51-8f38-4d6e-9a8e-9d1f85c85409
# IsConnected   : True
# ExtensionData : VMware.Hv.Services
# Name          : 192.168.101.70
# Uid           : /ViewServer=administrator@192.168.101.70/
# Client        : VMware.VimAutomation.HorizonView.Impl.V1.ViewServerClientImpl

#================================================================================================================================================
# Get-HVMachineSummary
#================================================================================================================================================
#region
#================================================================================================================================================
Get-HVMachineSummary | Sort-Object -Property Machine -Descending

# Machine         DesktopPool  DNS Name     User     Host            Agent Datastore  Status
# -------         -----------  --------     ----     ----            ----- ---------  ------
# Win10-Link03    Win10-Link   win10-lin... namur... 192.168.101.15  7.... DataSto... AVAILABLE
# ManualVM1       FullClone... manualvm1...          192.168.101.16  7.... DataSto... DISCONNECTED
# Win10-Link01    Win10-Link   win10-lin... namur... 192.168.101.15  7.... DataSto... AVAILABLE
# Win10-Link02    Win10-Link   win10-lin... namur... 192.168.101.15  7.... DataSto... DISCONNECTED
#================================================================================================================================================
Get-HVMachineSummary | Select *    # (Select * 쓰지말것)

# Id                      : VMware.Hv.MachineId
# Base                    : VMware.Hv.MachineBase
# NamesData               : VMware.Hv.MachineNamesData
# MessageSecurityData     : VMware.Hv.MachineMessageSecurityData
# ManagedMachineNamesData : VMware.Hv.MachineManagedMachineNamesData
================================================================================================================================================
Get-HVMachineSummary

# Machine         DesktopPool  DNS Name     User     Host            Agent Datastore  Status
# -------         -----------  --------     ----     ----            ----- ---------  ------
# SDS-VMW-004     inchul-test  sds-vmw-0... namur... 192.168.101.15  7.... DataSto... DISCONNECTED
# SDS-VMW-008     inchul-test  sds-vmw-0... namur... 192.168.101.15  7.... DataSto... AVAILABLE
# SDS-VMW-006     inchul-test  sds-vmw-0... namur... 192.168.101.15  7.... DataSto... DISCONNECTED
# Win10-Link02    Win10-Link   win10-lin... namur... 192.168.101.15  7.... DataSto... AVAILABLE
# AutoFullClone1  AutoFullC... desktop-q...          192.168.101.16  7.... DataSto... DISCONNECTED
# AutoFullClone2  AutoFullC... autofullc...          192.168.101.16  7.... DataSto... AVAILABLE

================================================================================================================================================
(Get-HVMachineSummary).ManagedMachineNamesData

# HostName          DatastorePaths
# --------          --------------
# 192.168.101.15    {DataStore15}
# 192.168.101.16    {DataStore16}
# 192.168.101.15    {DataStore15}
# 192.168.101.15    {DataStore15}
================================================================================================================================================
(Get-HVMachineSummary).MessageSecurityData

# MessageSecurityMode MessageSecurityEnhancedModeSupported
# ------------------- ------------------------------------
# ENHANCED                                            True
# ENABLED                                            False
# ENHANCED                                            True
# ENHANCED                                            True
================================================================================================================================================
(Get-HVMachineSummary).Base
#-----------------------------------------------------------------------------------------------------------------------------------------------
# Name                             : Win10-Link03
# DnsName                          : win10-link03.namurnd.io
# User                             : VMware.Hv.UserOrGroupId
# Users                            :
# AccessGroup                      : VMware.Hv.AccessGroupId
# Desktop                          : VMware.Hv.DesktopId
# DesktopName                      : Win10-Link
# Session                          :
# BasicState                       : AVAILABLE
# Type                             : MANAGED_VIRTUAL_MACHINE
# OperatingSystem                  : Windows 10
# OperatingSystemArchitecture      : 64_bit
# AgentVersion                     : 7.12.0
# AgentBuildNumber                 : 15805436
# RemoteExperienceAgentVersion     :
# RemoteExperienceAgentBuildNumber : 15805436
# RefId                            :
#-----------------------------------------------------------------------------------------------------------------------------------------------
# Name                             : ManualVM1
# DnsName                          :
# User                             :
# Users                            :
# AccessGroup                      : VMware.Hv.AccessGroupId
# Desktop                          : VMware.Hv.DesktopId
# DesktopName                      : FullCloneFloating
# Session                          :
# BasicState                       : WAIT_FOR_AGENT
# Type                             : MANAGED_VIRTUAL_MACHINE
# OperatingSystem                  : Windows 10
# OperatingSystemArchitecture      : 64_bit
# AgentVersion                     :
# AgentBuildNumber                 :
# RemoteExperienceAgentVersion     :
# RemoteExperienceAgentBuildNumber :
# RefId                            :
#-----------------------------------------------------------------------------------------------------------------------------------------------
# Name                             : Win10-Link01
# DnsName                          : win10-link01.namurnd.io
# User                             : VMware.Hv.UserOrGroupId
# Users                            :
# AccessGroup                      : VMware.Hv.AccessGroupId
# Desktop                          : VMware.Hv.DesktopId
# DesktopName                      : Win10-Link
# Session                          :
# BasicState                       : AVAILABLE
# Type                             : MANAGED_VIRTUAL_MACHINE
# OperatingSystem                  : Windows 10
# OperatingSystemArchitecture      : 64_bit
# AgentVersion                     : 7.12.0
# AgentBuildNumber                 : 15805436
# RemoteExperienceAgentVersion     :
# RemoteExperienceAgentBuildNumber : 15805436
# RefId                            :
#-----------------------------------------------------------------------------------------------------------------------------------------------
# Name                             : Win10-Link02
# DnsName                          : win10-link02.namurnd.io
# User                             : VMware.Hv.UserOrGroupId
# Users                            :
# AccessGroup                      : VMware.Hv.AccessGroupId
# Desktop                          : VMware.Hv.DesktopId
# DesktopName                      : Win10-Link
# Session                          : VMware.Hv.SessionId
# BasicState                       : CONNECTED
# Type                             : MANAGED_VIRTUAL_MACHINE
# OperatingSystem                  : Windows 10
# OperatingSystemArchitecture      : 64_bit
# AgentVersion                     : 7.12.0
# AgentBuildNumber                 : 15805436
# RemoteExperienceAgentVersion     :
# RemoteExperienceAgentBuildNumber : 15805436
# RefId                            :
#-----------------------------------------------------------------------------------------------------------------------------------------------
================================================================================================================================================
(Get-HVMachineSummary).Id

# Id
# --
# Machine/NmI1NGY3NzMtOWQ1MC00YTI2LWE4ZmEtOWMxYzk1N2M0OGU5/QXNzaWduZWRNYWNoaW5l/NzY5YjU0MGItZWYxNS00ZGNjLTgzZjYtYTZlYTc4NmU4ZGNl
# Machine/NmI1NGY3NzMtOWQ1MC00YTI2LWE4ZmEtOWMxYzk1N2M0OGU5/QXNzaWduZWRNYWNoaW5l/OGNiMGVkZWEtZTEzZC00NTZmLWEwOTQtN2M0ZTAzNGIxMDQx
# Machine/NmI1NGY3NzMtOWQ1MC00YTI2LWE4ZmEtOWMxYzk1N2M0OGU5/QXNzaWduZWRNYWNoaW5l/Y2EwZjc2ODUtMTNiZS00OTBiLTg2MTEtYzRmYmVlNzE0NGQ2
# Machine/NmI1NGY3NzMtOWQ1MC00YTI2LWE4ZmEtOWMxYzk1N2M0OGU5/QXNzaWduZWRNYWNoaW5l/ZGExNTUwMmEtYzAwMS00NGY0LWE0MjYtOGFiMTI0MDVmNjAw
================================================================================================================================================
#endregion

#================================================================================================================================================
# Get-HVMachine
#================================================================================================================================================
#region
(Get-HVMachine -MachineName Win10-Link02).ManagedMachineData.VirtualCenterData

# VirtualCenter               : VMware.Hv.VirtualCenterId
# Hostname                    : 192.168.101.15
# Path                        : /Datacenter/vm/Provisioning/Win10-Link/Win10-Link02
# VirtualMachinePowerState    : POWERED_ON
# ViewStorageAcceleratorState : CURRENT
# MemoryMB                    : 4096
# VirtualDisks                : {VMware.Hv.MachineVirtualDiskData, VMware.Hv.MachineVirtualDiskData, VMware.Hv.MachineVirtualDiskData, VMware.Hv.MachineVirtualDiskData}
# MissingInVCenter            : False
# InHoldCustomization         : False
# NetworkLabels               :
================================================================================================================================================
(Get-HVMachine -MachineName Win10-Link02).ManagedMachineData
(Get-HVMachine -MachineName AutoFullClone2).ManagedMachineData

# VirtualCenterData : VMware.Hv.MachineVirtualCenterData
# ViewComposerData  : VMware.Hv.MachineViewComposerData
# CreateTime        : 2020-12-02 오전 11:31:49
# CloneErrorMessage :
# CloneErrorTime    :
# InMaintenanceMode : False
================================================================================================================================================
(Get-HVMachine -MachineName Win10-Link02).MachineAgentPairingData

# PairingState       ConfiguredByBroker  AttemptedTheftByBroker
# ------------       ------------------  ----------------------
# PAIRED_AND_SECURED nm-vwcs.namurnd.io
================================================================================================================================================
Get-HVMachine -MachineName Win10-Link02

# Id                      : VMware.Hv.MachineId
# Base                    : VMware.Hv.MachineBase
# MessageSecurityData     : VMware.Hv.MachineMessageSecurityData
# ManagedMachineData      : VMware.Hv.MachineManagedMachineData
# MachineAgentPairingData : VMware.Hv.MachineAgentPairingData
================================================================================================================================================
Get-HVMachine

# Id                      : VMware.Hv.MachineId
# Base                    : VMware.Hv.MachineBase
# MessageSecurityData     : VMware.Hv.MachineMessageSecurityData
# ManagedMachineData      : VMware.Hv.MachineManagedMachineData
# MachineAgentPairingData : VMware.Hv.MachineAgentPairingData
================================================================================================================================================
#endregion

#================================================================================================================================================
# Get-HVPool (Desktop Pool 정보)
#================================================================================================================================================
#region

(Get-HVPool -PoolName 'win10-link').AutomatedDesktopData.VirtualCenterNamesData
# TemplatePath                 :
# ParentVmPath                 : /Datacenter/vm/Windows10Pro-StaticVM
# SnapshotPath                 : /Win10Pro_Sanp1
# ImageManagementStreamName    :
# ImageManagementTagName       :
# DatacenterPath               : /Datacenter
# VmFolderPath                 : /Datacenter/vm/Provisioning/Win10-Link
# HostOrClusterPath            : /Datacenter/host/NM_VMWC
# ResourcePoolPath             : /Datacenter/host/NM_VMWC/Resources
# DatastorePaths               : {/Datacenter/host/NM_VMWC/DataStore15}
# SdrsClusterPath              :
# PersistentDiskDatastorePaths :
# ReplicaDiskDatastorePath     :
# NicNames                     :
# NetworkLabelNames            :
# CustomizationSpecName        :

================================================================================================================================================
(Get-HVPool -PoolName 'FullCloneFloating').ManualDesktopData.UserAssignment

# UserAssignment AutomaticAssignment AllowMultipleAssignments
# -------------- ------------------- ------------------------
# FLOATING                      True
================================================================================================================================================
(Get-HVPool -PoolName 'win10-link').AutomatedDesktopData.UserAssignment

# UserAssignment AutomaticAssignment AllowMultipleAssignments
# -------------- ------------------- ------------------------
# DEDICATED                     True
================================================================================================================================================
(Get-HVPool -PoolName 'win10-link').AutomatedDesktopData.VmNamingSettings.PatternNamingSettings

# NamingPattern         : Win10-Link{n:fixed=2}
# MaxNumberOfMachines   : 3
# NumberOfSpareMachines : 1
# ProvisioningTime      : UP_FRONT
# MinNumberOfMachines   :
================================================================================================================================================
(Get-HVPool -PoolName 'win10-link').AutomatedDesktopData.CustomizationSettings

# CustomizationType              : QUICK_PREP
# DomainAdministrator            : VMware.Hv.ViewComposerDomainAdministratorId
# AdContainer                    : VMware.Hv.ADContainerId
# ReusePreExistingAccounts       : False
# NoCustomizationSettings        :
# SysprepCustomizationSettings   :
# QuickprepCustomizationSettings : VMware.Hv.DesktopQuickprepCustomizationSettings
# CloneprepCustomizationSettings :

#endregion

#================================================================================================================================================
# Get-HVPoolSummary (Desktop Pool Summary 정보)
#================================================================================================================================================
(Get-HVPoolSummary).DesktopSummaryData | Where-Object {($_.Enabled -eq 'True' -and $_.Deleting -eq 'False')} | Out-GridView
# Where-Object {($_.extension -eq ".xls" -or $_.extension -eq ".xlk")

#================================================================================================================================================
# 풀권한 전체 ( 공용 & 전용)
#================================================================================================================================================
(Get-HVEntitlement -ResourceName 데스크톱풀이름).base

#================================================================================================================================================
# 사용자 할당 정보
#================================================================================================================================================
#region
$ViewAPI = $global:DefaultHVServers[0].ExtensionData;
$Desktop = Get-HVMachine -MachineName 'Win10-Link02';
$retPoolVMAssignInfo = ($ViewApi.AdUserOrGroup.AduserOrGroup_Get($Desktop.base.user)).base;
$retPoolVMAssignInfo;

# Sid                       : S-1-5-21-2759185886-2966433550-3921846701-1117
# Group                     : False
# Domain                    : namurnd.io
# AdDistinguishedName       : CN=김 주현,OU=WebDrive,OU=Users,OU=나무기술,OU=SITE,DC=namurnd,DC=io
# Name                      : 김 주현
# FirstName                 : 주현
# LastName                  : 김
# LoginName                 : joohyun
# DisplayName               : namurnd.io\joohyun
# LongDisplayName           : joohyun@namurnd.io (김 주현)
# UserDisplayName           :
# Email                     : joohyun.kim@namutech.co.kr
# KioskUser                 : False
# UnauthenticatedAccessUser : False
# Phone                     :
# Description               :
# InFolder                  :
# UserPrincipalName         : joohyun@namurnd.io
# Guid                      : DBF7BD2E5095FE48B6953B2C135D0C1F
# FormattedGuid             : 2EBDF7DB-9550-48FE-B695-3B2C135D0C1F

#================================================================================================================================================
# ---------------------------------------------------------------------------------------------------
# Connnect to Horizon API Service
$HVserver1 = Connect-HVServer -server <COMPUTERNAME> -user <USERNAME>-password <PASSWORD> -domain <DOMAIN>
$ViewAPI = $global:DefaultHVServers[0].ExtensionData
$Assignments = @()

$Desktops = Get-HVMachine -PoolName <POOLNAME>

ForEach ($desktop in $desktops) {
  If($desktop.base.user) { $User = ($ViewApi.AdUserOrGroup.AduserOrGroup_Get($desktop.base.user)).base.LoginName } Else { $User = ' '}
  $Assignments += [PSCUSTOMOBJECT] @{
        Desktop = $desktop.base.name
        User    = $user
      }
}

$Desktop = Get-HVMachine -PoolName Win10-Link -MachineName Win10-Link01

$Assignments | sort desktop

# ---------------------------------------------------------------------------------------------------
$User = ($ViewApi.AdUserOrGroup.AduserOrGroup_Get($desktop.base.user)).base.LoginName
$UserDetail = ($ViewApi.AdUserOrGroup.AduserOrGroup_Get($desktop1.base.user)).base


# >> 전용 풀 권한
$global:DefaultHVServers[0].ExtensionData.AdUserOrGroup.AduserOrGroup_Get($desktop1.base.user)
$global:DefaultHVServers[0].ExtensionData.AdUserOrGroup.AduserOrGroup_Get((Get-HVMachine -MachineName Win10-Link03).base.user).base
# ---------------------------------------------------------------------------------------------------
# Sid                       : S-1-5-21-2759185886-2966433550-3921846701-1208
# Group                     : False
# Domain                    : namurnd.io
# AdDistinguishedName       : CN=안 제욱,OU=나무기술,OU=SITE,DC=namurnd,DC=io
# Name                      : 안 제욱
# FirstName                 : 안제욱
# LastName                  :
# LoginName                 : jewook
# DisplayName               : namurnd.io\jewook
# LongDisplayName           : jewook@namurnd.io (안 제욱)
# UserDisplayName           :
# Email                     :
# KioskUser                 : False
# UnauthenticatedAccessUser : False
# Phone                     :
# Description               :
# InFolder                  :
# UserPrincipalName         : jewook@namurnd.io
# Guid                      : FFB57811BC9CEA45964D709B7C72A4A8
# FormattedGuid             : 1178B5FF-9CBC-45EA-964D-709B7C72A4A8
# -----------------------------------------------------------------------------------------
#================================================================================================================================================

#endregion

#================================================================================================================================================
# Session 정보
#================================================================================================================================================
#region
$hvServer1 = Connect-HVServer -Server 192.168.101.70 -User 'namurnd\administrator' -Password 'namudev!23$'
$Services1 = $hvServer1.ExtensionData
$Desktop = Get-HVMachine -MachineName Win10-Link03
$services1.session.Session_GetLocalSummaryView($Desktop.base.session).namesdata

# UserName                : namurnd.io\argniss
# MachineOrRDSServerName  : Win10-Link03
# MachineOrRDSServerDNS   : win10-link03.namurnd.io
# AgentVersion            : 7.12.0
# DesktopPoolCN           : win10-link
# DesktopName             : Win10-Link
# DesktopType             : AUTOMATED
# DesktopSource           : VIEW_COMPOSER
# FarmName                :
# ClientLocationID        : 06ceca5ed0266bf5222100db50c62e0d68a0b120031302e86c83614a36100e71
# ClientType              : Windows
# ClientAddress           : 10.10.0.181
# ClientName              : DELL-ARGNISS
# ClientVersion           : 5.4.3
# SecurityGatewayDNS      : NM-VWCS.namurnd.io
# SecurityGatewayAddress  : 192.168.101.70
# SecurityGatewayLocation : Internal
# ApplicationNames        :
#endregion

#================================================================================================================================================
# Horizon >> Session 값을 가지고 지정 VM에 Message 전달
#================================================================================================================================================
#region
(Get-HVLocalSession).NamesData
(Get-HVLocalSession).NamesData | Where {$_.MachineOrRDSServerName -match 'Win10-Link01'}

Get-HVLocalSession | Select-Object -Property Id, NamesData | Where-Object {$_.NamesData.MachineOrRDSServerName -eq 'Win10-Link01'}

$session = get-HVlocalsession | select -first 1
$session = Get-HVLocalSession | Select-Object -Property Id, NamesData | Where-Object {$_.NamesData.MachineOrRDSServerName -eq 'Win10-Link01'}

$global:DefaultHVServers[0].ExtensionData.Session.Session_SendMessage($session.id, 'INFO', 'Message Content')
# Session_SendMessage(세션아이디, 메시지 타입, 메시지)    >> 메시지타입 : INFO / ERROR
#endregion
================================================================================================================================================