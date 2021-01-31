# Chạy kesh và kết nối với Cheat Engine

### Kesh hoạt động như thế nào?
- **kesh** chạy một process **kesh server** trên thiết bị android và giao tiếp với process windows thông qua **tcp socket**.
- Nó sử dụng **kesh server** để thao tác với ```memory, process, module, thread,..``` trực tiếp trên thiết bị android.
- **kesh server** là một phiên bản được mod lại từ [ceserver](https://github.com/cheat-engine/cheat-engine/tree/master/Cheat%20Engine/ceserver "ceserver") của **Cheat Engine**
<br>

### Chạy kesh server trên thiết bị android
- Đầu tiên chúng ta cần load kesh.dll
```autoit
    If @AutoItX64 Then
        KeDllOpen("kesh64.dll")
    Else
        KeDllOpen("kesh.dll")
    EndIf
```
- Sau đó set đường dẫn tới **adb.exe**
```autoit
    KeSetAdbPath("D:\LDPlayer\LDPlayer4.0\adb.exe")
```
- Set **adb device** nếu cần
```autoit
    KeSetAdbDevice("emulator-5555")
```
- Inject và chạy **kesh server** trên thiết bị android
```autoit
    $socket = KeServerCreate($port = 0) ;// nếu $port = 0 thì nó sẽ chọn ngẫu nhiên một port chưa được dùng
```
- Port của **kesh server** có thể được get bằng cách ```KeServerGetPort($socket)```

<br>

### Kết nối tới một kesh server đã mở
- Nếu bạn đã chạy **kesh server** trước đó, bạn có thể kết nối với nó bằng cách
```autoit
    KeServerConnect(21758) ;// kết nối tới port 21758
```
- Hoặc nếu không kết nối được thì sẽ chạy lại **kesh server**
```autoit
    KeServerConnectOrCreate(21758)
```

<br>

### Sử dụng Cheat Engine với kesh server
- Sau khi bạn đã chạy **kesh server**, bạn có thể kết nối **Cheat Engine** với nó.
- Nhấn nút **Select Process**, chọn **Network**, nhập số port chúng ta set khi chạy **kesh server**, sau đó nhấn **Connect**.<br>
<p align="center"><img src="https://raw.githubusercontent.com/thedemons/kesh-autoit/main/documentation/ce_setup.jpg" width="400"></p>
