#Examples
### Setup kesh
```autoit
; open kesh library
If @AutoItX64 Then
    KeDllOpen("kesh64.dll")
Else
    KeDllOpen("kesh.dll")
EndIf

; set path to adb.exe
Local $AdbPath = "D:\LDPlayer\LDPlayer4.0\adb.exe"
KeSetAdbPath($AdbPath)

; set specific device if needed
KeSetAdbDevice("emulator-5554")
```

### Start the kesh server
```autoit
; connect to the kesh server on port 21758, if the server isn't running then start it
Local $socket = KeServerConnectOrCreate(21758)

If $socket <= 0 Then
    MsgBox(16, "Error", "Failed to open kesh server")
    Exit
EndIf
```

### Get process id and handle
```autoit
; get pid of the process "com.google.android.gms"
Local $pid = KeGetProcessID("com.google.android.gms")
; get process handle
Local $hProcess = KeOpenProcess($pid)
```
