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
    apple_graphics = []

    i = 0
    while i < len(lines):
        line = lines[i]

        if "NVIDIA" in line or "AMD" in line:
            dedicated_gpu = line
        elif "Intel" in line and "Graphics" in line:
            integrated_gpu = line
        elif "AMD" in line and "Graphics" in line:
            dedicated_gpu = line
        elif "Apple" in line:
            # Récupérer les trois lignes spécifiques pour la puce Apple M1
            apple_graphics.extend(lines[i:i+3])

        i += 1

    return dedicated_gpu or integrated_gpu or apple_graphics or "No GPU information found."

if __name__ == "__main__":
    os_info = get_os_info()
    print(f"Operating System: {os_info}")

    graphics_card_info = get_graphics_card_info()
    print("\nGraphics Card Information:")
    parsed_graphics_info = parse_graphics_info(graphics_card_info)

    if isinstance(parsed_graphics_info, list):
        for line in parsed_graphics_info:
            print(line)
    else:
        print(parsed_graphics_info)
