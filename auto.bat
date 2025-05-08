@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

set /p USERNAME=Please enter username:
set /p PASSWORD=Please enter password:

echo [1/5] Initializing npm project...
cmd /c npm init -y 
cmd /c npm install node-fetch --save >nul 2>&1
if %errorlevel% neq 0 (
    echo npm init failed. Please check if Node.js is properly installed!
    pause
    exit /b
)

echo [2/5] Creating app.js script...
echo [2/5] Creating app.js script...
echo import fetch from 'node-fetch'; > app.js
echo. >> app.js
echo function loginRequest() { >> app.js
echo     return fetch("http://10.10.16.12/api/portal/v1/login", { >> app.js
echo         method: "POST", >> app.js
echo         headers: { >> app.js
echo             "Accept": "application/json, text/javascript, */*; q=0.01", >> app.js
echo             "Accept-Encoding": "gzip, deflate", >> app.js
echo             "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6", >> app.js
echo             "Cache-Control": "no-cache", >> app.js
echo             "Connection": "keep-alive", >> app.js
echo             "Content-Type": "application/json", >> app.js
echo             "Host": "10.10.16.12", >> app.js
echo             "Origin": "http://10.10.16.12", >> app.js
echo             "Pragma": "no-cache", >> app.js
echo             "Referer": "http://10.10.16.12/portal/index.html?v=202208181518", >> app.js
echo             "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36 Edg/132.0.0.0", >> app.js
echo             "X-KL-Ajax-Request": "Ajax_Request", >> app.js
echo             "X-Requested-With": "XMLHttpRequest" >> app.js
echo         }, >> app.js
echo         body: JSON.stringify({ >> app.js
echo             domain: "cmcc", >> app.js
echo             username: "%USERNAME%", >> app.js
echo             password: "%PASSWORD%" >> app.js
echo         }) >> app.js
echo     }) >> app.js
echo         .then(response =^> { >> app.js
echo             if (!response.ok) { >> app.js
echo                 throw new Error("Network response was not ok"); >> app.js
echo             } >> app.js
echo             return response.json(); >> app.js
echo         }); >> app.js
echo } >> app.js
echo. >> app.js
echo setInterval(() =^> { >> app.js
echo     fetch('https://www.baidu.com/', { >> app.js
echo         headers: { >> app.js
echo             'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36' >> app.js
echo         } >> app.js
echo     }) >> app.js
echo         .then(response =^> response.text()) >> app.js
echo         .then(html =^> { >> app.js
echo             // 处理获取到的HTML内容 >> app.js
echo         }) >> app.js
echo         .catch(error =^> { >> app.js
echo             console.error("Error fetching Baidu page:", error); >> app.js
echo             loginRequest() >> app.js
echo                 .then(resp =^> { >> app.js
echo                     console.log("Login successful:", resp); >> app.js
echo                 }) >> app.js
echo                 .catch(err =^> { >> app.js
echo                     console.error("There was a problem with the login request:", err); >> app.js
echo                 }); >> app.js
echo         }); >> app.js
echo }, 100); >> app.js

echo [3/5] Checking Node version...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Node.js is not properly installed or environment variables are not configured!
    pause
    exit /b
)

echo [3/5] Checking Node version...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Node.js is not properly installed or environment variables are not configured!
    pause
    exit /b
)
echo [3/5] Node.js version check passed.

set STARTUP_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set SHORTCUT="%STARTUP_PATH%\AutoLoginApp.lnk"

echo [4/5] Add to Windows startup? (Y/N)
set /p STARTUP_CHOICE=
if /I "%STARTUP_CHOICE%"=="Y" (
    echo [4/5] Adding to startup...
    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT%');$s.TargetPath='cmd.exe';$s.Arguments='/c cd /d \"%CD%\" ^& node app.js';$s.Save()" >nul 2>&1
    if %errorlevel% neq 0 (
        echo Failed to add to startup. Administrative privileges may be required!
    ) else (
        echo [4/5] Successfully added to startup.
    )
) else (
    echo [4/5] Skipped adding to startup.
)

echo [5/5] Running app.js...
cmd /c node app.js
if %errorlevel% neq 0 (
    echo Failed to run app.js. Please check if Node.js is properly installed!
    pause
    exit /b
)

endlocal
pause
