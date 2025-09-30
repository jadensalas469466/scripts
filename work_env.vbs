' Create
Dim WshShell
Set WshShell = CreateObject("WScript.Shell")

' Run v2rayN
WshShell.Run """C:\Users\sec\AppData\Local\Programs\v2rayN\v2rayN.exe""", 0

' Run KeePassXC
WshShell.Run """C:\Program Files\KeePassXC\KeePassXC.exe""", 0

' Run Snipaste
WshShell.Run """C:\Users\sec\AppData\Local\Programs\PixPin\PixPin.exe""", 0

' Run DeepL
WshShell.Run """C:\Users\sec\AppData\Roaming\Programs\Zero Install\0install-win.exe"" run --no-wait https://appdownload.deepl.com/windows/0install/deepl.xml", 0

' Run Stretchly
WshShell.Run """C:\Users\sec\AppData\Local\Programs\Stretchly\Stretchly.exe""", 0

' Run TurboTop
WshShell.Run """C:\Program Files (x86)\TurboTop\TurboTop.exe""", 0

' Destroy
Set WshShell = Nothing
