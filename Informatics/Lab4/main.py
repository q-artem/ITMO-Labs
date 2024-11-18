import time


def select_task():
    try:
        n = input(">>> Введите номер задания 0-5 (0 - обязательное задание, 1-5 - дополнительные), -1 для "
                  "тестирования\n    всех заданий, или нажмите Enter на этом устройстве для выхода: ")
        if n == "":
            print(r"{:-^110}".format(" Спасибо за проверку лабы! "))
            exit()
        n = int(n)
        if -2 > n > 5:
            raise Exception
    except Exception:
        print(">>> Плохое число, попробуйте ещё раз")
        n = select_task()
    return n

from xml2yaml import XmlToYaml
from dop1 import XmlToYamlLib
from dop2 import XmlToYamlRegEx
from dop3 import XmlToYamlFull
from dop4 import CompareTime
from dop5 import XmlToMarkdown

def main():
    print(r"{:-^110}".format(" Lab4UI "))
    tasks = [XmlToYaml, XmlToYamlLib, XmlToYamlRegEx, XmlToYamlFull, CompareTime, XmlToMarkdown]
    while 1:
        n = select_task()
        s, e = n, n + 1
        if n == -1:
            s, e = 0, 6
            print(">>> Тестирование всех заданий:")
        try:
            for w in range(s, e):
                print(f">>> Задание {w}:")
                t = time.time()
                g = ""
                for q in range(1000):
                    g = tasks[w]().main()
                print(g)
                print(f">>> Среднее время выполнения по 1000 запускам: {round((time.time() - t), 3)} мс")
        except BaseException as e:
            print(">>> Произошла ошибка, попробуйте ещё раз. Код ошибки:", e)

if __name__ == "__main__":
    main()
