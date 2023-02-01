import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../themes/colors.dart';
import '../../../../widgets/custom_button.dart';

class ADDCarouselImages extends StatefulWidget {
  ADDCarouselImages({Key? key, required this.update}) : super(key: key);
  Function update;
  @override
  State<ADDCarouselImages> createState() => _ADDCarouselImagesState();
}

class _ADDCarouselImagesState extends State<ADDCarouselImages> {
  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: "Carousel",
      subtitle: "Carousel Images",
      leading: const Icon(Icons.image),
      onTap: () {},
      child: SettingsScreen(
        title: "Add Carousel Images",
        children: [
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              getMultipImage();
            },
            child: Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                  child: Icon(
                    Icons.upload_file,
                    size: 50,
                  ),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: Get.width,
            height: 150,
            child: images.length == 0
                ? Center(
                    child: Text("No Images found"),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8)),
                          child: Image.file(
                            images[i],
                            fit: BoxFit.cover,
                          ));
                    },
                    itemCount: images.length,
                  ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: CustomButton(
              width: Get.width,
              radius: 30,
              height: 50,
              text: "Add Carousel",
              color: primary,
              onPressed: () async {
                for (int i = 0; i < images.length; i++) {
                  String url = await uploadFile(images[i]);
                  downloadUrls.add(url);

                  if (i == images.length - 1) {
                    storeEntry(downloadUrls, '');
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> downloadUrls = [];

  final ImagePicker _picker = ImagePicker();

  getMultipImage() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();

    if (pickedImages != null) {
      pickedImages.forEach((e) {
        images.add(File(e.path));
      });

      setState(() {});
      widget.update();
    }
  }

  Future<String> uploadFile(File file) async {
    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref();
    Reference ref = storageRef
        .child('pictures/${DateTime.now().microsecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(file, metaData);

    final taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  storeEntry(List<String> imageUrls, String name) {
    FirebaseFirestore.instance
        .collection('story')
        .add({'image': imageUrls, 'name': name}).then((value) {
      Get.snackbar('Success', 'Data is stored successfully');
    });
  }
}

// CustomButton(
//       width: Get.width,
//       radius: 30,
//       height: 50,
//       text: "Add Carousel",
//       color: primary,
//       onPressed: () async {},
//     ),
