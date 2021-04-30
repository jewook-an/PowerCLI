
Get-Command | where {$_.name -match "hv"}       # Horizon 관련 Function, Method, cmdlet
#----------------------------------------------------------------------------------------------------------------------
# Help 사용법     >> Full 옵션 사용시 Parameter 관련 상세 확인 가능
#----------------------------------------------------------------------------------------------------------------------
Get-Help Get-HVPool -Examples   #예제
Get-Help Get-HVPool -Detailed   #상세
Get-Help Get-HVPool -full       #전체

#######################################################################################################################
#----------------------------------------------------------------------------------------------------------------------
Get-HVPool -PoolName 'Win10Pro-Pool' -PoolType AUTOMATED -UserAssignment DEDICATED -Enabled $true -ProvisioningEnabled $true
#----------------------------------------------------------------------------------------------------------------------
Get-HVPool -PoolName 'mypool' -PoolType MANUAL -UserAssignment FLOATING -Enabled $true -ProvisioningEnabled $true
Get-HVPool -PoolType AUTOMATED -UserAssignment FLOATING
Get-HVPool -PoolName 'myrds' -PoolType RDS -UserAssignment DEDICATED -Enabled $false
Get-HVPool -PoolName 'myrds' -PoolType RDS -UserAssignment DEDICATED -Enabled $false -HvServer $mycs

#----------------------------------------------------------------------------------------------------------------------
# Set-HVPool : Get-Help Set-HVPool -full
#----------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------
Set-HVPool -PoolName <String> [-Enable] [-Disable] [-Start] [-Stop] [-Key <String>] [-Value <Object>] [-Spec <String>] [-globalEntitlement <String>] [-ResourcePool <String>] [-clearGlobalEntitlement] [-allowUsersToChooseProtocol <Boolean>] [-enableHTMLAccess <Boolean>] [-HvS
erver <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]

Set-HVPool [-Pool <Object>] [-Enable] [-Disable] [-Start] [-Stop] [-Key <String>] [-Value <Object>] [-Spec <String>] [-globalEntitlement <String>] [-ResourcePool <String>] [-clearGlobalEntitlement] [-allowUsersToChooseProtocol <Boolean>] [-enableHTMLAccess <Boolean>] [-HvSer
ver <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]

<#
* -PoolName <String>                                  Name of the pool to edit.
-Pool <Object>                                      Object(s) of the pool to edit.
-Enable [<SwitchParameter>]                         Switch parameter to enable the pool.
-Disable [<SwitchParameter>]                        Switch parameter to disable the pool.
-Start [<SwitchParameter>]                          Switch parameter to start the pool.
-Stop [<SwitchParameter>]                           Switch parameter to stop the pool.
-Key <String>                                       Property names path separated by . (dot) from the root of desktop spec. (desktop spec의 root 에서 속성 이름 경로는 .(dot) 로 구분)
-Value <Object>                                     Property value corresponds to above key name. (속성 값은 위의 키 이름에 해당합니다.)
-Spec <String>                                      Path of the JSON specification file containing key/value pair.
-globalEntitlement <String>
-ResourcePool <String>
-clearGlobalEntitlement [<SwitchParameter>]
-allowUsersToChooseProtocol <Boolean>
-enableHTMLAccess <Boolean>
-HvServer <Object>                                  View API service object of Connect-HVServer cmdlet.
-WhatIf [<SwitchParameter>]
-Confirm [<SwitchParameter>]
#>
#-----------------------------------------------------------------------------------------------------------------------
# Examples
#-----------------------------------------------------------------------------------------------------------------------
Set-HVPool -PoolName 'ManualPool' -Spec 'C:\Edit-HVPool\EditPool.json' -Confirm:$false           #Updates pool configuration by using json file
Set-HVPool -PoolName 'RDSPool' -Key 'base.description' -Value 'update description'               #Updates pool configuration with given parameters key and value

Set-HVPool -PoolName 'LnkClone' -Enable             # 풀 사용
Set-HVPool -PoolName 'LnkClone' -Disable            # 풀 사용안함
Set-HVPool -PoolName 'LnkClone' -Start              # 프로비저닝 사용
Set-HVPool -PoolName 'LnkClone' -Stop               # 프로비저닝 사용안함
Set-HVPool -PoolName 'Win10Pro-Pool' -Stop
Set-HVPool -PoolName 'Win10Pro-Pool' -Disable


#-----------------------------------------------------------------------------------------------------------------------
    New-HVPool  >> Creates new desktop pool.
    #데스크톱 풀 생성 (유형 및 사용자 할당 유형은 입력 매개 변수를 기반으로 결정됨)
#-----------------------------------------------------------------------------------------------------------------------
    #-----------------------------------------------------------------------------------------------------------------------
    # InstantClone
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -InstantClone -PoolName <String> [-PoolDisplayName <String>] [-Description <String>] [-AccessGroup <String>] [-GlobalEntitlement <String>] -UserAssignment <String> [-AutomaticAssignment <Boolean>] [-Enable <Boolean>] [-ConnectionServerRestrictions <String[]>] [-Au
    tomaticLogoffPolicy <String>] [-AutomaticLogoffMinutes <Int32>] [-allowUsersToResetMachines <Boolean>] [-allowMultipleSessionsPerUser <Boolean>] [-deleteOrRefreshMachineAfterLogoff <String>] [-supportedDisplayProtocols <String[]>] [-defaultDisplayProtocol <String>] [-allowUs
    ersToChooseProtocol <Int32>] [-enableHTMLAccess <Boolean>] [-renderer3D <String>] [-Quality <String>] [-Throttling <String>] [-Vcenter <String>] -ParentVM <String> -SnapshotVM <String> -VmFolder <String> -HostOrCluster <String> -ResourcePool <String> [-datacenter <String>] -
    Datastores <String[]> [-StorageOvercommit <String[]>] [-UseVSAN <Boolean>] [-UseSeparateDatastoresReplicaAndOSDisks <Boolean>] [-ReplicaDiskDatastore <String>] [-UseNativeSnapshots <Boolean>] [-ReclaimVmDiskSpace <Boolean>] [-RedirectWindowsProfile <Boolean>] [-Nics <Desktop
    NetworkInterfaceCardSettings[]>] [-EnableProvisioning <Boolean>] [-StopProvisioningOnError <Boolean>] [-TransparentPageSharingScope <String>] -NamingMethod <String> [-NamingPattern <String>] [-MaximumCount <Int32>] [-SpareCount <Int32>] [-ProvisioningTime <String>] [-Minimum
    Count <Int32>] [-SpecificNames <String[]>] [-StartInMaintenanceMode <Boolean>] [-NumUnassignedMachinesKeptPoweredOn <Int32>] [-AdContainer <Object>] -NetBiosName <String> [-DomainAdmin <String>] [-ReusePreExistingAccounts <Boolean>] [-PowerOffScriptName <String>] [-PowerOffS
    criptParameters <String>] [-PostSynchronizationScriptName <String>] [-PostSynchronizationScriptParameters <String>] [-HvServer <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]

    #-----------------------------------------------------------------------------------------------------------------------
    # LinkedClone
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -LinkedClone -PoolName <String> [-PoolDisplayName <String>] [-Description <String>] [-AccessGroup <String>] [-GlobalEntitlement <String>] -UserAssignment <String> [-AutomaticAssignment <Boolean>] [-Enable <Boolean>] [-ConnectionServerRestrictions <String[]>] [-Pow
    erPolicy <String>] [-AutomaticLogoffPolicy <String>] [-AutomaticLogoffMinutes <Int32>] [-allowUsersToResetMachines <Boolean>] [-allowMultipleSessionsPerUser <Boolean>] [-deleteOrRefreshMachineAfterLogoff <String>] [-refreshOsDiskAfterLogoff <String>] [-refreshPeriodDaysForRe
    plicaOsDisk <Int32>] [-refreshThresholdPercentageForReplicaOsDisk <Int32>] [-supportedDisplayProtocols <String[]>] [-defaultDisplayProtocol <String>] [-allowUsersToChooseProtocol <Int32>] [-enableHTMLAccess <Boolean>] [-renderer3D <String>] [-enableGRIDvGPUs <Boolean>] [-vRa
    mSizeMB <Int32>] [-maxNumberOfMonitors <Int32>] [-maxResolutionOfAnyOneMonitor <String>] [-Quality <String>] [-Throttling <String>] [-overrideGlobalSetting <Boolean>] [-enabled <Boolean>] [-url <String>] [-Vcenter <String>] -ParentVM <String> -SnapshotVM <String> -VmFolder <
    String> -HostOrCluster <String> -ResourcePool <String> [-datacenter <String>] -Datastores <String[]> [-StorageOvercommit <String[]>] [-UseVSAN <Boolean>] [-UseSeparateDatastoresReplicaAndOSDisks <Boolean>] [-ReplicaDiskDatastore <String>] [-UseNativeSnapshots <Boolean>] [-Re
    claimVmDiskSpace <Boolean>] [-ReclamationThresholdGB <Int32>] [-RedirectWindowsProfile <Boolean>] [-UseSeparateDatastoresPersistentAndOSDisks <Boolean>] [-PersistentDiskDatastores <String[]>] [-PersistentDiskStorageOvercommit <String[]>] [-DiskSizeMB <Int32>] [-DiskDriveLett
    er <String>] [-redirectDisposableFiles <Boolean>] [-NonPersistentDiskSizeMB <Int32>] [-NonPersistentDiskDriveLetter <String>] [-UseViewStorageAccelerator <Boolean>] [-ViewComposerDiskTypes <String>] [-RegenerateViewStorageAcceleratorDays <Int32>] [-BlackoutTimes <DesktopBlac
    koutTime[]>] [-Nics <DesktopNetworkInterfaceCardSettings[]>] [-EnableProvisioning <Boolean>] [-StopProvisioningOnError <Boolean>] [-TransparentPageSharingScope <String>] -NamingMethod <String> [-NamingPattern <String>] [-MinReady <Int32>] [-MaximumCount <Int32>] [-SpareCount
     <Int32>] [-ProvisioningTime <String>] [-MinimumCount <Int32>] [-SpecificNames <String[]>] [-StartInMaintenanceMode <Boolean>] [-NumUnassignedMachinesKeptPoweredOn <Int32>] [-AdContainer <Object>] [-NetBiosName <String>] [-DomainAdmin <String>] -CustType <String> [-ReusePreE
    xistingAccounts <Boolean>] [-SysPrepName <String>] [-PowerOffScriptName <String>] [-PowerOffScriptParameters <String>] [-PostSynchronizationScriptName <String>] [-PostSynchronizationScriptParameters <String>] [-HvServer <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]

    #-----------------------------------------------------------------------------------------------------------------------
    # FullClone
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -FullClone -PoolName <String> [-PoolDisplayName <String>] [-Description <String>] [-AccessGroup <String>] [-GlobalEntitlement <String>] -UserAssignment <String> [-AutomaticAssignment <Boolean>] [-Enable <Boolean>] [-ConnectionServerRestrictions <String[]>] [-Quali
    ty <String>] [-Throttling <String>] [-Vcenter <String>] -Template <String> -VmFolder <String> -HostOrCluster <String> -ResourcePool <String> [-datacenter <String>] -Datastores <String[]> [-StorageOvercommit <String[]>] [-UseVSAN <Boolean>] [-Nics <DesktopNetworkInterfaceCard
    Settings[]>] [-EnableProvisioning <Boolean>] [-StopProvisioningOnError <Boolean>] [-TransparentPageSharingScope <String>] -NamingMethod <String> [-NamingPattern <String>] [-MaximumCount <Int32>] [-SpareCount <Int32>] [-ProvisioningTime <String>] [-MinimumCount <Int32>] [-Spe
    cificNames <String[]>] [-StartInMaintenanceMode <Boolean>] [-NumUnassignedMachinesKeptPoweredOn <Int32>] [-NetBiosName <String>] -CustType <String> [-SysPrepName <String>] [-DoNotPowerOnVMsAfterCreation <Boolean>] [-HvServer <Object>] [-WhatIf] [-Confirm] [<CommonParameters>
    ]

    #-----------------------------------------------------------------------------------------------------------------------
    # Manual(수동)
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -Manual -PoolName <String> [-PoolDisplayName <String>] [-Description <String>] [-AccessGroup <String>] [-GlobalEntitlement <String>] -UserAssignment <String> [-AutomaticAssignment <Boolean>] [-Enable <Boolean>] [-ConnectionServerRestrictions <String[]>] [-allowUse
    rsToResetMachines <Boolean>] [-supportedDisplayProtocols <String[]>] [-defaultDisplayProtocol <String>] [-allowUsersToChooseProtocol <Int32>] [-enableHTMLAccess <Boolean>] [-Quality <String>] [-Throttling <String>] [-Vcenter <String>] [-TransparentPageSharingScope <String>]
    -Source <String> -VM <String[]> [-HvServer <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]

    #-----------------------------------------------------------------------------------------------------------------------
    # RDS
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -Rds -PoolName <String> [-PoolDisplayName <String>] [-Description <String>] [-AccessGroup <String>] [-GlobalEntitlement <String>] [-Enable <Boolean>] [-ConnectionServerRestrictions <String[]>] [-Farm <String>] [-HvServer <Object>] [-WhatIf] [-Confirm] [<CommonPara
    meters>]
    #-----------------------------------------------------------------------------------------------------------------------

    New-HVPool -Spec <String> [-PoolName <String>] [-PoolDisplayName <String>] [-Description <String>] [-AccessGroup <String>] [-GlobalEntitlement <String>] [-Enable <Boolean>] [-ConnectionServerRestrictions <String[]>] [-NamingPattern <String>] [-NumUnassignedMachinesKeptPowere
    dOn <Int32>] [-VM <String[]>] [-HvServer <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]

    New-HVPool -ClonePool <Object> -PoolName <String> [-PoolDisplayName <String>] [-Description <String>] [-AccessGroup <String>] [-GlobalEntitlement <String>] [-Enable <Boolean>] [-ConnectionServerRestrictions <String[]>] [-NamingMethod <String>] [-NamingPattern <String>] [-Spe
    cificNames <String[]>] [-VM <String[]>] [-Farm <String>] [-HvServer <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]

    #=======================================================================================================================
    # 매개변수 : 필수 값 확인 >> " * "
    #=======================================================================================================================
    * -InstantClone [<SwitchParameter>]                       Switch to Create Instant Clone pool.
    * -LinkedClone [<SwitchParameter>]                        Switch to Create Linked Clone pool.
    * -FullClone [<SwitchParameter>]                          Switch to Create Full Clone pool.
    * -Manual [<SwitchParameter>]                             Switch to Create Manual Clone pool.
    * -Rds [<SwitchParameter>]                                Switch to Create RDS pool.
    * -Spec <String>                                          Path of the JSON specification file.
    * -ClonePool <Object>                                     Existing pool info to clone a new pool.
    * -PoolName <String>                                      Name of the pool.

    -PoolDisplayName <String>                               # Display name of pool.
    -Description <String>                                   # Description of pool.
    -AccessGroup <String>                                   # View access group can organize the desktops in the pool.        Default Value is 'Root'.
    -GlobalEntitlement <String>                             # Description of pool.         Global entitlement to associate the pool.
    * -UserAssignment <String>                              # User Assignment type of pool. //         Set to DEDICATED for dedicated desktop pool. //        Set to FLOATING for floating desktop pool.
    -AutomaticAssignment <Boolean>                          # Automatic assignment of a user the first time they access the machine.        Applicable to dedicated desktop pool.
    -Enable <Boolean>                                       # Set true to enable the pool otherwise set to false.
    -ConnectionServerRestrictions <String[]>                # Connection server restrictions.        This is a list of tags that access to the desktop is restricted to.        No list means that the desktop can be accessed from any connection server.
    -PowerPolicy <String>                                   # Power policy for the machines in the desktop after logoff.        This setting is only relevant for managed machines
    -AutomaticLogoffPolicy <String>                         # Automatically log-off policy after disconnect.         This property has a default value of "NEVER".
    -AutomaticLogoffMinutes <Int32>                         # The timeout in minutes for automatic log-off after disconnect.        This property is required if automaticLogoffPolicy is set to "AFTER".
    -allowUsersToResetMachines <Boolean>                    # Whether users are allowed to reset/restart their machines.
    -allowMultipleSessionsPerUser <Boolean>                 # Whether multiple sessions are allowed per user in case of Floating User Assignment.
    -deleteOrRefreshMachineAfterLogoff <String>             # Whether machines are to be deleted or refreshed after logoff in case of Floating User Assignment.
    -refreshOsDiskAfterLogoff <String>                      # Whether and when to refresh the OS disks for dedicated-assignment, linked-clone machines.
    -refreshPeriodDaysForReplicaOsDisk <Int32>              # Regular interval at which to refresh the OS disk.
    -refreshThresholdPercentageForReplicaOsDisk <Int32>     # With the 'AT_SIZE' option for refreshOsDiskAfterLogoff, the size of the linked clone's OS disk in the datastore is compared to its maximum allowable size.
    -supportedDisplayProtocols <String[]>                   # The list of supported display protocols for the desktop.
    -defaultDisplayProtocol <String>                        # The default display protocol for the desktop. For a managed desktop, this will default to "PCOIP". For an unmanaged desktop, this will default to "RDP".
    -allowUsersToChooseProtocol <Int32>                     # Whether the users can choose the protocol.
    -enableHTMLAccess <Boolean>                             # HTML Access, enabled by VMware Blast technology, allows users to connect to View machines from Web browsers.
    -renderer3D <String>                                    # Specify 3D rendering dependent types hardware, software, vsphere client etc.
    -enableGRIDvGPUs <Boolean>                              # Whether GRIDvGPUs enabled or not
    -vRamSizeMB <Int32>                                     # VRAM size for View managed 3D rendering. More VRAM can improve 3D performance.
    -maxNumberOfMonitors <Int32>                            # The greater these values are, the more memory will be consumed on the associated ESX hosts
    -maxResolutionOfAnyOneMonitor <String>                  # The greater these values are, the more memory will be consumed on the associated ESX hosts.
    -Quality <String>                                       # This setting determines the image quality that the flash movie will render. Lower quality results in less bandwidth usage.
    -Throttling <String>                                    # This setting affects the frame rate of the flash movie. If enabled, the frames per second will be reduced based on the aggressiveness level.
    -overrideGlobalSetting <Boolean>                        # Mirage configuration specified here will be used for this Desktop
    -enabled <Boolean>                                      # Whether a Mirage server is enabled.
    -url <String>                                           # The URL of the Mirage server. This should be in the form "<(DNS name)|(IPv4)|(IPv6)><:(port)>". IPv6 addresses must be enclosed in square brackets.
    -Vcenter <String>                                       # Virtual Center server-address (IP or FQDN) where the pool virtual machines are located. This should be same as provided to the Connection Server while adding the vCenter server.
    * -Template <String>                                    # Virtual machine Template name to clone Virtual machines.        Applicable only to Full Clone pools.
    * -ParentVM <String>                                    # Parent Virtual Machine to clone Virtual machines.        Applicable only to Linked Clone and Instant Clone pools.
    * -SnapshotVM <String>                                  # Base image VM for Linked Clone pool and current Image for Instant Clone Pool.
    * -VmFolder <String>                                    # VM folder to deploy the VMs to.        Applicable to Full, Linked, Instant Clone Pools.
    * -HostOrCluster <String>                               # Host or cluster to deploy the VMs in.        Applicable to Full, Linked, Instant Clone Pools.
    * -ResourcePool <String>                                # Resource pool to deploy the VMs.        Applicable to Full, Linked, Instant Clone Pools.
    -datacenter <String>                                    # desktopSpec.automatedDesktopSpec.virtualCenterProvisioningSettings.virtualCenterProvisioningData.datacenter if LINKED_CLONE, INSTANT_CLONE, FULL_CLONE
    * -Datastores <String[]>                                # Datastore names to store the VM        Applicable to Full, Linked, Instant Clone Pools.
    -StorageOvercommit <String[]>                           # Storage overcommit determines how View places new VMs on the selected datastores.         Supported values are 'UNBOUNDED','AGGRESSIVE','MODERATE','CONSERVATIVE','NONE' and are case sensitive.
    -UseVSAN <Boolean>                                      # Whether to use vSphere VSAN. This is applicable for vSphere 5.5 or later.        Applicable to Full, Linked, Instant Clone Pools.
    -UseSeparateDatastoresReplicaAndOSDisks <Boolean>       # Whether to use separate datastores for replica and OS disks.
    -ReplicaDiskDatastore <String>                          # Datastore to store replica disks for View Composer and Instant clone engine sourced machines.
    -UseNativeSnapshots <Boolean>                           # Native NFS Snapshots is a hardware feature, specify whether to use or not
    -ReclaimVmDiskSpace <Boolean>                           # virtual machines can be configured to use a space efficient disk format that supports reclamation of unused disk space.
    -ReclamationThresholdGB <Int32>                         # Initiate reclamation when unused space on VM exceeds the threshold.
    -RedirectWindowsProfile <Boolean>                       # Windows profiles will be redirected to persistent disks, which are not affected by View Composer operations such as refresh, recompose and rebalance.
    -UseSeparateDatastoresPersistentAndOSDisks <Boolean>    # Whether to use separate datastores for persistent and OS disks. This must be false if redirectWindowsProfile is false.
    -PersistentDiskDatastores <String[]>                    # Name of the Persistent disk datastore
    -PersistentDiskStorageOvercommit <String[]>             # Storage overcommit determines how view places new VMs on the selected datastores.         Supported values are 'UNBOUNDED','AGGRESSIVE','MODERATE','CONSERVATIVE','NONE' and are case sensitive.
    -DiskSizeMB <Int32>                                     # Size of the persistent disk in MB.
    -DiskDriveLetter <String>                               # Persistent disk drive letter.
    -redirectDisposableFiles <Boolean>                      # Redirect disposable files to a non-persistent disk that will be deleted automatically when a user's session ends.
    -NonPersistentDiskSizeMB <Int32>                        # Size of the non persistent disk in MB.
    -NonPersistentDiskDriveLetter <String>                  # Non persistent disk drive letter.
    -UseViewStorageAccelerator <Boolean>                    # Whether to use View Storage Accelerator.
    -ViewComposerDiskTypes <String>                         # Disk types to enable for the View Storage Accelerator feature.
    -RegenerateViewStorageAcceleratorDays <Int32>           # How often to regenerate the View Storage Accelerator cache.
    -BlackoutTimes <DesktopBlackoutTime[]>                  # A list of blackout times.
    -Nics <DesktopNetworkInterfaceCardSettings[]>           # desktopSpec.automatedDesktopSpec.virtualCenterProvisioningSettings.virtualCenterNetworkingSettings.nics
    -EnableProvisioning <Boolean>                           # desktopSpec.automatedDesktopSpec.virtualCenterProvisioningSettings.enableProvsioning if LINKED_CLONE, INSTANT_CLONE, FULL_CLONE
    -StopProvisioningOnError <Boolean>                      # Set to true to stop provisioning of all VMs on error.        Applicable to Full, Linked, Instant Clone Pools.
    -TransparentPageSharingScope <String>                   # The transparent page sharing scope.        The default value is 'VM'.
    * -NamingMethod <String>                                # Determines how the VMs in the desktop are named.        Set SPECIFIED to use specific name.        Set PATTERN to use naming pattern.        The default value is PATTERN. For Instant Clone pool the value must be PATTERN.
    -NamingPattern <String>                                 # Virtual machines will be named according to the specified naming pattern.        Value would be considered only when $namingMethod = PATTERN.        The default value is poolName + '{n:fixed=4}'.
    -MinReady <Int32>                                       # Minimum number of ready (provisioned) machines during View Composer maintenance operations.        The default value is 0.        Applicable to Linked Clone Pools.
    -MaximumCount <Int32>                                   # Maximum number of machines in the pool.        The default value is 1.        Applicable to Full, Linked, Instant Clone Pools
    -SpareCount <Int32>                                     # Number of spare powered on machines in the pool.        The default value is 1.        Applicable to Full, Linked, Instant Clone Pools.
    -ProvisioningTime <String>                              # Determines when machines are provisioned.        Supported values are ON_DEMAND, UP_FRONT.        The default value is UP_FRONT.        Applicable to Full, Linked, Instant Clone Pools.
    -MinimumCount <Int32>                                   # The minimum number of machines to have provisioned if on demand provisioning is selected.        The default value is 0.        Applicable to Full, Linked, Instant Clone Pools.
    -SpecificNames <String[]>                               # Specified names of VMs in the pool.        The default value is <poolName>-1        Applicable to Full, Linked and Cloned Pools.
    -StartInMaintenanceMode <Boolean>                       # Set this to true to allow virtual machines to be customized manually before users can log        in and access them.        the default value is false        Applicable to Full, Linked, Instant Clone Pools.
    -NumUnassignedMachinesKeptPoweredOn <Int32>             # Number of unassigned machines kept powered on. value should be less than max number of vms in the pool.        The default value is 1.        Applicable to Full, Linked, Instant Clone Pools.        When JSON Spec file is used for pool creation, the value will be read from JSON spec.
    -AdContainer <Object>                                   # This is the Active Directory container which the machines will be added to upon creation.        The default value is 'CN=Computers'.        Applicable to Instant Clone Pool.
    * -NetBiosName <String>                                 # Domain Net Bios Name.        Applicable to Full, Linked, Instant Clone Pools.
    -DomainAdmin <String>                                   # Domain Administrator user name which will be used to join the domain.        Default value is null.        Applicable to Full, Linked, Instant Clone Pools.
    * -CustType <String>                                    # Type of customization to use.        Supported values are 'CLONE_PREP','QUICK_PREP','SYS_PREP','NONE'.        Applicable to Full, Linked Clone Pools.
    -ReusePreExistingAccounts <Boolean>                     # desktopSpec.automatedDesktopSpec.customizationSettings.reusePreExistingAccounts if LINKED_CLONE, INSTANT_CLONE
    -SysPrepName <String>                                   # The customization spec to use.        Applicable to Full, Linked Clone Pools.
    -DoNotPowerOnVMsAfterCreation <Boolean>                 # desktopSpec.automatedDesktopSpec.customizationSettings.noCustomizationSettings.doNotPowerOnVMsAfterCreation if FULL_CLONE
    -PowerOffScriptName <String>                            # Power off script. ClonePrep/QuickPrep can run a customization script on instant/linked clone machines before they are powered off. Provide the path to the script on the parent virtual machine.        Applicable to Linked, Instant Clone pools.
    -PowerOffScriptParameters <String>                      # Power off script parameters. Example: p1 p2 p3         Applicable to Linked, Instant Clone pools.
    -PostSynchronizationScriptName <String>                 # Post synchronization script. ClonePrep/QuickPrep can run a customization script on instant/linked clone machines after they are created or recovered or a new image is pushed. Provide the path to the script on the parent virtual machine.        Applicable to Linked, Instant Clone pools.
    -PostSynchronizationScriptParameters <String>           # Post synchronization script parameters. Example: p1 p2 p3         Applicable to Linked, Instant Clone pools.
    * -Source <String>                                      # Source of the Virtual machines for manual pool.        Supported values are 'VIRTUAL_CENTER','UNMANAGED'.        Set VIRTUAL_CENTER for vCenter managed VMs.        Set UNMANAGED for Physical machines or VMs which are not vCenter managed VMs.        Applicable to Manual Pools.
    * -VM <String[]>                                        # List of existing virtual machine names to add into manual pool.        Applicable to Manual Pools.
    -Farm <String>                                          # Farm to create RDS pools        Applicable to RDS Pools.
    -HvServer <Object>                                      # Reference to Horizon View Server to query the pools from. If the value is not passed or null then        first element from global:DefaultHVServers would be considered in-place of hvServer.
    -WhatIf [<SwitchParameter>]
    -Confirm [<SwitchParameter>]

    #=======================================================================================================================
    #-----------------------------------------------------------------------------------------------------------------------
    # 예제1 : Naming Method Pattern 사용 LinkedClone 풀 생성 (FLOATING)
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -LinkedClone -PoolName 'vmwarepool' -UserAssignment FLOATING -ParentVM 'Agent_vmware' -SnapshotVM 'kb-hotfix' -VmFolder 'vmware' -HostOrCluster 'CS-1' -ResourcePool 'CS-1' -Datastores 'datastore1' -NamingMethod PATTERN -PoolDisplayName 'vmware linkedclone p
    ool' -Description  'created linkedclone pool from ps' -EnableProvisioning $true -StopProvisioningOnError $false -NamingPattern  "vmware2" -MinReady 0 -MaximumCount 1 -SpareCount 1 -ProvisioningTime UP_FRONT -SysPrepName vmwarecust -CustType SYS_PREP -NetBiosName adviewdev -D
    omainAdmin root

    #-----------------------------------------------------------------------------------------------------------------------
    # 예제2 : JSON File 사용 LinkedClone 풀 생성
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -Spec C:\VMWare\Specs\LinkedClone.json -Confirm:$false

    #-----------------------------------------------------------------------------------------------------------------------
    # 예제3 : 기존 풀 구성 사용하여 새 풀 복제
    #-----------------------------------------------------------------------------------------------------------------------
    Get-HVPool -PoolName 'vmwarepool' | New-HVPool -PoolName 'clonedPool' -NamingPattern 'clonelnk1';
    (OR)
    $vmwarepool = Get-HVPool -PoolName 'vmwarepool';  New-HVPool -ClonePool $vmwarepool -PoolName 'clonedPool' -NamingPattern 'clonelnk1';

    #-----------------------------------------------------------------------------------------------------------------------
    # 예제4 : Naming Method Pattern 사용 InstantClone 풀 생성 (FLOATING)
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -InstantClone -PoolName "InsPoolvmware" -PoolDisplayName "insPool" -Description "create instant pool" -UserAssignment FLOATING -ParentVM 'Agent_vmware' -SnapshotVM 'kb-hotfix' -VmFolder 'vmware' -HostOrCluster  'CS-1' -ResourcePool 'CS-1' -NamingMethod PATT
    ERN -Datastores 'datastore1' -NamingPattern "inspool2" -NetBiosName 'adviewdev' -DomainAdmin root

    #-----------------------------------------------------------------------------------------------------------------------
    # 예제5 : Naming Method Pattern 사용 FullClone 풀 생성 (DEDICATED)
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -FullClone -PoolName "FullClone" -PoolDisplayName "FullClonePra" -Description "create full clone" -UserAssignment DEDICATED -Template 'powerCLI-VM-TEMPLATE' -VmFolder 'vmware' -HostOrCluster 'CS-1' -ResourcePool 'CS-1'  -Datastores 'datastore1' -NamingMetho
    d PATTERN -NamingPattern 'FullCln1' -SysPrepName vmwarecust -CustType SYS_PREP -NetBiosName adviewdev -DomainAdmin root

    #-----------------------------------------------------------------------------------------------------------------------
    # 예제6 : vCenter내 VM으로 MANAGED 수동풀 생성 (FLOATING)
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -MANUAL -PoolName 'manualVMWare' -PoolDisplayName 'MNLPUL' -Description 'Manual pool creation' -UserAssignment FLOATING -Source VIRTUAL_CENTER -VM 'PowerCLIVM1', 'PowerCLIVM2'

    #-----------------------------------------------------------------------------------------------------------------------
    # 예제7 : 관리되지 않는 VM으로 UNMANAGED 수동풀 생성 (FLOATING)
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -MANUAL -PoolName 'unmangedVMWare' -PoolDisplayName 'unMngPl' -Description 'unmanaged Manual Pool creation' -UserAssignment FLOATING -Source UNMANAGED -VM 'myphysicalmachine.vmware.com'

    #-----------------------------------------------------------------------------------------------------------------------
    # 예제8 : 명령줄과 JSON 각각 몇가지 매개변수를 통하여 InstantClone 풀을 생성
    #-----------------------------------------------------------------------------------------------------------------------
    New-HVPool -spec 'C:\Json\InstantClone.json' -PoolName 'InsPool1' -NamingPattern 'INSPool-'

    #=======================================================================================================================

<#
자동화 된 데스크톱 풀 선택 - 다음
전용 할당 선택 - 자동 할당 사용 해제 (사용하시려면 체크하세요) - 다음
전체 가상 시스템 - vCenter Server 선택 - 다음 (인스턴트/ViewComposer/전체가상시스템)

# 4. 데스크톱 풀 설정
데스크톱 풀 ID, 표시 될 디스플레이 이름, 풀 설명 입력 - 다음
전원 정책, 자동 로그오프 시간, 사용자 재설정 여부, 디스플레이 프로토콜, 모니터 수, 해상도, HTML Access 등 옵션 설정 - 다음
가상 시스템 이름 지정 - 수동으로 이름 지정 or 패턴사용 - 이름 입력
생성 가상 머신 이름 입력 (다수일 경우 엑셀 사용) - 다음 (패턴선택시 Skip)
프로비저닝 시간 - 모든 시스템을 미리 프로비저닝 - 다음
vSan 환경 시 VMware Virtual San 사용 / 아닐 시 VMware virtual San 사용 안함 - 다음
템플릿 화 된 마스터 이미지 선택, VM 폴더 위치 선택, 클러스터, 리소스, 데이터스토어 선택 - 다음
설정 가능 하다면 Storage Accelerator 사용 및 업무 시간 고려하여 블랙아웃 시간 설정
* (엔지니어확인) 생성해 두었던 마스터 이미지 용 사용자 지정 규격 선택 - 다음
사용자 권한 부여 체크 - 생성한 풀 설정 확인 - 마침 - 가상 머신 배포 대기
>> 완료후 권한 팝업

# 5. 풀 사용 권한 부여, 사용자 가상 머신 할당
풀에 대한 사용자 혹은 사용자 그룹 권한 추가 - 닫기
가상 머신 별 사용자 할당
권한 부여 확인 - 사용자 가상 머신 사용 준비 완료 확인
시스템 정상 작동 확인
 #>

#=================================================================================================================================
# https://github.com/vmware/PowerCLI-Example-Scripts/tree/master/Modules/VMware.Hv.Helper
#=================================================================================================================================
# https://roderikdeblock.com/create-horizon-desktop-pool-using-powercli/
# The first step is to get the credentials to logon the Horizon Server:
# Credentials $Cred = Get-Credential
#=================================================================================================================================
# Then the global settings of the scripts will be set (like vcenter/datstore etc.):
#Credentials
$Cred = Get-Credential

# Global Settings
$HVServer = "<Your Horizon View Connection Server>"
$Vcenter = "<Your vCenter>"
$datacenter = "<Your Datacenter>"
$datastore = "<Your Datsastore>"
$DomainAdmin = "<Your Instant Clone Domain Admin>"
$HostOrCluster = "<Your Cluster>"
$ResourcePool = "<Resourcepool path>"
$NetBiosName = "<Your NETBIOS>"
$ParentVM = "<Name of ParentVM>"
$SnapshotVM = "<Name of Snapshot VM>"

#=================================================================================================================================
# The next step is to define the environments/desktop pools. In this example I created a Production, Test and Proof of Concept Desktop Pool.
#=================================================================================================================================
# Select Environment
$Environment = "PRODUCTION" # or TEST or PROOFOFCONCEPT

If ($environment -eq "PRODUCTION")
    {
        $PoolName = "PRODUCTION"
        $PoolDisplayName = "PRODUCTION"
        $ProvTime = "UP_FRONT"
        $VmFolder  = "</DATASTORE/FOLDER>"
        $MinimumCount = 1
        $MaximumCount = 5
        $SpareCount = 1
        $NumUnassignedMachinesKeptPoweredOn = 1
        $AdContainer = "OU=PRODUCTION,OU=VIRTUAL DESKTOPS"
    }

If ($environment -eq "TEST")
    {
        $PoolName = "TEST"
        $PoolDisplayName = "TEST"
        $ProvTime = "UP_FRONT"
        $VmFolder  = "</DATASTORE/FOLDER>"
        $MinimumCount = 1
        $MaximumCount = 5
        $SpareCount = 1
        $NumUnassignedMachinesKeptPoweredOn = 1
        $AdContainer = "OU=TEST,OU=VIRTUAL DESKTOPS"
    }

If ($environment -eq "PROOFOFCONCEPT")
    {
        $PoolName = "PROOFOFCONCEPT"
        $PoolDisplayName = "PROOFOFCONCEPT"
        $ProvTime = "UP_FRONT"
        $VmFolder  = "</DATASTORE/FOLDER> "
        $MinimumCount = 1
        $MaximumCount = 5
        $SpareCount = 1
        $NumUnassignedMachinesKeptPoweredOn = 1
        $AdContainer = "OU=PROOFOFCONCEPT,OU=VIRTUAL DESKTOPS"
    }

#=================================================================================================================================
# After this the generic Horizon Settings will be set:
#=================================================================================================================================

#Generic Horizon Settings
$NamingPattern = "VDI-$($PoolName)-{n:fixed=4}" # for example
$UserAssignment = "FLOATING" # or DEDICATED
$AutomaticAssignment = $true # or $false
$allowUsersToResetMachines = $false # or $true
$AllowMultipleSessionsPerUser = $false # or $true
$deleteOrRefreshMachineAfterLogoff = "REFRESH" # DELETE or NEVER -lof
$RefreshOsDiskAfterLogoff = "NEVER"
$supportedDisplayProtocols = "BLAST","PCOIP"
$renderer3D = "DISABLED"
$enableGRIDvGPUs = $false
$maxNumberOfMonitors = 2
$maxResolutionOfAnyOneMonitor = "WUXGA"
$quality = "NO_CONTROL" #or HIGH LOW MEDIUM
$throttling = "DISABLED" #or AGGRESIVE CONSERVATIVE DISABLED MODERATE
$overrideGlobalSetting = $false # or $true
$UseSeparateDatastoresReplicaAndOSDisks = $false # or $true
$UseViewStorageAccelerator = $false # or $true
$EnableProvisioning = $true # or $false
$NamingMethod = "PATTERN"
$ReclaimVmDiskSpace = $false # or $true
$RedirectWindowsProfile = $false # or $true
$StopOnProvisioningError = $true # or $true
$StorageOvercommit = "UNBOUNDED"
$UseNativeSnapshots = $false # or $true
$UseSeparateDatastoresPersistentAndOSDisks = $false # or $true
$UseVSAN = $true # or $false
$enableHTMLAccess = $true # or $false
$defaultDisplayProtocol = "BLAST"
$AutomaticLogoffMinutes = 240
$allowUsersToChooseProtocol = 1
$AutomaticLogoffPolicy = "AFTER" #IMMEDIATELY or NEVER
$postsyncscript = ""
$postsyncpara = ""

#=================================================================================================================================
# Now it’s time to connect to the Horizon Connection Server: ()
# >> Connect to Horizon Connection Server Connect-HVServer -Server $HVServer -Credential $Cred
#=================================================================================================================================
# And finally the Desktop Pool will be created with the New-HVPool command.
# All the variables I have set before will be used to create the new Desktop Pool.
#=================================================================================================================================

#Create Pool
New-HVPool -instantclone `
            -Datastores $Datastores `
            -HostOrCluster $HostOrCluster `
            -NamingMethod $NamingMethod `
            -NetBiosName $NetBiosName `
            -ParentVM $ParentVM `
            -PoolName $NewPoolName `
            -ResourcePool $ResourcePool `
            -SnapshotVM $SnapshotVM `
            -UserAssignment $UserAssignment `
            -VmFolder $VmFolder `
            -AdContainer $AdContainer `
            -AutomaticAssignment $AutomaticAssignment `
            -datacenter $datacenter `
            -DomainAdmin $DomainAdmin `
            -Enable $true `
            -EnableProvisioning $EnableProvisioning `
            -MaximumCount $MaximumCount `
            -MinimumCount $MinimumCount `
            -NamingPattern $NamingPattern `
            -NumUnassignedMachinesKeptPoweredOn $NumUnassignedMachinesKeptPoweredOn `
            -PoolDisplayName $PoolDisplayName `
            -ProvisioningTime $ProvTime `
            -ReclaimVmDiskSpace $ReclaimVmDiskSpace `
            -RedirectWindowsProfile $RedirectWindowsProfile `
            -SpareCount $SpareCount `
            -StopProvisioningOnError $true `
            -StorageOvercommit $StorageOvercommit `
            -UseNativeSnapshots $UseNativeSnapshots `
            -UseSeparateDatastoresReplicaAndOSDisks $UseSeparateDatastoresReplicaAndOSDisks `
            -UseVSAN $UseVSAN `
            -Vcenter $Vcenter `
            -enableHTMLAccess $enableHTMLAccess `
            -defaultDisplayProtocol $defaultDisplayProtocol `
            -AutomaticLogoffMinutes $AutomaticLogoffMinutes `
            -allowUsersToChooseProtocol $allowUsersToChooseProtocol `
            -AutomaticLogoffPolicy $AutomaticLogoffPolicy `
            -PostSynchronizationScriptParameters $postsyncpara `
            -PostSynchronizationScriptName $postsyncscript `