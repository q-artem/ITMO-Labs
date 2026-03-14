import numpy as np
from scipy.integrate import quad
from scipy.optimize import minimize

A = np.array([0, 0])
C = np.array([10, 0])
K = np.array([2, 7])


def curve_length(B):
    x_B, y_B = B

    def dx_dt(t):
        return 2 * (1 - 2 * t) * x_B + 20 * t

    def dy_dt(t):
        return 2 * (1 - 2 * t) * y_B

    def integrand(t):
        return np.sqrt(dx_dt(t) ** 2 + dy_dt(t) ** 2)

    length, _ = quad(integrand, 0, 1)
    return length


def constraint(t_K):
    x_B = (2 - 10 * t_K ** 2) / (2 * t_K * (1 - t_K))
    y_B = 7 / (2 * t_K * (1 - t_K))
    return np.array([x_B, y_B])


def objective(t_K):
    B = constraint(t_K)
    return curve_length(B)


result = minimize(objective, x0=0.5, bounds=[(0.01, 0.99)])
t_K_opt = result.x[0]
B_opt = constraint(t_K_opt)

min_length = curve_length(B_opt)

print(f"Оптимальная точка B: {B_opt}")
print(f"Минимальная длина кривой: {min_length}")

import matplotlib.pyplot as plt

t = np.linspace(0, 1, 100)
x = (1 - t) ** 2 * A[0] + 2 * t * (1 - t) * B_opt[0] + t ** 2 * C[0]
y = (1 - t) ** 2 * A[1] + 2 * t * (1 - t) * B_opt[1] + t ** 2 * C[1]

plt.plot(x, y, )
plt.scatter([A[0], C[0], K[0]], [A[1], C[1], K[1]], color='red')
plt.scatter(B_opt[0], B_opt[1], color='red')
plt.xlabel("x")
plt.ylabel("y")
plt.title("Кривая Безье")
plt.grid()
plt.show()

