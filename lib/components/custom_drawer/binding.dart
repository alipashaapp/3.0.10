import 'package:get/get.dart';

import 'logic.dart';

class CustomDrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomDrawerLogic());
  }
}
