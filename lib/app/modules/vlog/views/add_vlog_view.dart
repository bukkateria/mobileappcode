import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/radio_button_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../common_views.dart';
import '../../../../cubit/post_cubit/post_cubit.dart';

class AddVlog extends StatefulWidget {
  const AddVlog({Key? key}) : super(key: key);

  @override
  _AddVlogState createState() => _AddVlogState();
}

class _AddVlogState extends State<AddVlog> {
  TextEditingController? addIngredientFieldController1;
  TextEditingController? descriptionController;
  TextEditingController? fullNameController;
  double? sliderValue;
  TextEditingController? addIngredientFieldController2;
  TextEditingController? texeareaController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isVideo = false;

  var file;

  @override
  void initState() {
    super.initState();
    addIngredientFieldController1 = TextEditingController();
    descriptionController = TextEditingController();
    fullNameController = TextEditingController();
    addIngredientFieldController2 = TextEditingController();
    texeareaController = TextEditingController();
    // WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {}));
  }

  File? image;

  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;

  //     final ImageHolder = File(image.path);

  //     setState(() => this.image = ImageHolder);
  //   } on PlatformException catch (e) {
  //     print('Cannot pick image: $e');
  //   }
  // }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imagePath = File(image.path);
      file = imagePath;
      isVideo = false;
      setState(() => this.image = imagePath);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future pickVideo(ImageSource source) async {
    try {
      final image = await ImagePicker().pickVideo(source: source);
      if (image == null) return;

      final imagePath = File(image.path);
      print("-----size---------");
      print("-----size--------- ${imagePath.lengthSync()}");
      if (imagePath.lengthSync() / (1000 * 1000) > 20) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please select video under 20MB")));
      } else {
        file = imagePath;
        isVideo = true;
        setState(() => this.image = imagePath);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {
        if (state.status == PostStatus.save) {
          Get.back();
          Get.back();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Vlog Successfully added!")));
        } else if (state.status == PostStatus.publish) {
          Get.back();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Vlog Successfully published!")));
          Get.back();
        } else if (state.status == PostStatus.error) {
          Get.back();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong!")));
        } else if (state.status == PostStatus.submitting) {
          CommonViews.showProgressDialog(context);
        }
      },
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: white,
              // toolbarHeight: 70,
              iconTheme: IconThemeData(color: dark),
              automaticallyImplyLeading: true,
              actions: [
                InkWell(
                  onTap: () {

                      if (image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Image not selected!")));
                      } else if (state.title == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please write title first!")));
                      } else if (state.description == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Description write title first!")));
                      } else {
                        print("----------save-----------");
                        context.read<PostCubit>().imageChanged(image!);
                        context.read<PostCubit>().productStatusChanged("PUBLISH");
                        context.read<PostCubit>().postExploreCredentials(
                            "${state.title}",
                            FirebaseAuth.instance.currentUser?.uid ?? "",
                            isVideo);
                      }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 20,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("Publish"),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                /*InkWell(
                  onTap: () {
                    if (state.status == PostStatus.save) {
                      context.read<PostCubit>().productStatusChanged("SAVE");
                      context.read<PostCubit>().updateExploreStatus(
                          "${state.key}",
                          FirebaseAuth.instance.currentUser?.uid ?? "");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please Save first!")));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 20,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("Publish"),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),*/
              ],
              centerTitle: true,
              elevation: 0,
            ),
            backgroundColor: white,
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () => _selectOptionBottomSheet(),
                    child: isVideo
                        ? image != null
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.video_file,
                                      size: 40,
                                    ),
                                    Text(
                                        "${image!.path.split('/')[image!.path.split('/').length - 1]}")
                                  ],
                                ),
                              )
                            : Image.file(
                                image!,
                                height: 230,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                        : image != null
                            ? Image.file(
                                image!,
                                height: 230,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 230,
                                padding: EdgeInsets.only(bottom: 20),
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: Text(
                                  "Tap to upload image/video",
                                  style: title3,
                                  textAlign: TextAlign.center,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    image: DecorationImage(
                                        scale: 2.0,
                                        fit: BoxFit.contain,
                                        image: AssetImage(
                                            "assets/images/food1.png"))),
                              ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: TextFormField(
                            controller: fullNameController,
                            onChanged: (value) {
                              context.read<PostCubit>().titleChanged(value);
                            },
                            keyboardType:TextInputType.text,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              hintText: 'Title',
                              hintStyle: title3.copyWith(color: grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE5E5E5),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE5E5E5),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: greyLight.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: TextFormField(
                            controller: descriptionController,
                            onChanged: (value) => EasyDebounce.debounce(
                              'descriptionController',
                              Duration(milliseconds: 2000),
                              () => setState(() {
                                context
                                    .read<PostCubit>()
                                    .descriptionChanged(value);
                              }),
                            ),
                            keyboardType: TextInputType.text,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              // labelText: 'Description',
                              hintText: 'Briefly describe your vlog here',
                              hintStyle: body3.copyWith(color: grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: greyLight.withOpacity(0.3),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: greyLight.withOpacity(0.3),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: greyLight.withOpacity(0.2),
                            ),
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _selectOptionBottomSheet() {
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: white,
            child: new Wrap(
              children: <Widget>[
                Container(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: width,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Choose Option',
                            textAlign: TextAlign.center,
                            style: title4,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pickImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: width,
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.black.withOpacity(0.7),
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Camera',
                                  style: title4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pickVideo(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: width,
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.video_collection,
                                  color: Colors.black.withOpacity(0.7),
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Video',
                                  style: title4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pickImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: width,
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.photo_album,
                                  color: Colors.black.withOpacity(0.7),
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Upload from Gallery',
                                  style: body3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
