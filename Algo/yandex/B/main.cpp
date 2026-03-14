#include <iostream>
#include <vector>

bool match(char a, char b) {  // правда, если это две одинаковых буквы разных регистров
  return a == b + 32 || a == b - 32;
}

int main() {
  freopen("input.txt", "r", stdin);
  int n;
  std::string s;
  std::cin >> s;
  n = s.size();
  std::vector<char> stack(n + 2);
  std::vector<int> ordinal_number(n + 2);
  std::vector<int> answer(n / 2 + 2);

  int pointer = 0;
  int counter_traps = 0;
  int counter_animals = 0;

  for (int i = 0; i < n; ++i) {
    int curr_id;
    if (s[i] < 'a') {
      counter_traps++;
      curr_id = counter_traps;
    } else {
      counter_animals++;
      curr_id = counter_animals;
    }

    if (pointer != 0 and match(stack[pointer - 1], s[i])) {
      if (s[i] < 'a') {  // если ловушка
        answer[curr_id] = ordinal_number[pointer - 1];
      } else {
        answer[ordinal_number[pointer - 1]] = curr_id;
      }
      pointer--;

    } else {
      stack[pointer] = s[i];
      ordinal_number[pointer] = curr_id;
      pointer++;
    }
  }
  if (pointer == 0) {
    std::cout << "Possible" << '\n';
    for (int i = 1; i <= counter_traps; ++i) {
      std::cout << answer[i] << (i == counter_traps ? "" : " ");
    }
    std::cout << '\n';
  } else {
    std::cout << "Impossible" << '\n';
  }

  return 0;
}
