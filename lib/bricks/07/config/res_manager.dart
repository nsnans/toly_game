import 'dart:async';
import 'dart:convert';

import 'package:flame_ext/flame_ext.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/extra_images.dart';
import '../model/level.dart';
import '../overlays/shop_page/goods_mamager.dart';
import 'game_config.dart';

class ResManager {

  ResManager._();
  static ResManager instance = ResManager._();

  late SharedPreferences sp;
  late GameConfigManager configManager;
  GoodsManager goodsManager = GoodsManager();

  List<Level> _levels = [];
  List<Level> get levels => _levels;

  TextureLoader loader = TextureLoader();

  final StreamController<double> _progressCtrl = StreamController();

  Stream<double> get loadStream => _progressCtrl.stream;

  void load() async{
    sp = await SharedPreferences.getInstance();
    _progressCtrl.add(0.1);
    configManager = GameConfigManager(sp);
    configManager.loadConfig(sp);
    await loadLevels();
    _progressCtrl.add(0.2);

    await loader.load(
      'assets/images/break_bricks/break_bricks.json',
      'break_bricks/break_bricks.png',
      extra: extraImages,
      loadingCallBack: (total,cur){
        _progressCtrl.add(0.8*(cur/total));
      }
    );
    await goodsManager.loadGoods();
    _progressCtrl.add(1);
    _progressCtrl.close();
  }

  Future<void> loadLevels() async {
    String path = 'assets/data/bricks_levels.json';
    String data = await rootBundle.loadString(path);
    List<dynamic> list = json.decode(data) as List;
    _levels = list.map(Level.fromMap).toList();
  }

}