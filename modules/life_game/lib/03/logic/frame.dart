// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-06
// Contact Me:  1981462002@qq.com

typedef XY = (int, int);

class Frame {
  XY size;

  /// 地图数据
  Map<XY, bool> spaces = {};

  /// 拥挤度关系
  Map<XY, int> spaceValueMap = {};

  Frame(this.size) {
    reset();
  }

  int spaceValue(XY key) => spaceValueMap[key] ?? 0;

  Frame clone() {
    Frame frame = Frame(size);
    frame.spaces = spaces.map((k, v) => MapEntry(k, v));
    frame.spaceValueMap = spaceValueMap.map((k, v) => MapEntry(k, v));
    return frame;
  }

  void birth(XY position){
    spaces[position] = true;
    _calcSpaceValue();
  }

  void died(XY position){
    spaces.remove(position);
    _calcSpaceValue();
  }


  void evolve() {
    spaceValueMap.forEach(_evolveAt);
    _calcSpaceValue();
  }

  void _evolveAt(XY key, int value) {
    bool live = spaces[key] == true;
    if (live) {
      bool keepAlive = (value == 2 || value == 3);
      if (!keepAlive) spaces.remove(key);
    } else {
      if (value == 3) spaces[key] = true;
    }
  }

  void _calcSpaceValue() {
    for (int y = 0; y < size.$1; y++) {
      for (int x = 0; x < size.$2; x++) {
        int count = _calculate(x, y);
        spaceValueMap[(x, y)] = count;
      }
    }
  }

  int _calculate(int x, int y) {
    int count = 0;
    for (int i = y - 1; i <= y + 1; i++) {
      for (int j = x - 1; j <= x + 1; j++) {
        if ((x, y) == (j, i)) continue;
        if (spaces[(j, i)] == true) count++;
      }
    }
    return count;
  }

  void reset() {
    spaces = {(3, 4): true, (4, 4): true, (5, 4): true, (4, 3): true};
    _calcSpaceValue();
  }

  void clear() {
    spaces.clear();
    spaceValueMap.clear();
  }
}
