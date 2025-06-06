import pprint
import re


class XmlToMarkdown:
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

        file = open("outputDop5.md", "w", encoding="utf-8")
        curr_spase = 0
        self.write_to_md(file, res, curr_spase, False)  # пишем в yaml
        file.close()
        return "Изменения успешно записаны в файл outputDop5.md"

    @staticmethod
    def parse_headers(headers, data):
        for q in re.finditer(r"<[^>]+>", data):  # ищем все теги по регулярке
            headers.append([q[0], q.start(), ""])
            if re.fullmatch(r"<!--[^>]+-->", headers[-1][0]): headers.pop(-1)  # удаляем <!-- комментарии -->
            if headers[-1][0][-2:] == "/>":
                headers[-1][0] = headers[-1][0][:-2] + ">"  # случай, когда тег пустой, делаем ещё один фиктивный
                headers.append(["</" + headers[-1][0].split(" ")[0][1:] + ">", headers[-1][1], headers[-1][2]])
        for q in range(len(headers)):  # пишем текстовые данные там, где они есть
            if headers[q][0][:2] == "</" and headers[q][0][2:] == headers[q - 1][0][1:]:
                headers[q - 1][2] = data[headers[q - 1][1] + len(headers[q - 1][0]):headers[q][1]]
        headers.pop(0)

    def rec_add(self, res: dict, headers: list[list[str | int]], start_on: int) -> None:
        if not headers: return
        if start_on > len(headers) - 1: return  # завершение рекурсии
        curr = headers[start_on]
        curr_name = curr[0][1:-1]
        if curr[2]:
            if curr_name in res.keys():
                if type(res[curr_name]) == list: res[curr_name].append(self.replace_entities(curr[2])) # заменяем сущ.
                else: res[curr_name] = [res[curr_name], self.replace_entities(curr[2])] # и пишем, если строка не пустая
            else: res[curr_name] = self.replace_entities(curr[2])
        else: res[curr_name] = dict()  # создаём словарь если пустая строка
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
                nm, prop = q.split(" ")[0], [w[0][1:] for w in re.finditer(r'\s[^\n<"]+="[^\n<"]*"', q)]
                if nm in res.keys(): res[nm].append(res[q])  # добавляем в список
                else: res[nm] = [res[q]]
                del res[q]  # удалили
                link = res[nm][-1]  # перезаписали ссылку
                add_fields = [["_" + w[:w.index("=")], w[w.index("=") + 1:][1:-1]] for w in prop]  # добавление полей
            else:  #                                                                                 для след. шага
                add_fields = []
            self.group_equal_tags(link, add_fields)

    def write_to_md(self, file, out, curr_spase, arrow_before_first):  # рекурсивная запись
        for q in out.keys():  # идём по ключам
            st = "\t" * curr_spase + "- " + q + ":"  # текущий тег
            if type(out[q]) == str:  # если попалась строка => просто текстовое поле
                if arrow_before_first:
                    arrow_before_first = False  # если с прошлого шага пришла необходимость стрелочки - добавляем
                    st = st[:curr_spase + 3 - 1] + "**" + st[curr_spase + 3 - 1:] + "**"
                st += " " + out[q] + "\n"  # пишем его
                file.write(st)
            if type(out[q]) == dict:  # если попался словарь => печатаем тег, переводим строку и идём глубже
                st += "\n"
                file.write(st) #   файл|словарь|добавили пробел | стрелка если несколько элементов
                self.write_to_md(file, out[q], curr_spase + 1, True if len(out.keys()) > 1 else False)
            if type(out[q]) == list:  # если попался список => печатаем тег, переводим строку и идём по элементам,
                st += "\n"  #           каждый раз взводя флаг добавления стрелочки
                file.write(st)
                for w in out[q]:
                    if type(w) == str: file.write(" " * (curr_spase + 1) + "- " + w + "\n")
                    else: self.write_to_md(file, w, curr_spase + 1, True)


if __name__ == "__main__":
    print(XmlToMarkdown().main(True))
