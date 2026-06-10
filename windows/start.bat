@echo off
REM ============================================================
REM  tw-pearl-miner (Windows) - edit WALLET and POOL below, then
REM  run this file (double-click, or run from a terminal). Keep it
REM  next to pearl-gpu-miner.exe + the two .dll files.
REM
REM  POOL is REQUIRED - this miner has no built-in pool. Set it to
REM  your mining pool's host:port. For a pool that needs an explicit
REM  transport, prefix the scheme, e.g.:
REM      set "POOL=stratum+ssl://your.pool.host:port"
REM      set "POOL=stratum+tcp://your.pool.host:port"
REM ============================================================
setlocal
REM ---- your settings ----
set "WALLET=YOUR_PRL_WALLET_ADDRESS"
set "POOL=YOUR_POOL_HOST:PORT"
set "WORKER=%COMPUTERNAME%"
REM -----------------------

cd /d "%~dp0"
if "%WALLET%"=="YOUR_PRL_WALLET_ADDRESS" set /p WALLET=Enter your prl1... wallet address:
if "%WALLET%"=="" ( echo No wallet entered - exiting. & pause & exit /b 1 )
if "%POOL%"=="YOUR_POOL_HOST:PORT" set /p POOL=Enter your pool host:port:
if "%POOL%"=="" ( echo No pool entered - exiting. & pause & exit /b 1 )
echo.
echo Starting tw-pearl-miner  (pool: %POOL%, worker: %WORKER%)
pearl-gpu-miner.exe --pool %POOL% --wallet %WALLET% --worker %WORKER%
echo.
echo Miner stopped.
pause
