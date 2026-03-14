from typing import Callable
from math import sin, pi, sqrt, cos

def calculate(func):
    n = 1000
    i_prev = 0
    i = rectangles(func1, a, b, n)
    while abs(i - i_prev) > epsilon:
        n *= 2
        i_prev = i
        i = rectangles(func1, a, b, n)
    return i


def rectangles(func: Callable[[float], float], start: float, end: float, n: int) -> float:
    step = (end - start) / n
    half_step = step / 2
    x = start + half_step
    area = 0.0
    while x < end:
        area += func(x) * step
        x += step
    return area



def trapezia(func: Callable[[float], float], start: float, end: float, n: int) -> float:
    h = (end - start) / n

    x = [start + i * h for i in range(n + 1)]

    integral = h / 2 * (func(x[0]) + 2 * sum([func(q) for q in x[1:-1]]) + func(x[-1]))
    return integral
'''
ld trapez(ld l, ld r, int n) {
    const ld h = (r-l)/n;
    ld res = (f(l) + f(l + n*h))/2;
    for (int i = 0; i < n; i++) {
        ld x = l + i*h;
        res += f(x);
    }
    res *= h;
    return res;
}

'''
def simpson(func: Callable[[float], float], start: float, end: float, n: int) -> float:
    h = (end - start) / n

    step = (end - start) / (n + 1 - 1)
    x = [start + i * step for i in range(n + 1)]

    integral = h/3 * (func(x[0]) + 4 * sum([func(q) for q in x[1:-1:2]]) +
                      2 * sum([func(q) for q in x[2:-2:2]]) + func(x[-1]))
    return integral


func1 = lambda x: cos(x ** 2)

a = 0
b = 1
epsilon = 1e-5



print("Прямоугольники:")
print(f"Площадь = {calculate(rectangles):.10f}")
print("Трапеции:")
print(f"Площадь = {calculate(trapezia):.10f}")
print("Метод Симпсона:")
print(f"Площадь = {calculate(simpson):.10f}")

#
#
# for q in [10, 100, 1000, 10000]:
#     approx_area = calculate_area(func3, st, ed, q)
#     print(f"n = {q:<6}: {approx_area:.7f} (ошибка {abs((correct_area - approx_area) / correct_area * 100):.7f}%)")
#
# func1 = lambda x: sin(x) ** 2
# func2 = lambda x: x * sin(x)
# st = 0
# ed = pi
#
# correct_area = pi / 2
# print("График 1:")
# print(f"Площадь = {correct_area}")
#
# for q in [10, 100, 1000, 10000]:
#     approx_area = calculate_area(func2, st, ed, q) - calculate_area(func1, st, ed, q)
#     print(f"n = {q:<6}: {approx_area:.7f} (ошибка {abs((correct_area - approx_area) / correct_area * 100):.7f}%)")
