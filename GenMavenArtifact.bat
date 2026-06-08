@echo off
title Maven

echo %cd%
echo.

set /p path="Path: "
set /p file="File: "

powershell -c "(Get-FileHash -Algorithm MD5 '%path%%file%').Hash.ToLower() | Out-File -NoNewline '%path%%file%.md5'"
powershell -c "(Get-FileHash -Algorithm SHA1 '%path%%file%').Hash.ToLower() | Out-File -NoNewline '%path%%file%.sha1'"
powershell -c "(Get-FileHash -Algorithm SHA256 '%path%%file%').Hash.ToLower() | Out-File -NoNewline '%path%%file%.sha256'"

pause
exit

REM TODO LATER

set /p name="Name: "

:: Example
:: <?xml version="1.0" encoding="UTF-8"?>
:: <project>
::   <modelVersion>4.0.0</modelVersion>
::   <groupId>mappings.neoforge</groupId>
::   <artifactId>1.21.1</artifactId>
::   <version>mojang_intermediary_1.21.1</version>
::   <packaging>jar</packaging>
::   <name>Mojang Intermediary Mappings 1.21.1 (NeoForge)</name>
:: </project>

powershell -c "(Get-FileHash -Algorithm MD5 'mojang_intermediary_1.21.1.pom').Hash.ToLower() | Out-File -NoNewline 'mojang_intermediary_1.21.1.pom.md5'"
powershell -c "(Get-FileHash -Algorithm SHA1 'mojang_intermediary_1.21.1.pom').Hash.ToLower() | Out-File -NoNewline 'mojang_intermediary_1.21.1.pom.sha1'"
powershell -c "(Get-FileHash -Algorithm SHA256 'mojang_intermediary_1.21.1.pom').Hash.ToLower() | Out-File -NoNewline 'mojang_intermediary_1.21.1.pom.sha256'"
