import 'package:get/get.dart';

import 'logic.dart';

class CreateProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateProductLogic());
  }
}
