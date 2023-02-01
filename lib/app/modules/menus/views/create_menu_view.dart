import 'dart:io';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/widgets/deliverytype_radio_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:bukateria/app/modules/pages/google_places_search.dart';
import 'package:bukateria/flutter_flow/flutter_flow_icon_button.dart';
import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/flutter_flow/flutter_flow_widgets.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/radio_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../common_views.dart';

class AddMenu extends StatefulWidget {
  final menu;
  const AddMenu({this.menu, Key? key}) : super(key: key);

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  TextEditingController? addIngredientFieldController1;
  TextEditingController? descriptionController;
  TextEditingController? fullNameController;
  TextEditingController? priceController;
  double? sliderValue;
  TextEditingController? addIngredientFieldController2;
  TextEditingController? texeareaController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedLocation = "Location";

  late VideoPlayerController _controller;

  bool isPlaying = false;


  @override
  void initState() {
    super.initState();

    if(widget.menu != null){
      fullNameController = TextEditingController(text: widget.menu.title);
      descriptionController = TextEditingController(text: widget.menu.description);
      priceController = TextEditingController(text: widget.menu.price);
      selectedLocation =  widget.menu.location;

      _deliveryType = widget.menu.deliveryType == "Delivery" ? DeliveryType.Delivery: DeliveryType.Pickup;

      if (widget.menu.isVideo) {
        _controller = VideoPlayerController.network(widget.menu.image,
            videoPlayerOptions: VideoPlayerOptions())
          ..initialize().then((_) {
            setState(() {});
          });
      }

    }else {
      addIngredientFieldController1 = TextEditingController();
      descriptionController = TextEditingController();
      fullNameController = TextEditingController();
      priceController = TextEditingController();
      addIngredientFieldController2 = TextEditingController();
      texeareaController = TextEditingController();
    }
    // WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {}));
  }

  MenuType? _menuType;
  DeliveryType? _deliveryType = null;

  String value = 'cuisines';
  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'african', title: 'African'),
    S2Choice<String>(value: 'american', title: 'American'),
    S2Choice<String>(value: 'Brazilian', title: 'Brazilian'),
    S2Choice<String>(value: 'british', title: 'British'),
    S2Choice<String>(value: 'cajun', title: 'Cajun'),
    S2Choice<String>(value: 'chinese', title: 'Chinese'),
    S2Choice<String>(value: 'french', title: 'French'),
    S2Choice<String>(value: 'german', title: 'German'),
    S2Choice<String>(value: 'greek', title: 'Greek'),
    S2Choice<String>(value: 'italian', title: 'Italian'),
    S2Choice<String>(value: 'indian', title: 'Indian'),
    S2Choice<String>(value: 'indonesian', title: 'Indonesian'),
    S2Choice<String>(value: 'japanese', title: 'Japanese'),
    S2Choice<String>(value: 'korean', title: 'Korean'),
    S2Choice<String>(value: 'lebanese', title: 'Lebanese'),
    S2Choice<String>(value: 'mediterranean', title: 'Mediterranean'),
    S2Choice<String>(value: 'mexican', title: 'Mexican'),
    S2Choice<String>(value: 'moroccan', title: 'Moroccan'),
    S2Choice<String>(value: 'pakistani', title: 'Pakistani'),
    S2Choice<String>(value: 'russian', title: 'Russian'),
    S2Choice<String>(value: 'spanish', title: 'Spanish'),
    S2Choice<String>(value: 'thai', title: 'Thai'),
    S2Choice<String>(value: 'turkish', title: 'Turkish'),
    S2Choice<String>(value: 'Vietnamese', title: 'Vietnamese'),
    S2Choice<String>(value: 'others', title: 'Others'),
  ];

  bool isVideo = false;

  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imagePath = File(image.path);
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
      if(imagePath.lengthSync()/(1000*1000) > 20){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select video under 20MB")));
      }else {
        this.image = imagePath;
        isVideo = true;
        setState(() => this.image = imagePath);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(listener: (context, state) {

      if (state.status == PostStatus.save) {
        Get.back();
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Menu Successfully added!")));
      }else if (state.status == PostStatus.publish) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Menu Successfully published!")));
        Get.back();
      }else if (state.status == PostStatus.error) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong!")));
      }else if (state.status == PostStatus.updated) {
        Get.back();
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("updated Successfully")));
      }else if(state.status == PostStatus.submitting){
        CommonViews.showProgressDialog(context);
      }
    }, child: BlocBuilder<PostCubit, PostState>(
    builder: (context, state) {
      return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: white,
        // toolbarHeight: 70,
        iconTheme: IconThemeData(color: dark),
        automaticallyImplyLeading: true,
        actions: [
         /*  widget.menu != null ? Container(): InkWell(
            onTap: (){
              String deliveryType = _deliveryType == null? "" :_deliveryType == DeliveryType.Delivery ? "delivery": "pickup";
              if(image == null){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image is not selected")));
              }else  if((fullNameController?.text ?? "").isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter title")));
              }else  if((descriptionController?.text ?? "").isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter description")));
              }else  if((priceController?.text ?? "").isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter price")));
              }else  if(selectedLocation.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("please enter location")));
              }else  if(deliveryType.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delivery type is not selected")));

              }else{
                context.read<PostCubit>().imageChanged(image!);
                context.read<PostCubit>().titleChanged(fullNameController!.text);
                context.read<PostCubit>().descriptionChanged(descriptionController!.text);
                context.read<PostCubit>().productStatusChanged("SAVE");
                context.read<PostCubit>().priceChanged(priceController!.text);
                context.read<PostCubit>().locationChanged(selectedLocation);
                context.read<PostCubit>().delvieryTypeChanged(_deliveryType == DeliveryType.Delivery ? "delivery": "pickup");

                context.read<PostCubit>().postMenuCredentials(image?.path ?? "", FirebaseAuth.instance.currentUser?.uid ?? "",isVideo);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 20,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: state.status == PostStatus.save? Colors.grey.shade300 : Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: Text("Save"),
            ),
          ),
          SizedBox(
            width: 10,
          ),*/
          widget.menu != null ? Container(): InkWell(
            onTap: (){
              /*if(state.status == PostStatus.save){
                context.read<PostCubit>().productStatusChanged("SAVE");
                context.read<PostCubit>().updateMenuStatus("${state.key}", FirebaseAuth.instance.currentUser?.uid ?? "");
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Save first!")));
              }*/
              String deliveryType = _deliveryType == null? "" :_deliveryType == DeliveryType.Delivery ? "delivery": "pickup";
              if(image == null){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image is not selected")));
              }else  if((fullNameController?.text ?? "").isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter title")));
              }else  if((descriptionController?.text ?? "").isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter description")));
              }else  if((priceController?.text ?? "").isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter price")));
              }else  if(selectedLocation.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("please enter location")));
              }else  if(deliveryType.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delivery type is not selected")));

              }else{
                context.read<PostCubit>().imageChanged(image!);
                context.read<PostCubit>().titleChanged(fullNameController!.text);
                context.read<PostCubit>().descriptionChanged(descriptionController!.text);
                context.read<PostCubit>().productStatusChanged("PUBLISH");
                context.read<PostCubit>().priceChanged(priceController!.text);
                context.read<PostCubit>().locationChanged(selectedLocation);
                context.read<PostCubit>().delvieryTypeChanged(_deliveryType == DeliveryType.Delivery ? "delivery": "pickup");
                context.read<PostCubit>().postMenuCredentials(image?.path ?? "", FirebaseAuth.instance.currentUser?.uid ?? "",isVideo);
              }

            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 20,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: primary, borderRadius: BorderRadius.circular(10)),
              child: Text("Publish"),
            ),
          ),
          widget.menu == null ? Container(): InkWell(
            onTap: (){
              if(image!=null){
                context.read<PostCubit>().imageChanged(image!);
              }
              if(fullNameController?.text != widget.menu.title && (fullNameController?.text ?? "").isNotEmpty){
                context.read<PostCubit>().titleChanged(fullNameController?.text ?? "");
              }
              if(descriptionController?.text != widget.menu.description && (descriptionController?.text ?? "").isNotEmpty){
                context.read<PostCubit>().descriptionChanged(descriptionController?.text ?? "");
              }
              if(priceController != widget.menu.price && (priceController?.text ?? "").isNotEmpty){
                context.read<PostCubit>().priceChanged(priceController?.text ?? "");
              }
              if(selectedLocation != widget.menu.location && selectedLocation.isNotEmpty){
                context.read<PostCubit>().locationChanged(selectedLocation);
              }
              String deliveryType = _deliveryType == null? "" :_deliveryType == DeliveryType.Delivery ? "delivery": "pickup";
              if(deliveryType.isNotEmpty){
                context.read<PostCubit>().delvieryTypeChanged(deliveryType);
              }
             context.read<PostCubit>().updateMenuDetails(widget.menu.key, FirebaseAuth.instance.currentUser?.uid ?? "",isVideo);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 20,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: primary, borderRadius: BorderRadius.circular(10)),
              child: Text("Update"),
            ),
          ),
          SizedBox(
            width: 20,
          ),
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
              child: widget.menu != null && image == null
                  ? widget.menu.isVideo
                  ? Container(
                height: 250,
                child: Stack(
                  children: [
                    VideoPlayer(_controller),
                    Center(
                      child: IconButton(
                        onPressed: () {
                          if (isPlaying) {
                            isPlaying = false;
                            _controller.pause();
                          } else {
                            isPlaying = true;
                            _controller.play();
                          }
                          setState(() {});
                        },
                        icon: Icon(
                          isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 30,
                          color: Colors.white,
                        ),
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
                  : CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: "${widget.menu.image}",
                errorWidget: (context, url, error) =>
                    Icon(Icons.error),
              )
                  : image != null ? isVideo ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.video_file,size: 40,),
                    Text("${image!.path.split('/')[image!.path.split('/').length-1]}")
                  ],
                ),
              )
                  : Image.file(
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
                        style: title4,
                        textAlign: TextAlign.center,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          image: DecorationImage(
                              scale: 2.0,
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/food1.png"))),
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
                      onChanged: (val) {},
                      autofocus: true,
                      obscureText: false,
                      keyboardType:TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Title',
                        hintStyle: title3.copyWith(color: grey),
                        labelStyle: body3,
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
                      onChanged: (val) {},
                      autofocus: true,
                      obscureText: false,
                      keyboardType:TextInputType.text,
                      decoration: InputDecoration(
                        // labelText: 'Description',
                        hintText: 'Briefly describe your menu here',
                        hintStyle: body3,
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

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                    child: TextFormField(
                      controller: priceController,
                      onChanged: (val) {},
                      autofocus: true,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        hintText: 'Price',
                        hintStyle: body3.copyWith(color: grey.withOpacity(0.3)),
                        labelStyle: body3,
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

                  GestureDetector(
                       onTap:() => Get.to(() =>  PlaceSearch(onSelection: (location){
                      setState((){
                        selectedLocation = location;
                      });
                    },)),
                    child: Container(
                        color: greyLight.withOpacity(0.3),
                        child: ListTile(
                          title: Text(
                            selectedLocation,
                            style: body3,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   color: greyLight.withOpacity(0.3),
                  //   child: SmartSelect<String>.single(
                  //       choiceType: S2ChoiceType.chips,
                  //       placeholder: "",
                  //       selectedValue: value,
                  //       title: 'Type of Cuisines',
                  //       choiceItems: options,
                  //       onChange: (state) =>
                  //           setState(() => value = state.value)),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Padding(
                  //   padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                  //   child: Text(
                  //     'Recipe Category',
                  //     style: title5,
                  //   ),
                  // ),
                  // CustomRadio(
                  //   menuType: _menuType,
                  //   title: "Appetizer",
                  //   value: MenuType.Appetizer,
                  //   onChanged: (val) {
                  //     setState(() {
                  //       _menuType = val;
                  //     });
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // CustomRadio(
                  //   menuType: _menuType,
                  //   title: "Main Dish",
                  //   value: MenuType.Main,
                  //   onChanged: (val) {
                  //     setState(() {
                  //       _menuType = val;
                  //     });
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // CustomRadio(
                  //   menuType: _menuType,
                  //   title: "Drink",
                  //   value: MenuType.Drink,
                  //   onChanged: (val) {
                  //     setState(() {
                  //       _menuType = val;
                  //     });
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // CustomRadio(
                  //   menuType: _menuType,
                  //   title: "Desert",
                  //   value: MenuType.Desert,
                  //   onChanged: (val) {
                  //     setState(() {
                  //       _menuType = val;
                  //     });
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // CustomRadio(
                  //   menuType: _menuType,
                  //   title: "Side Dish",
                  //   value: MenuType.Side,
                  //   onChanged: (val) {
                  //     setState(() {
                  //       _menuType = val;
                  //     });
                  //   },
                  // ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                    child: Text(
                      'Delivery Type',
                      style: title5,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDeliveryTypeRadio(
                          deliveryType: _deliveryType,
                          title: "Delivery",
                          value: DeliveryType.Pickup,
                          onChanged: (val) {
                            setState(() {
                              _deliveryType = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomDeliveryTypeRadio(
                          deliveryType: _deliveryType,
                          title: "Pickup",
                          value: DeliveryType.Delivery,
                          onChanged: (val) {
                            setState(() {
                              _deliveryType = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Padding(
                  //   padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                  //   child: TextFormField(
                  //     controller: descriptionController,
                  //     onChanged: (val) {},
                  //     autofocus: true,
                  //     obscureText: false,
                  //     decoration: InputDecoration(
                  //       // labelText: 'Description',
                  //       hintText: 'Enter your pick address',
                  //       hintStyle: body3,
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: greyLight.withOpacity(0.3),
                  //           width: 1,
                  //         ),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: greyLight.withOpacity(0.3),
                  //           width: 1,
                  //         ),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       filled: true,
                  //       fillColor: greyLight.withOpacity(0.2),
                  //     ),
                  //     maxLines: 3,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                  //   child: Text(
                  //     'Ingredients',
                  //     style: title5,
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     FlutterFlowIconButton(
                  //       borderColor: Colors.transparent,
                  //       borderRadius: 30,
                  //       borderWidth: 1,
                  //       buttonSize: 60,
                  //       icon: Icon(
                  //         Icons.drag_indicator,
                  //         color: FlutterFlowTheme.of(context).primaryText,
                  //         size: 30,
                  //       ),
                  //       onPressed: () {
                  //         print('IconButton pressed ...');
                  //       },
                  //     ),
                  //     Expanded(
                  //       child: Padding(
                  //         padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                  //         child: TextFormField(
                  //           controller: addIngredientFieldController1,
                  //           onChanged: (val) {},
                  //           autofocus: true,
                  //           obscureText: false,
                  //           decoration: InputDecoration(
                  //             labelText: 'Add ingredient',
                  //             hintText: 'Enter  ingredient',
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(
                  //                 color: Color(0xFFE5E5E5),
                  //                 width: 1,
                  //               ),
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(
                  //                 color: Color(0xFFE5E5E5),
                  //                 width: 1,
                  //               ),
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //             filled: true,
                  //             fillColor: greyLight.withOpacity(0.2),
                  //           ),
                  //           style:
                  //               FlutterFlowTheme.of(context).bodyText1.override(
                  //                     fontFamily: 'Poppins',
                  //                     fontWeight: FontWeight.normal,
                  //                   ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     FlutterFlowIconButton(
                  //       borderColor: Colors.transparent,
                  //       borderRadius: 30,
                  //       borderWidth: 1,
                  //       buttonSize: 60,
                  //       icon: Icon(
                  //         Icons.drag_indicator,
                  //         color: FlutterFlowTheme.of(context).primaryText,
                  //         size: 30,
                  //       ),
                  //       onPressed: () {
                  //         print('IconButton pressed ...');
                  //       },
                  //     ),
                  //     Expanded(
                  //       child: Padding(
                  //         padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                  //         child: TextFormField(
                  //           controller: addIngredientFieldController2,
                  //           onChanged: (val) {},
                  //           autofocus: true,
                  //           obscureText: false,
                  //           decoration: InputDecoration(
                  //             labelText: 'Add  ingredient',
                  //             hintText: 'Enter  ingredient',
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(
                  //                 color: Color(0xFFE5E5E5),
                  //                 width: 1,
                  //               ),
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(
                  //                 color: Color(0xFFE5E5E5),
                  //                 width: 1,
                  //               ),
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //             filled: true,
                  //             fillColor: greyLight.withOpacity(0.2),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Icon(Icons.add),
                  //     SizedBox(
                  //       width: 7,
                  //     ),
                  //     Text(
                  //       "ingredient",
                  //       style: title5,
                  //     )
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         "Delete Post",
                  //         textAlign: TextAlign.center,
                  //         style: title5.copyWith(color: primary),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    },
    ),);
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
