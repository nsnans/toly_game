main(){
  A a1 = A();
  A a2 = A();
  a2.setName();
  print(identical(a1, a2));
  print(a1.name);
  print(a2.name);
}

class A{

  A._();

  static A? _instance;

  factory A() => _instance ??= A._();

  String name='';
  void setName(){
    name= 'setname';
  }


}
