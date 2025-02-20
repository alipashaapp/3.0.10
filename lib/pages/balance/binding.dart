import 'package:get/get.dart';

import 'logic.dart';

class BalanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BalanceLogic());
  }
}
