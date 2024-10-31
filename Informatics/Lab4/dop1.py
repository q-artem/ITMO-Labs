import xmltodict
import yaml


class XmlToYamlLib:
    def main(self):
        f = open("input.xml", encoding="utf-8")
        data = f.read()
        f.close()
        data_dict = xmltodict.parse(data, encoding="utf-8")
        f = open("outputDop1.yaml", "w", encoding="utf-8")
        f.write(yaml.dump(data_dict, default_flow_style=False, allow_unicode=True))
        f.close()
        print("Изменения успешно записаны в файл outputDop1.yaml")


if __name__ == "__main__":
    XmlToYamlLib().main()
