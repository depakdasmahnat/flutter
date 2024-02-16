import 'package:flutter/cupertino.dart';

class CheckDemoController extends ChangeNotifier{
  int stepIndex =-1;
  addIndex(int? index){
    stepIndex =index??-1;
    notifyListeners();
  }

}