# вход - фиб, выход - 10


def t_input(b):
    try:
        if b == 1:
            bb = "Введите число в фибоначчивой СС: "
        else:
            bb = "Введите основание СС на выходе: "
        n = int(input(bb))
        if n <= 0:
            raise BaseException
        if b == 1:
            if str(n).count("1") + str(n).count("0") != len(str(n)):
                raise BaseException
            if "11" in str(n):
                print("Числи в фибоначчивой СС не может содержать две 1 рядом")
                raise BaseException
        if b == 2:
            if n > 10+26+26:
                raise BaseException
    except BaseException:
        print("Плохое число, попробуйте ещё раз")
        n = t_input(b)
    return n

n = t_input(1)
osn = t_input(2)

d = [1, 1]

for q in range(len(str(n)) - 1):
    d.append(d[-1] + d[-2])
d.pop(0)
summ = 0
d = d[::-1]
cntr = 0
for q in str(n):
    if q == "1":
        summ += d[cntr]
    cntr += 1


def convert_to_system(n, osn):
    d = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ".lower()
    r = ""
    if osn == 1:
        return n * "1"
    while n > 0:
        r = d[n % osn] + r
        n //= osn
    return r

print(f"Ваше число в {osn}-й системе счисления:", convert_to_system(summ, osn))

