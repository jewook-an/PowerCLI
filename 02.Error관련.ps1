###################################################################################################################
<#
## Windows PowerShell 2.0 설치 (서버)
1. 제어판 > 프로그램 및 기능
2. 역할 및 기능추가
3. 기능 : Windows PowerShell 2.0 엔진 설치

## WinRM (Windows 원격 관리 - Remote Management) 사용 정리
https://gist.github.com/aJchemist/5ae3b87add56d39a5b051d860b8bc781
https://docs.vmware.com/kr/VMware-vRealize-Operations-for-Published-Applications/6.5/com.vmware.v4pa.admin_install/GUID-D95FBEC0-0A77-4A91-B146-DD82A9C9F697.html
#>
PS > Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
PS > Dism /online /Enable-Feature /FeatureName:"MicrosoftWindowsPowerShellV2" -All

###################################################################################################################
# 네트워크 연결 형식 에러 : 연결타입 변경
Set-NetConnectionProfile -NetworkCategory Private

################################################################################################################################
# Getting Started with PowerCLI: Setup and Configuration (https://petri.com/vsphere-powercli-setup-configuration)
# Getting Started with PowerCLI: Start and Shutdown Virtual Machines (https://petri.com/vsphere-powercli-start-shutdown-vm)

# PowerCLI 10을 사용하는 경우 더 이상 PSSnapin이 없습니다. / Add-PSSnapin 줄이 포함 된 스크립트가 여전히 있으면 해당 줄을 스크립트에서 제거.

# PowerShell 3 이상인 경우 이러한 모듈이 $env : PSModulePath에 나열된 폴더 중 하나에 설치되어 있으면 더 이상 모듈을 명시 적으로 가져올 필요가 없습니다.

# 아담 Database Setting : https://www.vgyan.in/delete-linked-clone-virtual-machines-manually/

# Horizon에서 문제있는 데스크톱, 수동풀 제거 : https://kb.vmware.com/s/article/2015112
################################################################################################################################
# Connection Server Setting backup data path
C:\ProgramData\VMware\VDM\backups
#--------------------------------------------------------------
# Windows 내 PowerShell Module Path :
C:\Windows\System32\WindowsPowerShell\v1.0\Modules
#--------------------------------------------------------------
# 사용자 Module Path ( vCenter 내부에는 Module 없음 ) :
C:\Users\administrator.NAMURND\Documents\WindowsPowerShell\Modules
#--------------------------------------------------------------
# 관리자 모드 > View PowerCLI  :
C:\Program Files\VMware\VMware View\Server\bin
#--------------------------------------------------------------
################################################################################################################################
# Horizon View 7.5: 강제 삭제 >> Delete Linked Clone Virtual Machines Manually Part-17
################################################################################################################################
################################################################################################################################
# Adam DB Setting
# Error Message :
# Desktop Composer Fault: Virtual Machine with Input Specification already exists
# Virtual machine with Input Specification already exists
################################################################################################################################
# 1. Remove the virtual machines from the ADAM Database on the connection server.
# 2. Remove desktop references within the View Composer database.
# 3. Remove affected computer objects from Active Directory.
# 4. Remove the desktops from vCenter Server.
################################################################################################################################
# 작업 Process
# 1. View Administrator 콘솔에 로그인하고 프로비저닝을 비활성화 (Desktop Pool > Summary > Click on Status > Select Disable Provisioning)
# 2. BackUp Adam Database : Under Connection Servers > Select your connection server and hit on Backup now.
#    >> backup repository 확인 >> "C:\ProgramData\VMware\VDM\backups" folder. (LDF, SVI 파일 포맷)
# 3. Connection Server 도메인계정으로 Login : 제어판 > 관리도구 > ADSI 편집 > 마우스 오른버튼 > 연결대상
# 연결 설정
#     - 이름 : View ADAM Database
#     - 경로(연결지점, 컴퓨터 입력시 자동 Setting) : LDAP://localhost:389/dc=vdi,dc=vmware,dc=int
#     - 연결지점 > 고유이름 또는 명명 컨텍스트 선택, 입력 : dc=vdi,dc=vmware,dc=int
#     - 컴퓨터 > 도메인 또는 서버를 선택하거나 입력 합니다. (서버 | 도메인 [:포트]) : localhost:389
# 4. 생성된 > View ADAM Database > 오른버튼 > 새로만들기 > 새쿼리
#     - 이름 : VM Search / 검색루트 ( 찾아보기 > Servers 선택 ) / Query String >> (&(objectClass=pae-VM)(pae-displayname=VM이름))
# 5. AD Server 접근 > 해당 Domain > 찾기 > 컴퓨터 > VM Name > 삭제

# composer 데이터베이스에서 vm 항목을 제거하기 위해 Sviconfig RemoveSviClone 명령을 사용하고 있습니다.
# 1. View Composer 데이터베이스에서 연결된 클론 데이터베이스 항목.
# 2. Active Directory의 연결된 클론 컴퓨터 계정
# 3. vCenter Server에서 연결된 클론 가상 시스템.
#   - 32-bit servers: Install_drive\Program Files\VMware\VMware View Composer
#   - 64-bit servers: Install_drive\Program Files (x86)\VMware\VMware View Composer

################################################################################################################################
# 연결된 클론 데이터를 제거하기 전에 View Composer 서비스가 실행 중인지 확인, View Composer 시스템에서 SviConfig RemoveSviClone 명령 실행
################################################################################################################################
>> C:\Program Files <x86>\VMware\VMware View Composer
>> SviConfig -operation=RemoveSviClone -VmName=VMname -AdminUser=TheLocalAdminUser -AdminPassword=TheLocalAdminPassword -ServerUrl=TheViewComposerServerURL

SviConfig -operation=RemoveSviClone -VmName=Win10Pro-ID001 -AdminUser=namurnd\administrator -AdminPassword=namudev!23$ -ServerUrl=https://localhost:18443/SviService/v3_5
SviConfig -operation=RemoveSviClone -VmName=Win10Pro-ID002 -AdminUser=namurnd\administrator -AdminPassword=namudev!23$ -ServerUrl=https://localhost:18443/SviService/v3_5
SviConfig -operation=RemoveSviClone -VmName=Win10Pro-ID003 -AdminUser=namurnd\administrator -AdminPassword=namudev!23$ -ServerUrl=https://localhost:18443/SviService/v3_5
SviConfig -operation=RemoveSviClone -VmName=Win10Pro-ID004 -AdminUser=namurnd\administrator -AdminPassword=namudev!23$ -ServerUrl=https://localhost:18443/SviService/v3_5
SviConfig -operation=RemoveSviClone -VmName=Win10Pro-ID005 -AdminUser=namurnd\administrator -AdminPassword=namudev!23$ -ServerUrl=https://localhost:18443/SviService/v3_5
################################################################################################################################
# 1. VmName은 제거 할 가상 머신의 이름입니다.
# 2. LocalAdminUser는 로컬 관리자 그룹의 일부인 사용자의 이름입니다. 기본값은 관리자입니다.
# 3. LocalAdminPassword는 View Composer 서버에 연결하는 데 사용되는 관리자의 비밀번호입니다.
# 4. ViewComposerServerUrl은 View Composer 서버 URL입니다. VMware View Manager 6.0의 ViewComposerServerUrl은 View Composer 서버 URL입니다. 기본값은 https://localhost:18443/SviService/v3_5
################################################################################################################################
# >> 관리자 권한으로 명령 프롬프트를 열고 viConfig RemoveSviClone 명령을 실행하십시오.
# >> 다음과 유사한 출력을 볼 수 있습니다.
#
#     클론 ID를 가져옵니다.
#     연결된 클론을 제거합니다.
#     RemoveSviClone 작업이 성공적으로 완료되었습니다.
#     명령 프롬프트를 닫습니다.
################################################################################################################################

###################################################################################################################
# TrustedHosts 처리
#------------------------------------------------------------------------------------------------------------------
# TrustedHosts 목록 보기
# >> 오류메시지 : HTTPS 전송을 사용하거 나 대상 컴퓨터를 TrustedHosts 구성 설정에 추가해야 합니다
Get-Item wsman:\localhost\Client\TrustedHosts
#------------------------------------------------------------------------------------------------------------------
# TrustedHosts에 모든 컴퓨터를 추가
Set-Item wsman:\localhost\Client\TrustedHosts -value *
#------------------------------------------------------------------------------------------------------------------
# TrustedHosts에 특정 도메인/IP 컴퓨터를 추가
Set-Item wsman:\localhost\Client\TrustedHosts test.domain.com
Set-Item wsman:\localhost\Client\TrustedHosts *.domain.com
Set-Item wsman:\localhost\Client\TrustedHosts -value 1.1.1.1
#------------------------------------------------------------------------------------------------------------------
# 기존 TrustedHosts에 추가
$curValue = (Get-Item wsman:\localhost\Client\TrustedHosts).value
Set-Item wsman:\localhost\Client\TrustedHosts -value "$curValue, test.domain.com"
###################################################################################################################

###################################################################################################################
# Install-Module 실행 불가
# Windwos Server 2012R2 >> .NetFramework 5 설치 필요
https://www.microsoft.com/en-us/download/details.aspx?id=54616
파일 5개 중 1 실행 >> Win8.1AndW2K12R2-KB3191564-x64.msu
###################################################################################################################
# vmware.view.broker 스냅인 처리
1. 반드시 VMware View PowerCLI 프로그램 실행 (안될땐 Broker Server Link)
2. Add-PSSnapin
###################################################################################################################