import 'package:bukateria/app/modules/comments/views/comments_view.dart';
import 'package:bukateria/app/modules/profiles/views/profiles_view.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/models/recipe_model.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_button.dart';
import 'package:bukateria/widgets/custom_input.dart';
import 'package:bukateria/widgets/ingredientItem.dart';
import 'package:bukateria/widgets/method_widget.dart';
import 'package:bukateria/widgets/pop_menu.dart';
import 'package:bukateria/widgets/related_recipe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

import '../../../../common_views.dart';

class RecipeDetailView extends StatefulWidget {
  const RecipeDetailView({Key? key, required this.recipe}) : super(key: key);
  final recipe;

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  TextEditingController _commentController = TextEditingController();

  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  bool isPlaying = false;
  bool showPlayingButton = false;
  String username = "";

  @override
  void initState() {
    if (widget.recipe.isVideo) {
      _controller = VideoPlayerController.network(widget.recipe.image,
          videoPlayerOptions: VideoPlayerOptions())
        ..initialize().then((_) {
          _chewieController = ChewieController(
            videoPlayerController: _controller!,
            allowFullScreen: true,
            // aspectRatio: 2,
            autoPlay: false,
            looping: true,
          );
          showPlayingButton = true;
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.recipe.isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  bool check = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {
        if (state.status == PostStatus.success) {
          // Get.back();
          //  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success")));
          _commentController.text = "";
        } else if (state.status == PostStatus.error) {
          // Get.back();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong!")));
        } else if (state.status == PostStatus.submitting) {
          // CommonViews.showProgressDialog(context);
        }
      },
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
              stream: context.read<PostCubit>().getSpecificFollow(
                  widget.recipe.uid,
                  FirebaseAuth.instance.currentUser?.uid ?? ""),
              builder: (context, snap) {
                return SafeArea(
                  child: Scaffold(
                    body: CustomScrollView(slivers: [
                      SliverAppBar(
                          elevation: 1,
                          automaticallyImplyLeading: true,
                          backgroundColor: white,
                          iconTheme: const IconThemeData(color: dark),
                          expandedHeight: 250,
                          actions: [
                            Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: widget.recipe.uid ==
                                        FirebaseAuth.instance.currentUser?.uid
                                    ? PopMenu(
                                        post: widget.recipe,
                                        postType: "recipe",
                                      )
                                    : PopMenu(
                                        reportedPostUID: widget.recipe.key,
                                        reportedUserUID: widget.recipe.uid,
                                      ),
                              ),
                            ),
                          ],
                          pinned: true,
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
                          flexibleSpace: Container(
                            /*decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("${recipe.image}"))),*/
                            child: widget.recipe.isVideo
                                ? _chewieController != null &&
                                        _chewieController!.videoPlayerController
                                            .value.isInitialized
                                    ? Container(
                                        height: 250,
                                        color: Colors.black,
                                        child: Stack(
                                          children: [
                                            Chewie(
                                                controller: _chewieController!),
                                            // VideoPlayer(_controller),
                                            showPlayingButton
                                                ? Center(
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
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                          ],
                                        ),
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(
                                            color: primary))
                                : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: "${widget.recipe.image}",
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                          )),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 13,
                              ),
                              Text(
                                "${widget.recipe.title}",
                                style: title3.copyWith(
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 8),
                                      child: StreamBuilder<
                                          DocumentSnapshot<Object?>>(
                                        stream: context
                                            .read<PostCubit>()
                                            .getSpecificUser(widget.recipe.uid),
                                        builder: (context, snap) {
                                          username =
                                              snap.data?["username"] ?? "";
                                          if (snap.hasData) {
                                            return Container(
                                              child: InkWell(
                                                onTap: () {
                                                  Get.off(() => ProfilesView(
                                                        uid: widget.recipe.uid,
                                                      ));
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 7, 0),
                                                      child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                              "${snap.data?["image"]}",
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                                  "assets/images/image_placeholder.jpeg"),
                                                        ),
                                                        /*Image.asset(
                                                            'assets/images/avatar1.png',
                                                          ),*/
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "@${snap.data?["username"]}",
                                                                style: body4),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .location_pin,
                                                                  color: green,
                                                                  size: 20,
                                                                ),
                                                                Expanded(
                                                                    child: Text(
                                                                        "${snap.data?["address"]}",
                                                                        maxLines:
                                                                            2,
                                                                        style:
                                                                            body5)),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      widget.recipe.uid !=
                                              FirebaseAuth
                                                  .instance.currentUser?.uid
                                          ? CustomButton(
                                              width: 100,
                                              radius: 30,
                                              height: 35,
                                              onPressed: () {
                                                if (FirebaseAuth.instance
                                                        .currentUser?.uid !=
                                                    widget.recipe.uid) {
                                                  if (snap.data?.docs
                                                          .isNotEmpty ??
                                                      false) {
                                                    context
                                                        .read<PostCubit>()
                                                        .unFollow(
                                                            widget.recipe.uid,
                                                            FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    ?.uid ??
                                                                "");
                                                  } else {
                                                    context
                                                        .read<PostCubit>()
                                                        .addFollow(
                                                            widget.recipe.uid,
                                                            FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    ?.uid ??
                                                                "");
                                                  }
                                                }
                                              },
                                              color: /*snap.data?.docs.isNotEmpty ??
                                                    false
                                                ? greyLight
                                                : */
                                                  primary,
                                              text:
                                                  snap.data?.docs.isNotEmpty ??
                                                          false
                                                      ? "Unfollow"
                                                      : "Follow",
                                            )
                                          : Container(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              // Generated code for this subtitle Widget...
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 15, 0, 10),
                                child: Text(
                                  'Description',
                                  style: title5,
                                ),
                              ),

                              // Generated code for this body_text Widget...
                              Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 10),
                                  child: ReadMoreText(
                                    '${widget.recipe.description}',
                                    trimCollapsedText: "show more",
                                    trimLines: 4,
                                    trimMode: TrimMode.Line,
                                    style: body3,
                                  )),
                              StreamBuilder<QuerySnapshot>(
                                  stream: context
                                      .read<PostCubit>()
                                      .getIngredients(widget.recipe.key),
                                  builder: (context, snap) {
                                    print(
                                        "-----------vvv------------- ${snap.hasData} ${snap.data?.docs.length}");
                                    if (snap.hasData) {
                                      /*List<String>? list = [];
                                        snap.data?.docs.forEach((element) {
                                         list.add(element["ingredient"]);
                                         list.add(element.id);
                                        });
                                        widget.recipe.ingredients = list;*/

                                      List<Map<String, dynamic>>? list = [];
                                      snap.data?.docs.forEach((element) {
                                        Map<String, dynamic> map = {};
                                        map["ingredient"] =
                                            element["ingredient"];
                                        map["key"] = element['key'];
                                        list.add(map);
                                      });
                                      widget.recipe.ingredientsUpdatedList =
                                          list;

                                      return ListView(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        children: [
                                          snap.data?.docs.isNotEmpty ?? false
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 15, 0, 10),
                                                  child: Text(
                                                    'Ingredients',
                                                    style: title5,
                                                  ),
                                                )
                                              : Container(),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: snap.data?.docs.length,
                                              itemBuilder: (context, index) {
                                                return IngredientItem(
                                                  text: snap.data?.docs[index]
                                                      ["ingredient"],
                                                );
                                              }),
                                        ],
                                      );
                                    }
                                    return Container();
                                  }),

                              StreamBuilder<QuerySnapshot>(
                                  stream: context
                                      .read<PostCubit>()
                                      .getMethods(widget.recipe.key),
                                  builder: (context, snap) {
                                    print(
                                        "-----------www------------- ${snap.hasData} ${snap.data?.docs.length}");
                                    if (snap.hasData) {
                                      List<Map<String, dynamic>>? list = [];
                                      snap.data?.docs.forEach((element) {
                                        Map<String, dynamic> map = {};
                                        map["text"] = element["text"];
                                        map["image"] = element["image"];
                                        map["key"] = element["key"];
                                        list.add(map);
                                      });
                                      widget.recipe.method = list;
                                      return ListView(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        children: [
                                          snap.data?.docs.isNotEmpty ?? false
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 15, 0, 10),
                                                  child: Text(
                                                    'Methods',
                                                    style: title3,
                                                  ),
                                                )
                                              : Container(),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: snap.data?.docs.length,
                                              itemBuilder: (context, index) {
                                                return MethodWidget(
                                                  text: snap.data?.docs[index]
                                                      ["text"],
                                                  image: snap.data?.docs[index]
                                                      ["image"],
                                                );
                                              }),
                                        ],
                                      );
                                    }
                                    return Container();
                                  }),
                              // Generated code for this Row Widget...
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey,
                              ),

                              Container(
                                color: const Color.fromARGB(255, 233, 233, 233),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: context
                                      .read<PostCubit>()
                                      .getComments(widget.recipe.key),
                                  builder: (context, snap) {
                                    print(
                                        "--------saa------${snap.data?.docs.length}");
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 20),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 10, 0),
                                                child: Icon(
                                                  Icons
                                                      .chat_bubble_outline_sharp,
                                                  color: Colors.black,
                                                  size: 24,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 10, 0),
                                                child: Text('Comments',
                                                    style: body3),
                                              ),
                                              Text(
                                                '${snap.data?.docs.length ?? 0}',
                                                style: body3,
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Generated code for this Text Widget...
                                        InkWell(
                                          onTap: () {
                                            check = !check;
                                            setState(() {});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 10),
                                            child: Text(
                                              'View all comments',
                                              style: body3,
                                            ),
                                          ),
                                        ),
                                        // Generated code for this user_widget Widget...
                                        ListView.builder(
                                            itemCount: snap.data != null
                                                ? snap.data!.docs.length > 3
                                                    ? check
                                                        ? snap.data?.docs.length ??
                                                            0
                                                        : 3
                                                    : snap.data?.docs.length ??
                                                        0
                                                : 0,
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return StreamBuilder<
                                                      DocumentSnapshot>(
                                                  stream: context
                                                      .read<PostCubit>()
                                                      .getSpecificUser(
                                                          snap.data?.docs[index]
                                                              ["commentedBy"]),
                                                  builder: (context, userSnap) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 0, 12),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    0, 0, 7, 0),
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                imageUrl:
                                                                    "${userSnap.data?["image"]}",
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                              '${userSnap.data?["name"] ?? ""}',
                                                              style: body2.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black)),
                                                          SizedBox(
                                                            width: 6,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                '${snap.data?.docs[index]["comment"]}',
                                                                style: body4),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Container(
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(() => CommentsView(
                                                      recipe: widget.recipe,
                                                    ));
                                              },
                                              child: Container(
                                                height: 40,
                                                margin:
                                                    EdgeInsets.only(bottom: 12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.black38,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      "Add comment",
                                                    )),
                                                    Icon(
                                                      Icons.send_rounded,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),

                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // Generated code for this subtitle Widget...
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 15, 0, 10),
                                child: Text(
                                  "Other recipes by ${username}",
                                  style: title4,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: context
                                      .read<PostCubit>()
                                      .getRelatedRecipes(widget.recipe.uid),
                                  builder: (context, snap) {
                                    print(
                                        "-----------www------------- ${snap.hasData} ${snap.data?.docs.length}");
                                    if (snap.hasData) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemCount: snap.data?.docs.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                RecipeModel model = RecipeModel(
                                                  key: snap.data?.docs[index]
                                                      ["key"],
                                                  title: snap.data?.docs[index]
                                                      ["title"],
                                                  description:
                                                      snap.data?.docs[index]
                                                          ["description"],
                                                  productStatus:
                                                      snap.data?.docs[index]
                                                          ["productStatus"],
                                                  created_at:
                                                      (snap.data?.docs[index]
                                                                  ["created_at"]
                                                              as Timestamp)
                                                          .toDate(),
                                                  image: snap.data?.docs[index]
                                                      ["image"],
                                                  isVideo: snap.data
                                                      ?.docs[index]["isVideo"],
                                                  uid: snap.data?.docs[index]
                                                      ["uid"],
                                                  cuisine: snap.data
                                                      ?.docs[index]["cuisine"],
                                                  category: snap.data
                                                      ?.docs[index]["category"],
                                                );
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RecipeDetailView(
                                                                recipe:
                                                                    model)));
                                                //Get.to(() => RecipeDetailView(recipe: snap.data?.docs[index]));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: RelatedRecipe(
                                                  title: snap.data?.docs[index]
                                                      ['title'],
                                                  text: snap.data?.docs[index]
                                                      ['description'],
                                                  isVideo: snap.data
                                                      ?.docs[index]['isVideo'],
                                                  image: snap.data?.docs[index]
                                                      ['image'],
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                    return Container();
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),

                        // Generated code for this author_info Widget...
                      ]))
                    ]),
                  ),
                );
              });
        },
      ),
    );
  }
}
