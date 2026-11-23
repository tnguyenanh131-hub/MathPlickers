@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

set "PROJECT_DIR=%~dp0"
if "%PROJECT_DIR:~-1%"=="\" set "PROJECT_DIR=%PROJECT_DIR:~0,-1%"
cd /d "%PROJECT_DIR%"

set "HTTP_PORT=8000"
set "WS_PORT=8080"
if not defined OPEN_BROWSER set "OPEN_BROWSER=1"
set "PRESENTER_URL=http://localhost:%HTTP_PORT%/frontend/presenter-screen.html"
set "LAN_IP="

for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "$ip = (Get-NetIPConfiguration | Where-Object { $_.IPv4Address -ne $null -and $_.NetAdapter.Status -eq 'Up' -and $_.IPv4DefaultGateway -ne $null } | Select-Object -First 1).IPv4Address.IPAddress; if (-not $ip) { $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne '127.0.0.1' -and $_.IPAddress -notlike '169.254.*' } | Select-Object -First 1).IPAddress }; if ($ip) { Write-Output $ip }" 2^>nul`) do (
  if not defined LAN_IP set "LAN_IP=%%I"
)
if not defined LAN_IP set "LAN_IP=<IP-MAY-TINH>"

echo ==================================================
echo   PLICKERS MATH SUITE - KHOI DONG HE THONG (WINDOWS)
echo ==================================================
echo Thu muc du an : "%PROJECT_DIR%"
echo IPv4 LAN      : %LAN_IP%
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo [LOI] Khong tim thay Node.js.
  pause
  exit /b 1
)

if not exist "%PROJECT_DIR%\server\node_modules\ws" (
  pushd "%PROJECT_DIR%\server"
  call npm install --silent
  popd
)

start "Plickers WebSocket Server" cmd /k "cd /d ""%PROJECT_DIR%\server"" && node sync-server.js"
timeout /t 1 /nobreak >nul
start "Plickers Web Server" cmd /k "cd /d ""%PROJECT_DIR%"" && python -m http.server %HTTP_PORT%"
timeout /t 1 /nobreak >nul

if "%OPEN_BROWSER%"=="1" start "" "%PRESENTER_URL%"

echo [SAN SANG]
echo   - Man hinh TV / PC : %PRESENTER_URL%
echo   - In bo the A/B/C/D: http://localhost:%HTTP_PORT%/mobile-scanner/print-cards.html
echo   - Dien thoai quet   : http://%LAN_IP%:%HTTP_PORT%/mobile-scanner/index.html
pause
