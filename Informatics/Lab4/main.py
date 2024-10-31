import time


def select_task():
    try:
        n = input(">>> Выберите задание 0-5 (0 - обязательное задание, 1-5 - дополнительные), или нажмите Enter для выхода: ")
        if n == "":
            print(r"{:-^110}".format(" Спасибо за проверку лабы! "))
            exit()
        n = int(n)
        if -1 > n > 5:
            raise Exception
    except Exception:
        print(">>> Плохое число, попробуйте ещё раз")
        n = select_task()
    return n

from xml2yaml import XmlToYaml
from dop1 import XmlToYamlLib
from dop2 import XmlToYamlRegEx

def main():
    print(r"{:-^110}".format(" Lab4UI "))
    tasks = [XmlToYaml, XmlToYamlLib, XmlToYamlRegEx, "dop3.py", "dop4.py", "dop5.py"]
    while 1:
        n = select_task()
        try:
            t = time.time()
            g = ""
            for q in range(100):
                g = tasks[n]().main()
            print(g)
            print(f">>> Среднее время выполнения по 100 запускам: {round((time.time() - t) * 10, 3)} мс")
        except BaseException as e:
            print(">>> Произошла ошибка, попробуйте ещё раз. Код ошибки:", e)

if __name__ == "__main__":
    main()
