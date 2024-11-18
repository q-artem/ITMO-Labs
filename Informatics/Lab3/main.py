import re


def task_1():  # Смайлик: :</
    from tests_1 import tests, answers, num_tests

    print("#################################### Задание 1: ####################################")
    for q in range(num_tests):
        print(f"------------------------------------- Тест {q + 1}: --------------------------------------")
        print("> Входные данные:", tests[q][:500] + " ..." if len(tests[q]) > 500 else tests[q])
        ans = len(re.findall(r":</", tests[q]))
        if ans == answers[q]:
            print("> Ответ программы совпадает с правильным ответом:", ans)
        else:
            print("> Ошибка!")
    return True


def task_2():  # вариант 3
    from tests_2 import tests, answers, num_tests

    print("#################################### Задание 2: ####################################")
    for q in range(num_tests):
        print(f"------------------------------------- Тест {q + 1}: --------------------------------------")
        print("> Входные данные:", tests[q][:500] + " ..." if len(tests[q]) > 500 else tests[q])
        ans = sorted([q[:-5] for q in re.findall(r"\b[А-Я][\w|-]*\s[А-Я]\.[А-Я]\.", tests[q])])
        if ans == answers[q]:
            print("> Ответ программы совпадает с правильным ответом:\n" + "\n".join(ans))
        else:
            print("> Ошибка!")
    return True


def task_3():  # вариант 5
    from tests_3 import tests, answers, num_tests

    print("#################################### Задание 3: ####################################")
    for e in range(num_tests):
        print(f"------------------------------------- Тест {e + 1}: --------------------------------------")
        curr_test = "\n".join(tests[e])
        print("> Входные данные:\n" + (curr_test[:500] + " ..." if len(curr_test) > 500 else curr_test))
        for q in "АБВГДЕЁЖЗИКЛМНОПРСТУФХЦЧШЩЫЭЮЯ":
            src = re.findall(rf"\b[{q}][\w|-]*\s[А-Я]\.[А-Я]\.\sP3107\n", curr_test)
            if len(src) > 1:
                for w in src:
                    curr_test = curr_test.replace(w, "")
        if curr_test.split("\n") == answers[e]:
            print("> Ответ программы совпадает с правильным ответом:\n" + curr_test)
        else:
            print("> Ошибка!")
    return True


def select_task():
    try:
        n = input("Выберите задание (1, 2, 3), или нажмите Enter для выхода: ")
        if n == "":
            exit()
        n = int(n)
        if n > 3:
            raise Exception
    except Exception:
        print("Плохое число, попробуйте ещё раз")
        n = select_task()
    return n


def main():
    tasks = [task_1, task_2, task_3]
    while 1:
        n = select_task()
        if not tasks[n - 1]():
            print("Произошла какая-то ошибка, попробуйте ещё раз")


if __name__ == "__main__":
    main()
