' 启动多个程序以进入工作模式，0 为隐藏窗口启动，1 为激活窗口启动

' 创建 WshShell 对象
Dim WshShell
Set WshShell = CreateObject("WScript.Shell")

' 启动 v2rayN
WshShell.Run """C:\Users\sec\AppData\Local\Programs\v2rayN\v2rayN.exe""", 0

' 启动 KeePassXC
WshShell.Run """C:\Program Files\KeePassXC\KeePassXC.exe""", 0

' 启动 Snipaste
WshShell.Run """C:\Users\sec\AppData\Local\Programs\PixPin\PixPin.exe""", 0

' 启动 Deepl
WshShell.Run """C:\Users\sec\AppData\Roaming\Programs\Zero Install\0install-win.exe"" run --no-wait https://appdownload.deepl.com/windows/0install/deepl.xml", 0

' 启动 Stretchly
WshShell.Run """C:\Users\sec\AppData\Local\Programs\Stretchly\Stretchly.exe""", 0

' 启动 TurboTop
WshShell.Run """C:\Program Files (x86)\TurboTop\TurboTop.exe""", 0

' 释放 WshShell 对象
Set WshShell = Nothing
