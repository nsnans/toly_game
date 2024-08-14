import 'package:life_game/05/storage/persistence/frame/frame_store.dart';

main(){
  FrameQueryArgs args = FrameQueryArgs(
    title: 'title',
    subtitle: '000'
  );
  print(args.parserSql);
}

