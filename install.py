import os
import subprocess

def install_apks(apk_folder):

  for file in os.listdir(apk_folder):
    if file.endswith('.apk'):
      apk_path = os.path.join(apk_folder, file)
      print(f"Installing {apk_path}")
      try:
        result = subprocess.run(["adb", "install", apk_path], capture_output=True, text=True)
        if result.returncode == 0:
          print(f"Successfully installed {file}")
        else:
          print(f"Error installing {file}: {result.stderr}")
      except subprocess.CalledProcessError as e:
        print(f"Error executing ADB command: {e}")

if __name__ == "__main__":
  apk_folder = "mahfujarr/ADBloop"
  install_apks(apk_folder)
