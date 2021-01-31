# Process manipulation
### Getting a list of process
- To get a list of all running processes, use
```autoit
    $aProcess = KeGetProcessList()
	_ArrayDisplay($aProcess)
```
- It will return a 2D array of process id and process name
- Process name is 
<p align="center"><img src="https://raw.githubusercontent.com/thedemons/kesh-autoit/main/documentation/process/getprocesslistresult.png" width="500"></p>
