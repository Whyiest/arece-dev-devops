import platform
import subprocess

def get_os_info():
    return platform.system(), platform.release()

def get_gpu_info():
    os_system = platform.system()
    try:
        if os_system == "Windows":
            return subprocess.check_output("wmic path win32_VideoController get name", shell=True).decode()
        elif os_system == "Darwin":
            return subprocess.check_output("system_profiler SPDisplaysDataType | grep 'Chipset Model:'", shell=True).decode()
        elif os_system == "Linux":
            return subprocess.check_output("lspci | grep VGA", shell=True).decode()
        else:
            return "Unknown OS or Unsupported GPU Detection"
    except subprocess.CalledProcessError:
        return "GPU information not retrievable"

if __name__ == "__main__":
    os_name, os_version = get_os_info()
    gpu_info = get_gpu_info()

    print(f"Operating System: {os_name} {os_version}")
    print(f"GPU Information: {gpu_info}")
