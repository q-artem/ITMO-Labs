#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

int get_var(std::string var, std::unordered_map<std::string, std::vector<int>>& history) {
  if (history.count(var)) {
    return history[var].back();
  } else {
    std::vector<int> vec = {0};
    history[var] = vec;
    return get_var(var, history);  // :)
  }
}

void set_var(
    std::string var, int value, std::unordered_map<std::string, std::vector<int>>& history
) {
  get_var(var, history);
  history[var].push_back(value);
}

int main() {
  freopen("input.txt", "r", stdin);

  std::unordered_map<std::string, std::vector<int>> history;
  std::vector<std::vector<std::string>> calls = {{}};

  std::string line;
  while (std::getline(std::cin, line)) {
    if (line == "{") {
      calls.push_back({});
    } else if (line == "}") {
      for (auto call : calls.back()) {
        history[call].pop_back();
      }
      calls.pop_back();
    } else {
      int pos = line.find('=');
      std::string var = line.substr(0, pos);
      std::string right = line.substr(pos + 1);

      if (isdigit(right[0]) || right[0] == '-') {
        set_var(var, std::stoi(right), history);
      } else {
        set_var(var, get_var(right, history), history);
        std::cout << get_var(var, history) << std::endl;
      }

      calls.back().push_back(var);
    }
  }
  return 0;
}
