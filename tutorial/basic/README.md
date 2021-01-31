# Basic stuff about kesh

### How does kesh work?
- **kesh** load a server process on the android device that communicate with windows using **tcp socket**.
- It uses that server to manipulate ```memory, process, module, thread,..``` directly on the android device.
- The **kesh server** is a modified version of the [ceserver](https://github.com/cheat-engine/cheat-engine/tree/master/Cheat%20Engine/ceserver "ceserver") from **Cheat Engine**

### Start kesh server on the android device
- First you need to load the kesh.dll
```autoit
    If @AutoItX64 Then
        KeDllOpen("kesh64.dll")
    Else
        KeDllOpen("kesh.dll")
    EndIf
```
- Then specify the **adb.exe** path ```KeSetAdbPath("D:\LDPlayer\LDPlayer4.0\adb.exe")```
- Specify the **adb device** if needed```KeSetAdbDevice("emulator-5555")```
- Inject and start the **kesh server** on the android device
```autoit
    $socket = KeServerCreate($port = 0) ;// if $port = 0 then it'll select a random unsed port
```
- The port can then be retrieved like this ```KeServerGetPort($socket)```

</br>
### Connect to an existing kesh server
- If you already start the **kesh server** , you can connect it using this
```autoit
    KeServerConnect($port)
```
