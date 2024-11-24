@echo off
REM Nastavi lokalni disk C, kjer so bo odvijal ves proces pretvarjanja
SET C_DISK=C:
REM Nastavi takoimenovani mrezni disk m, kjer so locirane daoteke ki se backupirajo
SET M_DISK=M:
REM   http  repo.msys2.org/distrib/x86_64/msys2-x86_64-20200629.exe
REM   2024   msys2-x86_64-20240727.exe
SET MSYS2=%C_DISK%\Osebno\SavliM86\util\msys64\usr\bin
SET SED="%MSYS2%\sed.exe"
SET XMLLINT=M:\SloKJVA\xml_test\xmllint.exe
SET WGET="C:\Osebno\SavliM86\util\msys64\usr\bin\wget.exe"
echo.
echo    Najprej pobrisem prejsnje module...
rmdir /S /Q c:\Temp\sword\sword\                   2>NUL

REM %WGET% http://www.crosswire.org/OSIS/teiP5osis.2.5.0.xsd
REM %XMLLINT% --noout --schema teiP5osis.2.5.0.xsd c:\temp\sword M:\Strong\strongshebrew-master\strongshebrew-master\tei\slostronghebrew.tei.xml


%C_DISK%                                           2>NUL
cd %C_DISK%\temp                                   2>NUL
mkdir sword\modules\lexdict\zld\strongshebrew 2>NUL
rem dir

c:\temp\sword\tei2mod.exe sword/modules/lexdict/zld/strongshebrew/ m:\Strong\strongshebrew-master\strongshebrew-master\merged_strongshebrew.tei.xml -z

mkdir c:\temp\sword\mods.d
copy M:\Strong\strongshebrew-master\strongshebrew.conf c:\temp\sword\mods.d

M:                                                 2>NUL
cd m:\Strong\strongshebrew-master                   2>NUL

pause
pause