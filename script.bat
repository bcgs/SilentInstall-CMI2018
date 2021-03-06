@ECHO OFF
COLOR 08

REM Check if it has elevated privileges
NET SESSION >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Run it as Administrator...
    PING 127.0.0.1 >NUL 2>&1
    EXIT /B 1
)

ECHO ****************************
ECHO **        CMI 2018        **
ECHO ** Made with love by BCGS **
ECHO **************************** & ECHO.
ECHO ----------------------------
ECHO ----- Default Programs -----
ECHO ---------------------------- & ECHO.

REM Disable confirmation prompts 
ECHO Disabling UAC
REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f
REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
ECHO.

REM New variables to hold both the OS architecture and folder's new path
REG Query "HKLM\Hardware\Description\System\CentralProcessor\0" | FIND /i "x86" > NUL && SET OS=32BIT || SET OS=64BIT
IF %OS%==32BIT (SET FOLDER=System32) ELSE (SET FOLDER=SysWOW64)

REM Move the pack to (System32/SysWOW64) folder
MOVE "%~dp0_default_" %WINDIR%\%FOLDER%
SET NEWPATH=%WINDIR%\%FOLDER%\_default_

REM Pick an option
ECHO 1) Full installation
ECHO 2) Customized installation
ECHO.

SET /p uInput1=Pick one: 
IF %uInput1%==1 (
    SET uInput2=""    
    GOTO Chrome
)

ECHO.
ECHO a) Chrome
ECHO b) PeaZip
ECHO c) CDBurnerXP
ECHO d) VLC media player
ECHO e) Acrobat Read
ECHO f) Java
ECHO g) WPS Office
ECHO h) Kaspersky Free
ECHO i) Driver Booster & ECHO.
SET /p uInput2=Pick what NOT to install (e.g., bcgh):

:Chrome
IF NOT x%uInput2:a=%==x%uInput2% GOTO PeaZip
SET /p "=* Google Chrome " <NUL
REM https://enterprise.google.com/chrome/chrome-browser/
IF %OS%==32BIT (
    MSIEXEC /i %NEWPATH%\GoogleChromeStandaloneEnterprise.msi /qb!-
    IF EXIST "C:\Program Files\Google\Chrome" (ECHO (OK^)) ELSE (ECHO (Failed^))
) ELSE (
    MSIEXEC /i %NEWPATH%\GoogleChromeStandaloneEnterprise64.msi /qb!-
    IF EXIST "C:\Program Files (x86)\Google\Chrome" (ECHO (OK^)) ELSE (ECHO (Failed^))
)

:PeaZip
IF NOT x%uInput2:b=%==x%uInput2% GOTO CDBurnerXP
SET /p "=* PeaZip " <NUL
REM http://www.peazip.org/
IF %OS%==32BIT (
    START /wait %NEWPATH%\peazip-7.7.0.WINDOWS.exe /VERYSILENT
) ELSE (
    START /wait %NEWPATH%\peazip-7.7.0.WIN64.exe /VERYSILENT
)
IF EXIST "C:\Program Files\PeaZip" (ECHO (OK^)) ELSE (ECHO (Failed^))

:CDBurnerXP
IF NOT x%uInput2:c=%==x%uInput2% GOTO VLC
SET /p "=* CDBurnerXP " <NUL
REM https://cdburnerxp.se/en/download
IF %OS%==32BIT (
    START /wait %NEWPATH%\cdbxp_setup_4.5.8.7128_minimal.exe /SILENT /ACCEPTEULA=1
) ELSE (
    START /wait %NEWPATH%\cdbxp_setup_4.5.8.7128_x64_minimal.exe /SILENT /ACCEPTEULA=1
)
IF EXIST "C:\Program Files\CDBurnerXP" (ECHO (OK^)) ELSE (ECHO (Failed^))

:VLC
IF NOT x%uInput2:d=%==x%uInput2% GOTO Adobe
SET /p "=* VLC media player " <NUL
REM https://www.videolan.org/vlc/download-windows.html
IF %OS%==32BIT (
    START /wait %NEWPATH%\vlc-3.0.11-win32.exe /L=1046 /S
) ELSE (
    START /wait %NEWPATH%\vlc-3.0.11-win64.exe /L=1046 /S
)
IF EXIST "C:\Program Files\VideoLAN\VLC" (ECHO (OK^)) ELSE (ECHO (Failed^))

:Adobe
IF NOT x%uInput2:e=%==x%uInput2% GOTO Java
SET /p "=* Acrobat Reader DC " <NUL
REM https://get.adobe.com/reader/enterprise/
START /wait %NEWPATH%\AcroRdrDC1900820071_pt_BR.exe /sALL
IF %OS%==32BIT (
    IF EXIST "C:\Program Files\Adobe" (ECHO (OK^)) ELSE (ECHO (Failed^))
) ELSE (
    IF EXIST "C:\Program Files (x86)\Adobe" (ECHO (OK^)) ELSE (ECHO (Failed^))
)

:Java
IF NOT x%uInput2:f=%==x%uInput2% GOTO WPS
SET /p "=* Java " <NUL
REM https://www.java.com/en/download/manual.jsp
START /wait %NEWPATH%\jre-8u271-windows-i586.exe /s
IF %OS%==32BIT (
    IF EXIST "C:\Program Files\Java" (ECHO (OK^)) ELSE (ECHO (Failed^))
) ELSE (
    START /wait %NEWPATH%\jre-8u271-windows-x64.exe /s
    IF EXIST "C:\Program Files (x86)\Java" (
        IF EXIST "C:\Program Files\Java" (ECHO (OK^)) ELSE (ECHO (Failed^))
    ) ELSE ECHO (Failed^)
)

:WPS
IF NOT x%uInput2:g=%==x%uInput2% GOTO Kaspersky
SET /p "=* WPS Office " <NUL
REM https://www.wps.com/download/
START /wait %NEWPATH%\WPSOffice_11.2.0.9937.exe /S /ACCEPTEULA=1
IF EXIST "%UserProfile%\AppData\Local\Kingsoft\WPS Office" (ECHO (OK^)) ELSE (ECHO (Failed^))

:Kaspersky
IF NOT x%uInput2:h=%==x%uInput2% GOTO DriverBooster
SET /p "=* Kaspersky Free " <NUL
REM https://www.kaspersky.com.br/downloads/thank-you/free-antivirus-download

REM Check if .Net Framework 4.x (Kaspersky System Requirement) is already installed
REG QUERY "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" > NUL
IF %ERRORLEVEL% EQU 1 (
    START /wait %NEWPATH%\NDP471-KB4033342-x86-x64-AllOS-ENU.exe /q /norestart
)
IF %OS%==32BIT (
    START /wait %NEWPATH%\kaspersky_free_x86.exe
    IF EXIST "C:\Program Files\Kaspersky Lab\Kaspersky Free 18.0.0" (ECHO (OK^)) ELSE (ECHO (Failed^))
) ELSE (
    START /wait %NEWPATH%\kaspersky_free_x64.exe
    IF EXIST "C:\Program Files (x86)\Kaspersky Lab\Kaspersky Free 18.0.0" (ECHO (OK^)) ELSE (ECHO (Failed^))
)
ECHO.

:DriverBooster
IF NOT x%uInput2:i=%==x%uInput2% GOTO EOF
ECHO -------------------------------------------
ECHO --             ~Temp Program             --
ECHO -- Do not forget to remove it afterwards --
ECHO ------------------------------------------- & ECHO.

SET /p "=* Driver Booster " <NUL
REM https://www.iobit.com/pt/driver-booster.php
START /wait %NEWPATH%\driver_booster_setup.exe /VERYSILENT
IF %OS%==32BIT (
    IF EXIST "C:\Program Files\IObit" (ECHO (OK^)) ELSE (ECHO (Failed^))
) ELSE (
    IF EXIST "C:\Program Files (x86)\IObit" (ECHO (OK^)) ELSE (ECHO (Failed^))
)
ECHO.

:EOF
REM Re-enable confirmation prompts 
ECHO Re-enabling UAC
REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 5 /f
REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f

REM Delete folder
RD /s /q %NEWPATH%

ECHO.
PAUSE

REM Exit & delete this file
DEL "%~f0"&EXIT /B
