import 'package:get/get.dart';

import 'logic.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuLogic());
  }
}
