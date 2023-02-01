import 'dart:io';

import 'package:bukateria/app/modules/profiles/views/profiles_view.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';
import 'package:video_player/video_player.dart';

import '../cubit/post_cubit/post_cubit.dart';

class ExploreCard extends StatefulWidget {
  final explore;
  final formatCurrency =
      NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');

  ExploreCard({super.key, required this.explore});
  @override
  _ExploreCardState createState() => _ExploreCardState();
}

class _ExploreCardState extends State<ExploreCard> {
  late VideoPlayerController _controller;

  bool isPlaying = false;
  ChewieController? chewieController;
  Chewie? chewieWidget;
  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.explore.image)
      ..initialize().then((_) {
        print('aspect ratio is : ${_controller.value.aspectRatio}');
        chewieController = ChewieController(
          videoPlayerController: _controller,
          allowFullScreen: true,
          // aspectRatio: 2.5,
          autoPlay: false,
          looping: true,
        );

        chewieWidget = Chewie(
          controller: chewieController!,
        );
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          widget.explore.isVideo
              ? chewieController != null &&
                      chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Container(
                      height: 150,
                      color: Colors.black,
                      child: Stack(
                        children: [
                          chewieWidget!,
                          // VideoPlayer(_controller),

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
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 30,
                                color: Colors.white,
                              ),
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        color: primary,
                      ),
                    )
              : FadeInImage(
                  width: double.infinity,
                  height: 181,
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      //widget.product[Constants.image]
                      '${widget.explore.image}'),
                  placeholder: AssetImage(
                    "assets/images/big_logo.png",
                  ),
                ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${widget.explore.title}', style: title5),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
            child: StreamBuilder<DocumentSnapshot<Object?>>(
              stream:
                  context.read<PostCubit>().getSpecificUser(widget.explore.uid),
              builder: (context, snap) {
                if (snap.hasData) {
                  return InkWell(
                    onTap: () {
                      Get.off(() => ProfilesView(
                            uid: widget.explore.uid,
                          ));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                          child: Container(
                            width: 30,
                            height: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: context
                                    .read<PostCubit>()
                                    .getSpecificUser(widget.explore.uid),
                                builder: (context, snap) {
                                  return CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: "${snap.data?["image"]}",
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            "assets/images/image_placeholder.jpeg"),
                                  );
                                })
                            /*FadeInImage(
                                  width: double.infinity,
                                  height: 151,
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      '${snap.data?["image"]}'
                                  ),
                                  placeholder: AssetImage(
                                    "assets/images/big_logo.png",
                                  ),
                                )*/
                            ,
                          ),
                        ),
                        Expanded(
                          child:
                              Text('@${snap.data?["username"]}', style: body4),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: context
                                .read<PostCubit>()
                                .getSpecificFavorite(widget.explore.key),
                            builder: (context, snap) {
                              return Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if ((FirebaseAuth.instance.currentUser
                                                    ?.uid ??
                                                "") !=
                                            widget.explore.uid) {
                                          if (snap.data?.docs.isNotEmpty ??
                                              false) {
                                            context
                                                .read<PostCubit>()
                                                .removeFavorite(
                                                    widget.explore.uid,
                                                    FirebaseAuth.instance
                                                            .currentUser?.uid ??
                                                        "",
                                                    widget.explore.key,
                                                    "explore");
                                          } else {
                                            context
                                                .read<PostCubit>()
                                                .addFavorite(
                                                    widget.explore.uid,
                                                    FirebaseAuth.instance
                                                            .currentUser?.uid ??
                                                        "",
                                                    widget.explore.key,
                                                    "explore");
                                          }
                                        }
                                      },
                                      icon: Icon(
                                        snap.data?.docs.isEmpty ?? false
                                            ? Icons.favorite_outline
                                            : Icons.favorite,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("Favorite")
                                            .where("productID",
                                                isEqualTo: widget.explore.key)
                                            .snapshots(),
                                        builder: (context, snapCount) {
                                          return Text(
                                              "${snapCount.data?.docs.length ?? 0}");
                                        })
                                  ],
                                ),
                              );
                            }),
                        /*Row(
                          children: [
                            Icon(
                              true ? Icons.favorite : Icons.favorite_outline,
                              color: false ? primary : dark,
                              size: 24,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("2,500")
                          ],
                        ),*/
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
            child: Text('${widget.explore.description}',
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                softWrap: false,
                style: body4),
          ),
          SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }
}
