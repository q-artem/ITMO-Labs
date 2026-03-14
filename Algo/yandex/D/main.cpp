#include <algorithm>
#include <iostream>

int main() {
  freopen("input.txt", "r", stdin);

  long long a, b, c, d, k, col, prev = 0;

  std::cin >> a >> b >> c >> d >> k;

  col = a;

  for (long long i = 0; i < k; ++i) {
    prev = col;
    col = std::min(std::max(col * b - c, 0LL), d);
    if (col == prev) {
      break;
    }
  }

  std::cout << std::max(col, 0LL) << std::endl;

  return 0;
}
