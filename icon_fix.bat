@echo off

REM 修复系统无法正常显示的图标

REM 如果是64位系统，且是64位程序，则直接运行
REM 否则，以管理员身份重新启动自身
if "%PROCESSOR_ARCHITECTURE%" == "amd64" (
    if defined PROCESSOR_ARCHITEW6432 (
        goto :run
    ) else (
        powershell -noprofile "start-process '%0' -verb runas"
        exit /b
    )
) else (
    goto :run
)

:run

REM 关闭资源管理器
taskkill /f /im explorer.exe

REM 进入用户本地应用程序数据目录
cd /d %userprofile%\appdata\local

REM 删除图标缓存文件
del iconcache.db /a

REM 重启资源管理器
start explorer.exe
