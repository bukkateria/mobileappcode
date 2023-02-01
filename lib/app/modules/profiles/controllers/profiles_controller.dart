import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilesController extends GetxController {
  late PageController pagecontroller;
  var selectedPage = 0.obs;
  var checkedValue = false.obs;

  @override
  void onInit() {
    pagecontroller = PageController();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getPage(int pageNum) {
    selectedPage.value = pageNum;
    pagecontroller.animateToPage(pageNum,
        duration: Duration(microseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn);
  }
}
