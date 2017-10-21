@echo off

:: Test small string
echo unicorn| %~dp0target\%TARGET%\release\copy.exe
%~dp0target\%TARGET%\release\paste.exe > temp.txt
set /p VAR=<temp.txt

if "%VAR%" NEQ "unicorn" (
	echo "<%VAR%> is not equal <unicorn>"
	EXIT /B 1
)


:: Test big string
:: Create file with 2 bytes
echo.>big.txt

:: Expand to 1 KB
for /L %%i in (1, 1, 9) do type big.txt>>big.txt

:: Expand to 1 MB
for /L %%i in (1, 1, 10) do type big.txt>>big.txt

%~dp0target\%TARGET%\release\copy.exe < big.txt
%~dp0target\%TARGET%\release\paste.exe > temp.txt

fc /b big.txt temp.txt > nul
if errorlevel 1 (
	echo "big.txt content is not equal after paste"
	EXIT /B 1
)

:: Test multiline string
echo Hello>multiline.txt
echo Lines>>multiline.txt

%~dp0target\%TARGET%\release\copy.exe < multiline.txt
%~dp0target\%TARGET%\release\paste.exe > temp.txt

fc /b multiline.txt temp.txt > nul
if errorlevel 1 (
	echo "multiline.txt content is not equal after paste"
	EXIT /B 1
)

:: Test unicode string
echo ĀāĂăĄąĆćĈĉĊċČčĎ ፰፱፲፳፴፵፶፷፸፹፺፻፼ æøå ± 你好 🦄❤️🤘🐑💩 >unicode.txt

%~dp0target\%TARGET%\release\copy.exe < unicode.txt
%~dp0target\%TARGET%\release\paste.exe > temp.txt

fc /b unicode.txt temp.txt > nul
if errorlevel 1 (
	echo "unicode.txt content is not equal after paste"
	EXIT /B 1
)

echo "✅ Tests ok"