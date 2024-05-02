import 'package:path/path.dart' as path;

enum CellType {
  value0('images/sweeper/type0.svg'),
  value1('images/sweeper/type1.svg'),
  value2('images/sweeper/type2.svg'),
  value3('images/sweeper/type3.svg'),
  value4('images/sweeper/type4.svg'),
  value5('images/sweeper/type5.svg'),
  value6('images/sweeper/type6.svg'),
  value7('images/sweeper/type7.svg'),
  value8('images/sweeper/type8.svg'),
  mine('images/sweeper/mine.svg');
  final String src;
  const CellType(this.src);

  String get key => path.basename(src);
}

enum MarkType{
  flag('images/sweeper/flag.svg');

  final String src;

  const MarkType(this.src);

  String get key => path.basename(src);
}

enum DigitalType{
  d0('images/sweeper/d0.svg'),
  d1('images/sweeper/d1.svg'),
  d2('images/sweeper/d2.svg'),
  d3('images/sweeper/d3.svg'),
  d4('images/sweeper/d4.svg'),
  d5('images/sweeper/d5.svg'),
  d6('images/sweeper/d6.svg'),
  d7('images/sweeper/d7.svg'),
  d8('images/sweeper/d8.svg'),
  d9('images/sweeper/d9.svg');

  final String src;

  const DigitalType(this.src);

  String get key => path.basename(src);
}

enum FaceType {
  active('images/sweeper/face_active.svg'),
  lose('images/sweeper/face_lose.svg'),
  common('images/sweeper/face.svg')
  ;

  final String src;

  const FaceType(this.src);

  String get key => path.basename(src);
}

