import pprint


class XmlToYaml:
    def main(self, debug=False):
        f = open("input.xml", encoding="utf-8")
        data = f.read()
        f.close()
        out = dict()
        stack = []
        curr_filed = ""
        in_reading_header = False
        in_reading_field = False
        counter = -1
        while counter < len(data) - 1:
            counter += 1
            curr_symbol = data[counter]
            if in_reading_header == False and in_reading_field == False:
                if curr_symbol == "<":
                    in_reading_header = True
                    stack.append("")
                else:
                    curr_filed += curr_symbol
                continue
            if in_reading_header:
                if curr_symbol == ">":
                    in_reading_header = False
                    if len(stack) > 1 and len(stack[-1]) > 1 and stack[-1][0] == "/" and stack[-2].split(" ")[0] == stack[-1][1:]:
                        stack.pop(-1)
                        if curr_filed.replace("\n", " ").count(" ") != len(curr_filed):
                            self.add_filed(out, stack.copy(), curr_filed)
                        stack.pop(-1)
                        curr_filed = ""
                    else:
                        self.add_dict(out, stack.copy())
                        curr_filed = ""
                else:
                    stack[-1] = stack[-1] + curr_symbol
        out = out[list(out.keys())[0]]
        if debug: pprint.pprint(out, width=200)

        file = open("outputTask.yaml", "w", encoding="utf-8")
        curr_spase = 0
        self.write_to_yaml(file, out, curr_spase, False)
        file.close()
        return "Изменения успешно записаны в файл outputTask.yaml"

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

    def add_dict(self, out, stack):
        if len(stack) > 1:
            self.add_dict(out[stack.pop(0)], stack)
        else:
            out[stack[0]] = dict()

    def add_filed(self, out, stack, filed):
        if len(stack) > 1:
            self.add_filed(out[stack.pop(0)], stack, filed)
        else:
            out[stack[0]] = filed


if __name__ == "__main__":
    print(XmlToYaml().main(True))
