import numpy as np
import matplotlib.pyplot as plt

# Параметры кривой
t = np.linspace(0, 2 * np.pi, 1000000)  # Диапазон параметра t
r = 1 + np.cos(t)                     # Радиус r(t)
phi = t - np.tan(t / 2)                # Угол φ(t)

# Преобразование полярных координат в декартовы
x = r * np.cos(phi)
y = r * np.sin(phi)

# Точки A и B
A_r, A_phi = 2, 0                     # Точка A(2, 0)
B_r, B_phi = 1 + np.cos(np.pi/4), (np.pi/4) - np.tan(np.pi/8)  # Пример точки B(r0, φ0)

A_x = A_r * np.cos(A_phi)
A_y = A_r * np.sin(A_phi)
B_x = B_r * np.cos(B_phi)
B_y = B_r * np.sin(B_phi)

# Построение графика
plt.figure(figsize=(8, 8))
plt.plot(x, y, label='Кривая: $r = 1 + \cos t$, $\phi = t - \tan(t/2)$', color='blue')
plt.scatter([A_x, B_x], [A_y, B_y], color='red', label='Точки A и B')
plt.annotate('A(2, 0)', (A_x, A_y), textcoords="offset points", xytext=(10,0), ha='center')
plt.annotate(f'B({B_r:.2f}, {B_phi:.2f})', (B_x, B_y), textcoords="offset points", xytext=(10,0), ha='center')

# Настройки графика
plt.title('Параметрическая кривая в полярных координатах')
plt.xlabel('X')
plt.ylabel('Y')
plt.axhline(0, color='black', linewidth=0.5)
plt.axvline(0, color='black', linewidth=0.5)
plt.grid(True)
plt.legend()
plt.axis('equal')  # Одинаковый масштаб по осям
plt.show()