import pprint
import re


class XmlToYamlRegEx:
    def main(self, debug=False):
        f = open("input.xml", encoding="utf-8")
        data = f.read()
        f.close()
        headers = []
        for q in re.finditer(r"<[^>]+>", data):
            headers.append([q[0], q.start(), ""])
        for q in range(len(headers)):
            if headers[q][0][:2] == "</" and headers[q][0][2:] == headers[q - 1][0][1:]:
                headers[q - 1][2] = data[headers[q - 1][1] + len(headers[q - 1][0]):headers[q][1]]
        headers.pop(0)
        res = dict()
        self.rec_add(res, headers, 0)
        if debug: pprint.pprint(res, width=200)

        file = open("outputDop2.yaml", "w", encoding="utf-8")
        curr_spase = 0
        self.write_to_yaml(file, res, curr_spase, False)
        file.close()
        return "Изменения успешно записаны в файл outputDop2.yaml"

    def rec_add(self, res: dict, headers: list[list[str | int]], start_on: int) -> None:
        if not headers: return
        if start_on > len(headers) - 1: return
        curr = headers[start_on]
        curr_name = curr[0][1:-1]
        if curr[2]:
            res[curr_name] = curr[2]
        else:
            res[curr_name] = dict()
        end_ind = len(headers)
        for q in range(start_on, len(headers)):
            if headers[q][0][2:-1] == curr[0][1:-1].split(" ")[0]:
                end_ind = q
                break
        self.rec_add(res[curr_name], headers[start_on + 1:end_ind], 0)
        self.rec_add(res, headers, end_ind + 1)

    def write_to_yaml(self, file, out, curr_spase, arrow_before_first):
        last_header = ""
        for q in out.keys():
            st = " " * curr_spase + q + ":"
            lst_attr = []
            if " " in q:
                st = " " * curr_spase + q.split(" ")[0] + ":"
                lst_attr = q.split(" ")[1:]
            if type(out[q]) != dict:
                st += " '" + out[q] + "'\n"
                if arrow_before_first:
                    arrow_before_first = False
                    st = st[:curr_spase - 2] + "-" + st[curr_spase - 1:]
                file.write(st)
            else:
                st += "\n"
                if last_header != st:
                    file.write(st)
                last_header = st
                for w in lst_attr:
                    out[q]["_" + w.split("=")[0]] = w.split("=")[1][1:-1]
                self.write_to_yaml(file, out[q], curr_spase + 2, True if len(out.keys()) > 1 else False)


if __name__ == "__main__":
    print(XmlToYamlRegEx().main(True))
