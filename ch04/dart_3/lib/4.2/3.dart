void main() {
  final minjiMap = {'name': '민지', 'age': 19};
  // Map의 구조와 똑같은 구조로 Destructuring하면 된다.
  final {'name': name, 'age': age} = minjiMap;

  // name: 민지
  print('name: $name');

  // age: 19
  print('age: $age');


  // final {'name': name1, 'age1': age1} = minjiMap;
  // print('name: $name1');
  // print('age: $age1');

}
