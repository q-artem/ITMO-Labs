import pprint

FILENAME = "input.xml"

def main():
    f = open(FILENAME, encoding="utf-8")
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
                        add_filed(out, stack.copy(), curr_filed, False)
                    stack.pop(-1)
                    curr_filed = ""
                else:
                    a = stack[-1].split(" ")[1:]
                    stack[-1] = stack[-1].split(" ")[0]
                    add_dict(out, stack.copy(), True if a != [] else False)
                    for q in a:
                        add_filed(out, stack.copy(), q, True)
                    curr_filed = ""
            else:
                stack[-1] = stack[-1] + curr_symbol
    out = out[list(out.keys())[0]]
    pprint.pprint(out, width=200)

def add_dict(out, stack, if_specs):
    if len(stack) > 1:
        add_dict(out[stack.pop(0)], stack, if_specs)
    else:
        try:
            out[stack[0]]
        except KeyError:
            out[stack[0]] = [dict()]
        else:
            out[stack[0]].append(dict())

def add_filed(out, stack, filed, if_specs):
    if len(stack) > 2:
        add_filed(out[stack.pop(0)], stack, filed, if_specs)
    else:
        if if_specs:
            out[stack[0]][-1][stack[1]] = filed
        else:
            out[stack[0]][stack[0]] = filed



if __name__ == "__main__":
    main()