# Thao tác với process
### Lấy danh sách các process
- Để lấy danh sách các process đang chạy, dùng:
```autoit
    $aProcess = KeGetProcessList()
    _ArrayDisplay($aProcess)
```
- Hàm sẽ trả về một mảng 2 chiều, chứa process ID và tên process, kết quả nên trông như thế này:<p align="center"><img src="https://raw.githubusercontent.com/thedemons/kesh-autoit/main/documentation/process/getprocesslistresult.png" width="500"></p>
- Tên process sẽ chứa đường dẫn đầy đủ, như: ```/system/bin/app_process32 com.google.android.gms.ui```

<br>

### Lấy ID của process
- Chúng ta có thể lấy ID của process bằng cách sau:
```autoit
    $pid = KeGetProcessID($processName)
```
- ```$processName``` là tên của process trả về từ ```KeGetProcessList()```. Hoặc nó có thể là ```"com.google.android.gms.ui"``` trong trường hợp sau:
<p align="center"><img src="https://raw.githubusercontent.com/thedemons/kesh-autoit/main/documentation/process/ce_processlist.jpg" width="400"></p>

<br>

### Lấy danh sách các module trong process
- Để lấy danh sách tất cả các module trong process, dùng:
```autoit
    $aModule = KeGetProcessModuleList($pid)
    _ArrayDisplay($aModule)
```
- Hàm này sẽ trả về một mảng 2 chiều, chứa base address và tên của module, kết quả nên trông như thế này:<p align="center"><img src="https://raw.githubusercontent.com/thedemons/kesh-autoit/main/documentation/process/getprocessmodulelistresult.jpg" width="500"></p>

## Lấy base address của một module
- Lấy base address của module tên ```app_process32``` bằng cách:
```autoit
    $baseAddress = KeGetModuleBase($pid, "app_process32")
```

<br>

### Mở handle tới process
- Handle này được dùng để thực hiện các thao tác memory với process này
```autoit
    $hProcess = KeOpenProcess($pid)
```
