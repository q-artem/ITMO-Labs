from typing import Callable
from math import sin, pi, sqrt


def calculate_area(func: Callable[[float], float], start: float, end: float, n: int) -> float:
    step = (end - start) / n
    half_step = step / 2
    x = start + half_step
    area = 0.0
    while x < end:
        area += func(x) * step
        x += step
    return area


a = 1
func3 = lambda x: sqrt(-x ** 2 - a ** 2 + a * sqrt(4 * x ** 2 + a)) * 4
st = 0
ed = a * sqrt(2)

correct_area = 2 * (a ** 2)
print("График 2:")
print(f"Площадь = {correct_area}")

for q in [10, 100, 1000, 10000]:
    approx_area = calculate_area(func3, st, ed, q)
    print(f"n = {q:<6}: {approx_area:.7f} (ошибка {abs((correct_area - approx_area) / correct_area * 100):.7f}%)")

func1 = lambda x: sin(x) ** 2
func2 = lambda x: x * sin(x)
st = 0
ed = pi

correct_area = pi / 2
print("График 1:")
print(f"Площадь = {correct_area}")

for q in [10, 100, 1000, 10000]:
    approx_area = calculate_area(func2, st, ed, q) - calculate_area(func1, st, ed, q)
    print(f"n = {q:<6}: {approx_area:.7f} (ошибка {abs((correct_area - approx_area) / correct_area * 100):.7f}%)")
