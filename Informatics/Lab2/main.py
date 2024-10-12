def t_input():
    try:
        n = input("Введите Ваш код Хемминга: ")
        if len(n) < 3:
            raise BaseException
        if n.count("0") + n.count("1") != len(n):
            raise BaseException
    except BaseException:
        print("Плохое число, попробуйте ещё раз")
        n = t_input()
    return n


def calculate_col_ctrl(data):
    from math import log2, ceil

    return ceil(log2(len(data) + 1))


def add_to_classic(data, col_ctrl):
    return data + "0" * (2 ** col_ctrl - len(data) - 1)


def find_error(data, col_ctrl):
    d = ""
    for q in range(col_ctrl):
        ind = 2 ** q - 1
        step = 2 ** q
        ot = 0
        cntr = step
        for w in range(ind, len(data)):
            if cntr > 0:
                ot ^= int(data[w])
            cntr -= 1
            if cntr == -step:
                cntr = step
        d += str(ot)
    d = d[::-1]
    return int(d, 2)


def get_corr_bits(data, pos_error, corr_bits):
    f = []
    for q in range(corr_bits):
        f.append(2 ** q - 1)
    f = f[::-1]
    g = list(data)
    if pos_error != 0:
        g[pos_error - 1] = str(int(g[pos_error - 1]) ^ 1)
    for q in f:
        g.pop(q)
    return g


def print_inf_bits(corr_inf_bits, pos_error):
    if pos_error == 0:
        print("Ошибок либо нет, либо более одной")
    else:
        print("Ошибка в бите номер", pos_error)
    print("Исходное сообщение:", "".join(corr_inf_bits))


def main():
    data = t_input()
    col_ctrl = calculate_col_ctrl(data)
    data = add_to_classic(data, col_ctrl)
    pos_error = find_error(data, col_ctrl)
    corr_inf_bits = get_corr_bits(data, pos_error, col_ctrl)
    print_inf_bits(corr_inf_bits, pos_error)


if __name__ == "__main__":
    main()
