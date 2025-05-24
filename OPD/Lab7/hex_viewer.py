import sys
import time


def load_hex_frames(hex_file_path):
    """Загружает HEX-кадры из файла."""
    with open(hex_file_path, 'r') as f:
        lines = f.readlines()

    # Каждый кадр состоит из 10 байт (по одному на столбец шириной 10)
    frames = []
    current_frame = []

    for line in lines:
        line = line.strip()
        if not line:
            continue

        hex_bytes = line.split()
        current_frame.extend(hex_bytes)

        # Если собрали 10 байт (ширина кадра), формируем кадр
        if len(current_frame) == 10:
            frames.append(current_frame)
            current_frame = []

    return frames


def print_frame(frame):
    """Выводит кадр в консоль в виде ASCII-графики."""
    for y in range(8):  # 8 строк (высота кадра)
        for x in range(10):  # 10 столбцов (ширина кадра)
            hex_byte = frame[x]
            pixel_value = int(hex_byte, 16) & (1 << y)  # Получаем бит для y-й строки
            char = '##' if pixel_value else '..'
            print(char, end='')
        print()  # Новая строка


def main(hex_file_path):
    frames = load_hex_frames(hex_file_path)
    if not frames:
        print("В файле нет кадров!", file=sys.stderr)
        return

    current_frame_idx = 0
    total_frames = len(frames)

    print(f"Загружено {total_frames} кадров. Нажимайте Enter для просмотра следующего кадра.")

    while current_frame_idx < total_frames:
        time.sleep(0.25)
        print(f"\nКадр {current_frame_idx + 1}/{total_frames}:")
        print_frame(frames[current_frame_idx])
        current_frame_idx += 1

    print("Все кадры показаны.")


if __name__ == "__main__":
    # if len(sys.argv) != 2:
    #     print("Использование: python show_hex_frames.py <файл.hex>")
    #     sys.exit(1)

    hex_file_path = "output.hex"
    main(hex_file_path)