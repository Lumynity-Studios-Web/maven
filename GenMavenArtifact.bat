@echo off
title Add Jar To Maven

:start
cd /D "%~dp0"

if exist autogenerate.txt (
    (
        set /p artifact_subpath=
        set /p artifact_name=
        set /p artifact_version=
        set /p artifact_subgroup=
        set /p artifact_id=
    )<autogenerate.txt
    goto :confirm
)

echo.
echo SUBPATH
echo *Destination inside net\lumynitystudios\
set /p artifact_subpath=">> "
echo.
echo ARTIFACT FILE NAME
echo *Without extension
set /p artifact_name=">> "
echo.
echo VERSION
set /p artifact_version=">> "
echo.
echo SUBGROUP
echo *Leave blank for none
set /p artifact_subgroup=">> "
echo.
echo ARTIFACT ID
set /p artifact_id=">> "

:confirm
if "%artifact_subgroup%" == "" (
    set full_group=net.lumynitystudios
) else (
    set full_group=net.lumynitystudios.%artifact_subgroup%
)

set source_file=jars\%artifact_name%.jar
set artifact_dest=net\lumynitystudios\%artifact_subpath%

echo.
echo Source: %source_file%
echo Dest: %artifact_dest%
echo Group: %full_group%
echo Artifact: %artifact_id%
echo Version: %artifact_version%
echo Coord: %full_group%:%artifact_id%:%artifact_version%
echo.

set /p verify="Confirm? [y/n]: "
if /i "%verify%" == "y" goto :build
goto :start

:build
echo Installing...
call mvn install:install-file -DgroupId=%full_group% -DartifactId=%artifact_id% -Dversion=%artifact_version% -Dfile="%source_file%" -Dpackaging=jar -DlocalRepositoryPath=. -DcreateChecksum=true -DgeneratePom=true
if exist "%artifact_dest%maven-metadata-local.xml" (
    copy "%artifact_dest%maven-metadata-local.xml" "%artifact_dest%maven-metadata.xml"
    del "%artifact_dest%maven-metadata-local.xml"
)

echo Generating checksums...
set jar_file=%artifact_dest%%artifact_id%-%artifact_version%.jar
set pom_file=%artifact_dest%%artifact_id%-%artifact_version%.pom

powershell -c "(Get-FileHash -Algorithm MD5 '%jar_file%').Hash.ToLower() | Out-File -NoNewline '%jar_file%.md5'"
powershell -c "(Get-FileHash -Algorithm SHA1 '%jar_file%').Hash.ToLower() | Out-File -NoNewline '%jar_file%.sha1'"
powershell -c "(Get-FileHash -Algorithm SHA256 '%jar_file%').Hash.ToLower() | Out-File -NoNewline '%jar_file%.sha256'"

powershell -c "(Get-FileHash -Algorithm MD5 '%pom_file%').Hash.ToLower() | Out-File -NoNewline '%pom_file%.md5'"
powershell -c "(Get-FileHash -Algorithm SHA1 '%pom_file%').Hash.ToLower() | Out-File -NoNewline '%pom_file%.sha1'"
powershell -c "(Get-FileHash -Algorithm SHA256 '%pom_file%').Hash.ToLower() | Out-File -NoNewline '%pom_file%.sha256'"

echo Done!
pause >nul
exit