@echo off
REM ============================================================
REM  tw-pearl-miner (Windows) - edit WALLET below, then run this
REM  file (double-click, or run from a terminal). Keep it next to
REM  pearl-gpu-miner.exe + the two .dll files.
REM  Pool is built in (pearl.tw-pool.com:50001).
REM ============================================================
setlocal
REM ---- your settings ----
set "WALLET=YOUR_PRL_WALLET_ADDRESS"
set "WORKER=%COMPUTERNAME%"
REM Uncomment for a plaintext pool (no TLS):
REM set "POOL_TLS=0"
REM -----------------------

cd /d "%~dp0"
if "%WALLET%"=="YOUR_PRL_WALLET_ADDRESS" set /p WALLET=Enter your prl1... wallet address:
if "%WALLET%"=="" ( echo No wallet entered - exiting. & pause & exit /b 1 )
echo.
echo Starting tw-pearl-miner  (worker: %WORKER%)
pearl-gpu-miner.exe --wallet %WALLET% --worker %WORKER%
echo.
echo Miner stopped.
pause
