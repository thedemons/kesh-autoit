
# Memory manipulation
### Read a value from memory
- After openning the process handle, we can use it to read process memory:
```autoit
    $value = KeReadInt($hProcess, 0x384DCF50)
```
- The $value should be a number (int) value at ```0x384DCF50```
- You can use these functions to read other types of value: ```KeReadFloat(), KeReadDouble(), KeReadWord(), KeReadFloat()```
- Use ```KeReadString()``` and ```KeReadStringUnicode()``` to read a string
```autoit
    $string = KeReadString($hProcess, 0x384DCF50, $stringLength=0)
```
- If the ```$stringLength``` is set to 0, it'll auto detect the length
