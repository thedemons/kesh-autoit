# kesh-autoit
A simple Android memory library for AutoIt

### How does kesh work?
- **kesh** load a server process on the android device that communicate with windows using **tcp socket**.
- It uses that server to manipulate ```memory, process, module, thread,..``` directly on the android device.
- The **kesh server** is a modified version of the [ceserver](https://github.com/cheat-engine/cheat-engine/tree/master/Cheat%20Engine/ceserver "ceserver") from **Cheat Engine**

### Use Cheat Engine with kesh
- Cheat Engine can connect with kesh to work on android devices
- This can be done using this [tutorial](https://github.com/thedemons/kesh-autoit/tree/main/documentation#start-kesh-server-on-the-android-device)
