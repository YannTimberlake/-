@echo off
setlocal enabledelayedexpansion
 
for /f "delims=" %%i in ('dir *.ts /b ') do (
  echo file '%%i' >> files.txt
)
pause
