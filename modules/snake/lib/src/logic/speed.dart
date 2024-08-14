import 'package:equatable/equatable.dart';

/// [kWorldTimeUnit] 是世界演化的基本时间单位
/// 对应现实世界的 1000 ms 也就是 1s
///
/// [kSupports] 应用支持的演化速率设置
class Speed extends Equatable {
  final double level;

  static const _kWorldTimeUnit = 600;

  const Speed._(this.level);

  static List<Speed> kSupports = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0].map((e) => Speed._(e)).toList();

  static Speed initial = const Speed._(1);

  double get time => _kWorldTimeUnit / level;

  @override
  List<Object?> get props => [level];
}
