import pprint
import re


class XmlToYamlFull:
    def main(self, debug=False):
        file = open("input.xml", encoding="utf-8")
        data = file.read()
        file.close()
        headers = []
        res = dict()
        self.parse_headers(headers, data)  # парсим теги
        self.rec_add(res, headers, 0)  # рекурсивно формируем словарь
        self.group_equal_tags(res, [])  # группируем одинаковые теги и выносим их атрибуты
        if debug: pprint.pprint(res, width=200)

        file = open("outputDop3.yaml", "w", encoding="utf-8")
        curr_spase = 0
        self.write_to_yaml(file, res, curr_spase, False)  # пишем в yaml
        file.close()
        return "Изменения успешно записаны в файл outputDop3.yaml"

    @staticmethod
    def parse_headers(headers, data):
        for q in re.finditer(r"<[^>]+>", data):  # ищем все теги по регулярке
            headers.append([q[0], q.start(), ""])
            if re.fullmatch(r"<!--[^>]+-->", headers[-1][0]): headers.pop(-1)  # удаляем <!-- комментарии -->
        for q in range(len(headers)):  # пишем текстовые данные там, где они есть
            if headers[q][0][:2] == "</" and headers[q][0][2:] == headers[q - 1][0][1:]:
                headers[q - 1][2] = data[headers[q - 1][1] + len(headers[q - 1][0]):headers[q][1]]
        headers.pop(0)
        print(headers)

    def rec_add(self, res: dict, headers: list[list[str | int]], start_on: int) -> None:
        if not headers: return
        if start_on > len(headers) - 1: return  # завершение рекурсии
        curr = headers[start_on]
        curr_name = curr[0][1:-1]
        if curr[2]:
            res[curr_name] = self.replace_entities(curr[2])  # заменяем сущности и пишем, если строка не пустая
        else:
            res[curr_name] = dict()  # создаём словарь если пустая строка
        end_ind = len(headers)
        for q in range(start_on, len(headers)):
            if headers[q][0][2:-1] == curr[0][1:-1].split(" ")[0]:  # если два соседних тега, записываем
                end_ind = q  #                                        стартовую позицию и передаём дальше
                break
        self.rec_add(res[curr_name], headers[start_on + 1:end_ind], 0)  # рекурсия вглубь
        self.rec_add(res, headers, end_ind + 1)  #                                и вбок

    @staticmethod
    def replace_entities(s):
        for q in [["&lt;", '<'], ["&gt;", '>'], ["&amp;", '&'], ["&apos;", "'"], ["&quot;", '"']]:
            s = s.replace(q[0], q[1])  # замена сущностей
        return s

    def group_equal_tags(self, res: dict, add_fields: list[list]):
        if type(res) != dict: return
        if add_fields:  # добавляем поля с предыдущего шага рекурсии
            for q in add_fields:
                res[q[0]] = q[1]
        for q in list(res.keys()):  # идём по ключам
            link = res[q]  # ссылочка на словарь
            if " " in q:  # если есть атрибуты
                nm, prop = q.split(" ")[0], q.split(" ")[1:]  # сплитим
                if nm in res.keys(): res[nm].append(res[q])  # добавляем в список
                else: res[nm] = [res[q]]
                del res[q]  # удалили
                link = res[nm][-1]  # перезаписали ссылку
                add_fields = [["_" + w[:w.index("=")], w[w.index("=") + 1:][1:-1]] for w in prop]  # добавление полей
            else:  #                                                                                 для след. шага
                add_fields = []
            self.group_equal_tags(link, add_fields)

    def write_to_yaml(self, file, out, curr_spase, arrow_before_first):  # рекурсивная запись
        for q in out.keys():  # идём по ключам
            st = " " * curr_spase + q + ":"  # текущий тег
            if type(out[q]) == str:  # если попалась строка => просто текстовое поле
                st += " '" + out[q] + "'\n"  # пишем его
                if arrow_before_first:
                    arrow_before_first = False  # если с прошлого шага пришла необходимость стрелочки - добавляем
                    st = st[:curr_spase - 2] + "-" + st[curr_spase - 1:]
                file.write(st)
            if type(out[q]) == dict:  # если попался словарь => печатаем тег, переводим строку и идём глубже
                st += "\n"
                file.write(st) #   файл|словарь|добавили пробел | стрелка если несколько элементов
                self.write_to_yaml(file, out[q], curr_spase + 2, True if len(out.keys()) > 1 else False)
            if type(out[q]) == list:  # если попался список => печатаем тег, переводим строку и идём по элементам,
                st += "\n"  #           каждый раз взводя флаг добавления стрелочки
                file.write(st)
                for w in out[q]:
                    self.write_to_yaml(file, w, curr_spase + 2, True)


if __name__ == "__main__":
    print(XmlToYamlFull().main(True))
