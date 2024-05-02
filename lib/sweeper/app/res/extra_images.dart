


import '../../game/model/types.dart';


List<String> get extraSvg {
  List<String> result = [
    'images/sweeper/pressed.svg',
    'images/sweeper/closed.svg',
    'images/sweeper/flag.svg',
    'images/sweeper/d0.svg',
    'images/sweeper/face_pressed.svg',
    'images/sweeper/mine_red.svg',
  ];
  result.addAll(CellType.values.map((e) => e.src));
  result.addAll(FaceType.values.map((e) => e.src));
  result.addAll(DigitalType.values.map((e) => e.src));

  return result;
}