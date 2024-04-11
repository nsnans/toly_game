// import 'dart:convert';
//
// import 'package:toly_game/bricks/06/overlays/shop_page/goods.dart';
//
// void main() {
//   List<Goods> goods1 = kGoodsMap[GoodsType.paddle]!
//       .map((e) => Goods(
//           title: e.title,
//           src: e.src,
//           desc: e.desc,
//           coin: e.coin,
//           crystal: e.crystal,
//           type: GoodsType.paddle))
//       .toList();
//   List<Goods> goods2 = kGoodsMap[GoodsType.rune]!
//       .map((e) => Goods(
//       title: e.title,
//       src: e.src,
//       desc: e.desc,
//       coin: e.coin,
//       crystal: e.crystal,
//       type: GoodsType.rune))
//       .toList();
//   List<Goods> goods3 = kGoodsMap[GoodsType.function]!
//       .map((e) => Goods(
//       title: e.title,
//       src: e.src,
//       desc: e.desc,
//       coin: e.coin,
//       crystal: e.crystal,
//       type: GoodsType.function))
//       .toList();
//   print(jsonEncode([...goods1,...goods2,...goods3]));
// }
