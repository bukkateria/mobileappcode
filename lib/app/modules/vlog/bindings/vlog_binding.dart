import 'package:get/get.dart';

import '../controllers/vlog_controller.dart';

class VlogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VlogController>(
      () => VlogController(),
    );
  }
}
