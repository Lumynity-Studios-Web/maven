@echo off
title Add Jar To Maven
goto in1

:invalidInput
cls 
echo Invalid path or file name was entered. Current directory and variables have been reset.
echo Entered: %directory%%file%.jar
echo.
goto :in1

:autogenerate
::load from file
(
   set /p directory=
   set /p file=
   set /p name=
   set /p version=
   set /p group_id=
   set /p artifact_id=
)<autogenerate.txt
if exist "%directory%%file%.jar" (
   cd /D "%directory%"
   goto :genJarArtifacts
) else (
   goto :invalidInput
)

:in1
cd /D %~dp0
if exist autogenerate.txt goto :autogenerate
echo %cd%
echo.

set /p directory="Path: "
set /p file="File Name: "

if exist "%directory%%file%.jar" (
   cd /D "%directory%"
   goto :in2
) else (
   goto :invalidInput
)

:in2
set /p name="Name: "
set /p version="Version: "
set /p group_id="Group ID: "
set /p artifact_id="Artifact ID: "
REM TODO: check all to make sure they're not empty
goto :genJarArtifacts

:genJarArtifacts
powershell -c "(Get-FileHash -Algorithm MD5 '%file%.jar').Hash.ToLower() | Out-File -NoNewline '%file%.jar.md5'"
powershell -c "(Get-FileHash -Algorithm SHA1 '%file%.jar').Hash.ToLower() | Out-File -NoNewline '%file%.jar.sha1'"
powershell -c "(Get-FileHash -Algorithm SHA256 '%file%.jar').Hash.ToLower() | Out-File -NoNewline '%file%.jar.sha256'"
goto :genPom

:genPom
(
   echo ^<?xml version="1.0" encoding="UTF-8"?^>
   echo ^<project^>
   echo   ^<modelVersion^>4.0.0^</modelVersion^>
   echo   ^<name^>%name%^</name^>
   echo   ^<version^>%version%^</version^>
   echo   ^<groupId^>%group_id%^</groupId^>
   echo   ^<artifactId^>%artifact_id%^</artifactId^>
   echo   ^<packaging^>jar^</packaging^>
   echo ^</project^>
)>"%file%.pom"
goto :genPomArtifacts

:genPomArtifacts
powershell -c "(Get-FileHash -Algorithm MD5 '%file%.pom').Hash.ToLower() | Out-File -NoNewline '%file%.pom.md5'"
powershell -c "(Get-FileHash -Algorithm SHA1 '%file%.pom').Hash.ToLower() | Out-File -NoNewline '%file%.pom.sha1'"
powershell -c "(Get-FileHash -Algorithm SHA256 '%file%.pom').Hash.ToLower() | Out-File -NoNewline '%file%.pom.sha256'"
goto :treeAndExist

:treeAndExit
tree /f 
pause >nul
exit