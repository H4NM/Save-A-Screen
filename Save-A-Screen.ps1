$HKEY_SCREENSAVER_PATH = "HKCU:\Control Panel\Desktop"
$HKEY_DISPLAY_STRING_PATH = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Screensavers\ssText3d"
$CUSTOM_COLOR_VALUES = @("27ed01", "ed01ec", "ed8301", "017ced", "f1f400") #Green, Pink, Orange, Blue, Yellow


function set_custom_screen_saver {
    Set-ItemProperty -Path $HKEY_DISPLAY_STRING_PATH -Name "RotationSpeed" -Value 1          
    Set-ItemProperty -Path $HKEY_DISPLAY_STRING_PATH -Name "RotationStyle" -Value 0
    Set-ItemProperty -Path $HKEY_DISPLAY_STRING_PATH -Name "SurfaceType" -Value 1
    Set-ItemProperty -Path $HKEY_DISPLAY_STRING_PATH -Name "Size" -Value "a" #10
    Set-ItemProperty -Path $HKEY_DISPLAY_STRING_PATH -Name "FontFace" -Value "Comic Sans MS"

    $todays_date = $(Get-Date)
    $DAY = $todays_date.Day
    $MONTH = $todays_date.Month
    $HOUR = $todays_date.Hour
    $MINUTE = $todays_date.Minute
    $WEEKDAY = $todays_date.DayOfWeek

    Set-ItemProperty -Path $HKEY_DISPLAY_STRING_PATH -Name "SurfaceColor" -Value $(Get-Random -InputObject $CUSTOM_COLOR_VALUES)
    Set-ItemProperty -Path $HKEY_DISPLAY_STRING_PATH -Name "DisplayString" -Value "$DAY/$MONTH $WEEKDAY"  
}


function scrnsave_exe_exists{
    try {

        Get-ItemProperty -Path $HKEY_SCREENSAVER_PATH | Select-Object -ExpandProperty "SCRNSAVE.EXE" -ErrorAction Stop | Out-Null 
        return $true 
        }catch {
        return $false
        }
}


echo "[~] Checking if screen saver is active"
$screen_saver_status=$(Get-ItemPropertyValue -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveActive")


if (-not(scrnsave_exe_exists)){
    echo "[!] Screen saver binary key was not present. Adding it.."
    New-ItemProperty -Path $HKEY_SCREENSAVER_PATH -Name "SCRNSAVE.EXE" -Value "C:\WINDOWS\system32\ssText3d.scr"
}else{
    Set-ItemProperty -Path $HKEY_SCREENSAVER_PATH -Name "SCRNSAVE.EXE" -Value "C:\WINDOWS\system32\ssText3d.scr"
}

if ($screen_saver_status -ne 1){
    echo "[!] Screen saver is not active. Activating screensaver."
    Set-ItemProperty -Path $HKEY_SCREENSAVER_PATH -Name "ScreenSaveActive" -Value 1
    Set-ItemProperty -Path $HKEY_SCREENSAVER_PATH -Name "ScreenSaveTimeOut" -Value 60
}else{
    echo "[~] Screen saver is active!"
}

echo "[!] Updating screen saver text"
set_custom_screen_saver

