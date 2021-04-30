###################################################################################################################
# vCenter
#  | Out-GridView         #>> Grid 콘솔로 보여져 편함
# 여러줄 주석 : shift + alt + a
# Visual Studio Tab 이동 : Ctrl + F6 / Ctrl + shift + F6 / (파일선택 이동) Ctrl + Tab
# 명령어 확인 : Get-Command | where {$_.Source -match "Vmware.VimAutomation.core"}
###################################################################################################################
# 01. Get-VM (연결확인, VM Hardware 정보, VM 이동)
# 02. VM CPU, Memory
# 03. Template
# 04. Get-Folder
# 05. Get-Snapshot
# 06. Get-DataStore
# 07. Name 을 가지고 ID Value 찾기
# 08. ResourcePool
# 09. Get-VmHost
# 10. New VM - VM Create
# 11. Network Adapter 정보
# 12. IP, DNS, WINS 세팅 Examples ( 전체 VM을 상대로 )
# 13. Set VM - VM Modify

# 14. 해당 Host Nic : Name, MacAddress, MTU, Speed...  등 정보
# 15. 도메인가입
# 16. VM 내부로 File Copy

# ETC

###################################################################################################################
# 01. Get-VM, Move-VM
###################################################################################################################
#region

Get-Vm | Select-Object vCenterUrl, Name, IPAddress, HostName, State, Status, ProvisionedSpaceGB, UsedSpaceGB, @{N='vCenterUrl';E={$_.ExtensionData.Client.ServiceUrl.Split('/')[2]}}
Get-Vm | select ID, Name, IPAddress, HostName, State, Status, ProvisionedSpaceGB, UsedSpaceGB, @{N='vCenterUrl';E={{$_.ExtensionData.Client.ServiceUrl.Split('/')[2]}}}
Get-VM | Select Name, PowerState, NumCpu, CorePerSocket, MemoryGB, VMHostId, VMHost, FolderId, Folder, ResourcePoolId, ResourcePool, GuestId, UsedSpaceGB, ProvisionedSpaceGB, DatastoreIdList, CreateDate, Id, @{N = 'IPAddress';E={@($_.guest.IPAddress[0])}}

Get-Vm | where {{$_.ExtensionData.OverallStatus -ne 'green'}}

Get-Vm -ComputerName Server1 | Where-Object {$_.State -eq 'Running'}

#------------------------------------------------------------------------------------------------------------------
# 연결확인 > ConnectionState : Connected, GuestControl, StartConnected
Get-Vm Win10Pro-ID001 | Get-NetworkAdapter | where {$_.NetworkName -eq 'VM Network'} | select ConnectionState
#------------------------------------------------------------------------------------------------------------------
# 전체 VM의 Hard Disk Size
Get-Vm | Select-Object Name,@{n="HardDiskSizeGB"; e={(Get-HardDisk -VM $_ | Measure-Object -Sum CapacityGB).Sum}} | Out-GridView
#------------------------------------------------------------------------------------------------------------------
# VM Hardware 정보
#------------------------------------------------------------------------------------------------------------------
$vm = Get-View -ViewType VirtualMachine -Filter @{"Name" = "Win10Pro"};
$vmhostView = Get-View -ID $vm.Runtime.Host;$vmhostView.Summary.Runtime;

$result = "" | select vmName, NumCpu, MemoryGB, harddiskname, HardDiskCapacityGb
$result.vmName = $vm.Name
$result.NumCpu = $vm.NumCpu
$result.MemoryGB = $vm.MemoryGB
$result.HardDiskName = $vmHardDisk.Name
$result.HardDiskCapacityGb = [System.Math]::Round($vmHardDisk.CapacityGB, 0)
$results += $result
#------------------------------------------------------------------------------------------------------------------
# VM 이동
#------------------------------------------------------------------------------------------------------------------
# 현재 위치에서 IP 주소 10.23.112.235의 호스트로 이동
Get-Vm -Name VM | Move-VM -Destination 10.23.112.235
# "VM" 을 "Folder" 로 이동
Move-VM -VM VM -Destination Folder
# 가상 머신을 ResourcePool 자원 풀로 이동. ESX 호스트는 변경안됨.
Move-VM -VM VM -Destination ResourcePool
# MyVM1 가상 머신을 지정된 데이터 스토어 클러스터의 모든 데이터 스토어로 이동.
$myDatastoreCluster1 = Get-DatastoreCluster -Name 'MyDatastoreCluster1'
# Move-VM -VM 'MyVM1' -Datastore $myDatastoreCluster1

#------------------------------------------------------------------------------------------------------------------
# MyVM1 가상 머신을 지정된 데이터 스토어 클러스터로 이동하고 가상 머신 배치에 대한 VM 디스크 반 선호도 규칙을 설정.
# MyVM1 가상 머신의 디스크는 지정된 데이터 스토어 클러스터의 다른 데이터 스토어에 저장됨.
#------------------------------------------------------------------------------------------------------------------
$myVm1 = Get-Vm -Name 'MyVM1'
$vmdks = Get-Harddisk -VM $myVm1
$myDatastoreCluster1 = Get-DatastoreCluster -Name 'MyDatastoreCluster1'
$vmdkAntiAffinityRule = New-Object -TypeName VMware.VimAutomation.ViCore.Types.V1.DatastoreManagement.SdrsVMDiskAntiAffinityRule -ArgumentList $vmdks
Move-VM -VM '$myVm1' -Datastore $myDatastoreCluster1 -AdvancedOption $vmdkAntiAffinityRule

#------------------------------------------------------------------------------------------------------------------
# Master VM 계정 연결 dir 명령 처리 >> basic reference 참조 (Win10Pro-StaticIP >> testuser1 / P@ssw0rd)
#------------------------------------------------------------------------------------------------------------------

#endregion
###################################################################################################################
# 02. VM CPU, Memory
###################################################################################################################
#region

$VM = Get-Vm -name "W10-ID1-005"
$vmstat = "" | Select VmName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin
$vmstat.VmName = $vm.name
$statcpu = Get-Stat -Entity ($vm)-start (get-date).AddDays(-30) -Finish (get-date).AddDays(-1) -MaxSamples 10000 -stat cpu.usage.average -CPU:$false
$statmem = Get-Stat -Entity ($vm)-start (get-date).AddDays(-30) -Finish (get-date).AddDays(-1) -MaxSamples 10000 -stat mem.usage.average

$cpu = $statcpu | Measure-Object -Property value -Average -Maximum -Minimum
$mem = $statmem | Measure-Object -Property value -Average -Maximum -Minimum

$vmstat.CPUMax = $cpu.Maximum
$vmstat.CPUAvg = $cpu.Average
$vmstat.CPUMin = $cpu.Minimum
$vmstat.MemMax = $mem.Maximum
$vmstat.MemAvg = $mem.Average
$vmstat.MemMin = $mem.Minimum
Write-Host $vmstat
# >> @{VmName=Win10-Link02; MemMax=34.5900001525879; MemAvg=34.5900001525879; MemMin=34.5900001525879; CPUMax=0.589999973773956; CPUAvg=0.589999973773956; CPUMin=0.589999973773956}
#------------------------------------------------------------------------------------------------------------------
# VM CPU, Memory, Network, Disk 관련 사용율 (CSV Output >> | Export-Csv -Path d:AverageUsage.csv)
# 지난 30 일, 5 분 간격으로 전원이 켜진 가상 시스템의 평균 CPU, 메모리, 네트워크 및 디스크 사용량을 계산
# 필요시 >> "-IntervalMins 5" 수정
#------------------------------------------------------------------------------------------------------------------
Get-Vm | Where {$_.PowerState -eq "PoweredOn"} | Select Name, Host, NumCpu, MemoryMB, @{N="CPU Usage (Average), Mhz"; E={[Math]::Round((($_ | Get-Stat -Stat cpu.usagemhz.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}}, @{N="Memory Usage (Average), %"; E={[Math]::Round((($_ | Get-Stat -Stat mem.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} , @{N="Network Usage (Average), KBps"; E={[Math]::Round((($_ | Get-Stat -Stat net.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}}, @{N="Disk Usage (Average), KBps" ; E={[Math]::Round((($_ | Get-Stat -Stat disk.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} | Export-Csv -Path d:AverageUsage.csv

Select Name, Host, NumCpu, MemoryMB,
@{N="CPU Usage (Average), Mhz"; E={[Math]::Round((($_ | Get-Stat -Stat cpu.usagemhz.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}},
@{N="Memory Usage (Average), %"; E={[Math]::Round((($_ | Get-Stat -Stat mem.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}},
@{N="Network Usage (Average), KBps"; E={[Math]::Round((($_ | Get-Stat -Stat net.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}},
@{N="Disk Usage (Average), KBps" ; E={[Math]::Round((($_ | Get-Stat -Stat disk.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}}

# TEST
Get-Stat -Entity 'VComp-005' -Stat mem.usage.average -RealTime | Measure-Object -Property value -Average | select Average
Get-Stat -Entity 'Win10Pro-SIP001' -Stat mem.usage.average -RealTime | Measure-Object -Property value -Average | select Average

#------------------------------------------------------------------------------------------------------------------
# Cluster Name 으로 VM별 Name, CPU, Memory 정보
Get-Cluster NM_VMWC | Get-Vm | Where {$_.PowerState -eq “PoweredOn”} | Select Name, Host, NumCpu, MemoryMB

#endregion
###################################################################################################################
# 03. Template
###################################################################################################################
#region

Get-View -viewtype clustercomputeresource | select Name, @{N="VMs";E={(Get-View -viewtype virtualmachine -SearchRoot $_.moref -Filter @{"Config.Template"="False"}).Count} }, @{  N="Templates";E={$clname=$_.name; ($clusters | ? {$_.Name -eq $clname}).Count } }
# Template Function

$clusters = (Get-View -viewtype virtualmachine -Filter @{'Config.Template'='True'})| %{$_.Summary.Runtime.Host|Get-VIObjectByVIView|get-cluster|sort -property name} | Group-Object -Property name;
$rtnclusters = (Get-View -viewtype clustercomputeresource | select Name, @{N='VMs';E={(Get-View -viewtype virtualmachine -SearchRoot $_.moref -Filter @{'Config.Template'='False'}).Count} }, @{ N='Templates';E={$clname=$_.name; ($clusters | ? {$_.Name -eq $clname}).Count } });
$rtnclusters

#------------------------------------------------------------------------------------------------------------------
Get-Template | select Name, Id
Get-Template | select Name, numcpu, memorygb, @{N="Hard Disk"; E={get-harddisk -VM $_ }}, id
Get-View -id (Get-Template TEST202005081).id
Get-View -id (Get-Template TEST202005081).id | Select Name, Datastore, Snapshot, Parent, Moref
Get-View -id (Get-Template Win10Pro-InstantClone-Template).id | Select Name, Datastore, Snapshot, Parent, Moref
Get-View -id (Get-Template Windows10Pro-x64-Template).id | Select @{N='ID';E={(Get-Template Windows10Pro-x64-Template).id}}, Name, Datastore, Snapshot, Parent, Moref

<#
    Name      : TEST202005081
    Datastore : {Datastore-datastore-37}
    Snapshot  :
    Parent    : Folder-group-v22
    MoRef     : VirtualMachine-vm-124
#>
#------------------------------------------------------------------------------------------------------------------
# Template 은 Get-Vm에 노출 되지 않음. ( vCenter DB : Select * FROM [VCDB].[VMW].[VPX_VM] Where [IS_TEMPLATE] = 1)
#------------------------------------------------------------------------------------------------------------------
Get-View -id (Get-Template TEST202005081).id | Select @{N='ID';E={(Get-Template TEST202005081).id}}, Name, Datastore, Snapshot, Parent, Moref
Get-View -id (Get-Template Windows10x64_Template).id | Select @{N='ID';E={(Get-Template Windows10x64_Template).id}}, Name, Datastore, Snapshot, Parent, Moref
#------------------------------------------------------------------------------------------------------------------

#endregion
###################################################################################################################
# 04. Get-Folder
###################################################################################################################
#region

$folder = Get-Folder Folder | Get-View;
Get-View -SearchRoot $folder.MoRef -ViewType "VirtualMachine" -Filter @{'Name' = 'Win*'}
Get-View -SearchRoot $folder.MoRef -ViewType "VM" -Filter @{'Name' = 'Win*'}

Get-Folder | Select ID, Name, Type

#endregion
###################################################################################################################
# 05. Get-Snapshot -id (get-template TEST202005081).id
###################################################################################################################
#region

# Get-Snapshot [[-Name] <String[]>] [-Id <String[]>] [-VM] <VirtualMachine[]> [-Server <VIServer[]>] [<CommonParameters>]
# Example : Get-Snapshot -VM VM -Name 'Before ServicePack 2'
#------------------------------------------------------------------------------------------------------------------
Get-Vm | Get-Snapshot | sort SizeGB -descending | Select VM, Name, Created, @{Label='Size';Expression={'{0:N2} GB' -f ($_.SizeGB)}}, Id
Get-Vm | Get-Snapshot | sort SizeGB -descending | Select VM, Name, Created, @{Label='Size';Expression={'{0:N2} MB' -f ($_.SizeMB)}}, Id

# 스냅샷 리스트
Get-Snapshot *
Get-Snapshot * | Select-Object -Property Name, SizeGB, VM, PowerState, Children | Sort-Object -Property sizeGB -Descending | ft -AutoSize
<#
Name                 Description                    PowerState
----                 -----------                    ----------
Win10Pro_Snap1       Win10Pro_Snap1                 PoweredOff
Win10Pro-InsSnap1    Instant Clone 용 스냅           PoweredOff
snapshot-eff6dca7... snapshot                       PoweredOff
#>

#endregion
###################################################################################################################
# 06. Get-DataStore
###################################################################################################################
#region

# DataStore
Get-Datastore | Select ID, Name, FreeSpaceGB, CapacityGB
Get-Datastore -id "Datastore-datastore-29", "Datastore-datastore-37"

#  GetDatastore_MaximumFreeSize_ByDatastoreIdList
GetDatastore_MaximumFreeSize_ByDatastoreIdList -DatastoreIdList "Datastore-datastore-29"; "Datastore-datastore-37";

#------------------------------------------------------------------------------------------------------------------
Get-DataStore -Name 'DataStore15' | select @{N='vCenterUrl';E={$_.ExtensionData.Client.ServiceUrl.Split('/')[2]}}, Name, @{N='Status';E={$_.ExtensionData.OverallStatus}}, State, @{N='Device';E={$_.ExtensionData.Info.Vmfs.Extent.Diskname}}, CapacityGB, FreeSpaceGB, Type, @{N='VMCount';E={$_.ExtensionData.vm.count}}, @{N='LastUpdate';E={$_.ExtensionData.Info.TimeStamp}}
<#
vCenterUrl  : 192.168.50.16
Name        : DataStore15
Status      : green
State       : Available
Device      : naa.64cd98f0ae7deb00257e6c3d149323ab
CapacityGB  : 886.25
FreeSpaceGB : 351.1884765625
Type        : VMFS
VMCount     : 9
LastUpdate  : 2020-08-05 오전 4:57:26 #>
#------------------------------------------------------------------------------------------------------------------
#endregion
###################################################################################################################
# 07. Name 을 가지고 ID Value 찾기
###################################################################################################################
#region

Get-View -id (Get-Cluster NM_VMWC).id
Get-View -id (Get-Cluster NM_VMWC).id | Select MoRef
Get-View -id (Get-Cluster NM_VMWC).id | Select @{N="ID"; E={$_.MoRef}}
Get-View -id (Get-ResourcePool Resources).id | Select ID
Get-View -id (Get-Datastore DataStore15).id | Select @{N='ID'; E={$_.MoRef}}
Get-View -id (Get-Foler "데이터 센터").id | Select @{N='ID'; E={$_.MoRef}}

#endregion
###################################################################################################################
# 08. ResourcePool
###################################################################################################################
#region

Get-ResourcePool | Select ID, Name, CpuSharesLevel, CpuReservationMHz, CpuLimitMHz, MemSharesLevel, MemReservationGB, MemLimitGB
Get-ResourcePool | Where {{$_.Parent -match 'ClusterName'}} | Select Id
Get-ResourcePool | Where {{$_.ParentId -match 'Resourcepool Parent ID'}} | Select ID, Name, CpuSharesLevel, CpuReservationMHz, CpuLimitMHz, MemSharesLevel, MemReservationGB, MemLimitGB
################################################################################################
Get-ResourcePool | Select *
# ParentId                 : ClusterComputeResource-domain-c1950
# Parent                   : NewCluster2
# CpuSharesLevel           : Normal
# NumCpuShares             : 4000
# CpuReservationMHz        : 0
# CpuExpandableReservation : True
# CpuLimitMHz              : -1
# MemSharesLevel           : Normal
# NumMemShares             : 163840
# MemReservationMB         : 0
# MemReservationGB         : 0
# MemExpandableReservation : True
# MemLimitMB               : -1
# MemLimitGB               : -1
# Name                     : Resources
# CustomFields             : {}
# ExtensionData            : VMware.Vim.ResourcePool
# Id                       : ResourcePool-resgroup-1951
# Uid                      : /VIServer=vsphere.local\administrator@192.168.50.16:443/ResourcePool=ResourcePool-resgroup-1951/

# 클러스터의 루트 리소스 풀 ResourcePool1에 ResourcePool2라는 새 리소스 풀을 만듭니다.
$resourcepool1 = Get-ResourcePool -Location Cluster -Name ResourcePool1
New-ResourcePool -Location $resourcepool1 -Name ResourcePool2 -CpuExpandableReservation $true -CpuReservationMhz 500 -CpuSharesLevel high -MemExpandableReservation $true -MemReservationGB 5 -MemSharesLevel high

#Connect-HVServer conn-serv -Credential (get-credential xxx\xxx)
#Connect-VIServer vdi-vcenter -Credential (get-credential xxx\xxx)
New-ResourcePool -Location (Get-Cluster -Name NM_VMWC) -Name $short -CpuExpandableReservation $true -CpuReservationMhz 0 -CpuSharesLevel Normal -MemExpandableReservation $true -MemReservationMB 0 -MemSharesLevel Normal

#endregion
###################################################################################################################
# 09. Get-VmHost
###################################################################################################################
#region

Get-VmHost -Name '192.168.101.15' | select @{N='vCenterUrl';E={$_.ExtensionData.Client.ServiceUrl.Split('/')[2]}}, Name, ConnectionState, NumCpu, CpuTotalMHz, CpuUsageMhz, MemoryTotalMB, MemoryUsageMB, @{N='VMCount';E={$_.ExtensionData.vm.count}}, @{N='Uptime';E={$_.ExtensionData.Summary.Runtime.BootTime}}, @{N='Status';E={$_.ExtensionData.OverallStatus}}, @{N='ConfigStatus';E={$_.ExtensionData.ConfigStatus}}
<#
vCenterUrl      : 192.168.50.16
Name            : 192.168.101.15
ConnectionState : Connected
NumCpu          : 16
CpuTotalMhz     : 33520
CpuUsageMhz     : 1506
MemoryTotalMB   : 96729.5390625
MemoryUsageMB   : 24253
VMCount         : 9
Uptime          : 2020-04-07 오전 4:22:38
Status          : green
ConfigStatus    : green #>

#endregion
###################################################################################################################
# 10. New-VM
###################################################################################################################
#region

# Example 1 # 호스트, 데이터 스토어, 연결할 네트워크를 지정 VM 생성, 설정 구성.
$myTargetVMHost = Get-VMHost -Name MyVMHost1
New-VM -Name MyVM1 -ResourcePool $myTargetVMHost -Datastore MyDatastore1 -NumCPU 2 -MemoryGB 4 -DiskGB 40 -NetworkName "VM Network" -Floppy -CD -DiskStorageFormat Thin -GuestID winNetDatacenterGuest

# Example 2 # 클러스터를 지정하여 VM 생성/ ResourcePool 매개 변수는 ResourcePool, Cluster, VApp 및 독립 실행 형 VMHost 개체를 허용
$myCluster = Get-Cluster -Name MyCluster1
New-VM -Name MyVM1 -ResourcePool $myCluster

$myCluster = Get-Cluster -Name DE-V001
New-VM -Name TESTVM -ResourcePool $myCluster

# Example 3 # 대상 호스트의 자동 선택을 허용하는 대신 클러스터를 지정하고 명시 적으로 호스트를 선택하여 VM 생성
$vmhost = Get-VMHost -Name MyVMHost1
$myCluster = Get-Cluster -Name MyCluster1
New-VM -Name MyVM1 -VMHost $vmhost -ResourcePool $myCluster -DiskGB 4 -MemoryGB 1

# Example 4 # 여러 디스크가있는 VM 생성
$vmhost = Get-VMHost -Name MyVMHost1
New-VM -Name MyVM1 -ResourePool $vmhost -DiskGB 40,100

# Example 5 # 기존 디스크를 지정하여 VM 생성
$vmhost = Get-VMHost -Name MyVMHost1
New-VM -Name MyVM1 -ResourcePool $vmhost -DiskPath "[Storage1] WindowsXP/WindowsXP.vmdk"

# Example 6 # HardwareVersion 매개 변수를 통해 가상 머신 하드웨어의 버전을 명시 적으로 지정하여 VM 생성
$vmhost = Get-VMHost -Name MyVMHost1
New-VM -Name MyVM1 -ResourcePool $vmhost -HardwareVersion vmx-04

# Example 7 # 지정된 "$ds" 데이터 스토어 및 MyHost1 호스트에 암호화 된 VM 생성
$keyprovider = Get-KeyProvider "MyKeyProvider"
$ds = Get-Datastore -VMHost MyHost1
New-VM -Name 'MyVM' -VMHost MyHost1 -Datastore $ds -KeyProvider $keyprovider

# Example 8 # 지정된 "$ds" 데이터스토어 및 MyHost1 호스트의 VM 홈에 연결된 "$policy" 스토리지 정책을 사용하여 VM 생성
# "$policy"가 암호화 정책 인 경우 가상 머신의 VM Home은 생성 중에 암호화됨
$policy = Get-SpbmStoragePolicy "MyPolicy"
$ds = Get-Datastore -VMHost MyHost1
New-VM -Name 'MyVM' -VMHost MyHost1 -Datastore $ds -StoragePolicy $policy -SkipHardDisks

# Example 9 # 지정된 데이터 스토어 및 호스트에서 MyVM1 가상 머신을 복제하여 MyVM2라는 새 VM 생성
$myDatastore = Get-Datastore -Name MyDatastore1
$vmhost = Get-VMHost -Name MyVMHost1
New-VM -Name MyVM2 -VM MyVM1 -Datastore $myDatastore -VMHost $vmhost

# Example 10 # MyVM1 및 MyVM2 가상 머신을 MyHost1 호스트의 MyFolder1 폴더에 복사
New-VM -VM MyVM1, MyVM2 -Location MyFolder1 -VMHost MyHost1

# Example 11 # 가상 머신 MyVM1을 MyVM2에 복제하고 복제 된 가상 머신에 사용자 지정 사양을 적용
$myResourcePool = Get-ResourcePool -Name MyResourcePool1
$mySpecification = Get-OSCustomizationSpec -Name WindowsSpec
New-VM -VM MyVM1 -Name MyVM2 -OSCustomizationSpec $mySpecification -ResourcePool $myResourcePool

# Example 12 # 지정된 템플릿에서 가상 머신을 생성하고 지정된 사용자 지정 사양을 적용
$myResourcePool = Get-ResourcePool -Name MyResourcePool1
$myTemplate = Get-Template -Name WindowsTemplate
$mySpecification = Get-OSCustomizationSpec -Name WindowsSpec
New-VM -Name MyVM2 -Template $myTemplate -ResourcePool $myResourcePool -OSCustomizationSpec $mySpecification

# Example 13 # MyVM1 가상 머신에 대해 지정된 구성 파일을 검색하고 지정된 호스트에 MyVM1 가상 머신을 등록
cd vmstores:\myserver@443\Datacenter\Storage1\MyVM1\
$vmxFile = Get-Item MyVM1.vmx
$vmhost = Get-VMHost -Name MyVMHost1
New-VM -VMHost $vmhost -VMFilePath $vmxFile.DatastoreFullPath

# Example 21 # 상위 가상 머신의 지정된 스냅 샷에서 Linked Clone 생성 / 지정된 VM 호스트 및 데이터 스토어에 저장됨
$mySourceVM = Get-VM -Name MySourceVM1
$myReferenceSnapshot = Get-Snapshot -VM $mySourceVM -Name "InitialState"
$vmhost = Get-VMHost -Name MyVMHost1
$myDatastore = Get-Datastore -Name MyDatastore1
New-VM -Name MyLinkedCloneVM1 -VM $mySourceVM -LinkedClone -ReferenceSnapshot $myReferenceSnapshot -ResourcePool $vmhost -Datastore $myDatastore

# Example 22 # 지정된 구성으로 새 가상 머신을 생성하고 지정된 분산 포트 그룹에 연결합니다..
$myCluster = Get-Cluster -Name "MyCluster"
$myVDPortGroup = Get-VDPortgroup -Name "MyVDPortGroup"
$mySharedDatastore = Get-Datastore -Name "MySharedDatastore"
New-VM -Name MyVM -ResourcePool $myCluster -Portgroup $myVDPortGroup -DiskGB 40 -MemoryGB 4 -Datastore $mySharedDatastore

#------------------------------------------------------------------------------------------------------------------
# 체크 필요 >> Description 추가
#------------------------------------------------------------------------------------------------------------------
$ClusterId = Get-View -id (Get-Cluster NM_VMWC).id | Select @{N = 'ID'; E={$_.MoRef}}
$DatastoreId = Get-View -id (Get-Datastore DataStore15).id | Select @{N = 'ID'; E={$_.MoRef}};
$ResourcePoolId = Get-View -id (Get-ResourcePool Resources).id | Select @{N = 'ID'; E={$_.MoRef}}

# 지정폴더 없을때 생성 로직 확인후 추가???
$folderName = 'TestVM'
$folderName -replace ' ', '` '
$folderId = Get-View -id (Get-Folder $folderName).id | Select @{N = 'ID'; E={$_.MoRef}}
$TemplateId = Get-View -id (Get-Template Windows10Pro-x64-Template).id | Select @{N = 'ID'; E={$_.MoRef}}

# >> ID 처리로 안됨 >> Feela 내부 함수 처리 로직임.
New-VM -Datastore $DatastoreId -ResourcePool $ResourcePoolId -Location $folderId -Template $TemplateId -VMName 'Win10Pro-ID006'

#------------------------------------------------------------------------------------------------------------------
# VM 생성 TEST 완료 (Feela 함수)
#------------------------------------------------------------------------------------------------------------------
NewVM_FromTemplate_ByIdEx -ClusterId ClusterComputeResource-domain-c61 -DatastoreIdList "Datastore-datastore-29;Datastore-datastore-37" -ResourcePoolId "ResourcePool-resgroup-62" -VMFolderId Folder-group-v70 -VMTemplateId VirtualMachine-vm-97 -VMName 'PowerShellBase-VM'
NewVM_FromTemplate_ByIdEx -ClusterId ClusterComputeResource-domain-c61 -DatastoreIdList "Datastore-datastore-29" -ResourcePoolId "ResourcePool-resgroup-62" -VMFolderId Folder-group-v252 -VMTemplateId VirtualMachine-vm-251 -VMName 'PowerShellBase-VM'

" -ClusterId $ClusterId -DatastoreIdList 'Get-View -id (Get-ResourcePool DataStore15).id | Select @{N = 'ID'; E={$_.MoRef}} ;'  -ResourcePoolId $ResourcePoolId -VMFolderId $folderId -VMTemplateId $TemplateId -VMName 'Win10Pro-ID006' "

"NewVM_FromTemplate_ByIdEx ClusterComputeResource-domain-c0 '' ResourcePool-resgroup-0 Folder-group-v0 VirtualMachine-vm-0"

#endregion
###################################################################################################################
# 11. Network Adapter 정보
###################################################################################################################
#region

#------------------------------------------------------------------------------------------------------------------
$VMName = 'Win10Pro-SIP001'
$networkAdapters = Get-Vm $VMName | Get-NetworkAdapter
<#
Name                 Type       NetworkName  MacAddress         WakeOnLan Enabled
----                 ----       -----------  ----------         ---------
네트워크 어댑터 1    e1000e     VM Network   00:50:56:90:7e:49       True
#>
Get-Vm $VMName | Get-NetworkAdapter -name $networkAdapters.name | set-networkadapter -networkname $networkAdapters.NetworkName -Confirm:$false -Connected:$true -StartConnected:$true

#endregion
###################################################################################################################
# 12. IP, DNS, WINS 세팅 Examples ( 전체 VM을 상대로 )
###################################################################################################################
#region

$vm = Get-Vm -name 'Win10Pro-SIP001'
$cmd1 = 'netsh interface ip set address name="Ethernet0" static 192.168.101.231 255.255.255.0 192.168.101.1 1'
$cmd2 = 'netsh interface ip set dns name="Ethernet0" static 192.168.50.2'
$cmd3 = 'netsh interface ip add dns name="Ethernet0" 192.168.50.3'

invoke-vmscript -VM $vm -ScriptText $cmd1 -GuestUser 'testuser1' -GuestPassword 'P@ssw0rd' -ScriptType bat
invoke-vmscript -VM $vm -ScriptText $cmd2 -GuestUser 'testuser1' -GuestPassword 'P@ssw0rd' -ScriptType bat
invoke-vmscript -VM $vm -ScriptText $cmd3 -GuestUser 'testuser1' -GuestPassword 'P@ssw0rd' -ScriptType bat

<#
# 해당 Guest 계정은 Master VM 생성시 정한 계정이 확실
Invoke-VMScript -VM $vm -ScriptText $cmd1 -GuestUser 'namurnd\administrator' -GuestPassword 'namudev!23$' -ScriptType bat
Invoke-VMScript -VM $vm -ScriptText $cmd2 -GuestUser 'namurnd\administrator' -GuestPassword 'namudev!23$' -ScriptType bat
Invoke-VMScript -VM $vm -ScriptText $cmd3 -GuestUser 'namurnd\administrator' -GuestPassword 'namudev!23$' -ScriptType bat
#>
#------------------------------------------------------------------------------------------------------------------
$VIServer = Read-Host "Enter vCenter Server Name or IP: "
#$VIServer = Read-Host "192.168.50.16"
Connect-VIServer $VIServer

$HostCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter ESX host credentials", "", "")
$GuestCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter Guest credentials", "", "")
$PrimaryDNS = Read-Host "Primary DNS: "
$SecondaryDNS = Read-Host "Secondary DNS: "
$PrimaryOldWINS = Read-Host "Old Primary WINS: "
$SecondaryOldWINS = Read-Host "Old Secondary WINS: "
$PrimaryWINS = Read-Host "Primary WINS: "
$SecondaryWINS = Read-Host "Secondary WINS: "

get-vm |  %{ $_.Name; $_ | Invoke-VMScript -HostCredential $HostCred -GuestCredential $GuestCred -ScriptType "bat" -ScriptText "netsh interface ip set dns ""Local Area Connection"" static $PrimaryDNS" }
get-vm |  %{ $_.Name; $_ | Invoke-VMScript -HostCredential $HostCred -GuestCredential $GuestCred -ScriptType "bat" -ScriptText "netsh interface ip add dns ""Local Area Connection"" $SecondaryDNS" }
get-vm |  %{ $_.Name; $_ | Invoke-VMScript -HostCredential $HostCred -GuestCredential $GuestCred -ScriptType "bat" -ScriptText "netsh interface ip delete wins ""Local Area Connection"" $PrimaryOldWINS" }
get-vm |  %{ $_.Name; $_ | Invoke-VMScript -HostCredential $HostCred -GuestCredential $GuestCred -ScriptType "bat" -ScriptText "netsh interface ip delete wins ""Local Area Connection"" $SecondaryOldWINS" }
get-vm |  %{ $_.Name; $_ | Invoke-VMScript -HostCredential $HostCred -GuestCredential $GuestCred -ScriptType "bat" -ScriptText "netsh interface ip add wins ""Local Area Connection"" $PrimaryWINS" }
get-vm |  %{ $_.Name; $_ | Invoke-VMScript -HostCredential $HostCred -GuestCredential $GuestCred -ScriptType "bat" -ScriptText "netsh interface ip add wins ""Local Area Connection"" $SecondaryWINS index=2" }

#------------------------------------------------------------------------------------------------------------------
Invoke-VMScript -VM $vmname -GuestUser $VMLocalUser -GuestPassword $VMLocalPWord -ScriptType Powershell "netdom join /d:mywork.domain computername /userd:domainaccount /passwordd:pwd"
#------------------------------------------------------------------------------------------------------------------

#endregion

###################################################################################################################
# 13. Set VM - VM Modify
###################################################################################################################
#region

# Example 1 # VM 가상 머신을 템플릿으로 변환하고 템플릿을 $template 변수에 저장합니다.
$template = Get-VM VM | Set-VM -ToTemplate -Name VMTemplate

# Example 2 # ResourcePool01에서 가상 머신의 메모리 및 CPU 수를 업그레이드합니다
Get-VM -Location ResourcePool01 | Set-VM -MemoryGB 2 -NumCPU 2

# Example 3 # VM 가상 머신의 가상 하드웨어 버전을 업그레이드합니다.
Set-VM -VM VM -HardwareVersion vmx-07

# Example 4 # VM 가상 머신을 "초기 상태"스냅 샷으로 되돌립니다.
$snapshot = Get-Snapshot -VM $vm -Name "Initial state"
Set-VM -VM $vm -Snapshot $snapshot

# Example 5 #
# 지정된 가상 머신에 사용자 지정 사양을 적용합니다.
$spec = Get-OSCustomizationSpec -Name FinanceDepartmentSpec;
Set-VM -VM $vm -OSCustomizationSpec $spec

# Example 6 #
# 지정된 가상 머신의 이름, 설명 및 게스트 ID를 변경합니다.
Set-VM $vm -Name "Web Server" -GuestID winNetStandardGuest -Description "Company's web server"

# Example 7 #
# VM 홈 및 모든 유효한 하드 디스크를 포함하여 $ vm에 저장된 전체 가상 머신을 암호화합니다
$keyprovider = Get-KeyProvider | select -first 1
Set-VM $vm -KeyProvider $keyprovider

# Example 8 #
# $storagepolicy를 $vm 가상 머신의 VM Home에 연결합니다./ $storagepolicy가 암호화 정책인 경우 $vm 가상 머신의 VM Home이 암호화되거나 새 정책으로 다시 암호화됩니다.
# $storagepolicy가 비암호화 정책인 경우 $vm 가상 머신의 VM 홈이 해독되고 (이 cmdlet 이전에 암호화되었으며 암호화 된 디스크가없는 경우) 새 정책으로 연결됩니다.
$storagepolicy = Get-SpbmStoragePolicy | select -first 1
Set-VM $vm -StoragePolicy $storagepolicy -SkipHardDisks

# Example 9 # VM 홈 및 모든 유효한 하드 디스크를 포함하여 $ vm에 저장된 전체 가상 머신을 해독합니다.
Set-VM $vm -DisableEncryption

#endregion

##############################################################################################################################################
# V2 SwitchParameter	지정된 경우 cmdlet은 EsxCli 개체 버전 2 (V2)를 반환하고 그렇지 않으면 EsxCli 개체 버전 1 (V1)이 반환됩니다.
# 인터페이스 V2는 이름으로 만 메소드 인수 지정을 지원합니다. ESXCLI와의 상호 운용성을 위해 권장되는 PowerCLI 인터페이스입니다.
# 인터페이스 V1은 위치 별 메서드 인수 지정 만 지원합니다. 인터페이스 V1을 사용하는 스크립트는 서로 다른 두 버전의 ESXi에서 호환된다는 보장이 없습니다.
# 인터페이스 V1은 더 이상 사용되지 않습니다.	그릇된	그릇된
#
# VMHost	VMHost []	ESXCLI 기능을 노출 할 호스트를 지정합니다.
##############################################################################################################################################
#region

# Example 4 #
# 지정된 네임 스페이스에서 사용 가능한 모든 애플리케이션 목록을 검색합니다. 이 예제는 vCenter Server 5.0 / ESXi 5.0 이상에서 작동합니다.
$vmHost = Get-VMHost "vmHostIp"
$esxcli = Get-EsxCli -VMHost $vmHost -V2
$esxcli.storage.nmp
# Example 5 #
# 지정된 ESXCLI 애플리케이션의 사용 가능한 모든 명령 목록을 검색합니다. 이 예제는 vCenter Server 5.0 / ESXi 5.0 이상에서 작동합니다.
$vmHost = Get-VMHost "vmHostIp"
$esxcli = Get-EsxCli -VMHost $vmHost -V2
$esxcli.storage.nmp.device
# Example 7 #
# PowerCLI의 ESXCLI V2 인터페이스를 사용하여 ESXCLI 애플리케이션의 명령을 실행합니다. 이 예제는 vCenter Server 5.0 / ESXi 5.0 이상에서 작동합니다.
$vmHost = Get-VMHost "vmHostIp"
$esxcli = Get-EsxCli -VMHost $vmHost -V2
$esxcli.storage.nmp.device.list.Invoke()
# Example 13 #
# 지정된 관리 개체 유형 (vim.EsxCLI.storage.nmp.device) 및 해당 메서드에 대한 정보를 가져옵니다.
$vmHost = Get-VMHost "vmHostIp"
$esxcli = Get-EsxCli -VMHost $vmHost -V2
$moTypeInfo = $esxcli.TypeManager.QueryTypeInfo("vim.EsxCLI.storage.nmp.device")

$moTypeInfo.managedTypeInfo[0].method

#endregion
##############################################################################################################################################
# 14. 해당 Host Nic : Name, MacAddress, MTU, Speed...  등 정보
##############################################################################################################################################
#region

$vmHost = Get-VMHost "vmHostIp"
$esxcli = Get-EsxCli -VMHost $vmHost -V2
$esxcli.network.nic.list()

$NIC = Get-NetworkAdapter -VM $server
Set-NetworkAdapter -NetworkAdapter $NIC -NetworkName "MyNewVLan 1234" -Confirm:$false

# 예제 1 #
#가상 네트워크 어댑터의 Mac 주소 및 WakeOnLan 설정을 구성합니다.
Get-VM VM | Get-NetworkAdapter | Set-NetworkAdapter -MacAddress '00:50:56:a1:00:00' -WakeOnLan:$true
# 예제 2 #
#가상 네트워크 어댑터의 유형을 설정합니다.
Get-VM VM | Get-NetworkAdapter | Set-NetworkAdapter -Type EnhancedVmxnet
# 예제 3 #
#가상 네트워크 어댑터의 연결 상태를 설정합니다.
Get-VM VM | Get-NetworkAdapter | Set-NetworkAdapter -Connected:$true
# 예제 4 #
#모든 가상 머신에서 "Network adapter 1"이라는 이름의 모든 네트워크 어댑터를 검색하여 지정된 분산 포트 그룹에 연결합니다.
$myNetworkAdapters = Get-VM | Get-NetworkAdapter -Name "Network adapter 1"
$myVDPortGroup = Get-VDPortgroup -Name MyVDPortGroup
Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters -Portgroup $myVDPortGroup
# 예제 5 #
#지정된 가상 머신에 추가 된 "Network adapter 1"이라는 네트워크 어댑터를 검색하고 지정된 Distributed Switch의 지정된 포트에 연결합니다.
$myNetworkAdapter = Get-VM -Name MyVM | Get-NetworkAdapter -Name "Network adapter 1"
$myVDSwitch = Get-VDSwitch -Name MyVDSwitch
Set-NetworkAdapter -NetworkAdapter $myNetworkAdapter -DistributedSwitch $MyVDSwitch -PortId 100

# Where  조건 처리
# 예제 1 #
(Get-Migrationbatch -Identity $MigrationBatchName | Where {($_.Status -like "Completed") -or ($_.Status -like "CompletedWithErrors") -or ($_.Status -like "Corrupted") -or ($_.Status -like "Failed") -or ($_.Status -like "Stopped")})
# 예제 2 #
(Get-Migrationbatch -Identity $MigrationBatchName | Where Status -in "Completed","CompletedWithErrors","Corrupted","Failed","Stopped")
# 예제 3 #
$filter_status = @("Completed", "CompletedWithErrors","Curropted","Failed", "Stopped")
Get-Migrationbatch -Identity $MigrationBatchName | Where Status -Match ($filter_status -Join "|")

#endregion

###################################################################################################################
# 15. 도메인가입
###################################################################################################################
#region

$myscript = @"
    $cred = New-Object System.Management.Automation.PsCredential("domain\user", (ConvertTo-SecureString 'P@$$w0rd' -AsPlainText -Force))
    Add-Computer -DomainName "mydomain" -Credential $cred -ComputerName mywindowsserver
    Restart-Computer
"@
Invoke-VMScript -ScriptText $myscript -vm mywindowsserver -GuestUser administrator -GuestPassword 'P@ssw0rd' -ScriptType Powershell
Invoke-VMScript -ScriptText $myscript -vm mywindowsserver -GuestUser administrator -GuestPassword 'P@ssw0rd' -ScriptType Powershell

$VMName = 'Win10Pro-SIP001'
# $VMName = 'Win10Pro-SIP002'
# $VMName = 'Win10Pro-SIP003'
$vmLocalUser = "testuser1"
$vmLocalPWord = ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force
$vmLocalCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $vmLocalUser, $vmLocalPWord

# This Scriptblock is used to add new VMs to the newly created domain by first defining the domain creds on the machine and then using Add-Computer
$JoinNewDomain = '$DomainUser = "namurnd\Administrator";
                  $DomainPWord = ConvertTo-SecureString -String "namudev!23$" -AsPlainText -Force;
                  $DomainCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DomainUser, $DomainPWord;
                  Add-Computer -DomainName namurnd.io -Credential $DomainCredential;
                  Start-Sleep -Seconds 20;
                  Shutdown /r /t 0'

Invoke-VMScript -ScriptText $JoinNewDomain -VM $VMName -GuestCredential $vmLocalCredential

# Script dir 테스트
Invoke-VMScript -vm 'Win10Pro-SIP003' -ScriptText "dir c:\" -GuestUser 'testuser1' -GuestPassword 'P@ssw0rd' -ScriptType bat

#endregion

###################################################################################################################
# 16. VM 내부로 File Copy
#------------------------------------------------------------------------------------------------------------------
# VMware Tools를 사용하여 지정된 가상 시스템의 게스트 OS와 파일 및 폴더를 복사합니다.
# 동일한 이름의 파일이 대상 디렉토리에 있으면 덮어 씁니다.
# VMware Tools에 연결할 때 GuestUser 및 GuestPassword 또는 GuestCredential 매개 변수를 사용하여 인증하십시오.
# 호스트를 인증하려면 HostUser 및 HostPassword 또는 HostCredential 매개 변수를 사용하십시오.
# SSPI는 지원되지 않습니다.
###################################################################################################################
#region

# Copy-VMGuestFile [-Source] <String[]> [-Destination] <String> -LocalToGuest [-Force] [-VM] <VirtualMachine[]> [-HostCredential <PSCredential>] [-HostUser <String>] [-HostPassword <SecureString>] [-GuestCredential <PSCredential>] [-GuestUser <String>] [-GuestPassword <SecureString>] [-ToolsWaitSecs <Int32>] [-Server <VIServer[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
# Copy-VMGuestFile [-Source] <String[]> [-Destination] <String> [-VM] <VirtualMachine[]> [-Force] [-GuestCredential <PSCredential>] [-GuestPassword <SecureString>] -GuestToLocal [-GuestUser <String>] [-HostCredential <PSCredential>] [-HostPassword <SecureString>] [-HostUser <String>] [-Server <VIServer[]>] [-ToolsWaitSecs <Int32>] [-Confirm] [-WhatIf] [<CommonParameters>]
# Copy-VMGuestFile [-Source] <String[]> [-Destination] <String> [-VM] <VirtualMachine[]> [-Force] [-GuestCredential <PSCredential>] [-GuestPassword <SecureString>] [-GuestUser <String>] [-HostCredential <PSCredential>] [-HostPassword <SecureString>] [-HostUser <String>] -LocalToGuest [-Server <VIServer[]>] [-ToolsWaitSecs <Int32>] [-Confirm] [-WhatIf] [<CommonParameters>]

#------------------------------------------------------------------------------------------------------------------
# Example 1 : text.txt 파일을 게스트 OS 시스템에서 로컬 Temp 디렉토리로 복사합니다.
Copy-VMGuestFile -Source c:\text.txt -Destination c:\temp\ -VM VM -GuestToLocal -GuestUser user -GuestPassword pass2
#------------------------------------------------------------------------------------------------------------------
# Example 2 : 로컬 컴퓨터에서 게스트 운영 체제로 파일을 복사합니다.
$vm = Get-VM -Name VM
Get-Item "c:\FolderToCopy\*.*" | Copy-VMGuestFile -Destination "c:\MyFolder" -VM $vm -LocalToGuest -GuestUser -GuestPassword pass2
#------------------------------------------------------------------------------------------------------------------
#==================================================================================================================
Copy-VMGuestFile -Source E:\MyApp\WarFile\MyAPP.war -Destination D:\Temp\MyApp.wap  -GuestToLocal -VM MYAPPServer01
Copy-VMGuestFile -Source D:\Temp\MyApp.war -Destination D:\Tomcat\webapps\MyApp.war -LocalToGuest -VM MYAPPWeb01 -GuestUser Administrator -GuestPassword xxxxxxxxxx

#==================================================================================================================
# (응용 프로그램 서버에서 파일을 복사하는 명령에 -GuestToLocal 매개 변수를 사용하고 명령에서 -LocalToGuest를 사용하는 웹 서버에 파일을 복사하는 명령에 유의하십시오.
# 또한 웹 서버에 대한 권한이 없으므로 로컬 워크 스테이션에 로그온 한 사용자 때문에 웹 서버에 대한 권한이있는 사용자 계정 및 비밀번호를 지정해야합니다.
# 매개 변수와 함께 로컬 관리자 계정을 사용했습니다.
# -GuestUser Administrator -GuestPassword xxxxxxxxxx,
# PowerCLI 세션을 실행하는 계정에 이 서버에 대한 권한이 있으므로 응용 프로그램 서버에서 복사하기 위해 명령에 계정을 지정할 필요가 없습니다.)

#------------------------------------------------------------------------------------------------------------------
# 파일이 대상에 이미 존재하는 경우 -Force 매개 변수를 포함해야합니다
Copy-VMGuestFile -Source E:\MyApp\WarFile\MyAPP.war -Destination D:\Temp\MyApp.war -GuestToLocal -VM MYAPPServer01 -Force
Copy-VMGuestFile -Source D:\Temp\MyApp.war -Destination D:\Tomcat\webapps\MyApp.war -LocalToGuest -VM MYAPPWeb01 -GuestUser Administrator -GuestPassword xxxxxxxxxx -Force

#------------------------------------------------------------------------------------------------------------------
# 명령줄에 게스트사용자 이름과 비밀번호를 표시하는 대신 자격증명을 입력하라는 메시지가 표시 될 수 있습니다
Copy-VMGuestFile -Source D:\Temp\MyApp.war -Destination D:\Tomcat\webapps\MyApp.war -LocalToGuest -VM MYAPPWeb01 -GuestCredential (Get-Credential)

#------------------------------------------------------------------------------------------------------------------
# 파일을 복사 할 웹 서버가 많았으므로 끝 부분에 두 자리 숫자가있는 MYAPPWeb이라는 이름이 지정되었습니다. MYAPPWeb01, MYAPPWeb02, 예 : 다음을 사용하여 파일을 모두 복사했습니다.
$webcred = Get-Credential -Message “Please provide credentials for the Web Servers(웹 서버에 대한 자격 증명을 제공하십시오)”
Copy-VMGuestFile -Source E:\MyApp\WarFile\MyAPP.war -Destination D:\Temp\MyApp.war -GuestToLocal -VM MYAPPServer01 -Force

ForEach($WebServer in Get-VM MYAPPWeb??) {
    Copy-VMGuestFile -Source D:\Temp\MyApp.war -Destination D:\Tomcat\webapps\MyApp.war -LocalToGuest -VM $WebServer -GuestCredential $webcred -Force
}

#endregion

##############################################################################################################################################
# ETC
##############################################################################################################################################
#region
# Create VM
$retCreateVMClone = New-VM -Name {0} -VM {1} {2} -Confirm:$False -ErrorAction Stop;
# VM OS
$rtnOSName = (Get-VM -Name $retCreateVMClone.Name | Get-View -Property @('Name', 'Config.GuestFullName', 'Guest.GuestFullName', 'Snapshot.RootSnapshotList')).Config.GuestFullName;
# VM Detail Info
$retCreateVMClone | Select @{N='NumCpu';E={$rtnCreateVMClone.NumCpu}}, @{N='CorePerSocket';E={$rtnCreateVMClone.CorePerSocket}}, @{N='MemoryMB';E={$rtnCreateVMClone.MemoryMB}}, @{N='UsedSpaceGB';E={$rtnCreateVMClone.UsedSpaceGB}}, @{N='ProvisionedSpaceGB';E={$rtnCreateVMClone.ProvisionedSpaceGB}}, @{N='PersistentId';E={$rtnCreateVMClone.PersistentId}}, @{N='Name';E={$rtnCreateVMClone.Name}}, @{N='Id';E={$rtnCreateVMClone.Id}}, @{N='Folder';E={$rtnCreateVMClone.Folder}}, @{N='FolderId';E={$rtnCreateVMClone.FolderId}}, @{N='ResourcePoolId';E={$rtnCreateVMClone.ResourcePoolId}}, @{N='ResourcePool';E={$rtnCreateVMClone.ResourcePool}}, @{N='OSName';E={$rtnOSName}}

$retCreateVMClone | Select NumCpu, CorePerSocket, MemoryMB, UsedSpaceGB, ProvisionedSpaceGB, PersistentId, Name, Id, Folder, FolderId, ResourcePoolId, ResourcePool, @{N='OSName';E={(Get-VM -Name $retCreateVMClone.Name | Get-View -Property @('Name', 'Config.GuestFullName', 'Guest.GuestFullName', 'Snapshot.RootSnapshotList')).Config.GuestFullName}}

@{N='NumCpu';E={$rtnCreateVMClone.NumCpu}}, @{N='CorePerSocket';E={$rtnCreateVMClone.CorePerSocket}}, @{N='MemoryMB';E={$rtnCreateVMClone.MemoryMB}}, @{N='UsedSpaceGB';E={$rtnCreateVMClone.UsedSpaceGB}}, @{N='ProvisionedSpaceGB';E={$rtnCreateVMClone.ProvisionedSpaceGB}}, @{N='PersistentId';E={$rtnCreateVMClone.PersistentId}}, @{N='Name';E={$rtnCreateVMClone.Name}}, @{N='Id';E={$rtnCreateVMClone.Id}}, @{N='Folder';E={$rtnCreateVMClone.Folder}}, @{N='FolderId';E={$rtnCreateVMClone.FolderId}}, @{N='ResourcePoolId';E={$rtnCreateVMClone.ResourcePoolId}}, @{N='ResourcePool';E={$rtnCreateVMClone.ResourcePool}}, @{N='OSName';E={$rtnOSName}}
#endregion