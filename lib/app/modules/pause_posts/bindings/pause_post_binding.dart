import 'package:get/get.dart';

import '../controllers/pause_post_controller.dart';

class PausePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PausePostController>(
          () => PausePostController(),
    );
  }
}
