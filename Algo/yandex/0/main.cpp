#include <iostream>
#include <string>

void solve() {
  std::string s;
  std::cin >> s;

  int n = s.length();

  if (n % 2 == 0) {
    bool fl = 0;
    for (int i = 0; i < n >> 1; i++) {
      if (s[i] != s[(n >> 1) + i]) {
        fl = 1;
        break;
      }
    }
    if (!fl) {
      std::cout << "YES" << std::endl;
    } else {
      std::cout << "NO" << std::endl;
    }
  } else {
    std::cout << "NO" << std::endl;
  }
}

int main() {
  freopen("input.txt", "r", stdin);
  int n;
  std::cin >> n;
  for (int i = 0; i < n; ++i) {
    solve();
  }
  return 0;
}
