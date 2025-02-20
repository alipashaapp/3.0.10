import 'package:get/get.dart';

import 'logic.dart';

class ShippingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShippingLogic());
  }
}
