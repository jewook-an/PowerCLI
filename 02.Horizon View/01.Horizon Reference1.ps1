###################################################################################################################
# Horizon View (Connection Server) - 시스템 정보 : 인벤토리 > 리소스 > 시스템
#  | Out-GridView         #>> Grid 콘솔로 보여져 편함
# 여러줄 주석 : shift + alt + a
# 1줄 복제 > Shift + Alt + 상하 방향키
###################################################################################################################
# 01. Get-HVMachineSummary
# 02. Connect-ViewBroker
# 03. 도메인가입
# 04. IP, DNS Setting
# 05. VM 내부로 File Copy
# 06. 유지보수모드
# 07. 사용자 할당
# 08. RESET VM
# 09. Get-HVPool / Set-HVPool / New-HVPool

# 09. ETC (Connection Server Session 연결후 broker 모듈을 통한 관리)
# >> Basic Reference : 03. Enter-Session : Administraotor >> success 연결후 처리

    # Add-ManualPool, Get-ViewVC, Update-ManualPool
    # 특정 View Connection Server 인스턴스에 대한 구성 설정 가져 오기
    # 특정 View Connection Server 인스턴스에 대한 구성 설정 업데이트
    # 특정 View Connection Server 인스턴스에 대한 보안 PCoIP 연결 구성
    # 특정 View Connection Server 인스턴스에 대한 PCoIP 외부 URL 설정
    # 특정 보안 서버에 대한 PCoIP 외부 URL 설정

###################################################################################################################

###################################################################################################################
# 01. Get-HVMachineSummary
###################################################################################################################
#region

# Sort 1 >> int (Ascending >> Empty)
Get-HVMachineSummary | Sort-Object -Property Machine -Descending
# Sort 2 >> TEXT
Get-HVMachineSummary | Sort-Object -Property @{Expression = "Machine"; Descending = $True}, @{Expression = "DesktopPool"; Descending = $False}
Get-HVMachineSummary | Sort-Object -Property @{Expression = {$_.Machine}; Descending = $True}, @{Expression = "DesktopPool"; Descending = $False}
# Get-ChildItem -Path C:\Test\*.txt | Sort-Object -Property @{Expression = {$_.CreationTime - $_.LastWriteTime}; Descending = $False} | Format-Table CreationTime, LastWriteTime, FullName

# Horizon Agent상태 고급기능 >> 데스크톱 상태확인 : 해당목록은 데스크톱의 사용중, 새사용자 연결 사용가능여부, 오류상태 여부 포함
# 사용자가 로그인했지만 현재 사용자와 데스크톱의 연결이 끊어진 데스크톱 목록 반환
$DisconnectedVMs = Get-HVMachineSummary -State DISCONNECTED
$DisconnectedVMs | Out-GridView         #>> Grid 콘솔로 보여져 편함
Get-HVMachineSummary | Out-GridView

#endregion
###################################################################################################################
# 02. Connect-ViewBroker
###################################################################################################################
#region
Connect-ViewBroker -name 192.168.101.70 -user administrator -password namudev!23$ -domain namurnd
<# CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Add-ViewVC                                         1.0        VMware.View.Broker
Function        Connect-ViewBroker                                 1.0        VMware.View.Broker
Function        Get-ViewApplication                                1.0        VMware.View.Broker
Function        Get-ViewDesktop                                    1.0        VMware.View.Broker
Function        Get-ViewFarm                                       1.0        VMware.View.Broker
Function        Get-ViewLicense                                    1.0        VMware.View.Broker
Function        Get-ViewMachine                                    1.0        VMware.View.Broker
Function        Get-ViewRDSServer                                  1.0        VMware.View.Broker
Function        Get-ViewSession                                    1.0        VMware.View.Broker
Function        Get-ViewVC                                         1.0        VMware.View.Broker
Function        Get-ViewVCVM                                       1.0        VMware.View.Broker
Function        Remove-ViewVC                                      1.0        VMware.View.Broker
Function        Set-ViewLicense                                    1.0        VMware.View.Broker
Function        Set-ViewSession                                    1.0        VMware.View.Broker #>
#endregion
###################################################################################################################
# 06. 유지보수모드
###################################################################################################################
#region
Get-HVMachine -MachineName 'Win10Pro-SIP001' | Set-HVMachine -Maintenance ENTER_MAINTENANCE_MODE        #>> 유지보수모드
Get-HVMachine -MachineName 'Win10Pro-SIP001' | Set-HVMachine -Maintenance EXIT_MAINTENANCE_MODE         #>> 유지보수모드 해제
#endregion
###################################################################################################################
# 07. 사용자 할당
###################################################################################################################
#region

#------------------------------------------------------------------------------------------------------------------
Set-HVMachine -MachineName 'Win10Pro-SIP001' -User 'namurnd\viewuser3'      # 차선책 >> (사용자 할당해제 X >> 타인을 할당 or Reset, Delete > Remove-HVMachine)

#------------------------------------------------------------------------------------------------------------------
# 사용자 할당 제거 (https://www.retouw.nl/powercli/remove-desktop-assignment/)
$hvserver1 = connect-hvserver connectionservername
$hvserver1 = connect-hvserver 192.168.101.70
$hvserver1 = Connect-HVServer -Server 192.168.101.70 -User 'namurnd\administrator' -Password 'namudev!23$'

$services1 = $hvserver1.extensiondata
$machinename = "MACHINENAME"
$machinename = "Win10Pro-SIP001"

$machineid = (get-hvmachine -machinename $machinename).id
$machineservice = new-object vmware.hv.machineservice
$machineinfohelper = $machineservice.read($services1, $machineid)
$machineinfohelper.getbasehelper().setuser($null)
$machineservice.update($services1, $machineinfohelper)

# 아래 명령은 오류 였던듯.
Set-HVMachine -MachineName 'Win10Pro-SIP001' -User $null

#endregion
###################################################################################################################
# 08. RESET VM
###################################################################################################################
#region

#------------------------------------------------------------------------------------------------------------------
$queryservice = new-object VMware.Hv.QueryServiceService
$defn = New-Object VMware.Hv.QueryDefinition
$defn.QueryEntityType = "MachineNamesView"
$filter = new-object VMware.Hv.QueryFilterContains
$filter.MemberName = 'base.name'
$filter.Value = "Pod1Pool2"
$defn.filter = $filter
$results = ($queryservice.QueryService_Query($services1, $defn)).results

$singlevm = $results | select-object -first 1
$multiplevms = $results

$services1.machine.machine_reset($singlevm.id)
$services1.Machine.Machine_ResetMachines($multiplevms.id)

#endregion
###################################################################################################################
# 09. Get-HVPool / Set-HVPool / New-HVPool
# 풀 수정 방법 :
# https://philchapman.us/2019/12/02/horizon-powercli-modify-existing-pool-settings/
# https://github.com/vmware/PowerCLI-Example-Scripts/issues/83
# 해당 파일 참조 >> C:\Program Files\WindowsPowerShell\Modules\VMware.Hv.Helper\VMware.HV.Helper.psm1
###################################################################################################################
#region
Get-HVPool -PoolName 'Test' | New-HVPool -PoolName $name -NamingPattern "$short-{n:fixed=3}"
Set-HVPool  -PoolName $name -Disable
Set-HVPool  -PoolName $name -key 'automatedDesktopData.vmNamingSettings.patternNamingSettings.maxNumberOfMachines' -value $maxvdi
Set-HVPool  -PoolName $name -key 'automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterProvisioningData.resourcePool' -value $short

$pool = Get-HVPool -PoolName 'Win10Pro-StaticIP'
# Parent VM Path
$pool.AutomatedDesktopData.VirtualCenterNamesData.ParentVmPath
# SnapShot Path
$pool.AutomatedDesktopData.VirtualCenterNamesData.SnapshotPath
# ParentVM Name
$pool.AutomatedDesktopData.VirtualCenterNamesData.ParentVmPath.substring(($pool.AutomatedDesktopData.VirtualCenterNamesData.ParentVmPath.LastIndexOf("/")+1))
# SnapShot Name
$pool.AutomatedDesktopData.VirtualCenterNamesData.SnapshotPath.substring(($pool.AutomatedDesktopData.VirtualCenterNamesData.SnapshotPath.LastIndexOf("/")+1))
#endregion
###################################################################################################################
# 09. ETC (Connection Server Session 연결후 broker 모듈을 통한 관리)
# >> Basic Reference : 03. Enter-Session : Administraotor >> success 연결후 처리
# 1. Connection Server : Enter-PSSession 접근
# 2. Add-PSSnapin vmware.view.broker (없을땐 Import)
###################################################################################################################
#region
#------------------------------------------------------------------------------------------------------------------
# VM 사용자 지정 >> 해당 VM에 권한여부 파악 > 지정할 User Check (타VM에 기 Assign되어 있는지..)
#------------------------------------------------------------------------------------------------------------------
Update-UserOwnership -machine_id (Get-DesktopVM -Name "vm04").machine_id -sid (Get-User -name usr1).sid
Update-UserOwnership -machine_id (Get-DesktopVM -Name "vm04").machine_id -sid (Get-User -name usr1).sid

# namurnd.io\viewuser1
# (Get-User -name "뷰사용자1").sid
# (Get-DesktopVM -Name "Win10Pro-SIP003").machine_id
Update-UserOwnership -machine_id (Get-DesktopVM -Name "Win10Pro-SIP003").machine_id -sid (Get-User -name "뷰사용자3").sid
#------------------------------------------------------------------------------------------------------------------
# VM 재구성 (Recompose)  : 머신 재구성은 상위 가상 머신에 고정 된 모든 연결된 클론 가상 머신을 동시에 업데이트 한다
#------------------------------------------------------------------------------------------------------------------
Get-DesktopVM -Name ""{0}"" | Send-LinkedCloneRecompose -schedule ""{1}"" -parentVMPath ""{2}"" -parentSnapshotPath ""{3}"" -forceLogoff $true -stopOnError $true -ErrorAction Stop

#------------------------------------------------------------------------------------------------------------------
# Add-ManualPool, Get-ViewVC 및 Update-ManualPool cmdlet을 사용하여 수동으로 프로비저닝 된 데스크톱 풀을 만들고 업데이트 할 수 있습니다.
# 다음 예에서 Add-ManualPool cmdlet은 이름이 myVM 인 가상 시스템이 포함 된 manPool이라는 수동으로 프로비저닝 된 데스크톱 풀을 만듭니다.
Add-ManualPool -pool_id manPool -id (Get-Vm -name "myVM").id -isUserResetAllowed $true

# 다음 예에서 Get-ViewVC cmdlet은 vc.mydom.int라는 vCenter Server 인스턴스가 관리하는 데스크톱에서 man1이라는 수동으로 프로비저닝 된 데스크톱 풀을 생성합니다.
Get-ViewVC -serverName vc.mydom.int | Get-DesktopVM -poolType Manual | Add-ManualPool -pool_id man1 -isUserResetAllowed $false

# 다음 예에서 Update-ManualPool cmdlet은 man1이라는 수동으로 프로비저닝 된 데스크톱 풀의 구성을 업데이트합니다.
Update-ManualPool -pool_id man1 -displayName "Manual Desktop 1" -isUserResetAllowed $true

#endregion
###################################################################################################################
#region Import-Module VMware.View.Broker

# https://docs.vmware.com/kr/VMware-Horizon-7/7.0/com.vmware.view.integration.doc/GUID-2E8E6344-7EB8-44D2-B58A-4B7545000716.html
# 연결 브로커 이벤트는 데스크톱 및 애플리케이션 세션, 사용자 인증 실패 및 프로비저닝 오류와 같은 View 연결 서버 관련 정보를 보고합니다
# >> https://github.com/9whirls/VMware.View.Broker
# C:\Program Files\WindowsPowerShell\Modules 해당경로에 VMware.View.Broker.psm1 and VMware.View.Broker.psd1 into the new folder
# run the command below to load this module
Import-Module VMware.View.Broker
###################################################################################################################
# >> Add-ViewVC : 'Add-ViewVC' 명령이 'VMware.View.Broker' 모듈에 있지만 모듈을 로드할 수 없습니다.
# >> 자세한 내용을 보려면 'Import-Module VMware.View.Broker'을(를) 실행하십시오

# >> 이 문제를 해결하려면 View Connection Server 업데이트 중에 설치된 새 PowershellServiceCmdlets.dll 파일을 Windows PowerShell에 등록해야합니다.
# >> 파일을 등록하려면 새 Windows PowerShell 프롬프트를 열고 다음 스크립트를 실행하십시오.
# >> “C:\Program Files\VMware\VMware View\Server\Extras\PowerShell\add-snapin.ps1”
# >> “${Env:ProgramFiles}\VMware\${Env:VMwareView}\Server\Extras\PowerShell\add-snapin.ps1”
Import-Module -Name ${Env:ProgramFiles}\WindowsPowerShell\Modules\VMware.View.Broker -Verbose
###################################################################################################################

# 특정 View Connection Server 인스턴스에 대한 구성 설정 가져 오기
Get-ConnectionBroker -broker_id CONNSVR1 #broker_id 필수값 아님
###################################################################################################################
# 특정 View Connection Server 인스턴스에 대한 구성 설정 업데이트
Update-ConnectionBroker -broker_id CONNSVR1 -directConnect $false -secureIdEnabled $true -ldapBackupFrequency EveryWeek
###################################################################################################################
# 특정 View Connection Server 인스턴스에 대한 보안 PCoIP 연결 구성
Update-ConnectionBroker -broker_id CS-VSG -directPCoIP $FALSE
###################################################################################################################
# 특정 View Connection Server 인스턴스에 대한 PCoIP 외부 URL 설정
Update-ConnectionBroker -broker_id CS-VSG -externalPCoIPURL 10.18.133.34:4172
###################################################################################################################
# 특정 보안 서버에 대한 PCoIP 외부 URL 설정
Update-ConnectionBroker -broker_id SECSVR-03 -externalPCoIPURL 10.116.32.136:4172
#endregion
###################################################################################################################
#------------------------------------------------------------------------------------------------------------------
###################################################################################################################
# New-HVPool
###################################################################################################################
#region

PS C:\WINDOWS\system32> New-HVPool -FullClone
cmdlet New-HVPool(명령 파이프라인 위치 1)
다음 매개 변수에 대한 값을 제공하십시오.
PoolName: TESTAAA
UserAssignment: DEDICATED
Template: Windows10Pro-x64-Template
VmFolder: Provisioning
HostOrCluster: NM_VMWC
ResourcePool: /Datacenter/host/NM_VMWC/Resources
Datastores[0]: /Datacenter/host/NM_VMWC/DataStore15
Datastores[1]:
NamingMethod: PATTERN
CustType: none

New-HVPool -FullClone -PoolName "FullClone1" -PoolDisplayName "FullClone1Display" -Description "FullClone1DisplayDescription" -UserAssignment DEDICATED -Template 'Windows10Pro-x64-Template' -VmFolder 'Provisioning' -HostOrCluster 'NM_VMWC' -ResourcePool '/Datacenter/host/NM_VMWC/Resources'  -Datastores '/Datacenter/host/NM_VMWC/DataStore15' -NamingMethod PATTERN -NamingPattern 'FullClone{n:fixed=1}' -CustType NONE

#endregion
###################################################################################################################
# PS C:\WINDOWS\system32> Get-Command | where {$_.name -match "hvpool"}
#
# CommandType     Name                                               Version    Source
# -----------     ----                                               -------    ------
# Function        Get-HVPool                                         1.3.1      VMware.Hv.Helper
# Function        Get-HVPoolSpec                                     1.3.1      VMware.Hv.Helper
# Function        Get-HVPoolSummary                                  1.3.1      VMware.Hv.Helper
# Function        New-HVPool                                         1.3.1      VMware.Hv.Helper
# Function        Remove-HVPool                                      1.3.1      VMware.Hv.Helper
# Function        Set-HVPool                                         1.3.1      VMware.Hv.Helper
# Function        Start-HVPool                                       1.3.1      VMware.Hv.Helper
###################################################################################################################
#region

# 수동풀(Manual - vCenter내 VM)
New-HVPool -MANUAL -PoolName 'manualVMWare' -PoolDisplayName 'MNLPUL' -Description 'Manual pool creation' -UserAssignment FLOATING -Source VIRTUAL_CENTER -VM 'PowerCLIVM1', 'PowerCLIVM2'
# 수동풀(Manual - vCenter내 VM 아닐때)
New-HVPool -MANUAL -PoolName 'unmangedVMWare' -PoolDisplayName 'unMngPl' -Description 'unmanaged Manual Pool creation' -UserAssignment FLOATING -Source UNMANAGED -VM 'myphysicalmachine.vmware.com'
# 인스턴트클론 (자동 - NamingPattern)
New-HVPool -InstantClone -PoolName "InsPoolvmware" -PoolDisplayName "insPool" -Description "create instant pool" -UserAssignment FLOATING -ParentVM 'Agent_vmware' -SnapshotVM 'kb-hotfix' -VmFolder 'vmware' -HostOrCluster  'CS-1' -ResourcePool 'CS-1' -NamingMethod PATTERN -Datastores 'datastore1' -NamingPattern "inspool2" -NetBiosName 'adviewdev' -DomainAdmin root
# 풀 복제
Get-HVPool -PoolName 'vmwarepool' | New-HVPool -PoolName 'clonedPool' -NamingPattern 'clonelnk1';
$vmwarepool = Get-HVPool -PoolName 'vmwarepool';  New-HVPool -ClonePool $vmwarepool -PoolName 'clonedPool' -NamingPattern 'clonelnk1';

$Services1 = $Global:DefaultHVServers.ExtensionData
$Services1
$hvServer1 = $Services1.ConnectionServer.ConnectionServer_List()
$hvServer1.General

# Powershell param 형식 Error : 사용 난해.
$Services1.Desktop.Desktop_AddMachinesToManualDesktop((get-hvpool -poolname ManualClone1).id, (Get-VM -Name TEST001).Id);
# https://www.retouw.nl/2018/01/11/adding-manual-desktops-in-horizon-view-and-assigning-them-using-powercli/
>> Add-HVDesktop -PoolName 'ManualClone1' -Machines 'TEST001' -Confirm:$false
# VM 제거
$services1.desktop.Desktop_RemoveMachineFromManualDesktop((get-hvpool -poolname ManualClone1).id, (get-hvmachine -machinename TEST001).id)

# Full Clone Example
{try {New-HVPool -FullClone -PoolName "FullCloneTEST" -PoolDisplayName "PoolDisplayName" -Description "Description" -UserAssignment DEDICATED -Template "Windows10Pro-x64" -VmFolder "/Datacenter/vm/TestVM" -HostOrCluster "/Datacenter/host/NM_VMWC" -ResourcePool "/Datacenter/host/NM_VMWC/Resources" -Datastores "'DataStore15' ,'DataStore16'" -NamingMethod "PATTERN" -NamingPattern "FCTest{n:fixed=4}"  -SysPrepName "" -CustType "QUICK_PREP" -NetBiosName "NAMURND" -DomainAdmin "administrator" -ErrorAction Stop}catch{$retFullClonePool.ErrorDescription=$_.Exception.Message}}

#endregion
###################################################################################################################
# 사용자 / 그룹을 리소스와 연결
###################################################################################################################
#region

# 사용자 / 그룹을 풀과 연결
New-HVEntitlement  -User 'administrator@adviewdev.eng.vmware.com' -ResourceName 'InsClnPol' -Confirm:$false
# 사용자 / 그룹을 응용 프로그램과 연결
New-HVEntitlement  -User 'adviewdev\administrator' -ResourceName 'Calculator' -ResourceType Application
# 사용자 / 그룹을 URLRedirection 설정과 연결
New-HVEntitlement  -User 'adviewdev.eng.vmware.com\administrator' -ResourceName 'UrlSetting1' -ResourceType URLRedirection
# 사용자 / 그룹을 데스크톱 권한과 연결
New-HVEntitlement  -User 'adviewdev.eng.vmware.com\administrator' -ResourceName 'GE1' -ResourceType GlobalEntitlement
# 사용자 / 그룹을 응용 프로그램 권한과 연결
New-HVEntitlement  -User 'adviewdev\administrator' -ResourceName 'GEAPP1' -ResourceType GlobalApplicationEntitlement
# 사용자 / 그룹을 풀 목록과 연결
$pools = Get-HVPool; $pools | New-HVEntitlement  -User 'adviewdev\administrator' -Confirm:$false

New-HVEntitlement  -User 'namurnd.io\ViewUserGroup' -ResourceName 'AutoFullClone' -Type Group -Confirm:$false

#endregion
###################################################################################################################
# Get-HVEntitlement : 사용자 권한 확인
###################################################################################################################
#region example
# -ResourceName <String>
# The resource(Application, Desktop etc.) name.
# 리소스 유형이 데스크탑 인 경우 와일드 카드 문자 '*'만 지원 (Supports only wildcard character '*' when resource type is desktop.)

# 응용 프로그램 풀과 관련된 모든 권한을 가져온다
Get-HVEntitlement -ResourceType Application
# 사용자, 그룹 이름 및 응용 프로그램 리소스와 관련된 권한을 가져온다.
Get-HVEntitlement -User 'adviewdev.eng.vmware.com\administrator' -ResourceName 'calculator' -ResourceType Application
# 사용자, 그룹 및 URLRedirection 리소스에 특정한 권한을 가져온다.
Get-HVEntitlement -User 'adviewdev.eng.vmware.com\administrator' -ResourceName 'UrlSetting1' -ResourceType URLRedirection
# 사용자, 그룹 및 GlobalEntitlement 리소스에 특정한 권한을 가져온다.
Get-HVEntitlement -User 'administrator@adviewdev.eng.vmware.com' -ResourceName 'GE1' -ResourceType GlobalEntitlement
# Pool Assign Information
(Get-HVEntitlement -ResourceName 'Win10-Link' -User jewook@namurnd.io).base | Select Sid, Group, LoginName, Name, DisplayName, UserPrincipalName
#endregion
###################################################################################################################

###################################################################################################################
#region

#endregion