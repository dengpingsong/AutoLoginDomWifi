@echo off
setlocal enabledelayedexpansion

:: 获取用户输入账号和密码
set /p USERNAME=请输入登录账号：
set /p PASSWORD=请输入登录密码：

:: 初始化 Node 项目
echo [1/5] 初始化 npm 项目...
npm init -y >nul 2>&1

:: 创建 app.js 文件
echo [2/5] 创建 app.js 脚本...
(
echo const URL = "http://10.10.16.12/api/portal/v1/login";
echo const LOGIN_PAYLOAD = {
echo     domain: "cmcc",
echo     username: "%USERNAME%",
echo     password: "%PASSWORD%"
echo };
echo.
echo function loginRequest() {
echo     return fetch(URL, {
echo         method: "POST",
echo         headers: {
echo             "Content-Type": "application/json",
echo             "X-Requested-With": "XMLHttpRequest"
echo         },
echo         body: JSON.stringify(LOGIN_PAYLOAD)
echo     }).then(resp => {
echo         if (!resp.ok) throw new Error("Login failed");
echo         return resp.json();
echo     });
echo }
echo.
echo setInterval(() => {
echo     fetch("https://www.baidu.com", {
echo         headers: { "User-Agent": "Mozilla/5.0" }
echo     }).then(res => res.text())
echo       .then(_ => {})
echo       .catch(err => {
echo           console.log("网络异常，尝试重新登录...");
echo           loginRequest().then(res => {
echo               console.log("登录成功:", res);
echo           }).catch(err => {
echo               console.error("登录失败:", err);
echo           });
echo       });
echo }, 5000);
) > app.js

:: 检查 Node 版本
echo [3/5] Node 版本检查...
node -v

:: 可选：添加到启动项
set STARTUP_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set SHORTCUT="%STARTUP_PATH%\AutoLoginApp.lnk"

echo [4/5] 是否添加到 Windows 启动项？(Y/N)
set /p STARTUP_CHOICE=
if /I "%STARTUP_CHOICE%"=="Y" (
    echo [4/5] 添加启动项...
    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT%');$s.TargetPath='cmd.exe';$s.Arguments='/c cd /d \"%CD%\" ^& node app.js';$s.Save()"
)

:: 启动脚本
echo [5/5] 正在运行 app.js...
node app.js

endlocal
pause
