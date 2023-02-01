import 'package:get/get.dart';

import '../controllers/comments_controller.dart';

class PausePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommentsController>(
          () => CommentsController(),
    );
  }
}
