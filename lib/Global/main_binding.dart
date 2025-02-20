import 'package:ali_pasha_graph/Global/main_controller.dart';
import 'package:get/get.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController(), fenix: true);
  }
}
