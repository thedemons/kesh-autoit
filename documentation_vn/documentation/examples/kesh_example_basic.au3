#include <Array.au3>
#include "kesh.au3"


; Mở thư viện kesh
If @AutoItX64 Then
	KeDllOpen("kesh64.dll")
Else
	KeDllOpen("kesh.dll")
EndIf

; set dường dẫn tới adb.exe
Local $AdbPath = "D:\LDPlayer\LDPlayer4.0\adb.exe"
KeSetAdbPath($AdbPath)

; kết nối tới kesh server ở port 21758, nếu server chưa chạy thì tạo mới
Local $socket = KeServerConnectOrCreate(21758)

If $socket <= 0 Then
	MsgBox(16, "Lỗi", "Chạy kesh server thất bại")
	Exit
EndIf

; lấy danh sách process
Local $aProcessList = KeGetProcessList()
_ArrayDisplay($aProcessList)

; lấy pid của process "com.google.android.gms"
Local $processName = "com.google.android.gms" ; "/system/bin/app_process32 com.google.android.gms"
Local $pid = KeGetProcessID($processName)
MsgBox(0,"PID của " & $processName, $pid)

; lấy danh sách tất cả module trong process
Local $aModuleList = KeGetProcessModuleList($pid)
_ArrayDisplay($aModuleList)

; mở process handle
Local $hProcess = KeOpenProcess($pid)
MsgBox(0,"Process handle", $hProcess)

; lấy base address của module "app_process32"
Local $baseAddress = KeGetModuleBase($pid, "app_process32")
MsgBox(0,"Module base address", $baseAddress)

; đọc giá trị tại base address
Local $readBase = KeReadInt($hProcess, $baseAddress)
MsgBox(0,"Giá trị tại base address", $readBase)

; ghi giá trị vào base address
KeWriteInt($hProcess, $baseAddress, 999999)

; đọc giá trị lại lần nữa
Local $readBaseNew = KeReadInt($hProcess, $baseAddress)
MsgBox(0,"Giá trị mới tại base address", $readBaseNew)

; backup lại giá trị
KeWriteInt($hProcess, $baseAddress, $readBase)
