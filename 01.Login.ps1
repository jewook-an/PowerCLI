#===============================================================================================================================
# Connection Server, vCenter Server, ViewBroker 연결
#===============================================================================================================================

Connect-HVServer -Server 192.168.101.70 -User 'namurnd\administrator' -Password 'namudev!23$'               #(View Connection)

Connect-VIServer -Server 192.168.50.16 -User 'administrator@vsphere.local' -Password 'P@$$w0rd' -force      #(vCenter)

Connect-ViewBroker -Name 192.168.101.70 -User administrator -Password namudev!23$ -Domain namurnd

Connect-ViewBroker -Name 192.168.101.70 -User 'namurnd\administrator' -Password 'namudev!23$' -Domain 'namurnd'

#===============================================================================================================================
# ERROR  >> Connect-HVServer : '192.168.101.70' 권한을 가진 SSL/TLS에 대한 보안 채널을 설정할 수 없습니다.
#===============================================================================================================================

Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $true
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

#===============================================================================================================================
# Connection Server Infomation
#===============================================================================================================================
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

################################################################################################################################
# Administraotor >> success
[string][ValidateNotNullOrEmpty()]$passwd = "namudev!23$"
$secpasswd = ConvertTo-SecureString -String $passwd -AsPlainText -Force
$mycreds = New-Object Management.Automation.PSCredential ("administrator@namurnd.io", $secpasswd)
PS C:\Windows\system32> Enter-PSSession -ComputerName 192.168.101.70 -Credential $mycreds
[192.168.101.70]: PS C:\Users\administrator.NAMURND\Documents> Enable PSRemoting #(Error시 아래 명령 실행 TEST)
[192.168.101.70]: PS C:\Users\administrator.NAMURND\Documents> Add-PSSnapin vmware.view.broker
[192.168.101.70]: PS C:\Users\administrator.NAMURND\Documents> Get-ViewVC

#===============================================================================================================================
# vCenter Server Infomation
#===============================================================================================================================
<#
# vc                      : 0
# vc_id                   : 0dc294e1-47dc-4ca9-90d9-bdb9e8242194
# description             :
# serverName              : 192.168.50.16
# serverUrl               : https://192.168.50.16:443/sdk
# port                    : 443
# username                : administrator@namurnd.io
# composerVcConfigId      : 94f1ae07-cb5b-4480-8e31-35bbc89f4c41
# composerUrl             : https://192.168.50.16:18443
# adConfig                : [administrator]namurnd.io;
# composerPort            : 18443
# composerUsername        : administrator@namurnd.io
# createRampFactor        : 20
# deleteRampFactor        : 50
# instantCreateDampFactor : 20
# seSparseReclamation     : true
#>


# Linux 가상 시스템 생성        : >> New-VM –Name "LINUX" –DiskGB 30 –DiskStorageFormat Thick –DataStore datastore1 –MemoryGB 3
# Windows 가상 시스템 생성      : >> New-VM –Name "WINDOWS" –DiskGB 30 –DiskStorageFormat Thick –DataStore datastore1 –MemoryGB 3 -guestid windows8Server64Guest
# 사용가능 가상 시스템 List      : >> Get-Vm | Select-Object Name, NumCPU, MemoryMB, PowerState, Host
# PowerCLI 모듈을 업그레이드    : >> Update-Module VMware.PowerCLI
#-------------------------------------------------------------------------------------------------------------------------------
