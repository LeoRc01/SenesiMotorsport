import 'package:get/get.dart';

class Controller extends GetxController {
  var isChanged = false.obs;

  void setChanged(state) => isChanged(state);
  bool getChanged() => isChanged.value;
}
