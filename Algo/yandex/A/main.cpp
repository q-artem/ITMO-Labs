#include <iostream>
#include <vector>

int main() {
  // freopen("input.txt", "r", stdin);
  int n = 0;
  std::cin >> n;
  std::vector<int> a(n);
  for (int i = 0; i < n; ++i) {
    std::cin >> a[i];
  }

  int const window = 3;  // Размер окна
  int last_int = a[0] + 1;  // Предидущий элемент

  int curr_seq_eq = 0;  // Текущее количество одинаковых элементов подряд
  int max_seq = 0;  // Максимальная длина последовательности до текущего элемента
  int best_seq = 0;  // Лучшая длина

  int start_point_index = 0;  // Стартовый элемент текущей последовательности
  int best_start = 0;  // Стартовый элемент лучшей последовательности
  int curr = 0;  // Текущий элемент

  for (int i = 0; i < n; ++i) {
    curr = a[i];
    if (curr == last_int) {
      curr_seq_eq++;
    } else {
      curr_seq_eq = 1;
    }

    last_int = curr;
    if (curr_seq_eq >= window) {
      max_seq = window - 1;
      start_point_index = i - (window - 1) + 1;
    } else {
      max_seq += 1;
    }

    if (max_seq > best_seq) {
      best_seq = std::max(best_seq, max_seq);
      best_start = start_point_index;
    }
  }

  std::cout << best_start + 1 << " " << best_start + 1 + best_seq - 1 << '\n';

  return 0;
}
