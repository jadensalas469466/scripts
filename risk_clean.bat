@echo off
chcp 65001 > nul

REM 清理系统中可能存在风险的文件

echo 准备清理风险文件...

REM 清理 Visual Studio Code 的代码备份
del /q /s "C:\Users\sec\AppData\Roaming\Code\Backups\*.*"
for /d %%p in ("C:\Users\sec\AppData\Roaming\Code\Backups\*") do rmdir /q /s "%%p"

REM 清理虚拟机的交换文件
del /q /s "C:\Users\sec\AppData\Local\Temp\vmware-sec\VMwareDnD\*.*"
for /d %%p in ("C:\Users\sec\AppData\Local\Temp\vmware-sec\VMwareDnD\*") do rmdir /q /s "%%p"

echo 风险文件已清理完毕

exit
