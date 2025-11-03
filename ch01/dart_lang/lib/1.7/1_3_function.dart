int addTwoNumbers(int a, [int b = 2]) {
  return a + b;
}
void main() {
  print(addTwoNumbers(1));
  print(addTwoNumbers(1,3));
}
