################################################################################################################################
# 목차
################################################################################################################################
#region
# >>> VisualStudion Code Folding >> https://code.visualstudio.com/docs/editor/codebasics > Search : Folding
# 01. Connection Server, vCenter Server, ViewBroker 연결
# 02. Connection Server Infomation
# 03. Enter-Session : Administraotor >> success
# 04. Import-Module & Add-PSSnapin / 모듈 다운로드
# 05. 전체 PowerCLI 가이드
# 06. 전체 Command 확인 & Port
# 07. View PowerCLI cmdlet (전체-Horizon 7.0, 7.1, 7.2)
# 08. VM Create & ETC
# 09. 데스크톱 상태확인
# 10. PowerShell 에서에 Path 빈공백 처리
# 11.
# 12. Help >> 사용법

#  | Out-GridView         #>> Grid 콘솔로 보여져 편함
# 여러줄 주석 : shift + alt + a
#endregion
################################################################################################################################
# 01. Connection Server, vCenter Server, ViewBroker 연결, Disconnect
################################################################################################################################
#region
# View Connection
Connect-HVServer -Server 192.168.101.70 -User 'namurnd\administrator' -Password 'namudev!23$'
# View Broker
Connect-ViewBroker -Name 192.168.101.70 -User administrator -Password namudev!23$ -Domain namurnd
Connect-ViewBroker -Name 192.168.101.70 -User 'namurnd\administrator' -Password 'namudev!23$' -Domain 'namurnd'
#(vCenter)
Connect-VIServer -Server 192.168.50.16 -User 'administrator@vsphere.local' -Password 'P@$$w0rd' -force
Connect-VIServer -Server 192.168.50.16 -Protocol https -User 'administrator@vsphere.local' -Password 'P@$$w0rd'
Connect-VIServer -Server 192.168.50.16 -Protocol https -User 'namurnd\administrator' -Password 'namudev!23$'

# 인증서 확인 무시 (인증서 오류 없이 vCenter에 연결) // Connect-VIServer 권한을 지닌 SSL/TLS 보안 채널에 대해 트러스트 관계를 설정할 수 없다
Set-PowerCLIConfiguration -InvalidCertificateAction ignore -confirm:$false
Set-PowerCLIConfiguration -Confirm:$false -Scope AllUsers -InvalidCertificateAction Ignore

# Disconnect
Disconnect-VIServer 192.168.50.16 -confirm:$false
Disconnect-HVServer * -Force -Confirm:$false -ErrorAction SilentlyContinue
Disconnect-VIServer * -Force -Confirm:$false -ErrorAction SilentlyContinue
#endregion
################################################################################################################################
# 02. Connection Server Infomation
################################################################################################################################
#region

$Services1 = $Global:DefaultHVServers.ExtensionData
$Services1
$hvServer1 = $Services1.ConnectionServer.ConnectionServer_List()
$hvServer1.General

<#
Name                              : NM-VDICS
ServerAddress                     : https://NM-VDICS.namurnd.io:443
Enabled                           : True
Tags                              :
ExternalURL                       : https://NM-VDICS.namurnd.io:443
ExternalPCoIPURL                  : 192.168.101.70:4172
HasPCoIPGatewaySupport            : True
HasBlastGatewaySupport            : True
AuxillaryExternalPCoIPIPv4Address :
ExternalAppblastURL               : https://NM-VDICS.namurnd.io:8443
LocalConnectionServer             : True
BypassTunnel                      : False
BypassPCoIPGateway                : True
BypassAppBlastGateway             : False
DirectHTMLABSG                    : False
Version                           : 7.10.0-14584133
IpMode                            : IPv4
FipsModeEnabled                   : False
Fqhn                              : NM-VDICS.namurnd.io
ClusterName                       : Cluster-NM-VDICS
DiscloseServicePrincipalName      : False
#>

#endregion
################################################################################################################################
# 03. PSCredential > Enter-Session : Administrator >> success
################################################################################################################################
#region

[string][ValidateNotNullOrEmpty()]$passwd = "namudev!23$"
$secpasswd = ConvertTo-SecureString -String $passwd -AsPlainText -Force
$mycreds = New-Object Management.Automation.PSCredential ("administrator@namurnd.io", $secpasswd)
#-------------------------------------------------------------------------------------------------------------------------------
Enter-PSSession -ComputerName 192.168.101.70 -Credential $mycreds
[string][ValidateNotNullOrEmpty()]$passwd = "namudev!23$";$secpasswd = ConvertTo-SecureString -String $passwd -AsPlainText -Force;$mycreds = New-Object Management.Automation.PSCredential ("administrator@namurnd.io", $secpasswd)
# [192.168.101.70]: PS C:\Users\administrator.NAMURND\Documents> Enable PSRemoting #(Error시 아래 명령 실행 TEST)
# [192.168.101.70]: PS C:\Users\administrator.NAMURND\Documents> Import-Module VMware.View.Broker
# [192.168.101.70]: PS C:\Users\administrator.NAMURND\Documents> Add-PSSnapin vmware.view.broker #(Error시 Import-Module VMware.View.Broker 필요)
# [192.168.101.70]: PS C:\Users\administrator.NAMURND\Documents> Get-ViewVC

#endregion
#===============================================================================================================================
# 지정 VM > Invoke-VMScript & 지정 Script 실행
#===============================================================================================================================
#region

[string][ValidateNotNullOrEmpty()]$passwd = "P@ssw0rd"
$secpasswd = ConvertTo-SecureString -String $passwd -AsPlainText -Force
$mycreds = New-Object Management.Automation.PSCredential ("testuser1", $secpasswd)
$script = "dir c:\"
$vm = "Win10Pro-SIP003"
Invoke-VMScript -VM $vm -ScriptText $script -GuestCredential $mycreds
Invoke-VMScript -VM $vm -ScriptText $script -GuestUser "testuser1" -GuestPassword "P@ssw0rd"

# >> Invoke-VMScript -VM Win10Pro-SIP001 -ScriptText "dir c:\" -GuestCredential $mycreds

#endregion
################################################################################################################################
# 04.Import-Module & Add-PSSnapin / 모듈 다운로드
################################################################################################################################
#region
Install-Module Vmware.PowerCLI
Import-Module Vmware.PowerCLI
# Import-Module VMware.VimAutomation.HorizonView
# Import-Module VMware.VimAutomation.Core
# 누겟 오류 설치 불가
# 1.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# 2.
Install-PackageProvider -Name NuGet
# 3.
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
#===============================================================================================================================
# 모듈 다운로드 : https://github.com/vmware/PowerCLI-Example-Scripts\
#===============================================================================================================================
# $env:PSModulePath 명령을 사용하여 Windows PowerShell 세션에서 모듈 경로를 확인하고 VMware.Hv.Helper 모듈을 해당 위치로 복사합니다.

Get-Module -ListAvailable 'VMware.Hv.Helper' | Import-Module
Get-Module -ListAvailable 'Vmware.Hv.Helper' | Import-Module Get-Command -Module 'VMware.Hv.Helper'
Get-Module -ListAvailable 'VMware.View.Broker' | Import-Module
Get-Module -ListAvailable 'Vmware.View.Broker' | Import-Module Get-Command -Module 'VMware.View.Broker'

Install-Module -Name VMware.Hv.Helper -Scope CurrentUser
#===============================================================================================================================
# Import-Module : 형식 데이터 파일을 로드하는 동안 오류가 발생했습니다.
# 파일이 디지털 서명되지 않았습니다. 현재 시스템에서 이 스크립트를 실행할 수 없습니다.
#===============================================================================================================================
Import-Module VMware.Hv.Helper
# Import-Module : 형식 데이터 파일을 로드하는 동안 오류가 발생했습니다.
<#
C:\Users\Administrator\Documents\WindowsPowerShell\Modules\VMware.Hv.Helper\VMware.HV.Helper.format.ps1xml,
C:\Users\Administrator\Documents\WindowsPowerShell\Modules\VMware.Hv.Helper\VMware.HV.Helper.format.ps1xml: 다음 유효성 검사 예외로 인해 파일을 건너뛰었습니다.
C:\Users\Administrator\Documents\WindowsPowerShell\Modules\VMware.Hv.Helper\VMware.HV.Helper.format.ps1xml 파일을 로드할 수 없습니다.
C:\Users\Administrator\Documents\WindowsPowerShell\Modules\VMware.Hv.Helper\VMware.HV.Helper.format.ps1xml 파일이 디지털 서명되지 않았습니다.
현재 시스템에서 이 스크립트를 실행할 수 없습니다. 스크립트 실행 및 실행 정책 설정에 대한 자세한 내용은 http://go.microsoft.com/fwlink/?LinkID=135170의 about_Execution_Policies를 참조하십시오...
#>

# https://nasemo.com/archives/1995
# 1. 일반 적용 : Windows + R  >>>
powershell.exe -noexit -executionpolicy unrestricted

# 2. 영구 적용(PowerShell 관리자권한) : # 엔터를 치고 Y 와 엔터 >> 이제 정책 변경에 의해 디지털 사인이 되지 않아도 실행이 됩니다
Set-ExecutionPolicy unrestricted

# 3. 현재의 실행 정책을 확인 : # 윈도우 7 의 경우 기본 상태가 restricted
Get-ExecutionPolicy

# 4. 다시 기본 상태로 :
Set-ExecutionPolicy Restricted

# 에러 발생시 해당 Line 주석(#) 처리
Install-Module Vmware.View.Broker
Add-PSSnapin Vmware.View.Broker

#endregion
################################################################################################################################
# 05. 전체 PowerCLI 가이드 : https://www.vmgu.ru/images/posters/pdf/VMware_PowerCLI_Poster_6.pdf
################################################################################################################################
#region

# 전체 Port 확인 : netstat -an
# 전체 Command 확인 : Get-Command // List of Commands
Get-Command | Where-Object {$_.name -match "get-hv"}
Get-Command -PSSnapin Vmware.view.broker | more             # Command Search

# PowerShell 설치 경로 확인
$env:PSModulePath

#endregion
################################################################################################################################
# 06. 전체 Command 확인 : Get-Command // List of Commands // 전체 Port 확인 : netstat -an
################################################################################################################################
#region

# 전체 Port 확인 : netstat -an
# 전체 Command 확인 : Get-Command // List of Commands
Get-Command | Where-Object {$_.name -match "get-hv"}
Get-Command -PSSnapin Vmware.view.broker | more             # Command Search

# PowerShell 설치 경로 확인
$env:PSModulePath

#endregion
################################################################################################################################
# 07. View PowerCLI cmdlet (전체-Horizon 7.0, 7.1, 7.2)
################################################################################################################################
#region

# 영문 : https://docs.vmware.com/en/VMware-Horizon-7/7.2/com.vmware.view.integration.doc/GUID-1FD242A9-1C3B-4864-84E5-D70A59CE3D7C.html
# 한글 : https://docs.vmware.com/kr/VMware-Horizon-7/7.2/com.vmware.view.integration.doc/GUID-1FD242A9-1C3B-4864-84E5-D70A59CE3D7C.html
# 01. View 연결 서버 인스턴스 관리                                   # 01. Managing View Connection Server Instances
# 02. View에서 vCenter Server 인스턴스 관리                          # 02. Managing vCenter Server Instances in View
# 03. 데스크톱 풀 관리                                               # 03. Managing Desktop Pools
# 04. 자동으로 프로비저닝된 데스크톱 풀 생성 및 업데이트관리            # 04. Creating and Updating Automatically Provisioned Desktop Pools
# 05. 연결된 클론 데스크톱 풀 생성 및 업데이트관리                     # 05. Creating and Updating Linked-Clone Desktop Pools
# 06. 수동으로 프로비저닝된 데스크톱 풀 생성 및 업데이트관리            # 06. Creating and Updating Manually Provisioned Desktop Pools
# 07. 관리 않는 수동 데스크톱 풀 생성 및 업데이트관리                  # 07. Creating and Updating Manual Unmanaged Desktop Pools
# 08. 사용자 및 그룹에 대한 정보 표시관리                             # 08. Displaying Information About Users and Groups
# 09. 데스크톱 권한 관리                                             # 09. Managing Desktop Entitlements
# 10. 원격 세션 관리                                                 # 10. Managing Remote Sessions
# 11. 가상 시스템 관리                                               # 11. Managing Virtual Machines
# 12. 물리적 시스템에 대한 정보 표시관리                               # 12. Displaying Information About Physical Machines
# 13. 가상 시스템 소유권 업데이트관리                                 # 13. Updating Virtual Machine Ownership
# 14. 이벤트 보고서 표시관리                                          # 14. Displaying Event Reports
# 15. 전역 설정 표시 및 업데이트관리                                  # 15. Displaying and Updating Global Settings
# 16. 라이센스 키 표시 및 추가관리                                    # 16. Displaying and Adding License Keys

#endregion
################################################################################################################################
# 08. VM Create & ETC
################################################################################################################################
# Linux 가상 시스템 생성        : >> New-VM –Name "LINUX" –DiskGB 30 –DiskStorageFormat Thick –DataStore datastore1 –MemoryGB 3
# Windows 가상 시스템 생성      : >> New-VM –Name "WINDOWS" –DiskGB 30 –DiskStorageFormat Thick –DataStore datastore1 –MemoryGB 3 -guestid windows8Server64Guest
# 사용가능 가상 시스템 List     : >> Get-Vm | Select-Object Name, NumCPU, MemoryMB, PowerState, Host
# PowerCLI 모듈을 업그레이드    : >> Update-Module VMware.PowerCLI

################################################################################################################################
# 09. 데스크톱 상태확인
# Horizon Agent상태 고급기능 >> 해당목록은 데스크톱의 사용중, 새사용자 연결 사용가능여부, 오류상태 여부 포함
################################################################################################################################
#region

# 사용자가 로그인했지만 현재 사용자와 데스크톱의 연결이 끊어진 데스크톱 목록 반환
$DisconnectedVMs = Get-HVMachineSummary -State DISCONNECTED
$DisconnectedVMs | Out-GridView         #>> Grid 콘솔로 보여져 편함
Get-HVMachineSummary | Out-GridView

#endregion
################################################################################################################################
# 10. PowerShell 에서에 Path 빈공백 처리
################################################################################################################################
#region

$MSBuild = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe"
& $MSBuild $PathToSolution /p:OutDir=$OutDirVar /t:Rebuild /p:Configuration=Release

# cd "${Env:ProgramFiles}\WindowsPowerShell\Modules"

#endregion
################################################################################################################################
# 11.
################################################################################################################################

################################################################################################################################
# 12. Help >> 사용법
################################################################################################################################
#region

Get-Help FunctionName | more
Get-Help FunctionName -full | more

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
################################################################################################################################
#  IP & DNS 변경
################################################################################################################################
#region

# $newGateWay = $newIP.Split(".")[0]+"."+$newIP.Split(".")[1]+"."+$newIP.Split(".")[2]+".1"
# $cmdIP = "netsh interface ipv4 set address name=`"Ethernet0 2`" static $newIP 255.255.255.0 $newGateWay"
# $cmdDNS1 = "netsh interface ipv4 set dns name=`"Ethernet 2`" static 8.8.8.8"
# $cmdDNS2 = "netsh interface ip add dns name=`"Ethernet 2`" 8.8.4.4 index=2"

$vm = Get-VM $hostname
$cred = Get-Credential Administrator
$cred = Get-Credential $Guestcreds

Invoke-VMScript -VM $vm -ScriptType Bat -ScriptText $cmdIP -Verbose -GuestCredential $cred
Invoke-VMScript -VM $vm -ScriptType Bat -ScriptText $cmdDNS1 -Verbose -GuestCredential $cred
Invoke-VMScript -VM $vm -ScriptType Bat -ScriptText $cmdDNS2 -Verbose -GuestCredential $cred

$newIP = "192.168.101.222"
$cmdIP = "netsh interface ip set address ""Ethernet0"" static $newIP"
Invoke-VMScript -VM $vm -ScriptType Bat -ScriptText $cmdIP -Verbose -GuestCredential $cred

#================================================== Full Sample ==================================================
[string][ValidateNotNullOrEmpty()] $passwd = 'namudev!23$'
$secpasswd = ConvertTo-SecureString -String $passwd -AsPlainText -Force
$cred = New-Object Management.Automation.PSCredential ('namurnd\administrator', $secpasswd)
$newIP = "192.168.101.249"
$VM = Get-VM -Name 'SDS-VMW-004'
$newGateWay = $newIP.Split(".")[0]+"."+$newIP.Split(".")[1]+"."+$newIP.Split(".")[2]+".1"

$cmdIP = "netsh interface ipv4 set address name='Ethernet0' static $newIP 255.255.255.0 $newGateWay"
Invoke-VMScript -VM $vm -ScriptType Bat -ScriptText $cmdIP -Verbose -GuestCredential $creds
#=================================================================================================================
#endregion
################################################################################################################################
# PowerShell MS-SQL 연결
################################################################################################################################
#region

$Server = "192.168.50.4";
$DBName = "SamsungCcms";
$Id = "NCCVDI";
$Password = "P@ssw0rd";
$Timeout = 5000;
$Conn = New-Object System.Data.SqlClient.SqlConnection
$Conn.ConnectionString = "Server=" + $Server + ";Database=" + $DBName + ";User ID=" + $Id + ";Password=" + $Password
$Conn.Open()

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $Query
$SqlCmd.Connection = $Conn
$SqlCmd.CommandTimeout = $Timeout

$SqlDataAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlDataAdapter.SelectCommand = $SqlCmd

$DataSet = New-Object System.Data.DataSet
$SqlDataAdapter.Fill( $DataSet )

Return $DataSet.Tables

#endregion
################################################################################################################################
# 기타 > 상위버전 사용 가능성 있음 > cmdlets 에 노출 안됨
################################################################################################################################
# >> Horozon 버전 7.7에서 사용되는것으로 보여짐
# Add-ManualPool, Get-ViewVC 및 Update-ManualPool cmdlet을 사용하여 수동으로 프로비저닝 된 데스크톱 풀을 만들고 업데이트 할 수 있습니다.
# 다음 예에서 Add-ManualPool cmdlet은 이름이 myVM 인 가상 시스템이 포함 된 manPool이라는 수동으로 프로비저닝 된 데스크톱 풀을 만듭니다.
Add-ManualPool -pool_id manPool -id (Get-Vm -name "myVM").id -isUserResetAllowed $true

# 다음 예에서 Get-ViewVC cmdlet은 vc.mydom.int라는 vCenter Server 인스턴스가 관리하는 데스크톱에서 man1이라는 수동으로 프로비저닝 된 데스크톱 풀을 생성합니다.
Get-ViewVC -serverName vc.mydom.int | Get-DesktopVM -poolType Manual | Add-ManualPool -pool_id man1 -isUserResetAllowed $false

# 다음 예에서 Update-ManualPool cmdlet은 man1이라는 수동으로 프로비저닝 된 데스크톱 풀의 구성을 업데이트합니다.
Update-ManualPool -pool_id man1 -displayName "Manual Desktop 1" -isUserResetAllowed $true

#==============================================================================================================================
# https://docs.vmware.com/kr/VMware-Horizon-7/7.0/com.vmware.view.integration.doc/GUID-2E8E6344-7EB8-44D2-B58A-4B7545000716.html
# 연결 브로커 이벤트는 데스크톱 및 애플리케이션 세션, 사용자 인증 실패 및 프로비저닝 오류와 같은 View 연결 서버 관련 정보를 보고합니다
# >> https://github.com/9whirls/VMware.View.Broker
# C:\Program Files\WindowsPowerShell\Modules 해당경로에 VMware.View.Broker.psm1 and VMware.View.Broker.psd1 into the new folder
# run the command below to load this module
>> Import-Module VMware.View.Broker

>> Add-ViewVC : 'Add-ViewVC' 명령이 'VMware.View.Broker' 모듈에 있지만 모듈을 로드할 수 없습니다. 자세한 내용을 보려면 'Import-Module VMware.View.Broker'을(를) 실행하십시오
>> 이 문제를 해결하려면 View Connection Server 업데이트 중에 설치된 새 PowershellServiceCmdlets.dll 파일을 Windows PowerShell에 등록해야합니다.
>> 파일을 등록하려면 새 Windows PowerShell 프롬프트를 열고 다음 스크립트를 실행하십시오.
>> “C:\Program Files\VMware\VMware View\Server\Extras\PowerShell\add-snapin.ps1”
>> “${Env:ProgramFiles}\VMware\${Env:VMwareView}\Server\Extras\PowerShell\add-snapin.ps1”
Import-Module -Name ${Env:ProgramFiles}\WindowsPowerShell\Modules\VMware.View.Broker -Verbose

#==============================================================================================================================
# 특정 View Connection Server 인스턴스에 대한 구성 설정 가져 오기
Get-ConnectionBroker -broker_id CONNSVR1
#==============================================================================================================================
# 특정 View Connection Server 인스턴스에 대한 구성 설정 업데이트
Update-ConnectionBroker -broker_id CONNSVR1 -directConnect $false -secureIdEnabled $true -ldapBackupFrequency EveryWeek
#==============================================================================================================================
# 특정 View Connection Server 인스턴스에 대한 보안 PCoIP 연결 구성
Update-ConnectionBroker -broker_id CS-VSG -directPCoIP $FALSE
#==============================================================================================================================
# 특정 View Connection Server 인스턴스에 대한 PCoIP 외부 URL 설정
Update-ConnectionBroker -broker_id CS-VSG -externalPCoIPURL 10.18.133.34:4172
#==============================================================================================================================
# 특정 보안 서버에 대한 PCoIP 외부 URL 설정
Update-ConnectionBroker -broker_id SECSVR-03 -externalPCoIPURL 10.116.32.136:4172
#==============================================================================================================================



################################################################################################################################
#
################################################################################################################################

################################################################################################################################
#
################################################################################################################################

################################################################################################################################
#
################################################################################################################################

################################################################################################################################
#
################################################################################################################################