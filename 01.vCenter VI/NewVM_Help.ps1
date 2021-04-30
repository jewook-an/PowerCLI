
###################################################################################################################
# New VM - VM Create
###################################################################################################################
#region Example

#-------------------------- Example 1 --------------------------
# 호스트, 데이터 스토어, 연결할 네트워크를 지정 VM 생성, 설정 구성.
    $myTargetVMHost = Get-VMHost -Name MyVMHost1
    New-VM -Name MyVM1 -ResourcePool $myTargetVMHost -Datastore MyDatastore1 -NumCPU 2 -MemoryGB 4 -DiskGB 40 -NetworkName "VM Network" -Floppy -CD -DiskStorageFormat Thin -GuestID winNetDatacenterGuest
#-------------------------- Example 2 --------------------------
# 클러스터를 지정하여 VM 생성/ ResourcePool 매개 변수는 ResourcePool, Cluster, VApp 및 독립 실행 형 VMHost 개체를 허용
    $myCluster = Get-Cluster -Name MyCluster1
    New-VM -Name MyVM1 -ResourcePool $myCluster

    $myCluster = Get-Cluster -Name DE-V001
    New-VM -Name TESTVM -ResourcePool $myCluster
#-------------------------- Example 3 --------------------------
# 대상 호스트의 자동 선택을 허용하는 대신 클러스터를 지정하고 명시 적으로 호스트를 선택하여 VM 생성
    $vmhost = Get-VMHost -Name MyVMHost1
    $myCluster = Get-Cluster -Name MyCluster1
    New-VM -Name MyVM1 -VMHost $vmhost -ResourcePool $myCluster -DiskGB 4 -MemoryGB 1
#-------------------------- Example 4 --------------------------
# 여러 디스크가있는 VM 생성
    $vmhost = Get-VMHost -Name MyVMHost1
    New-VM -Name MyVM1 -ResourePool $vmhost -DiskGB 40,100
#-------------------------- Example 5 --------------------------
# 기존 디스크를 지정하여 VM 생성
    $vmhost = Get-VMHost -Name MyVMHost1
    New-VM -Name MyVM1 -ResourcePool $vmhost -DiskPath "[Storage1] WindowsXP/WindowsXP.vmdk"
#-------------------------- Example 6 --------------------------
# HardwareVersion 매개 변수를 통해 가상 머신 하드웨어의 버전을 명시 적으로 지정하여 VM 생성
    $vmhost = Get-VMHost -Name MyVMHost1
    New-VM -Name MyVM1 -ResourcePool $vmhost -HardwareVersion vmx-04
#-------------------------- Example 7 --------------------------
# 지정된 "$ds" 데이터 스토어 및 MyHost1 호스트에 암호화 된 VM 생성
    $keyprovider = Get-KeyProvider "MyKeyProvider"
    $ds = Get-Datastore -VMHost MyHost1
    New-VM -Name 'MyVM' -VMHost MyHost1 -Datastore $ds -KeyProvider $keyprovider
#-------------------------- Example 8 --------------------------
# 지정된 "$ds" 데이터스토어 및 MyHost1 호스트의 VM 홈에 연결된 "$policy" 스토리지 정책을 사용하여 VM 생성
# "$policy"가 암호화 정책 인 경우 가상 머신의 VM Home은 생성 중에 암호화됨
    $policy = Get-SpbmStoragePolicy "MyPolicy"
    $ds = Get-Datastore -VMHost MyHost1
    New-VM -Name 'MyVM' -VMHost MyHost1 -Datastore $ds -StoragePolicy $policy -SkipHardDisks
#-------------------------- Example 9 --------------------------
# 지정된 데이터 스토어 및 호스트에서 MyVM1 가상 머신을 복제하여 MyVM2라는 새 VM 생성
    $myDatastore = Get-Datastore -Name MyDatastore1
    $vmhost = Get-VMHost -Name MyVMHost1
    New-VM -Name MyVM2 -VM MyVM1 -Datastore $myDatastore -VMHost $vmhost
#-------------------------- Example 10 --------------------------
# MyVM1 및 MyVM2 가상 머신을 MyHost1 호스트의 MyFolder1 폴더에 복사
    New-VM -VM MyVM1, MyVM2 -Location MyFolder1 -VMHost MyHost1
#-------------------------- Example 11 --------------------------
# 가상 머신 MyVM1을 MyVM2에 복제하고 복제 된 가상 머신에 사용자 지정 사양을 적용
    $myResourcePool = Get-ResourcePool -Name MyResourcePool1
    $mySpecification = Get-OSCustomizationSpec -Name WindowsSpec
    New-VM -VM MyVM1 -Name MyVM2 -OSCustomizationSpec $mySpecification -ResourcePool $myResourcePool
#-------------------------- Example 12 --------------------------
# Creates a virtual machine from the specified template and applies the specified customization specification.
# 지정된 템플릿에서 가상 머신을 생성하고 지정된 사용자 지정 사양을 적용
    $myResourcePool = Get-ResourcePool -Name MyResourcePool1
    $myTemplate = Get-Template -Name WindowsTemplate
    $mySpecification = Get-OSCustomizationSpec -Name WindowsSpec
    New-VM -Name MyVM2 -Template $myTemplate -ResourcePool $myResourcePool -OSCustomizationSpec $mySpecification
#-------------------------- Example 13 --------------------------
# Retrieves the specified configuration file for the MyVM1 virtual machine and registers the MyVM1 virtual machine on the specified host.
# MyVM1 가상 머신에 대해 지정된 구성 파일을 검색하고 지정된 호스트에 MyVM1 가상 머신을 등록
    cd vmstores:\myserver@443\Datacenter\Storage1\MyVM1\
    $vmxFile = Get-Item MyVM1.vmx
    $vmhost = Get-VMHost -Name MyVMHost1
    New-VM -VMHost $vmhost -VMFilePath $vmxFile.DatastoreFullPath
#-------------------------- Example 14 -------------------------- >> SKIP
#-------------------------- Example 15 --------------------------
#-------------------------- Example 16 --------------------------
#-------------------------- Example 17 --------------------------
#-------------------------- Example 18 --------------------------
#-------------------------- Example 19 --------------------------
#-------------------------- Example 20 --------------------------
#-------------------------- Example 21 --------------------------
# 상위 가상 머신의 지정된 스냅 샷에서 Linked Clone 생성 / 지정된 VM 호스트 및 데이터 스토어에 저장됨
    $mySourceVM = Get-VM -Name MySourceVM1
    $myReferenceSnapshot = Get-Snapshot -VM $mySourceVM -Name "InitialState"
    $vmhost = Get-VMHost -Name MyVMHost1
    $myDatastore = Get-Datastore -Name MyDatastore1
    New-VM -Name MyLinkedCloneVM1 -VM $mySourceVM -LinkedClone -ReferenceSnapshot $myReferenceSnapshot -ResourcePool $vmhost -Datastore $myDatastore
#-------------------------- Example 22 ---------------------G-----
# Creates a new virtual machine with the specified configuration and connects it to the specified distributed port group.
# 지정된 구성으로 새 가상 머신을 생성하고 지정된 분산 포트 그룹에 연결함.
    $myCluster = Get-Cluster -Name "MyCluster"
    $myVDPortGroup = Get-VDPortgroup -Name "MyVDPortGroup"
    $mySharedDatastore = Get-Datastore -Name "MySharedDatastore"
    New-VM -Name MyVM -ResourcePool $myCluster -Portgroup $myVDPortGroup -DiskGB 40 -MemoryGB 4 -Datastore $mySharedDatastore


#endregion

#region New-VM Option

구문
New-VM [[-VMHost] <VMHost>] [-AdvancedOption <AdvancedOption[]>] [-AlternateGuestName <String>] [-CD] [-CoresPerSocket <Int32>] [-Datastore <Stora
geResource>] [-DiskGB <Decimal[]>] [-DiskMB <Int64[]>] [-DiskPath <String[]>] [-DiskStorageFormat <VirtualDiskStorageFormat>] [-DrsAutomationLevel
<DrsAutomationLevel>] [-Floppy] [-GuestId <String>] [-HAIsolationResponse <HAIsolationResponse>] [-HardwareVersion <String>] [-HARestartPriority
<HARestartPriority>] [-Location <Folder>] [-MemoryGB <Decimal>] [-MemoryMB <Int64>] -Name <String> [-NetworkName <String[]>] [-Notes <String>] [-N
umCpu <Int32>] [-Portgroup <VirtualPortGroupBase[]>] [-ResourcePool <VIContainer>] [-RunAsync] [-Server <VIServer[]>] [-VApp <VApp>] [-Version <VM
Version>] [-VMSwapfilePolicy <VMSwapfilePolicy>] [-Confirm] [-WhatIf] [-SkipHardDisks] [-StoragePolicy <StoragePolicy>] [-ReplicationGroup <Replic
ationGroup>] [-KeyProvider <KmsCluster>] [<CommonParameters>]

New-VM [[-VMHost] <VMHost>] [-AdvancedOption <AdvancedOption[]>] [-Datastore <StorageResource>] [-DiskStorageFormat <VirtualDiskStorageFormat>] [-
DrsAutomationLevel <DrsAutomationLevel>] [-HAIsolationResponse <HAIsolationResponse>] [-HARestartPriority <HARestartPriority>] [-LinkedClone] [-Lo
cation <Folder>] [-Name <String>] [-Notes <String>] [-OSCustomizationSpec <OSCustomizationSpec>] [-ReferenceSnapshot <Snapshot>] [-ResourcePool <V
IContainer>] [-RunAsync] [-Server <VIServer[]>] [-VApp <VApp>] -VM <VirtualMachine[]> [-Confirm] [-WhatIf] [-StoragePolicy <StoragePolicy>] [-Repl
icationGroup <ReplicationGroup>] [-StoragePolicyTarget <StoragePolicyTargetType>] [<CommonParameters>]

New-VM [[-VMHost] <VMHost>] [-Template] <Template> [-AdvancedOption <AdvancedOption[]>] [-Datastore <StorageResource>] [-DiskStorageFormat <Virtua
lDiskStorageFormat>] [-DrsAutomationLevel <DrsAutomationLevel>] [-HAIsolationResponse <HAIsolationResponse>] [-HARestartPriority <HARestartPriorit
y>] [-Location <Folder>] -Name <String> [-NetworkName <String[]>] [-Notes <String>] [-OSCustomizationSpec <OSCustomizationSpec>] [-Portgroup <Virt
ualPortGroupBase[]>] [-ResourcePool <VIContainer>] [-RunAsync] [-Server <VIServer[]>] [-VApp <VApp>] [-Confirm] [-WhatIf] [-StoragePolicy <Storage
Policy>] [-ReplicationGroup <ReplicationGroup>] [-StoragePolicyTarget <StoragePolicyTargetType>] [<CommonParameters>]

New-VM [[-VMHost] <VMHost>] [-ContentLibraryItem] <ContentLibraryItem> [-Datastore <StorageResource>] [-DiskStorageFormat <VirtualDiskStorageForma
t>] [-DrsAutomationLevel <DrsAutomationLevel>] [-HAIsolationResponse <HAIsolationResponse>] [-HARestartPriority <HARestartPriority>] [-Location <F
older>] [-Name <String>] [-ResourcePool <VIContainer>] [-RunAsync] [-Server <VIServer[]>] [-Confirm] [-WhatIf] [<CommonParameters>]

New-VM [[-VMHost] <VMHost>] [-DrsAutomationLevel <DrsAutomationLevel>] [-HAIsolationResponse <HAIsolationResponse>] [-HARestartPriority <HARestart
Priority>] [-Location <Folder>] [-Name <String>] [-Notes <String>] [-ResourcePool <VIContainer>] [-RunAsync] [-Server <VIServer[]>] [-VApp <VApp>]
-VMFilePath <String> [-Confirm] [-WhatIf] [<CommonParameters>]

-AlternateGuestName <String>
새 가상 머신의 전체 OS 이름을 지정함 GuestID 매개 변수가 otherGuest 또는 otherGuest64로 설정된 경우이 매개 변수를 사용하십시오.

-CD [<SwitchParameter>]
새 가상 머신에 CD 드라이브를 추가 할 것임을 나타냅니다.

-ContentLibraryItem <ContentLibraryItem>
가상 컴퓨터를 배포 할 콘텐츠 라이브러리 템플릿을 지정함

-CoresPerSocket <Int32>
소켓 당 가상 CPU 코어 수를 지정합니다

-Datastore <StorageResource>
새 가상 머신을 배치 할 데이터 스토어를 지정함
DatastoreCluster가 Datastore 매개 변수에 전달되면 가상 머신은 자동화 된 SDRS 모드에서 VM 내 선호도 규칙이 활성화 된 DatastoreCluster에 배치됩니다 (다른 규칙이 지정되지 않은 경우).
SdrsVMDiskAntiAffinityRule 객체 또는 SdrsVMAntiAffinityRule 객체를 AdvancedOption 매개 변수에 전달하여 DatastoreCluster에서 가상 머신을 생성 할 때 SDRS 규칙을 지정할 수 있습니다.
이 두 규칙은 상호 배타적입니다.

-DiskGB <Decimal[]>
새 가상 머신에 만들고 추가하려는 디스크의 크기 (GB)를 지정함

-DiskPath <String[]>
새 가상 머신에 추가 할 가상 디스크의 경로를 지정함

-DiskStorageFormat <VirtualDiskStorageFormat>
가상 머신 디스크의 스토리지 형식을 지정함 이 매개 변수는 Thin, Thick 및 EagerZeroedThick 값을 허용함

-DrsAutomationLevel <DrsAutomationLevel>
DRS (Distributed Resource Scheduler) 자동화 수준을 지정함
유효한 값은 FullyAutomated, Manual, PartiallyAutomated, AsSpecifiedByCluster 및 Disabled입니다.
파이프 라인을 통해이 매개 변수에 값을 전달하는 것은 더 이상 사용되지 않으며 향후 릴리스에서 비활성화됩니다.
이 매개 변수 지정은 가상 머신이 클러스터 내부에있을 때만 지원됩니다. 그렇지 않으면 오류가 나타납니다.

-Floppy [<SwitchParameter>]
새 가상 머신에 플로피 드라이브를 추가 할 것임을 나타냅니다.

-GuestId <String>
새 가상 머신의 게스트 운영 체제를 지정함
특정 ESX 버전에 대한 유효한 값은 http://www.vmware.com/support/developer/vc-sdk/에서 제공되는 vSphere API 참조의
VirtualMachineGuestOsIdentifier 열거 유형에 대한 설명에 나열되어 있습니다.
호스트의 하드웨어 구성에 따라 일부 게스트 운영 체제가 적용되지 않을 수 있습니다.

-HAIsolationResponse <HAIsolationResponse>
호스트가 나머지 컴퓨팅 리소스와 격리 된 것으로 판단하는 경우 가상 머신의 전원을 꺼야하는지 여부를 나타냅니다.
사용 가능한 값은 AsSpecifiedByCluster, PowerOff 및 DoNothing입니다.
파이프 라인을 통해이 매개 변수에 값을 전달하는 것은 더 이상 사용되지 않으며 향후 릴리스에서 비활성화됩니다.
이 매개 변수 지정은 가상 머신이 클러스터 내부에있을 때만 지원됩니다. 그렇지 않으면 오류가 나타납니다.

-HardwareVersion <String>
새 가상 머신의 버전을 지정함 기본적으로 새 가상 머신은 사용 가능한 최신 버전으로 생성됩니다.

-HARestartPriority <HARestartPriority>
새 가상 머신의 HA 다시 시작 우선 순위를 지정함
유효한 값은 Disabled, Low, Medium, High 및 ClusterRestartPriority입니다.
VMware 고 가용성 (HA)은 실패한 가상 머신을 감지하고 대체 ESX 호스트에서 자동으로 다시 시작하는 기능입니다.
파이프 라인을 통해이 매개 변수에 값을 전달하는 것은 더 이상 사용되지 않으며 향후 릴리스에서 비활성화됩니다.
이 매개 변수 지정은 가상 머신이 클러스터 내부에있을 때만 지원됩니다. 그렇지 않으면 오류가 나타납니다.

-LinkedClone [<SwitchParameter>]
연결된 클론을 생성 할 것임을 나타냅니다. LinkedClone 매개 변수를 설정하면 ReferenceSnapshot 매개 변수가 필수가됩니다.

-Location <Folder>
새 가상 머신을 배치 할 폴더를 지정함

-MemoryGB <Decimal>
새 가상 머신의 메모리 크기 (GB)를 지정함

-Name <String>
새 가상 머신의 이름을 지정함 기존 가상 머신을 등록하거나 복제하려는 경우이 매개 변수는 필수가 아닙니다.
필수 여부                        true

-NetworkName <String[]>
새 가상 머신을 연결할 네트워크를 지정함 분산 포트 그룹 이름을 지정하는 것은 더 이상 사용되지 않습니다. 대신 Portgroup 매개 변수를 사용하십시오.

-Notes <String>
새 가상 머신에 대한 설명을 제공함 이 매개 변수의 별명은 설명입니다.

-NumCpu <Int32>
새 가상 머신의 가상 CPU 수를 지정함

-OSCustomizationSpec <OSCustomizationSpec>
새 가상 머신에 적용되는 사용자 지정 사양을 지정함

-Portgroup <VirtualPortGroupBase[]>
가상 머신을 연결하려는 표준 또는 분산 포트 그룹을 지정함 지정된 각 포트 그룹에 대해 새 네트워크 어댑터가 생성됩니다.

-ReferenceSnapshot <Snapshot>
생성하려는 연결된 클론의 소스 스냅 샷을 지정함 LinkedClone 매개 변수를 설정하면 ReferenceSnapshot 매개 변수가 필수가됩니다.

-ResourcePool <VIContainer>
새 가상 머신을 배치 할 위치를 지정함 매개 변수는 VMHost, Cluster, ResourcePool 및 VApp 개체를 허용함
가치가없는 경우 지정되면 가상 머신이 호스트의 리소스 풀에 추가됩니다.

-RunAsync [<SwitchParameter>]
작업이 완료 될 때까지 기다리지 않고 명령이 즉시 반환됨을 나타냅니다.
이 모드에서 cmdlet의 출력은 Task 개체입니다.
RunAsync 매개 변수에 대한 자세한 정보를 보려면 VMware PowerCLI 콘솔에서 "help About_RunAsync"를 실행하십시오.

-Template <Template>
새 가상 머신 생성에 사용할 가상 머신 템플릿을 지정함 파이프 라인을 통해이 매개 변수에 값을 전달하는 것은 더 이상 사용되지 않으며 향후 릴리스에서 비활성화됩니다.
필수 여부                        true

-VM <VirtualMachine[]>
복제 할 가상 머신을 지정함 / 필수 여부 true

-VMFilePath <String>
등록 할 가상 머신의 경로를 지정함 / 필수 여부 true

-VMHost <VMHost>
새 가상 머신을 만들 호스트를 지정함

-Confirm [<SwitchParameter>]
값이 $ true이면 cmdlet이 실행하기 전에 확인을 요청 함을 나타냅니다. 값이 $false이면 cmdlet은 묻지 않고 실행됩니다. 사용자 확인 용

-SkipHardDisks [<SwitchParameter>]
새 가상 머신의 하드 디스크에 StoragePolicy 또는 Encryption을 적용할지 여부를 지정함

-StoragePolicy <StoragePolicy>
생성하는 동안 새 가상 머신에 연결하려는 StoragePolicy를 지정함 StoragePolicy가 암호화 정책 인 경우 새 가상 머신이 암호화됩니다.

-ReplicationGroup <ReplicationGroup>
새 가상 머신을 배치 할 ReplicationGroup을 지정함 StoragePolicy 매개 변수에 제공된 스토리지 정책에 적용 할 수 있습니다.

#endregion

###################################################################################################################
# 10. Set VM - VM Modify
###################################################################################################################
#region Set VM Example

# -------------------------- Example 1 --------------------------
# Converts the VM virtual machine to a template and stores the template in the $template variable.
# VM 가상 머신을 템플릿으로 변환하고 템플릿을 $template 변수에 저장함
$template = Get-VM VM | Set-VM -ToTemplate -Name VMTemplate
# -------------------------- Example 2 --------------------------
# Upgrades the memory and CPU count of the virtual machines in ResourcePool01.
# ResourcePool01에서 가상 머신의 메모리 및 CPU 수를 업그레이드합니다
Get-VM -Location ResourcePool01 | Set-VM -MemoryGB 2 -NumCPU 2
# -------------------------- Example 3 --------------------------
# Upgrades the virtual hardware version of the VM virtual machine.
# VM 가상 머신의 가상 하드웨어 버전을 업그레이드함
Set-VM -VM VM -HardwareVersion vmx-07
# -------------------------- Example 4 --------------------------
# Reverts the VM virtual machine to the "Initial state" snapshot.
# VM 가상 머신을 "초기 상태"스냅 샷으로 되돌립니다.
$snapshot = Get-Snapshot -VM $vm -Name "Initial state"
Set-VM -VM $vm -Snapshot $snapshot
# -------------------------- Example 5 --------------------------
# Applies a customization specification on the specified virtual machines.
# 지정된 가상 머신에 사용자 지정 사양을 적용함
$spec = Get-OSCustomizationSpec -Name FinanceDepartmentSpec;
Set-VM -VM $vm -OSCustomizationSpec $spec
# -------------------------- Example 6 --------------------------
# Changes the name, description, and guest ID of the specified virtual machine.
# 지정된 가상 머신의 이름, 설명 및 게스트 ID를 변경함
Set-VM $vm -Name "Web Server" -GuestID winNetStandardGuest -Description "Company's web server"
# -------------------------- Example 7 --------------------------
# Encrypts the whole virtual machine stored in $vm including its VM Home and all its valid hard disks.
# VM 홈 및 모든 유효한 하드 디스크를 포함하여 $ vm에 저장된 전체 가상 머신을 암호화합니다
$keyprovider = Get-KeyProvider | select -first 1
Set-VM $vm -KeyProvider $keyprovider
# -------------------------- Example 8 --------------------------
$storagepolicy = Get-SpbmStoragePolicy | select -first 1
Set-VM $vm -StoragePolicy $storagepolicy -SkipHardDisks
# Attaches the $storagepolicy to the VM Home of the $vm virtual machine: - If the $storagepolicy is an encryption policy, the VM Home of the $vm virtual machine is encrypted or re-encrypted with the new policy.
# $storagepolicy를 $vm 가상 머신의 VM Home에 연결함
# $storagepolicy가 암호화 정책인 경우 $vm 가상 머신의 VM Home이 암호화되거나 새 정책으로 다시 암호화됩니다.
# If the $storagepolicy is a non-encryption policy, the VM Home of the $vm virtual machine is decrypted (if it was encrypted before this cmdlet, and it has no encrypted disks) and attached with the new policy.
# $storagepolicy가 비암호화 정책인 경우 $vm 가상 머신의 VM 홈이 해독되고 (이 cmdlet 이전에 암호화되었으며 암호화 된 디스크가없는 경우) 새 정책으로 연결됩니다.
# -------------------------- Example 9 --------------------------
# Decrypts the whole virtual machine stored in $vm including its VM Home and all its valid hard disks.
# VM 홈 및 모든 유효한 하드 디스크를 포함하여 $ vm에 저장된 전체 가상 머신을 해독함
Set-VM $vm -DisableEncryption

#endregion
