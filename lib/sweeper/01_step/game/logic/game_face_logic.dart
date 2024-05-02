import 'dart:async';

mixin GameFaceLogic{
  bool _isActive = false;

  final StreamController<bool> _faceCtrl = StreamController.broadcast();

  Stream<bool> get faceStream => _faceCtrl.stream;

  void activeFace(){
    if(_isActive) return;
    _faceCtrl.add(true);
    _isActive = true;
  }

  void resetFace(){
    if(!_isActive) return;
    _faceCtrl.add(false);
    _isActive = false;
  }
}