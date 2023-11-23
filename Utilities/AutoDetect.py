import platform
import subprocess


def get_os_info():
    return platform.system()


def get_graphics_card_info():
    try:
        if platform.system() == "Windows":
            # For Windows, you can use WMIC command
            result = subprocess.run(["wmic", "path", "win32_videocontroller", "get", "caption"], capture_output=True,
                                    text=True)
            return result.stdout.strip()
        elif platform.system() == "Darwin":
            # For macOS, you can use system_profiler
            result = subprocess.run(["system_profiler", "SPDisplaysDataType"], capture_output=True, text=True)
            return result.stdout.strip()
        elif platform.system() == "Linux":
            # For Linux, you can use lspci command
            result = subprocess.run(["lspci", "-nnk", "|", "grep", "-A", "2", "VGA"], shell=True, capture_output=True,
                                    text=True)
            return result.stdout.strip()
        else:
            return "Unsupported platform"

    except Exception as e:
        return f"Error getting GPU information: {e}"


def parse_graphics_info(graphics_info):
    lines = graphics_info.splitlines()

    integrated_gpu = None
    dedicated_gpu = None
    apple_graphics = None

    i = 0
    while i < len(lines):
        line = lines[i]

        if "NVIDIA" in line and "Graphics" in line:
            dedicated_gpu = "NVIDIA"
        elif "AMD" in line and "Graphics" in line:
            dedicated_gpu = "AMD"
        elif "Intel" in line and "Graphics" in line:
            integrated_gpu = "INTEL"
        elif "Apple" in line:
            apple_graphics = "APPLE"
        i += 1
    return dedicated_gpu or apple_graphics or integrated_gpu or "No GPU information found."


if __name__ == "__main__":
    os_info = get_os_info()
    # print(f"Operating System: {os_info}")

    graphics_card_info = get_graphics_card_info()
    # print("\nGraphics Card Information:")
    parsed_graphics_info = parse_graphics_info(graphics_card_info)
    print(parsed_graphics_info)
