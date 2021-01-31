# Thao tác với memory
### Đọc một giá trị từ memory
- Sau khi đã mở handle tới process, chúng ta có thể dùng handle đó để đọc memory:
```autoit
    $value = KeReadInt($hProcess, 0x384DCF50)
```
- $value sẽ là giá trị số (int) tại ```0x384DCF50```
- Có thể đọc những kiểu dữ liệu khác bằng các hàm sau: ```KeReadFloat(), KeReadDouble(), KeReadWord(), KeReadFloat()```
- Dùng ```KeReadString()``` và ```KeReadStringUnicode()``` để đọc một string:
```autoit
    $string = KeReadString($hProcess, 0x384DCF50, $stringLength=0)
```
- Nếu ```$stringLength``` được đặt là ```0```, nó sẽ tự động phát hiện độ dài của string
- Để đọc một kiểu dữ liệu tùy chọn, hãy dùng:
```autoit
    $value = KeRead($hProcess, 0x384DCF50, $type="int")
```
- Xem các kiểu dữ liệu có thể dùng ở [đây](https://www.autoitscript.com/autoit3/docs/functions/DllStructCreate.htm)

<br>

### Ghi một giá trị vào memory
- Để ghi giá trị ```999``` tới address ```0x384DCF50```, hãy dùng:
```autoit
    KeWriteInt($hProcess, 0x384DCF50, 999)
```
- Có thể ghi những kiểu dữ liệu khác bằng các hàm sau: ```KeWriteFloat(), KeWriteDouble(), KeWriteWord(), KeWriteFloat()```
- Dùng ```KeWriteString()``` và ```KeWriteStringUnicode()``` để ghi một string:
```autoit
    KeWriteString($hProcess, 0x384DCF50, "hello world", $stringLength=0)
```
- Nếu ```$stringLength``` được đặt là ```0```, nó sẽ ghi string với một ```NULL``` byte ở cuối, nếu được đặt là ```-1```, nó sẽ ghi string mà không có ```NULL``` byte.
- Để ghi một kiểu dữ liệu tùy chọn, hãy dùng:
```autoit
    KeWrite($hProcess, 0x384DCF50, 999, $type="int")
```
- Xem các kiểu dữ liệu có thể dùng ở [đây](https://www.autoitscript.com/autoit3/docs/functions/DllStructCreate.htm)
