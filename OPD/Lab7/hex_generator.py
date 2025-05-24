
# Да, вайбкодинг, и что вы мне сделаете?

import cv2
import numpy as np
from tqdm import tqdm  # Для прогресс-бара (установите через pip install tqdm)


def video_to_hex(input_video_path, output_hex_path):
    # Открываем видео
    cap = cv2.VideoCapture(input_video_path)

    # Получаем исходные параметры видео
    original_fps = cap.get(cv2.CAP_PROP_FPS)
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))

    # Устанавливаем новые параметры
    target_fps = 5
    target_width = 10
    target_height = 8

    # Рассчитываем шаг для выбора кадров (чтобы получить 4 FPS)
    frame_step = int(original_fps / target_fps)

    # Подготовка данных для записи
    hex_data = []

    # Обрабатываем кадры с шагом
    for frame_idx in tqdm(range(0, total_frames, frame_step)):
        cap.set(cv2.CAP_PROP_POS_FRAMES, frame_idx)
        ret, frame = cap.read()
        if not ret:
            break

        # Конвертируем в оттенки серого
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        # Изменяем размер до 10x8
        resized = cv2.resize(gray, (target_width, target_height), interpolation=cv2.INTER_AREA)

        # Бинаризация (если нужно черно-белое)
        _, binary = cv2.threshold(resized, 128, 255, cv2.THRESH_BINARY)

        # Преобразуем в шестнадцатеричный формат (по столбцам, 8 пикселей = 1 байт)
        for x in range(target_width):
            column_pixels = binary[:, x][::-1]  # Получаем столбец высотой 8 пикселей
            byte = 0
            for y in range(target_height):
                # Преобразуем пиксель в бит (0 или 1)
                bit = 1 if column_pixels[y] > 128 else 0
                byte |= (bit << y)  # Упаковываем в байт
            hex_str = f"{byte:02X}"  # Форматируем в 2 символа HEX
            hex_data.append(hex_str)

    # Закрываем видео
    cap.release()

    # Сохраняем HEX-данные в файл
    with open(output_hex_path, 'w') as f:
        # Записываем построчно (например, по 10 байт на строку - по ширине кадра)
        for i in range(0, len(hex_data), target_width):
            line = ' '.join(hex_data[i:i + target_width][::-1]) + '\n'
            f.write(line)

    print(f"HEX-данные сохранены в {output_hex_path}")


# Пример использования
input_video = "bad_apple_short.mp4"  # Путь к исходному видео
output_hex = "output.hex"  # Файл для сохранения HEX-данных

video_to_hex(input_video, output_hex)