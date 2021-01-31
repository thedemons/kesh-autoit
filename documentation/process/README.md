# Process manipulation
### Getting a list of processes
- To get a list of all running processes, use
```autoit
    $aProcess = KeGetProcessList()
	_ArrayDisplay($aProcess)
```
- It will return a 2D array of process id and process name, the results should look like this
<p align="center"><img src="https://raw.githubusercontent.com/thedemons/kesh-autoit/main/documentation/process/getprocesslistresult.png" width="500"></p>

- The process name includes the path such as ```/system/bin/app_process32 com.google.android.gms```

<br>

### Getting the process ID
- The process ID can be retrieved using
```autoit
    $pid = KeGetProcessID($processName)
```
- ```$processName``` is the name of process returned by ```KeGetProcessList()```. Or it can be ```"com.google.android.gms"``` in this case:
<p align="center"><img src="https://raw.githubusercontent.com/thedemons/kesh-autoit/main/documentation/process/ce_processlist.jpg" width="400"></p>

<br>

### Open handle to the process
- Once we got the process ID, we can use it to open the process handle
```autoit
    $hProcess = KeOpenProcess($pid)
```
- This handle can later be used to manipulate the process
