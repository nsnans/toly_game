// // Copyright 2014 The 张风捷特烈 . All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
//
// // Author:      张风捷特烈
// // CreateTime:  2024-07-06
// // Contact Me:  1981462002@qq.com
// // 基于二维数组实现，较为复杂。已采用 [frame.dart] 映射版
//
// class Frame {
//   int get row => data.length;
//
//   int get column => data.isEmpty ? 0 : data.first.length;
//
//   late List<List<int>> data =  [
//     [0, 0, 0, 0, 0, 0, 0, 0, 0],
//     [0, 0, 0, 0, 0, 0, 0, 0, 0],
//     [0, 0, 0, 0, 0, 0, 0, 0, 0],
//     [0, 0, 0, 0, 1, 0, 0, 0, 0],
//     [0, 0, 0, 1, 1, 0, 0, 0, 0],
//     [0, 0, 0, 0, 1, 0, 0, 0, 0],
//     [0, 0, 0, 0, 0, 0, 0, 0, 0],
//     [0, 0, 0, 0, 0, 0, 0, 0, 0],
//     [0, 0, 0, 0, 0, 0, 0, 0, 0]
//   ];
//
//
//   final Map<(int, int), int> _cellNeighborsMap = {};
//
//   Map<(int, int), int> get cellNeighborsMap => _cellNeighborsMap;
//
//   int neighborsCount((int, int) key) => _cellNeighborsMap[key] ?? 0;
//
//   void next() {
//     (int, int) size = (row, column);
//     List<List<int>> newData = data.toList();
//     for (var i = 0; i < size.$1; i++) {
//       for (var j = 0; j < size.$2; j++) {
//         int aliveNeighbors = neighborsCount((i, j));
//         if (data[i][j] == 1) {
//           newData[i][j] = (aliveNeighbors == 2 || aliveNeighbors == 3) ? 1 : 0;
//         } else {
//           newData[i][j] = (aliveNeighbors == 3) ? 1 : 0;
//         }
//       }
//     }
//     data = newData;
//   }
//
//   void calcNeighbors() {
//     (int, int) size = (row, column);
//     for (int i = 0; i < size.$1; i++) {
//       for (int j = 0; j < size.$2; j++) {
//         int count = _countAliveNeighbors((i, j), size);
//         _cellNeighborsMap[(i, j)] = count;
//       }
//     }
//   }
//
//   int _countAliveNeighbors((int, int) pos, (int, int) size) {
//     int count = 0;
//     for (var i = -1; i <= 1; i++) {
//       for (var j = -1; j <= 1; j++) {
//         if (i == 0 && j == 0) continue;
//         int newRow = pos.$1 + i;
//         int newCol = pos.$2 + j;
//         if (newRow >= 0 && newRow < size.$1 && newCol >= 0 && newCol < size.$2) {
//           count += data[newRow][newCol];
//         }
//       }
//     }
//     return count;
//   }
//
//   void reset() {
//     data = [
//       [0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 1, 0, 0, 0, 0],
//       [0, 0, 0, 1, 1, 1, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0]
//     ];
//   }
// }
