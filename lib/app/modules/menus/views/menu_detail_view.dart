import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bukateria/app/modules/payment/views/payment_view.dart';
import 'package:bukateria/app/modules/profiles/views/profiles_view.dart';
import 'package:bukateria/cubit/order_cubit/order_cubit.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/models/menus_model.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:bukateria/repository/order_repository.dart';
import 'package:bukateria/repository/postRepository/post_repository.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_button.dart';
import 'package:bukateria/widgets/custom_input.dart';
import 'package:bukateria/widgets/ingredientItem.dart';
import 'package:bukateria/widgets/method_widget.dart';
import 'package:bukateria/widgets/pop_menu.dart';
import 'package:uuid/uuid.dart';
import 'package:bukateria/widgets/related_recipe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../common_views.dart';

/*class MenuDetailView extends GetView {
  MenuDetailView({Key? key, required this.menu}) : super(key: key);
  int? countControllerValue;
  final menu;
  String email = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(listener: (context, state) {

      if (state.status == PostStatus.save) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Menu Successfully saved!")));
      }else if (state.status == PostStatus.publish) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Menu Successfully published!")));
        Get.back();
      }else if (state.status == PostStatus.error) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong!")));
      }else if(state.status == PostStatus.submitting){
        CommonViews.showProgressDialog(context);
      }else if(state.status == PostStatus.success){
        Get.back();
      }
    }, child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
         return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: context.read<PostCubit>().getSpecificUser(menu.uid),
      builder: (context, snap) {
        if (snap.hasData) {
          return Scaffold(
            body: CustomScrollView(slivers: [
              SliverAppBar(
                  elevation: 1,
                  automaticallyImplyLeading: true,
                  backgroundColor: white,
                  iconTheme: IconThemeData(color: dark),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          FirebaseAuth.instance
                              .currentUser?.uid !=
                              menu.uid ? StreamBuilder<QuerySnapshot>(
                              stream: context.read<PostCubit>().getSpecificFavorite(menu.key),
                              builder: (context, snap){
                          return  IconButton(onPressed: (){
                              if (snap.data?.docs
                                  .isNotEmpty ??
                                  false) {
                                context
                                    .read<PostCubit>()
                                    .removeFavorite(
                                    menu.uid,
                                    FirebaseAuth.instance.currentUser?.uid ?? "",
                                  menu.key,
                                  "menu"
                                    );
                              } else {
                                context
                                    .read<PostCubit>()
                                    .addFavorite(
                                    menu.uid,
                                    FirebaseAuth.instance.currentUser?.uid ?? "",
                                    menu.key,
                                    "menu");
                              }

                            },
                              icon: Icon(
                                snap.data?.docs.isEmpty ?? false ? Icons.favorite_outline: Icons.favorite,
                                color: dark,
                                size: 30,
                              ),);
                          }): Container(),
                          PopMenu(),
                        ],
                      ),
                    )
                  ],
                  expandedHeight: 250,
                  pinned: true,
                  flexibleSpace: Container(
                      */ /*decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("${menu.image}"))),*/ /*
                      child: Container(
                    width: double.infinity,
                    height: 300,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "${menu.image}",
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ))),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        "${menu.title}",
                        style: title3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: "${snap.data?["image"]}",
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      (snap.data?["name"] ?? "").toString().isNotEmpty ? (snap.data?["name"] ?? "").toString(): snap.data?["email"],
                                      style: body4),
                                  // Text('${snap.data?["userType"]}',
                                  //     style: body5),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          color: green,
                                          size: 20,
                                        ),
                                        Expanded(
                                            child: Text(menu.location,
                                                maxLines: 2, style: body5)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                         menu.uid != FirebaseAuth.instance.currentUser?.uid?
                         StreamBuilder<QuerySnapshot>(
                             stream: context.read<PostCubit>().getSpecificFollow(menu.uid, FirebaseAuth.instance.currentUser?.uid ?? ""),
                             builder: (context,snap){
                               print("-----------${snap.data?.docs.length}");
                               return  CustomButton(
                                   width: 90,
                                   radius: 30,
                                   height: 35,
                                   onPressed: () {
                                     if(snap.data?.docs.isNotEmpty ?? false){
                                       context.read<PostCubit>().unFollow(
                                           menu.uid,
                                           FirebaseAuth.instance.currentUser?.uid ?? ""
                                       );
                                     }else {
                                       context.read<PostCubit>().addFollow(
                                           menu.uid,
                                           FirebaseAuth.instance.currentUser?.uid ??
                                               ""
                                       );
                                     }
                                   },
                                   color: snap.data?.docs.isNotEmpty ?? false
                                       ? greyLight : primary,
                                   text: snap.data?.docs.isNotEmpty ?? false
                                       ? "Remove" : "Follow" );
                             }):
                             Container()
                        ],
                      ),

                      // Generated code for this subtitle Widget...
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 10),
                        child: Text(
                          'Description',
                          style: title5,
                        ),
                      ),

                      // Generated code for this body_text Widget...
                      Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                          child: ReadMoreText(
                            '${menu.description}',
                            trimLines: 4,
                            trimMode: TrimMode.Line,
                            style: body3,
                          )),

                      SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          width: 300,
                          radius: 30,
                          height: 45,
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30))),
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 30),
                                    child: Container(
                                      height: Get.height * 0.4,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Order",
                                                style: title3,
                                              ),
                                              Text(
                                                "ID: 5673h33",
                                                style: title5,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Pickup Address",
                                                style: title5,
                                              ),
                                              // Text(
                                              //   "Change Address",
                                              //   style: body3.copyWith(color: blue),
                                              // )
                                            ],
                                          ),
                                          Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons.location_pin),
                                                        Text("Abuja, Nigeria")
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.person),
                                                        Text("Shola Kilode")
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.phone),
                                                        Text(
                                                            "+234-801-998882282")
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          CustomButton(
                                              radius: 30,
                                              color: primary,
                                              height: 40,
                                              onPressed: () =>
                                                  Get.to(() => PaymentWidget()),
                                              width: 200,
                                              text: "Confirm order")
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            //  Get.to(() => PaymentWidget());
                          },
                          color: dark,
                          text: "Place Order"),

                      // Generated code for this Row Widget...
                      SizedBox(
                        height: 20,
                      ),

                      // Generated code for this subtitle Widget...
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 10),
                        child: Text(
                          'Other menus by ${snap.data?['email']}',
                          style: title5,
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: context
                              .read<PostCubit>()
                              .getRelatedMenus(menu.uid),
                          builder: (context, snap) {
                            print(
                                "-----------www------------- ${snap.hasData} ${snap.data?.docs.length}");
                            if (snap.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: snap.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: RelatedRecipe(
                                        title: snap.data?.docs[index]['title'],
                                        text: snap.data?.docs[index]
                                            ['description'],
                                        image: snap.data?.docs[index]['image'],
                                      ),
                                    );
                                  });
                            }
                            return Container();
                          }),
                      // Generated code for this menuItem Widget...
                      */ /*RelatedRecipe(
                  title: "Okro Soup",
                  text:
                      "A wonderfully delicious 2 patty melt that melts into your...",
                  image: "assets/images/fd3.jpg",
                ),
                SizedBox(
                  height: 10,
                ),
                RelatedRecipe(
                  title: "Shakky Pepper soup",
                  text:
                      "A wonderfully delicious 2 patty melt that melts into your...",
                  image: "assets/images/fd5.jpg",
                ),*/ /*
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),

// Generated code for this author_info Widget...
              ]))
            ]),
          );
        }
        return Container();
      },
    );
        },
    ),);

  }
}*/

class MenuDetailView extends StatefulWidget {
  final menu;

  const MenuDetailView({Key? key, required this.menu}) : super(key: key);

  @override
  State<MenuDetailView> createState() => _MenuDetailViewState();
}

class _MenuDetailViewState extends State<MenuDetailView> {
  int? countControllerValue;

  String email = "";

  late VideoPlayerController _controller;

  bool isPlaying = false;
  bool showPlayButton = false;

  String a = "";

  double top = 0;
  OrderCubit orderCubit = OrderCubit(orderRepository: OrderRepository());
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    const _chars = '1234567890AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    var uuid = Uuid();
    a = getRandomString(8);
    if (widget.menu.isVideo) {
      _controller = VideoPlayerController.network(widget.menu.image,
          videoPlayerOptions: VideoPlayerOptions())
        ..initialize().then((_) {
          showPlayButton = true;
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.menu.isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {
        if (state.status == PostStatus.save) {
          Get.back();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Menu Successfully saved!")));
        } else if (state.status == PostStatus.publish) {
          Get.back();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Menu Successfully published!")));
          Get.back();
        } else if (state.status == PostStatus.error) {
          Get.back();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong!")));
        } else if (state.status == PostStatus.submitting) {
          CommonViews.showProgressDialog(context);
        } else if (state.status == PostStatus.success) {
          Get.back();
        }
      },
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return StreamBuilder<DocumentSnapshot<Object?>>(
            stream: context.read<PostCubit>().getSpecificUser(widget.menu.uid),
            builder: (context, snap) {
              if (snap.hasData) {
                return Scaffold(
                  body: CustomScrollView(slivers: [
                    SliverAppBar(
                        elevation: 1,
                        automaticallyImplyLeading: true,
                        backgroundColor: white,
                        iconTheme: IconThemeData(color: dark),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                FirebaseAuth.instance.currentUser?.uid !=
                                        widget.menu.uid
                                    ? StreamBuilder<QuerySnapshot>(
                                        stream: context
                                            .read<PostCubit>()
                                            .getSpecificFavorite(
                                                widget.menu.key),
                                        builder: (context, snap) {
                                          return Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            alignment: Alignment.center,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                if (snap.data?.docs
                                                        .isNotEmpty ??
                                                    false) {
                                                  context
                                                      .read<PostCubit>()
                                                      .removeFavorite(
                                                          widget.menu.uid,
                                                          FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid ??
                                                              "",
                                                          widget.menu.key,
                                                          "menu");
                                                } else {
                                                  context
                                                      .read<PostCubit>()
                                                      .addFavorite(
                                                          widget.menu.uid,
                                                          FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid ??
                                                              "",
                                                          widget.menu.key,
                                                          "menu");
                                                }
                                              },
                                              icon: Icon(
                                                snap.data?.docs.isEmpty ?? false
                                                    ? Icons.favorite_outline
                                                    : Icons.favorite,
                                                color: dark,
                                                size: 30,
                                              ),
                                            ),
                                          );
                                        })
                                    : Container(),
                                Container(
                                  width: 40,
                                  height: 40,
                                  margin: EdgeInsets.only(left: 12,right: 12),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: widget.menu.uid ==
                                        FirebaseAuth.instance.currentUser?.uid
                                        ? PopMenu(
                                      postType: "menu",
                                      post: widget.menu,
                                    )
                                        : PopMenu(
                                      reportedPostUID: widget.menu.key,
                                      reportedUserUID: widget.menu.uid,
                                    ),
                                  )
                                ),
                              ],
                            ),
                          )
                        ],
                        leading: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        expandedHeight: 250,
                        pinned: true,
                        flexibleSpace: Container(
                            /*decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("${menu.image}"))),*/
                            child: Container(
                          width: double.infinity,
                          height: 300,
                          child: widget.menu.isVideo
                              ? Container(
                                  height: 300,
                                  child: Stack(
                                    children: [
                                      VideoPlayer(_controller),
                                      Center(
                                        child: showPlayButton
                                            ? IconButton(
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
                                              )
                                            : CircularProgressIndicator(),
                                      )
                                    ],
                                  ),
                                )
                              : CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: "${widget.menu.image}",
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                        ))),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 13,
                            ),
                            Text(
                              "${widget.menu.title}",
                              style: title3,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    Get.to(() => ProfilesView(
                                          uid: widget.menu.uid,
                                        ));
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 7, 0),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: "${snap.data?["image"]}",
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset("assets/images/image_placeholder.jpeg"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("@${snap.data?["username"]}",
                                                style: body4),
                                            // Text('${snap.data?["userType"]}',
                                            //     style: body5),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.location_pin,
                                                    color: green,
                                                    size: 20,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          widget.menu.location,
                                                          maxLines: 2,
                                                          style: body5)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                widget.menu.uid !=
                                        FirebaseAuth.instance.currentUser?.uid
                                    ? StreamBuilder<QuerySnapshot>(
                                        stream: context
                                            .read<PostCubit>()
                                            .getSpecificFollow(
                                                widget.menu.uid,
                                                FirebaseAuth.instance
                                                        .currentUser?.uid ??
                                                    ""),
                                        builder: (context, snap) {
                                          print(
                                              "-----------${snap.data?.docs.length}");
                                          return CustomButton(
                                              width: 100,
                                              radius: 30,
                                              height: 35,
                                              onPressed: () {
                                                if (snap.data?.docs
                                                        .isNotEmpty ??
                                                    false) {
                                                  context
                                                      .read<PostCubit>()
                                                      .unFollow(
                                                          widget.menu.uid,
                                                          FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid ??
                                                              "");
                                                } else {
                                                  context
                                                      .read<PostCubit>()
                                                      .addFollow(
                                                          widget.menu.uid,
                                                          FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid ??
                                                              "");
                                                }
                                              },
                                              color: /*snap.data?.docs.isNotEmpty ?? false
                                                ? greyLight : */
                                                  primary,
                                              text:
                                                  snap.data?.docs.isNotEmpty ??
                                                          false
                                                      ? "Unfollow"
                                                      : "Follow");
                                        })
                                    : Container()
                              ],
                            ),

                            // Generated code for this subtitle Widget...
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 15, 0, 10),
                              child: Text(
                                'Description',
                                style: title5,
                              ),
                            ),

                            // Generated code for this body_text Widget...
                            Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: ReadMoreText(
                                  '${widget.menu.description}',
                                  trimLines: 4,
                                  trimMode: TrimMode.Line,
                                  style: body3,
                                )),

                            SizedBox(
                              height: 20,
                            ),
                            (FirebaseAuth.instance.currentUser?.uid ?? "") !=
                                    widget.menu.uid.toString()
                                ? BlocListener<OrderCubit, OrderState>(
                                    listener: (context, state) {
                                      print("---------${state}");
                                      if (state.status ==
                                          OrderStatus.processing) {
                                        Get.back();
                                        CommonViews.showProgressDialog(context);
                                      } else if (state.status ==
                                          OrderStatus.success) {
                                        Get.back();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Order successfully placed!')));
                                      } else if (state.status ==
                                          OrderStatus.error) {
                                        Get.back();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Something went wrong!')));
                                      }
                                    },
                                    child: BlocBuilder<OrderCubit, OrderState>(
                                      bloc: context.read<OrderCubit>(),
                                      builder: (context, state) {
                                        return CustomButton(
                                            width: 300,
                                            radius: 30,
                                            height: 45,
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      30))),
                                                  builder: (context) {
                                                    return StreamBuilder<
                                                        DocumentSnapshot>(
                                                      stream: context
                                                          .read<PostCubit>()
                                                          .getSpecificUser(
                                                              widget.menu.uid),
                                                      builder:
                                                          (context, userSnap) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  top: 30),
                                                          child: Container(
                                                            height: Get.height *
                                                                0.6,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Order",
                                                                      style:
                                                                          title3,
                                                                    ),
                                                                    Text(
                                                                      "ID: $a",
                                                                      style:
                                                                          title5,
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 25,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "Delivery Type",
                                                                      style:
                                                                          title5,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    "${widget.menu.deliveryType}",
                                                                    style:
                                                                        title5,
                                                                  ),
                                                                ),
                                                                Card(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              "Seller Detail",
                                                                              style: title5,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        widget.menu.deliveryType == "pickup"
                                                                            ? Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 5),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(Icons.location_pin),
                                                                              Expanded(child: Text("${userSnap.data?['address']}"))
                                                                            ],
                                                                          ),
                                                                        )
                                                                            :Container(),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 5),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(Icons.person),
                                                                              userSnap.data?['name'].toString() == '' ?
                                                                              Text("${userSnap.data?['username']}"):
                                                                              Text("${userSnap.data?['name']}")
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        widget.menu.deliveryType != "pickup"
                                                                            ? Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 5),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(Icons.phone),
                                                                              Text("${userSnap.data?['phone']}")
                                                                            ],
                                                                          ),
                                                                        )
                                                                            : Container(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                CustomButton(
                                                                    radius: 30,
                                                                    color:
                                                                        primary,
                                                                    height: 40,
                                                                    onPressed:
                                                                        () {

                                                                          FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser?.uid??"").get().then((value) {
                                                                            if(value["address"]!= "" && value["phone"]!= ""){

                                                                              context
                                                                                  .read<
                                                                                  OrderCubit>()
                                                                                  .changeOrderId(
                                                                                  "${a}");
                                                                              context
                                                                                  .read<
                                                                                  OrderCubit>()
                                                                                  .changeBuyerId(
                                                                                  "${FirebaseAuth.instance.currentUser?.uid ?? ""}");
                                                                              context
                                                                                  .read<
                                                                                  OrderCubit>()
                                                                                  .changeDateTime(
                                                                                  "${DateTime.now().toString()}");
                                                                              context
                                                                                  .read<
                                                                                  OrderCubit>()
                                                                                  .changeDeliveryType(
                                                                                  "${widget.menu.deliveryType}");
                                                                              context
                                                                                  .read<
                                                                                  OrderCubit>()
                                                                                  .changeMenuId(
                                                                                  "${widget.menu.key}");
                                                                              context
                                                                                  .read<
                                                                                  OrderCubit>()
                                                                                  .changeOrderStatus(
                                                                                  "Pending");
                                                                              context
                                                                                  .read<
                                                                                  OrderCubit>()
                                                                                  .changeSellerId(
                                                                                  "${widget.menu.uid}");
                                                                              FirebaseFirestore
                                                                                  .instance
                                                                                  .collection(
                                                                                  "User")
                                                                                  .doc(widget
                                                                                  .menu
                                                                                  .uid)
                                                                                  .get()
                                                                                  .then(
                                                                                      (value) async {
                                                                                    FirebaseFirestore
                                                                                        .instance
                                                                                        .collection(
                                                                                        "User")
                                                                                        .doc(FirebaseAuth.instance.currentUser?.uid ??
                                                                                        "")
                                                                                        .get()
                                                                                        .then((valueSender) async {
                                                                                      Map<String, dynamic>
                                                                                      notificationData =
                                                                                      {};
                                                                                      notificationData["receiverId"] =
                                                                                          FirebaseAuth.instance.currentUser?.uid ?? "";
                                                                                      notificationData["senderId"] = widget
                                                                                          .menu
                                                                                          .uid;
                                                                                      notificationData["message"] =
                                                                                      "You have a new order";
                                                                                      notificationData["createdAt"] =
                                                                                          DateTime.now().toString();
                                                                                      orderCubit.sendNotification(
                                                                                          value["token"],
                                                                                          valueSender["name"],
                                                                                          context,
                                                                                          "You have a new order");
                                                                                      await FirebaseFirestore
                                                                                          .instance
                                                                                          .collection("notifications")
                                                                                          .doc()
                                                                                          .set(notificationData);

                                                                                    });
                                                                                  });
                                                                              context
                                                                                  .read<
                                                                                  OrderCubit>()
                                                                                  .placeOrder();

                                                                            }else{
                                                                              showAddDialog(context, _phoneController, _addressController);
                                                                            }
                                                                          });
                                                                      

                                                                    },
                                                                    width: 200,
                                                                    text:
                                                                        "Confirm order")
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  });
                                              //  Get.to(() => PaymentWidget());
                                            },
                                            color: dark,
                                            text: "Place Order");
                                      },
                                    ),
                                  )
                                : Container(),

                            // Generated code for this Row Widget...
                            SizedBox(
                              height: 20,
                            ),

                            // Generated code for this subtitle Widget...
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 15, 0, 10),
                              child: Text(
                                'Other menus by ${snap.data?['username']}',
                                style: title5,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: context
                                    .read<PostCubit>()
                                    .getRelatedMenus(widget.menu.uid),
                                builder: (context, snap) {
                                  print(
                                      "-----------www------------- ${snap.hasData} ${snap.data?.docs.length}");
                                  if (snap.hasData) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snap.data?.docs.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: InkWell(
                                              onTap: () {
                                                // print("--------click-------${snap.data?.docs[index]["is"]}");
                                                DocumentSnapshot element =
                                                    snap.data!.docs[index];
                                                MenusModel model = MenusModel(
                                                    key: element["key"],
                                                    title: element["title"],
                                                    description:
                                                        element["description"],
                                                    productStatus: element[
                                                        "productStatus"],
                                                    created_at:
                                                        (element["created_at"]
                                                                as Timestamp)
                                                            .toDate(),
                                                    image: element["image"],
                                                    uid: element["uid"],
                                                    isVideo: element["isVideo"],
                                                    deliveryType:
                                                        element["deliveryType"],
                                                    price: element["price"],
                                                    location:
                                                        element["location"]);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MenuDetailView(
                                                                menu: model)));
                                                //Get.to(() => MenuDetailView(menu: model));
                                              },
                                              child: RelatedRecipe(
                                                title: snap.data?.docs[index]
                                                    ['title'],
                                                text: snap.data?.docs[index]
                                                    ['description'],
                                                isVideo: snap.data?.docs[index]
                                                    ['isVideo'],
                                                image: snap.data?.docs[index]
                                                    ['image'],
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                  return Container();
                                }),
                            // Generated code for this menuItem Widget...
                            /*RelatedRecipe(
                  title: "Okro Soup",
                  text:
                      "A wonderfully delicious 2 patty melt that melts into your...",
                  image: "assets/images/fd3.jpg",
                ),
                SizedBox(
                  height: 10,
                ),
                RelatedRecipe(
                  title: "Shakky Pepper soup",
                  text:
                      "A wonderfully delicious 2 patty melt that melts into your...",
                  image: "assets/images/fd5.jpg",
                ),*/
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),

// Generated code for this author_info Widget...
                    ]))
                  ]),
                );
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}

showAddDialog(BuildContext context, _phoneController, _addressController ){
  showDialog(context: context, builder: (context){
    return Dialog(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12,),
            Text("Add Pickup Contact Detail",
                style: title5.copyWith(color: primary)),
            SizedBox(height: 12,),
            Text("Please fill the details to proceed",
                style: title7.copyWith(color: grey)),
            SizedBox(height: 16,),
            Padding(
              padding:
              const EdgeInsets.all(12),
              child: Container(
                height: 50,
                child: TextFormField(
                  controller: _phoneController,
                  onChanged: (_) {},
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    // labelText: 'Description',
                    hintText: 'Enter your phone number',
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
                  maxLines: 1,
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.all(12),
              child: Container(
                height: 50,
                child: TextFormField(
                  controller: _addressController,
                  onChanged: (_) {},
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    // labelText: 'Description',
                    hintText: 'Enter your address',
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
                  maxLines: 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primary)
                  ),
                  onPressed: () async{
                if(_phoneController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter phone number")));
                }else if(_addressController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter address")));
                }else{
                  Map<String,dynamic> map = {};
                  map["phone"] = _phoneController.text;
                  map["address"] = _addressController.text;
                  FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser?.uid ?? "").update(map).then((value) {
                    Navigator.pop(context);
                    //Get.to(() => AddMenu());
                  });
                }

              }, child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: Text("Add")
                  ))),
            )
          ],
        ),
      ),
    );
  });
}
