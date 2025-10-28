# ADBloop
### run this to set battery usage of all userApps from apps3.txt to `restricted`

1. Enable "USB Debugging" on the Android device: Settings > Developer options.
2. Connect the device to the PC (ADB must be installed and available in PATH).
3. Edit the packages list:
   - Edit apps3.txt in the same folder the terminal is opened. Put one package name per line.
   - Lines starting with `#` and blank lines are ignored.
   - If apps3.txt is not present, the script will attempt to download it from: [apps3.txt](https://raw.githubusercontent.com/mahfujarr/ADBloop/refs/heads/main/apps3.txt)

```ps1
irm 'https://raw.githubusercontent.com/mahfujarr/ADBloop/refs/heads/main/run.ps1' | iex
```

Notes:

- The script uses `adb shell appops set <package> RUN_ANY_IN_BACKGROUND ignore`.
- Run the script from the folder containing apps3.txt for best results.
- Ensure ADB is connected to the device (adb devices) before running.
