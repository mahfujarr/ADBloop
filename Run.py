import subprocess
import time

def command(package_name):
  command = f"adb shell appops set {package_name} RUN_ANY_IN_BACKGROUND ignore"
  try:
    output = subprocess.check_output(command, shell=True, text=True)
    if output == "":
      print(f"{package_name} --> RESTRICTED")
    else:
      print(f"{output}")
  except subprocess.CalledProcessError as e:
    print(f"Error running command for {package_name}: {e}")

def main():
  with open('apps.txt', 'r') as f:
    line_count = len(f.readlines())
    print(f"You have {line_count} packages in the file\n\n")
  with open('apps.txt', 'r') as f:
    package_names = f.read().splitlines()
    n = 0

    for package_name in package_names:
      command(package_name)
      print(f"{(n/line_count)*100:.1f}% completed", end='\r')
      n += 1
      time.sleep(0.1)

if __name__ == "__main__":
  main()
