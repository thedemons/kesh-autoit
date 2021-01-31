# Examples
### Cài đặt kesh
```autoit
; mở thư viện kesh
If @AutoItX64 Then
    KeDllOpen("kesh64.dll")
Else
    KeDllOpen("kesh.dll")
EndIf

; set đường dẫn tới adb.exe
Local $AdbPath = "D:\LDPlayer\LDPlayer4.0\adb.exe"
KeSetAdbPath($AdbPath)
```

### Chạy kesh server
```autoit
; kết nối tới kesh server ở port 21758, nếu server chưa chạy thì tạo mới
Local $socket = KeServerConnectOrCreate(21758)

If $socket <= 0 Then
    MsgBox(16, "Lỗi", "Chạy kesh server thất bạt")
    Exit
EndIf
```

### Lấy id của process và mở handle của nó
```autoit
; lấy pid của process "com.google.android.gms"
Local $pid = KeGetProcessID("com.google.android.gms")
; mở handle của process
Local $hProcess = KeOpenProcess($pid)
```

### Đọc và ghi process memory
```autoit
; lấy base address của module "app_process32"
Local $baseAddress = KeGetModuleBase($pid, "app_process32")
; đọc giá trị tại base address
Local $readBase = KeReadInt($hProcess, $baseAddress)
; ghi một giá trị vào base address
KeWriteInt($hProcess, $baseAddress, 999999)
```

### Sử dụng kesh với nhiều thiết bị
```autoit
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
```
