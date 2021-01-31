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

Local $dev1_name = "emulator-5554"
Local $dev2_name = "127.0.0.1:5555"

; Chạy kesh server trên thiết bị 1
KeSetAdbDevice($dev1_name)
; Dùng KeServerCreate($port = 0) để tự động chọn một port chưa được dùng
; chúng ta cũng có thể dùng KeServerConnectOrCreate() với một port đã được định sẵn
Local $socket_dev1 = KeServerCreate() 

; Chạy kesh server trên thiết bị 2
KeSetAdbDevice($dev2_name)
Local $socket_dev2 = KeServerCreate()

; Chuyển sang thiết bị 1
KeSetAdbDevice($dev1_name)
KeServerSetSocket($socket_dev1)
; Lấy danh sách process trên thiết bị 1
_ArrayDisplay(KeGetProcessList())

; Chuyển sang thiết bị 2
KeSetAdbDevice($dev2_name)
KeServerSetSocket($socket_dev2)
; Lấy danh sách process trên thiết bị 2
_ArrayDisplay(KeGetProcessList())
