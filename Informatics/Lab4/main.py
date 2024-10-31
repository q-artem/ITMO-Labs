
def select_task():
    try:
        n = input(">>> Выберите задание 0-5 (0 - обязательное задание, 1-5 - дополнительные), или нажмите Enter для выхода: ")
        if n == "":
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

def main():
    tasks = [XmlToYaml, XmlToYamlLib, "dop2.py", "dop3.py", "dop4.py", "dop5.py"]
    while 1:
        n = select_task()
        try:
            tasks[n]().main()
        except BaseException as e:
            print(">>> Произошла ошибка, попробуйте ещё раз. Код ошибки:", e)

if __name__ == "__main__":
    main()
