#include <iostream>

extern void process(char *str, int *to_reverse, int n_to_reverse);

int main() {
  char str[256];
  int n_to_reverse;
  int to_reverse[64];
  std::cout << "Submit text: ";
  std::cin.getline(str, 256);
  std::cout << "Number of words to reverse: ";
  std::cin >> n_to_reverse;
  std::cout << "Words to reverse: ";
  for(int i = 0; i < n_to_reverse; i++)
    std::cin >> to_reverse[i];
  process(str, to_reverse, n_to_reverse);
  std::cout << "Resulting text: " << str << std::endl;
}