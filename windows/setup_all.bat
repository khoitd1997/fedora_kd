REM basically a wrapper script to call powershell
powershell -noprofile -command "&{ start-process powershell -ArgumentList '-executionpolicy remotesigned -noprofile -file %~dp0\setup_all.ps1' -verb RunAs}"