import 'package:get/get.dart';

import 'logic.dart';

class AgreePrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AgreePrivacyLogic());
  }
}
