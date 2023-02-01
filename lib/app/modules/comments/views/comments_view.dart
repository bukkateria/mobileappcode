import 'package:bukateria/app/modules/menus/views/menu_detail_view.dart';
import 'package:bukateria/app/modules/recipes/views/recipe_detail_view.dart';
import 'package:bukateria/common_views.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/models/menus_model.dart';
import 'package:bukateria/models/recipe_model.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_input.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../widgets/related_recipe.dart';

class CommentsView extends StatefulWidget {
  final recipe;

  const CommentsView({this.recipe, Key? key}) : super(key: key);

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _commentController = TextEditingController();
  TextEditingController _commentReplyController = TextEditingController();

  var _controller;

  int checkIndex = -1;
  String commentReply = "";

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'Comments',
          style: title3,
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
          child: BlocListener<PostCubit, PostState>(
        listener: (context, state) {
          if (state.status == PostStatus.save) {
            Get.back();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Recipe Successfully saved!")));
          } else if (state.status == PostStatus.success) {
            Get.back();
          } else if (state.status == PostStatus.error) {
            Get.back();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Something went wrong!")));
          } else if (state.status == PostStatus.updated) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Successfully updated")));
            Get.back();
            Get.back();
          } else if (state.status == PostStatus.submitting) {
            CommonViews.showProgressDialog(context);
          }
        },
        child: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
            stream: context.read<PostCubit>().getComments(widget.recipe.key),
            builder: (context, snap) {
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: ListView.builder(
                            itemCount: snap.data?.docs.length ?? 0,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return StreamBuilder<DocumentSnapshot>(
                                  stream: context
                                      .read<PostCubit>()
                                      .getSpecificUser(snap.data?.docs[index]
                                          ["commentedBy"]),
                                  builder: (context, userSnap) {
                                    return ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 12),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 7, 0),
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                    "${userSnap.data?["image"]}",
                                                    errorWidget:
                                                        (context, url, error) =>
                                                        Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${userSnap.data?["name"] ?? ""}',
                                                        style: body2.copyWith(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black)),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Text(
                                                        '${snap.data?.docs[index]["comment"]}',
                                                        style: body4),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(),
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                if(checkIndex == index){
                                                                  checkIndex = -1;
                                                                }else {
                                                                  checkIndex =
                                                                      index;
                                                                }
                                                                _commentController.text = userSnap.data?["username"]+" ";
                                                                commentReply = userSnap.data?["username"];
                                                              });
                                                            },
                                                            child: Text("Reply"))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                            stream: context.read<PostCubit>().getComments(snap.data?.docs[index]["key"]),
                                            builder: (context,subComments){
                                              if(subComments.data?.docs!=null){
                                                return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: subComments.data?.docs.length ?? 0,
                                                    itemBuilder: (context,index3){
                                                  return Row(
                                                    children: [
                                                      Expanded(child: Container(),),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/1.5,
                                                        child: StreamBuilder<DocumentSnapshot>(
                                                            stream: context
                                                        .read<PostCubit>()
                                                        .getSpecificUser(subComments.data?.docs[index3]["commentedBy"]),
                                                            builder: (context,subCommentUser){
                                                          if(subCommentUser.data != null) {
                                                            return Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 12),
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize
                                                                    .max,
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0, 0, 7,
                                                                        0),
                                                                    child: Container(
                                                                      width: 30,
                                                                      height: 30,
                                                                      clipBehavior: Clip
                                                                          .antiAlias,
                                                                      decoration: const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: CachedNetworkImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        imageUrl:
                                                                        "${subCommentUser
                                                                            .data?["image"]}",
                                                                        errorWidget:
                                                                            (
                                                                            context,
                                                                            url,
                                                                            error) =>
                                                                            Icon(
                                                                                Icons
                                                                                    .error),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Text(
                                                                            '${subCommentUser
                                                                                .data?["name"] ??
                                                                                ""}',
                                                                            style: body2
                                                                                .copyWith(
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .bold,
                                                                                color: Colors
                                                                                    .black)),
                                                                        SizedBox(
                                                                          width: 6,
                                                                        ),
                                                                        Text(
                                                                            '${subComments
                                                                                .data
                                                                                ?.docs[index]["comment"]}',
                                                                            style: body4)
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                          return Container();
                                                        }),
                                                      )

                                                    ],
                                                  );
                                                });
                                              }
                                          return Container();
                                        })
                                      ],
                                    );
                                  });
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: CustomInput(
                        controller: _commentController,
                        height: 60,
                        suffixIcon: Icons.send,
                        labelText: "Add comment",
                        filled: true,
                        bgcolor: white,
                        borderRadius: 30,
                        onPress: () {
                          if(checkIndex == -1){
                            context.read<PostCubit>().addComment(
                                widget.recipe.key,
                                FirebaseAuth.instance.currentUser?.uid ?? "",
                                _commentController.text,
                                widget.recipe.uid,
                                "recipe");
                          }else{
                            context.read<PostCubit>().addComment(
                                snap.data?.docs[checkIndex]
                                ["key"],
                                FirebaseAuth
                                    .instance
                                    .currentUser
                                    ?.uid ??
                                    "",
                                _commentController.text.replaceAll("${commentReply}", "").trim(),
                                widget
                                    .recipe.uid,
                                "comment");
                          }

                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }),
      )),
    );
  }

  menuTabView() {
    return StreamBuilder<QuerySnapshot?>(
      stream: context
          .read<PostCubit>()
          .getPauseMenus(FirebaseAuth.instance.currentUser?.uid ?? ""),
      builder: (context, snap) {
        print("-----------pauseMenu----------- ${snap.data?.docs.length}");
        if (snap.data?.docs.isNotEmpty ?? false) {
          return ListView.builder(
              itemCount: snap.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                MenusModel model = MenusModel(
                  key: snap.data!.docs[index]["key"],
                  title: snap.data!.docs[index]["title"],
                  description: snap.data!.docs[index]["description"],
                  productStatus: snap.data!.docs[index]["productStatus"],
                  created_at:
                      (snap.data!.docs[index]["created_at"] as Timestamp)
                          .toDate(),
                  image: snap.data!.docs[index]["image"],
                  uid: snap.data!.docs[index]["uid"],
                  isVideo: snap.data!.docs[index]["isVideo"],
                  deliveryType: snap.data!.docs[index]["deliveryType"],
                  price: snap.data!.docs[index]["price"],
                  location: snap.data!.docs[index]["location"],
                );
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: InkWell(
                    onTap: () => Get.to(() => MenuDetailView(menu: model)),
                    child: RelatedRecipe(
                      title: "${model.title}",
                      text: "${model.description}",
                      isVideo: model.isVideo ?? false,
                      image: "${model.image}",
                    ),
                  ),
                );
              });
        } else {
          return Container(
            child: Center(child: Text("Not Found")),
          );
        }
        /*return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ,
                SizedBox(
                  height: 10,
                ),
                RelatedRecipe(
                  title: "Shakky Pepper soup",
                  text:
                  "A wonderfully delicious 2 patty melt that melts into your...",
                  image: "assets/images/fd5.jpg",
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );*/
      },
    );
  }

  recipeTabView() {
    return StreamBuilder<QuerySnapshot?>(
      stream: context
          .read<PostCubit>()
          .getPauseRecipes(FirebaseAuth.instance.currentUser?.uid ?? ""),
      builder: (context, snap) {
        if (snap.data?.docs.isNotEmpty ?? false) {
          return ListView.builder(
              itemCount: snap.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                RecipeModel model = RecipeModel(
                  key: snap.data?.docs[index]["key"],
                  title: snap.data?.docs[index]["title"],
                  description: snap.data?.docs[index]["description"],
                  productStatus: snap.data?.docs[index]["productStatus"],
                  created_at:
                      (snap.data?.docs[index]["created_at"] as Timestamp)
                          .toDate(),
                  image: snap.data?.docs[index]["image"],
                  isVideo: snap.data?.docs[index]["isVideo"],
                  uid: snap.data?.docs[index]["uid"],
                  cuisine: snap.data?.docs[index]["cuisine"],
                  category: snap.data?.docs[index]["category"],
                );
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: InkWell(
                    onTap: () => Get.to(() => RecipeDetailView(recipe: model)),
                    child: RelatedRecipe(
                      title: "${model.title}",
                      text: "${model.description}",
                      isVideo: model.isVideo ?? false,
                      image: "${model.image}",
                    ),
                  ),
                );
              });
        } else {
          return Container(
            child: Center(child: Text("Not Found")),
          );
        }
        /*return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ,
                SizedBox(
                  height: 10,
                ),
                RelatedRecipe(
                  title: "Shakky Pepper soup",
                  text:
                  "A wonderfully delicious 2 patty melt that melts into your...",
                  image: "assets/images/fd5.jpg",
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );*/
      },
    );
  }
}
