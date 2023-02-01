import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../themes/colors.dart';
import '../../../../widgets/custom_button.dart';

class CarouselImagesView extends StatefulWidget {
  const CarouselImagesView({Key? key}) : super(key: key);

  @override
  _CarouselImagesViewState createState() => _CarouselImagesViewState();
}

class _CarouselImagesViewState extends State<CarouselImagesView> {
  List<File> images = [];
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Carousel'),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                getMultipImage();
              },
              child: Container(
                  width: 200,
                  height: 200,
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
              margin: const EdgeInsets.symmetric(horizontal: 10),
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
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: loader
                  ? const CircularProgressIndicator(
                      color: primary,
                    )
                  : CustomButton(
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
                            storeEntry(downloadUrls);
                          }
                        }
                      },
                    ),
            ),
          ]),
        ),
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
    }
  }

  Future<String> uploadFile(File file) async {
    setState(() {
      loader = true;
    });
    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref();
    Reference ref = storageRef
        .child('pictures/${DateTime.now().microsecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(file, metaData);

    final taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  storeEntry(List<String> imageUrls) {
    FirebaseFirestore.instance
        .collection('carousel')
        .doc('images')
        .set({'image': imageUrls}).then((value) {
      setState(() {
        loader = false;
        images.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully uploaded!")));
    });
  }
}
