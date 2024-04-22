import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:path/path.dart' as path;

typedef LoadProgressCallBack = void Function(int total, int cur);

class TextureLoader {
  final List<Frame> _frames = [];
  late final Image _sprites;

  final Map<String, Sprite> _staticSpriteMap = {};

  Future<void> _initStaticSprites(List<String> extra) async {
    List<String> images = extra;
    for (int i = 0; i < images.length; i++) {
      String filename = path.basename(images[i]);
      _staticSpriteMap[filename] = await Sprite.load(images[i]);
    }
  }

  Future<void> load(
    String jsonAsset,
    String imageAsset, {
    List<String> extra = const [],
    LoadProgressCallBack? loadingCallBack,
  }) async {
    int total = extra.length+3;
    int cur = 0;
    List<String> images = extra;
    for (int i = 0; i < images.length; i++) {
      String filename = path.basename(images[i]);
      _staticSpriteMap[filename] = await Sprite.load(images[i]);
      cur++;
      loadingCallBack?.call(total,cur);
    }
    _frames.clear();
    String data = await rootBundle.loadString(jsonAsset);
    cur++;
    loadingCallBack?.call(total,cur);
    List<dynamic> textures = json.decode(data)['textures'];

    for (int i = 0; i < textures.length; i++) {
      dynamic texture = textures[i];
      _frames.addAll((texture['frames'] as List).map(Frame.fromMap));
    }
    _sprites = await Flame.images.load(imageAsset);
    cur++;
    loadingCallBack?.call(total,cur);
  }

  Sprite operator [](String name) {
    if (_staticSpriteMap.containsKey(name)) {
      return _staticSpriteMap[name]!;
    }

    Frame frame = _frames.singleWhere((e) => e.name == name);
    return Sprite(
      _sprites,
      srcPosition: frame.srcPosition,
      srcSize: frame.sourceSize,
    );
  }
}

class Frame {
  final String name;
  final Vector2 sourceSize;
  final Vector2 srcPosition;

  Frame({
    required this.name,
    required this.sourceSize,
    required this.srcPosition,
  });

  factory Frame.fromMap(dynamic map) {
    return Frame(
        name: map['filename'],
        sourceSize: Vector2(
          map['frame']['w'].toDouble(),
          map['frame']['h'].toDouble(),
        ),
        srcPosition: Vector2(
          map['frame']['x'].toDouble(),
          map['frame']['y'].toDouble(),
        ));
  }

  @override
  String toString() {
    return 'Frame{name: $name, sourceSize: $sourceSize, srcPosition: $srcPosition}';
  }
}
