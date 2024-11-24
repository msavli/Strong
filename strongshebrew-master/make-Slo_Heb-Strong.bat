@echo off

echo.
echo   ==========================================================
echo   ====== Izdelava datoteke za v prevajanje na deepl  =======
echo   ==========================================================
echo.


SET DATOTEKA_PRED_PREVAJANJEM=slostrongshebrew.tei.xml
SET DATOTEKA_OD_TADEJA=strongshebrew-masterprevedeno.txt
SET DATOTEKA_PO_PREVAJANJU=slostrongshebrew.tei.xml
REM Nastavi lokalni disk C, kjer so bo odvijal ves proces pretvarjanja
SET C_DISK=C:
REM   http  repo.msys2.org/distrib/x86_64/msys2-x86_64-20200629.exe
REM   2024   msys2-x86_64-20240727.exe
SET MSYS2=%C_DISK%\Osebno\SavliM86\util\msys64\usr\bin
SET SED="%MSYS2%\sed.exe"
SET AWK="%MSYS2%\awk.exe"
SET GREP="%MSYS2%\grep.exe"
SET DIFF="C:\Osebno\SavliM86\util\Cygwin64\bin\diff.exe"
SET NOTEPAD="%C_DISK%\Program Files\Notepad++\Notepad++.exe"
REM Nastavi takoimenovani mrezni disk m, kjer so locirane daoteke ki se backupirajo
SET M_DISK=M:
SET XMLLINT=M:\SloKJVA\xml_test\xmllint.exe
SET WGET="C:\Osebno\SavliM86\util\msys64\usr\bin\wget.exe"

REM goto PO_PREVODU
goto PREVAJANJE

copy /Y strongshebrew.tei.xml %DATOTEKA_PRED_PREVAJANJEM%





echo  Replace every tab character (\t) with four spaces in the %DATOTEKA_PRED_PREVAJANJEM%
%SED% -i "s/\t/    /g" %DATOTEKA_PRED_PREVAJANJEM%

echo  Sed command to remove the first 26 lines from the file %DATOTEKA_PRED_PREVAJANJEM%:
%SED% -i '1,26d' %DATOTEKA_PRED_PREVAJANJEM%

echo  Remove the last 3 lines from the file %DATOTEKA_PRED_PREVAJANJEM%
%SED% -i "$d" %DATOTEKA_PRED_PREVAJANJEM%
%SED% -i "$d" %DATOTEKA_PRED_PREVAJANJEM%
%SED% -i "$d" %DATOTEKA_PRED_PREVAJANJEM%

REM 1   ======= Tabela pretvorb ================
REM 2   ____<entryFree n="2">                    -> XY2YX
REM 3   ________<orth>                           -> XYR
REM 4   </orth>                                  -> XYL
REM 5   ________<orth type="trans" rend="bold">  -> XYD
REM 6   </orth>                                  -> XYT
REM 7   ________<pron rend="italic">             -> XYC
REM 8   </pron><lb/>                             -> XYN
REM 9   ________<def>                            -> XYF
REM 10  <lb/>		                             -> _XYBL_
REM 11  <hi rend="italic">                       -> _XYHT_
REM 12  </hi>                                    -> _XYHTC_
REM 13  _<hi rend="bold">_                       -> XYMD
REM 14  _</hi>_                                  -> XYDHY
REM 15  _</def>                                  -> XYFD
REM 16  <ref target="StrongsHebrew:22">H22</ref>_-> XWT  ... TWX
REM 17  </entryFree>                             -> XZTY
REM 18  <hi rend="super">                        -> _XYU_
REM 19 <ref osisRef="                            -> XYWYX
REM 20   ">                                      -> XYQYX
REM    ========================================

echo Pretvorbe
echo 1
%SED% -i "s/    <entryFree n=\"\([0-9]*\)\">/XY\1YX/g" %DATOTEKA_PRED_PREVAJANJEM%
echo 2
%SED% -i "s/        <orth>/XYR/g" %DATOTEKA_PRED_PREVAJANJEM%
echo 3
%SED% -i "s/<\/orth>/XYL/g" %DATOTEKA_PRED_PREVAJANJEM%
echo 4
%SED% -i "s/        <orth type=\"trans\" rend=\"bold\">/XYD/g" %DATOTEKA_PRED_PREVAJANJEM%
echo 5
%SED% -i "s/<\/orth>/XYT/g" %DATOTEKA_PRED_PREVAJANJEM%
echo 6
%SED% -i "s/        <pron rend=\"italic\">/XYC/g" %DATOTEKA_PRED_PREVAJANJEM%
echo 7
%SED% -i "s/<\/pron><lb\/>/XYN/g" %DATOTEKA_PRED_PREVAJANJEM%
echo 8
%SED% -i "s/        <def>/XYF /g" %DATOTEKA_PRED_PREVAJANJEM%
echo 9
%SED% -i "s/<lb\/>/ XYBL /g" %DATOTEKA_PRED_PREVAJANJEM%
echo 11
%SED% -i "s/<\/hi>/ XYHTC /g" %DATOTEKA_PRED_PREVAJANJEM%
echo 10
%SED% -i "s/<hi rend=\"italic\">/ XYHT /g" %DATOTEKA_PRED_PREVAJANJEM%
echo 12
%SED% -i "s/<hi rend=\"bold\">/ XYMD /g" %DATOTEKA_PRED_PREVAJANJEM%
echo 13
%SED% -i "s/<\/hi>/ XYDHY /g" %DATOTEKA_PRED_PREVAJANJEM%
echo 14
%SED% -i "s/<\/def>/ XYFD /g" %DATOTEKA_PRED_PREVAJANJEM%
echo 15
%SED% -i "s/<ref target=\\\"StrongsHebrew:\\([0-9]*\\)\\\">H\\([0-9]*\\)<\\/ref>/XWT\\1TWX/g" %DATOTEKA_PRED_PREVAJANJEM%
echo 16
%SED% -i "s/<\/ref>/ XWSR /g" %DATOTEKA_PRED_PREVAJANJEM%
echo 17
%SED% -i "s/    <\/entryFree>/XZTY/g" %DATOTEKA_PRED_PREVAJANJEM%
echo 18 
%SED% -i "s/<hi rend=\"super\">/ XYU /g" %DATOTEKA_PRED_PREVAJANJEM%
echo 19
%SED% -i "s/<ref osisRef=\"/XYWYX/g" %DATOTEKA_PRED_PREVAJANJEM%
echo 20
%SED% -i 's/\">/XYQYX/g' %DATOTEKA_PRED_PREVAJANJEM%

REM %GREP% "orthographical error in" %DATOTEKA_PRED_PREVAJANJEM%
REM %GREP% "{gate} {leaf} lid. " %DATOTEKA_PRED_PREVAJANJEM%


rem %NOTEPAD% %DATOTEKA_PRED_PREVAJANJEM%
pause



REM Samo za testiranje delovanja
copy /y %DATOTEKA_PRED_PREVAJANJEM% %DATOTEKA_PO_PREVAJANJU%

:PO_PREVODU
copy /y %DATOTEKA_OD_TADEJA% %DATOTEKA_PO_PREVAJANJU%

echo Doda prvotno preveden header
(type slo_header_stronghebrew.txt & type %DATOTEKA_PO_PREVAJANJU%) > temp_file && move /Y temp_file %DATOTEKA_PO_PREVAJANJU%


echo Sedaj pa pretvori nazaj
echo 1
rem %SED% -i 's/XY\([0-9]*\)YX/    <entryFree n=\"\1\">/g' %DATOTEKA_PO_PREVAJANJU%
%SED% -i "s/XY\\([0-9]*\\)YX/    <entryFree n=\\\"\\1\\\">/g" %DATOTEKA_PO_PREVAJANJU%
echo 2
%SED% -i "s/XYR/        <orth>/g" %DATOTEKA_PO_PREVAJANJU%
echo 3
%SED% -i "s/XYL/<\/orth>/g" %DATOTEKA_PO_PREVAJANJU%
echo 4
%SED% -i "s/XYD/        <orth type=\"trans\" rend=\"bold\">/g" %DATOTEKA_PO_PREVAJANJU%
echo 5
%SED% -i "s/XYT/<\/orth>/g" %DATOTEKA_PO_PREVAJANJU%
echo 6
%SED% -i "s/XYC/        <pron rend=\"italic\">/g" %DATOTEKA_PO_PREVAJANJU%
echo 7
%SED% -i "s/XYN/<\/pron><lb\/>/g" %DATOTEKA_PO_PREVAJANJU%
echo 8
%SED% -i "s/XYF /        <def>/g" %DATOTEKA_PO_PREVAJANJU%
echo 9
%SED% -i "s/XYBL/<lb\/>/g" %DATOTEKA_PO_PREVAJANJU%
echo 11
%SED% -i "s/XYHTC/<\/hi>/g" %DATOTEKA_PO_PREVAJANJU%
echo 10
%SED% -i "s/XYHT/<hi rend=\"italic\">/g" %DATOTEKA_PO_PREVAJANJU%
echo 12
%SED% -i "s/XYMD/<hi rend=\"bold\">/g" %DATOTEKA_PO_PREVAJANJU%
echo 13
%SED% -i "s/XYDHY/<\/hi>/g" %DATOTEKA_PO_PREVAJANJU%
echo 14
%SED% -i "s/XYFD/<\/def>/g" %DATOTEKA_PO_PREVAJANJU%
echo 15
%SED% -i "s/XWT\([0-9]*\)TWX/<ref target=\"StrongsHebrew:\1\">H\1<\/ref>/g" %DATOTEKA_PO_PREVAJANJU%
echo 16
%SED% -i "s/XWSR/<\/ref>/g" %DATOTEKA_PO_PREVAJANJU%
echo 17
%SED% -i "s/XZTY/    <\/entryFree>/g" %DATOTEKA_PO_PREVAJANJU%
echo 18
%SED% -i "s/XYU/<hi rend=\"super\">/g" %DATOTEKA_PO_PREVAJANJU%
echo 19
%SED% -i "s/XYWYX/<ref osisRef=\"/g" %DATOTEKA_PO_PREVAJANJU%
echo 20
%SED% -i 's/XYQYX/\"\>/g' %DATOTEKA_PO_PREVAJANJU%

REM %GREP% "orthographical error in" %DATOTEKA_PO_PREVAJANJU%
REM %GREP% "{gate} {leaf} lid. " %DATOTEKA_PO_PREVAJANJU%

echo   Doda se zadnje tri vrstice
(
echo ^</body^>
echo ^</text^>
echo ^</TEI^>
) >> %DATOTEKA_PO_PREVAJANJU%


%NOTEPAD% %DATOTEKA_PO_PREVAJANJU%


rem echo %DIFF% %DATOTEKA_PO_PREVAJANJU% strongshebrew.tei.xml
rem %DIFF% %DATOTEKA_PO_PREVAJANJU% strongshebrew.tei.xml


 
:PREVAJANJE
echo.
echo    Najprej pobrisem prejsnje module...
rmdir /S /Q c:\Temp\sword\sword\                   2>NUL

rem %WGET% http://www.crosswire.org/OSIS/teiP5osis.2.5.0.xsd
%XMLLINT% --noout --schema teiP5osis.2.5.0.xsd c:\temp\sword M:\Strong\strongshebrew-master\slostrongshebrew.tei.xml

%C_DISK%                                           2>NUL
cd %C_DISK%\temp                                   2>NUL
mkdir sword\modules\lexdict\zld\slostrongshebrew   2>NUL

c:\temp\sword\tei2mod.exe sword/modules/lexdict/zld/slostrongshebrew/ M:\Strong\strongshebrew-master\slostrongshebrew.tei.xml -z

mkdir c:\temp\sword\mods.d                         2>NUL
copy M:\Strong\strongshebrew-master\slostrongshebrew.conf c:\temp\sword\mods.d

M:                                                 2>NUL
cd m:\Strong\strongshebrew-master                  2>NUL


pause
pause
