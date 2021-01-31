#cs ---------------------------------------------------------------------------

library:							demem
.						a simple memory library for autoit

author:         thedemons
discord:		thedemons#8671
facebook:		/demonsmsc


functions:

	KeDllOpen
	KeDllClose
	KeIsDllLoaded

	KeSetAdbPath
	KeSetAdbDevice

	KeServerCreate
	KeServerConnect
	KeServerConnectOrCreate
	KeServerSetSocket
	KeServerGetVersion
	KeServerTerminate
	KeServerCloseConnection
	KeServerGetPort

	KeOpenProcess
	KeReadProcessMemory
	KeWriteProcessMemory
	KeGetProcessID
	KeGetProcessList
	KeGetModuleBase

	KeCreateToolhelp32Snapshot
	KeModule32First
	KeModule32Next
	KeProcess32First
	KeProcess32Next
	KeVirtualQueryEx
	KeCloseHandle

	KeRead
	KeReadInt
	KeReadFloat
	KeReadDouble
	KeReadWord
	KeReadByte
	KeReadString
	KeReadStringUnicode

	KeWrite
	KeWriteInt
	KeWriteFloat
	KeWriteDouble
	KeWriteWord
	KeWriteByte
	KeWriteString
	KeWriteStringUnicode


#ce ----------------------------------------------------------------------------

#include-once
#include <WinAPI.au3>

Global $__kesh_handle = -1

Global Const $TH32CS_SNAPALL =		BitOR(0x00000001, 0x00000008, 0x00000002, 0x00000004)
Global Const $TH32CS_INHERIT =		0x80000000
Global Const $TH32CS_SNAPHEAPLIST =	0x00000001
Global Const $TH32CS_SNAPMODULE =	0x00000008
Global Const $TH32CS_SNAPMODULE32 =	0x00000010
Global Const $TH32CS_SNAPPROCESS =	0x00000002
Global Const $TH32CS_SNAPTHREAD =	0x00000004

Global Const $__MODULEENTRY32 = "DWORD dwSize; DWORD th32ModuleID; DWORD th32ProcessID; DWORD GlblcntUsage; DWORD ProccntUsage; BYTE* modBaseAddr; DWORD modBaseSize; HMODULE hModule; char szModule[255 + 1]; char szExePath[260];"
Global Const $__PROCESSENTRY32 = "DWORD dwSize; DWORD cntUsage; DWORD th32ProcessID; ptr th32DefaultHeapID; DWORD th32ModuleID; DWORD cntThreads; DWORD th32ParentProcessID; LONG pcPriClassBase; DWORD dwFlags; CHAR szExeFile[260];"
Global Const $__MEMORY_BASIC_INFORMATION = "ptr BaseAddress; ptr AllocationBase; DWORD AllocationProtect; PTR RegionSize; DWORD State; DWORD Protect; DWORD Type;"
Global $__currentsocket = 0






; Load the kesh library
;
; $dll_path:		path to the library
;
; [Return]
;	success:		true
;	failed:			false
Func KeDllOpen($dll_path)

	$__kesh_handle = DllOpen($dll_path)
	Return ($__kesh_handle = -1) ? False : True
EndFunc



; Close the kesh library
;
; [Return]			none
Func KeDllClose()
	DllClose($__kesh_handle)
	$__kesh_handle = -1
EndFunc



; Return true if the kesh library is loaded
Func KeIsDllLoaded()
	Return ($__kesh_handle <> -1)
EndFunc



; Setup the path to the adb
; You need to enable Root and ADB connection on the emulator
;
; [Return]
;	success:	true
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeSetAdbPath($AdbPath)

	Local $result = DllCall($__kesh_handle, "none:cdecl", "KeSetAdbPath", "wstr", $AdbPath)
	If @error Then Return SetError(1, @error, False)

	return True
EndFunc



; Set ADB device
;
; [Return]
;	success:	true
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeSetAdbDevice($deviceName)

	Local $result = DllCall($__kesh_handle, "none:cdecl", "KeSetAdbDevice", "wstr", $deviceName)
	If @error Then Return SetError(1, @error, False)

	return True
EndFunc



; Create a kesh server on the android emulator
;
; [Return]
;	success:	the socket connected to the server
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeServerCreate($port = 0)

	Local $result = DllCall($__kesh_handle, "handle:cdecl", "KeServerCreate", "short", $port)
	If @error Then Return SetError(1, @error, False)

	If $result[0] <> 0 Then $__currentsocket = $result[0]
	return $result[0]
EndFunc



; Connect to the kesh server on the android emulator
;
; [Return]
;	success:	the socket connected to the server
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeServerConnect($port, $timeout = 1000)

	Local $result = DllCall($__kesh_handle, "handle:cdecl", "KeServerConnect", "short", $port, "int", $timeout)
	If @error Then Return SetError(1, @error, False)

	If $result[0] <> 0 Then $__currentsocket = $result[0]
	return $result[0]
EndFunc



; Connect to the kesh server, if the server isn't running then create it
;
; [Return]
;	success:	the socket connected to the server
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeServerConnectOrCreate($port, $timeout = 1000)

	Local $result = DllCall($__kesh_handle, "handle:cdecl", "KeServerConnectOrCreate", "short", $port, "int", $timeout)
	If @error Then Return SetError(1, @error, False)

	If $result[0] <> 0 Then $__currentsocket = $result[0]
	return $result[0]
EndFunc



; Set current server socket to work with
;
; [Return]		none
Func KeServerSetSocket($socket)
	$__currentsocket = $socket
EndFunc



; Get kesh server version
;
; [Return]
;	success:	version in string
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeServerGetVersion($socket = $__currentsocket)

	Local $buffer = DllStructCreate("char[512]")
	Local $result = DllCall($__kesh_handle, "int:cdecl", "KeServerGetVersion", "handle", $socket, "ptr", DllStructGetPtr($buffer), "int", DllStructGetSize($buffer))
	If @error Then Return SetError(1, @error, False)

	return DllStructGetData($buffer, 1)
EndFunc



; Close server connection
;
; [Return]
;	success:	true
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeServerCloseConnection($socket = $__currentsocket)

	Local $result = DllCall($__kesh_handle, "bool:cdecl", "KeServerCloseConnection", "handle", $socket)
	If @error Then Return SetError(1, @error, False)
	Return $result[0]
EndFunc



; Terminate kesh server
;
; [Return]
;	success:	true
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeServerTerminate($socket = $__currentsocket)

	Local $result = DllCall($__kesh_handle, "bool:cdecl", "KeServerTerminate", "handle", $socket)
	If @error Then Return SetError(1, @error, False)
	Return $result[0]
EndFunc



; Get the kesh server port
;
; [Return]
;	success:	port number
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeServerGetPort($socket = $__currentsocket)

	Local $result = DllCall($__kesh_handle, "short:cdecl", "KeServerGetPort", "handle", $socket)
	If @error Then Return SetError(1, @error, False)

	return Int($result[0])
EndFunc



; Open a process
;
; [Return]
;	success:	the process handle
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeOpenProcess($pid, $bInherit = False)

	Local $result = DllCall($__kesh_handle, "handle:cdecl", "KeOpenProcess", "handle", $__currentsocket, "dword", 0, "bool", $bInherit, "dword", $pid)
	If @error Then Return SetError(1, @error, False)

	return $result[0]
EndFunc



; Read process memory
;
; $struct:		returned by DllStructCreate
; $iRead:		the number of bytes read
;
; [Return]
;	success:	true
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeReadProcessMemory($hProcess, $address, $struct, ByRef $iRead)

	$iRead = 0
	Local $struct_iRead = DllStructCreate("dword")

	Local $result = DllCall($__kesh_handle, "bool:cdecl", "KeReadProcessMemory", "handle", $__currentsocket, "handle", $hProcess, _
	"ptr", $address, "ptr", DllStructGetPtr($struct), "dword", DllStructGetSize($struct), "ptr", DllStructGetPtr($struct_iRead))

	If @error Then Return SetError(1, @error, False)
	If $result[0] = False Then Return SetError(2, 0, False)

	$iRead = DllStructGetData($struct_iRead, 1)
	Return $result[0]
EndFunc



; Read process memory
;
; $struct:		returned by DllStructCreate
; $iWritten:		the number of bytes written
;
; [Return]
;	success:	true
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeWriteProcessMemory($hProcess, $address, $struct, ByRef $iWritten)

	$iWritten = 0

	Local $struct_iWritten = DllStructCreate("dword")
	Local $result = DllCall($__kesh_handle, "bool:cdecl", "KeWriteProcessMemory", "handle", $__currentsocket, "handle", $hProcess, _
	"ptr", $address, "ptr", DllStructGetPtr($struct), "dword", DllStructGetSize($struct), "ptr", DllStructGetPtr($struct_iWritten))

	If @error Then Return SetError(1, @error, False)
	If $result[0] = False Then Return SetError(2, 0, False)

	$iWritten = DllStructGetData($struct_iWritten, 1)
	Return $result[0]
EndFunc



; Get the id of a specific process
;
; [Return]
;	success:	id of the process
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeGetProcessID($processName)

	Local $result = DllCall($__kesh_handle, "dword:cdecl", "KeGetProcessID", "handle", $__currentsocket, "str", $processName)
	If @error Then Return SetError(1, @error, False)

	return $result[0]
EndFunc



; Get all process
;
; [Return]
;	success:	a 2d array contain pid and process name
;	failed:		false and set @error to non-zero
;
; @error	1: KeCreateToolhelp32Snapshot failed
;
; [Remarks]
;			if success, the function return a 2d array
;			$aProcess[n][0]:	process id
;			$aProcess[n][1]:	process name
Func KeGetProcessList()
	Local $hSnapShot = KeCreateToolhelp32Snapshot($TH32CS_SNAPPROCESS, 0)
	If @error Then Return SetError(1, 0, False)

	Local $isFirst = True
	Local $aProcessList[0][2]
	While 1
		$processEntry = KeProcess32Next($hSnapshot, $isFirst)
		If @error Then ExitLoop

		$isFirst = False
		Local $count = UBound($aProcessList)
		Redim $aProcessList[$count+1][2]
		$aProcessList[$count][0] = DllStructGetData($processEntry, "th32ProcessID")
		$aProcessList[$count][1] = DllStructGetData($processEntry, "szExeFile")
	WEnd

	KeCloseHandle($hSnapshot)
	Return $aProcessList
EndFunc



; Get the base address of a specific module
;
; [Return]
;	success:	base address of the module
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeGetModuleBase($pid, $moduleName = "app_process32")

	Local $result = DllCall($__kesh_handle, "ptr:cdecl", "KeGetModuleBase", "handle", $__currentsocket, "dword", $pid, "str", $moduleName)
	If @error Then Return SetError(1, @error, False)

	return $result[0]
EndFunc



; Takes a snapshot of a specified process
;
; [Return]
;	success:	a snapshot handle
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeCreateToolhelp32Snapshot($flags, $pid)

	Local $result = DllCall($__kesh_handle, "handle:cdecl", "KeCreateToolhelp32Snapshot", "handle", $__currentsocket, "dword", $flags, "dword", $pid)
	If @error Then Return SetError(1, @error, False)

	return $result[0]
EndFunc



; Retrieves information about the next module associated with a process or thread
;
; [Return]
;	success:	a $__MODULEENTRY32 struct
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeModule32Next returned false
Func KeModule32Next($hSnapshot, $isFirst = False)
    Local $moduleEntry = DllStructCreate($__MODULEENTRY32)

	Local $result = DllCall($__kesh_handle, "bool:cdecl", "KeModule32Next", "handle", $__currentsocket, "handle", $hSnapshot, "ptr", DllStructGetPtr($moduleEntry), "bool", $isFirst)

	If @error Then Return SetError(1, @error, False)
	If $result[0] = False Then Return SetError(2, 0, False)

	return $moduleEntry
EndFunc



; Retrieves information about the first module associated with a process
;
; [Return]
;	success:	a $__MODULEENTRY32 struct
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeModule32Next returned false
Func KeModule32First($hSnapshot)
	Return KeModule32Next($hSnapshot, True)
EndFunc



; Retrieves information about the next process recorded in a system snapshot.
;
; [Return]
;	success:	a $__PROCESSENTRY32 struct
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeProcess32Next returned false
Func KeProcess32Next($hSnapshot, $isFirst = False)
    Local $processEntry = DllStructCreate($__PROCESSENTRY32)
	Local $result = DllCall($__kesh_handle, "bool:cdecl", "KeProcess32Next", "handle", $__currentsocket, _
	"handle", $hSnapshot, "ptr", DllStructGetPtr($processEntry), "bool", $isFirst)

	If @error Then Return SetError(1, @error, False)
	If $result[0] = False Then Return SetError(2, 0, False)

	return $processEntry
EndFunc



; Retrieves information about the first process encountered in a system snapshot
;
; [Return]
;	success:	a $__PROCESSENTRY32 struct
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeProcess32Next returned false
Func KeProcess32First($hSnapshot)
	Return KeProcess32Next($hSnapshot, True)
EndFunc



; Retrieves information about a range of pages within the virtual address space of a specified process
;
; [Return]
;	success:	a $__MEMORY_BASIC_INFORMATION struct
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeVirtualQueryEx returned false
Func KeVirtualQueryEx($hProcess, $address)
    Local $meminfo = DllStructCreate($__MEMORY_BASIC_INFORMATION)

	Local $result = DllCall($__kesh_handle, "ptr:cdecl", "KeVirtualQueryEx", "handle", $__currentsocket, "handle", $hProcess, "ptr", $address, "ptr", DllStructGetPtr($meminfo), "dword", DllStructGetSize($meminfo))

	If @error Then Return SetError(1, @error, False)
	If $result[0] = False Then Return SetError(2, 0, False)

	return $meminfo
EndFunc



; Closes an open object handle
;
; [Return]
;	success:	a $__MEMORY_BASIC_INFORMATION struct
;	failed:		false
;
; @error	1: DllCall failed, @extended is the @error of DllCall
Func KeCloseHandle($handle)

	Local $result = DllCall($__kesh_handle, "bool:cdecl", "KeCloseHandle", "handle", $__currentsocket, "handle", $handle)
	If @error Then Return SetError(1, @error, False)

	return $result[0]
EndFunc





; //////////////////////////////////////////////////////////////////////////////////////////////////////////////

; Read from memory
;
; $type:	type of the value
;			-	int, byte, float, double..
;			-	see more types in DllStructCreate help file.
;
; [Return]
;	success:	the memory value
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeRead($hProcess, $address, $type = "int")

	Local $buffer = DllStructCreate($type)
	Local $iRead = 0
	Local $result = KeReadProcessMemory($hProcess, $address, $buffer, $iRead)

	Return $result ? DllStructGetData($buffer, 1) : False
EndFunc



; Write to memory
;
; $type:	type of the value
;			-	int, byte, float, double..
;			-	see more types in DllStructCreate help file.
;
; [Return]
;	success:	the number of bytes written
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeWrite($hProcess, $address, $value, $type = "int")

	Local $buffer = DllStructCreate($type)
	DllStructSetData($buffer, 1, $value)
	Local $iWritten = 0

	Local $result = KeWriteProcessMemory($hProcess, $address, $buffer, $iWritten)
	Return $result ? $iWritten : False
EndFunc



; Read an int (4 bytes) from memory
;
; [Return]
;	success:	the memory value
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeReadInt($hProcess, $address)
	Return KeRead($hProcess, $address, "int")
EndFunc



; Read a float (4 bytes) from memory
;
; [Return]
;	success:	the memory value
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeReadFloat($hProcess, $address)
	Return KeRead($hProcess, $address, "float")
EndFunc



; Read a double (8 bytes) from memory
;
; [Return]
;	success:	the memory value
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeReadDouble($hProcess, $address)
	Return KeRead($hProcess, $address, "double")
EndFunc



; Read a word (2 bytes) from memory
;
; [Return]
;	success:	the memory value
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeReadWord($hProcess, $address)
	Return KeRead($hProcess, $address, "word")
EndFunc



; Read a byte from memory
;
; [Return]
;	success:	the memory value
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeReadByte($hProcess, $address)
	Return KeRead($hProcess, $address, "byte")
EndFunc



; Write an int (4 bytes) to memory
;
; [Return]
;	success:	the number of bytes written
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeWriteInt($hProcess, $address, $value)
	Return KeWrite($hProcess, $address, $value, "int")
EndFunc



; Write a float (4 bytes) to memory
;
; [Return]
;	success:	the number of bytes written
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeWriteFloat($hProcess, $address, $value)
	Return KeWrite($hProcess, $address, $value, "float")
EndFunc



; Write a double (8 bytes) to memory
;
; [Return]
;	success:	the number of bytes written
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeWriteDouble($hProcess, $address, $value)
	Return KeWrite($hProcess, $address, $value, "double")
EndFunc



; Write a word (2 bytes) to memory
;
; [Return]
;	success:	the number of bytes written
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeWriteWord($hProcess, $address, $value)
	Return KeWrite($hProcess, $address, $value, "word")
EndFunc



; Write a byte to memory
;
; [Return]
;	success:	the number of bytes written
;	failed:		false and set @error to non-zero
;
; @error	1: DllCall failed, @extended is the @error of DllCall
;			2: KeReadProcessMemory returned false
Func KeWriteByte($hProcess, $address, $value)
	Return KeWrite($hProcess, $address, $value, "byte")
EndFunc



; Read a string from memory
;
; $len:		length of the string you need to read
;			default: 0 - auto detect the length of the string, max length for this is 32kb
;
; [Return]
;	success:	the string
;	failed:		false
Func KeReadString($hProcess, $address, $len = 0)

	If $len < 0 Then Return False

	If $len <> 0 Then

		Local $buffer = DllStructCreate(StringFormat("char[%d]", $len))
		Local $iRead = 0
		Local $result = KeReadProcessMemory($hProcess, $address, $buffer, $iRead)

		Return $result ? DllStructGetData($buffer, 1) : False

	Else

		Local $string = ""
		Local $old_strlen = 0, $strlen = 0
		Local $buffer_len = 8
		Local $loop_ = 0

		While True

			Local $buffer = DllStructCreate(StringFormat("char[%d]", $buffer_len))
			Local $iRead = 0
			Local $result = KeReadProcessMemory($hProcess, $address + $loop_ * $buffer_len, $buffer, $iRead)

			$string &= DllStructGetData($buffer, 1)
			$strlen = StringLen($string)

			If ($strlen - $old_strlen) < $buffer_len Then ExitLoop
			If $strlen >= (1024*32 - $buffer_len) Then ExitLoop
			If $result = False Then ExitLoop

			$old_strlen = $strlen
			$loop_ += 1
		WEnd

		Return ($strlen == 0) ? False : _WinAPI_MultiByteToWideChar($string, 65001, 0, True)
	EndIf

EndFunc



; Read a unicode string from memory
;
; $len:		length of the string you need to read
;			default: 0 - auto detect the length of the string, max length for this is 32kb
;
; [Return]
;	success:	the string
;	failed:		false
Func KeReadStringUnicode($hProcess, $address, $len = 0)

	If $len < 0 Then Return False

	If $len <> 0 Then

		Local $buffer = DllStructCreate(StringFormat("wchar[%d]", $len))
		Local $iRead = 0
		Local $result = KeReadProcessMemory($hProcess, $address, $buffer, $iRead)

		Return $result ? DllStructGetData($buffer, 1) : False

	Else

		Local $string = ""
		Local $old_strlen = 0, $strlen = 0
		Local $buffer_len = 1024
		Local $loop_ = 0

		While True

			Local $buffer = DllStructCreate(StringFormat("wchar[%d]", $buffer_len))
			Local $iRead = 0
			Local $result = KeReadProcessMemory($hProcess, $address + $loop_ * $buffer_len*2, $buffer, $iRead)

			$string &= DllStructGetData($buffer, 1)
			$strlen = StringLen($string)

			If ($strlen - $old_strlen) < $buffer_len Then ExitLoop
			If $strlen >= (1024*32 - $buffer_len) Then ExitLoop
			If $result = False Then ExitLoop

			$old_strlen = $strlen
			$loop_ += 1
		WEnd

		Return ($strlen == 0) ? False : $string
	EndIf

EndFunc



; Write a string to memory
;
; $string:	string to write
; $len:		length of the string,
;			0:		write the string with a NULL byte at the end
;			-1:		write the string without a NULL byte
;			default: 0
;			custom:	the length in bytes
;					if bigger than the actual length of the string in bytes,
;					it will replace those bytes with NULL
;
; [Return]
;	success:	the number of bytes written
;	failed:		false
;
; @error	1: KeWriteProcessMemory failed
;			2: the string is invalid
Func KeWriteString($hProcess, $address, $string, $len = 0)

	Local $strlen = StringLen($string)
	If $strlen <= 0 Then Return SetError(2, 0, False)


	Local $struct_str = _WinAPI_WideCharToMultiByte($string, 65001, False)

	Local $struct_size = DllStructGetSize($struct_str)
	If $len = 0 Then
		$len = $struct_size
	ElseIf $len = -1 Then
		$len = $struct_size - 1
	EndIf

	Local $struct_str_final = DllStructCreate(StringFormat("char[%d]", $len), DllStructGetPtr($struct_str))
	Local $iWritten = 0

	Local $result = KeWriteProcessMemory($hProcess, $address, $struct_str_final, $iWritten)

	Return $result ? $iWritten : SetError(1, @error, False)
EndFunc



; Write a unicode string to memory
;
; $string:	string to write
; $len:		length of the string,
;			0:		write the string with a NULL byte at the end
;			-1:		write the string without a NULL byte
;			default: 0
;			custom:	the length in bytes
;					if bigger than the actual length of the string in bytes,
;					it will replace those bytes with NULL
;
; [Return]
;	success:	the number of bytes written
;	failed:		false
;
; @error	1: KeWriteProcessMemory failed
;			2: the string is invalid
Func KeWriteStringUnicode($hProcess, $address, $string, $len = 0)

	Local $strlen = StringLen($string)
	If $strlen <= 0 Then Return SetError(2, 0, False)

	If $len = 0 Then
		$len = $strlen + 1
	ElseIf $len = -1 Then
		$len = $strlen
	EndIf

	Local $struct_str = DllStructCreate(StringFormat("wchar[%d]", $len))
	DllStructSetData($struct_str, 1, $string)
	Local $iWritten = 0

	Local $result = KeWriteProcessMemory($hProcess, $address, $struct_str, $iWritten)


	Return $result ? $iWritten : SetError(1, @error, False)
EndFunc

