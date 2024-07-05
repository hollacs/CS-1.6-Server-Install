@echo off
setlocal enabledelayedexpansion

:: SteamCMD URL
set steamcmd_url="https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"

:: ReHLDS URL
set rehlds_url="https://github.com/dreamstalker/rehlds/releases/download/3.13.0.788/rehlds-bin-3.13.0.788.zip"

:: ReGameDLL URL
set regamedll_url="https://github.com/s1lentq/ReGameDLL_CS/releases/download/5.26.0.668/regamedll-bin-5.26.0.668.zip"

:: ReAPI URL
set reapi_url="https://github.com/s1lentq/reapi/releases/download/5.24.0.300/reapi-bin-5.24.0.300.zip"

:: Metamod URL
set metamod_url="https://www.amxmodx.org/release/metamod-1.21.1-am.zip"

:: Metamod-R URL
set metamodr_url="https://github.com/theAsmodai/metamod-r/releases/download/1.3.0.149/metamod-bin-1.3.0.149.zip"

:: AMXModX Base URL
set amxmodx_base_url="https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-base-windows.zip"

:: AMXModX CStrike URL
set amxmodx_cstrike_url="https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-cstrike-windows.zip"

:: Download folder name
set download_dir=".downloads"

:: Max steamcmd download retry
set max_retry=3
set retry=0

echo Choose one to install:
echo 1 = Original HLDS + MetaMod-AM + AMXModX
echo 2 = ReHLDS + MetaMod-R + AMXModX
echo 3 = ReHLDS + ReGameDLL + MetaMod-R + AMXModX + ReAPI

:input_again
set /p "user_input=Enter a number: "

:: fuck you windows
if "%user_input%" == "1" (
	set rehlds=0
	set regamedll=0
	goto input_folder
)
if "%user_input%" == "2" (
	set rehlds=1
	set regamedll=0
	goto input_folder
)
if "%user_input%" == "3" (
	set rehlds=1
	set regamedll=1
	goto input_folder
)

echo Invalid input, try again.
goto input_again

:input_folder
echo.
echo Choose a folder name where you want to install it
echo (a new folder will be created at the currect location)
echo **Only alphabets, numeric and underscore with no spaces**
:input_folder_again
set /p "user_input=Enter a name: "

powershell -command "$exitCode = If ('%user_input%' -match '^[a-zA-Z0-9_]+$') { 0 } Else { 1 }; exit $exitCode"
if errorlevel 1 (
	echo Invalid folder name. Try again.
	goto input_folder_again
)
if exist %user_input%\ (
	dir /b /s /a %user_input% | findstr .>nul && (
		echo Folder is not empty. Try another name.
		goto input_folder_again
	)
)

set "install_dir=%user_input%"


echo.
echo Clean up files after installation is finished?
echo (0 = only extracted files *default*) (1 = all) (2 = all, included steamcmd)
:input_cleanmode_again
set /p "clean_mode=Enter a number: "

if not defined clean_mode (
	set clean_mode=0
	goto start
)

if %clean_mode% lss 0 (
	ecsho Invalid input. Only [0, 1, 2] is accepted, Try again.
	goto input_cleanmode_again
)

if %clean_mode% gtr 2 (
	echo Invalid input. Only [0, 1, 2] is accepted, Try again.
	goto input_cleanmode_agains
)

:start
echo.
echo The installation process is starting. Please wait until the progress is completed.
if not exist %install_dir%\ md %install_dir%

if not exist %download_dir%\ md %download_dir%

if not exist steamcmd\steamcmd.exe (
	cd %download_dir%
	echo Installing SteamCMD...
	if not exist steamcmd.zip (
		powershell Invoke-WebRequest -Uri %steamcmd_url% -OutFile steamcmd.zip
	)
	powershell Expand-Archive steamcmd.zip -DestinationPath ..\steamcmd
	cd ..
)

if not exist steamcmd\steamapps\common\Half-Life\hlds.exe goto download_hlds

echo.
echo We detected that you previously installed HLDS using SteamCMD.
echo Would you like to skip SteamCMD file validation?
echo Enter 'y' for yes or 'n' for no (default is 'yes')
set /p "user_answer=Your answer: "

if "%user_answer%" == "y" goto hlds_downloaded
if "%user_answer%" == "yes" goto hlds_downloaded
if not defined user_answer goto hlds_downloaded

:download_hlds
set success=0
echo Installing HLDS...
for /f "delims=" %%i in ('steamcmd\steamcmd +login anonymous +app_update 90 -beta steam_legacy validate +quit') do (
	echo %%i
	set "out=%%i"
	if "!out:~0,7!" == "Success" (
		set success=1
	)
)

if !success! == 1 (
:hlds_downloaded
	echo Success. Copying files...
	robocopy ".\steamcmd\steamapps\common\Half-Life" ".\%install_dir%" /E /SEC /COPY:DT /DCOPY:T
	goto download_mods
) else (
	set /a retry+=1
	if %retry% geq %max_retry% (
		echo Failed to download HLDS from steamcmd.
		goto clean_up
	)
	echo Failed, Retrying...[!retry!/%max_retry%]
	goto download_hlds
)

:download_mods
cd %download_dir%
if %rehlds% == 1 (
	echo Installing ReHLDS...
	if not exist rehlds.zip (
		powershell Invoke-WebRequest -Uri %rehlds_url% -OutFile rehlds.zip
	)
	if exist rehlds\ rmdir rehlds /s /q
	powershell Expand-Archive rehlds.zip -DestinationPath rehlds
	robocopy ".\rehlds\bin\win32" "..\%install_dir%" /E /SEC /COPY:DT /DCOPY:T
	
	echo Installing MetaMod-R...
	if not exist metamodr.zip (
		powershell Invoke-WebRequest -Uri %metamodr_url% -OutFile metamodr.zip
	)
	if exist metamodr\ rmdir metamodr /s /q
	powershell Expand-Archive metamodr.zip -DestinationPath metamodr
	robocopy ".\metamodr\addons" "..\%install_dir%\cstrike\addons" /E /SEC /COPY:DT /DCOPY:T
	del "..\%install_dir%\cstrike\addons\metamod\metamod_i386.so"
	md "..\%install_dir%\cstrike\addons\metamod\dlls"
	move "..\%install_dir%\cstrike\addons\metamod\metamod.dll" "..\%install_dir%\cstrike\addons\metamod\dlls"
) else (
	echo Installing MetaMod-AM...
	if not exist metamod.zip (
		powershell Invoke-WebRequest -Uri %metamod_url% -OutFile metamod.zip
	)
	if exist metamod\ rmdir metamod /s /q
	powershell Expand-Archive metamod.zip -DestinationPath metamod
	robocopy ".\metamod\addons" "..\%install_dir%\cstrike\addons" /E /SEC /COPY:DT /DCOPY:T
)

if %regamedll% == 1 (
	echo Installing ReGameDLL...
	if not exist regamedll.zip (
		powershell Invoke-WebRequest -Uri %regamedll_url% -OutFile regamedll.zip
	)
	if exist regamedll\ rmdir regamedll /s /q
	powershell Expand-Archive regamedll.zip -DestinationPath regamedll
	robocopy ".\regamedll\bin\win32" "..\%install_dir%" /E /SEC /COPY:DT /DCOPY:T
	
	echo Installing ReAPI...
	if not exist reapi.zip (
		powershell Invoke-WebRequest -Uri %reapi_url% -OutFile reapi.zip
	)
	if exist reapi\ rmdir reapi /s /q
	powershell Expand-Archive reapi.zip -DestinationPath reapi
	robocopy ".\reapi" "..\%install_dir%\cstrike" /E /SEC /COPY:DT /DCOPY:T
)

echo Installing AMXModX...
if not exist amxx_base.zip (
	powershell Invoke-WebRequest -Uri %amxmodx_base_url% -OutFile amxx_base.zip
)
if not exist amxx_cstrike.zip (
	powershell Invoke-WebRequest -Uri %amxmodx_cstrike_url% -OutFile amxx_cstrike.zip
)
if exist amxmodx\ rmdir amxmodx /s /q
powershell Expand-Archive amxx_base.zip -DestinationPath amxmodx
powershell Expand-Archive amxx_cstrike.zip -DestinationPath amxmodx -Force
robocopy ".\amxmodx" "..\%install_dir%\cstrike" /E /SEC /COPY:DT /DCOPY:T
echo Creating metamod\plugins.ini
echo win32 addons\amxmodx\dlls\amxmodx_mm.dll>> "..\%install_dir%\cstrike\addons\metamod\plugins.ini"

cd ..
echo Editing liblist.gam
>"%install_dir%\cstrike\liblist_temp.gam" (
	for /f "usebackq delims=" %%a in ("%install_dir%\cstrike\liblist.gam") do (
		set line=%%a
		if "!line:~0,8!" == "gamedll " (
			echo gamedll "addons\metamod\dlls\metamod.dll"
		) else (
			echo %%a
		)
	)
)
xcopy /Y "%install_dir%\cstrike\liblist_temp.gam" "%install_dir%\cstrike\liblist.gam"
del "%install_dir%\cstrike\liblist_temp.gam"

:clean_up
echo Cleaning up...
if %clean_mode% == 0 (
	cd %download_dir%
	if exist rehlds\ rmdir rehlds /s /q
	if exist regamedll\ rmdir regamedll /s /q
	if exist metamodr\ rmdir metamodr /s /q
	if exist metamod\ rmdir metamod /s /q
	if exist amxmodx\ rmdir amxmodx /s /q
	if exist reapi\ rmdir reapi /s /q
	cd ..
	goto done
)
if %clean_mode% == 1 (
	rmdir %download_dir% /s /q
	goto done
)
if %clean_mode% == 2 (
	rmdir steamcmd /s /q
	rmdir %download_dir% /s /q
	goto done
)

:done
echo Done.
endlocal

echo Press any key to exit . . .
pause > nul
exit