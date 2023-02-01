import 'dart:io';

import 'package:bukateria/app/modules/menus/views/menu_detail_view.dart';
import 'package:bukateria/app/modules/profiles/views/profiles_view.dart';
import 'package:bukateria/data/menus_list.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';
import 'package:video_player/video_player.dart';

import '../cubit/post_cubit/post_cubit.dart';

class MenuCardComponentWidget extends StatefulWidget {
  final menu;

  final formatCurrency =
      NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');

  MenuCardComponentWidget({super.key, required this.menu});
  @override
  _MenuCardComponentWidgetState createState() =>
      _MenuCardComponentWidgetState();
}

class _MenuCardComponentWidgetState extends State<MenuCardComponentWidget> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  bool isPlaying = false;

  @override
  void initState() {
    if (widget.menu.isVideo) {
      _controller = VideoPlayerController.network(widget.menu.image,
          videoPlayerOptions: VideoPlayerOptions())
        ..initialize().then((_) {
          _chewieController = ChewieController(
            videoPlayerController: _controller!,
            allowFullScreen: true,
            // aspectRatio: 2,
            autoPlay: false,
            looping: true,
          );
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.menu.isVideo) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {},
      child: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Color(0x3D0F1113),
                  offset: Offset(0, 1),
                )
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: GestureDetector(
                          onTap: () =>
                              Get.to(() => MenuDetailView(menu: widget.menu)),
                          child: Container(
                            child: widget.menu.isVideo
                                ? _chewieController != null &&
                                        _chewieController!.videoPlayerController
                                            .value.isInitialized
                                    ? Container(
                                        height: 150,
                                        color: Colors.black,
                                        child: Stack(
                                          children: [
                                            _controller != null
                                                ? Chewie(
                                                    controller:
                                                        _chewieController!)
                                                // VideoPlayer(_controller!)
                                                : Container(),
                                            Center(
                                              child: IconButton(
                                                onPressed: () {
                                                  if (isPlaying) {
                                                    isPlaying = false;
                                                    _controller!.pause();
                                                  } else {
                                                    isPlaying = true;
                                                    _controller!.play();
                                                  }
                                                  setState(() {});
                                                  /* if(isPlaying){
                                        isPlaying= false;
                                        _controller.pause();
                                      }else{
                                        isPlaying = true;
                                        _controller.play();
                                      }
                                      setState((){});*/
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
                                    : Center(
                                        child: const CircularProgressIndicator(
                                            color: primary),
                                      )
                                : CachedNetworkImage(
                                    height: 250,
                                    width: Get.width,
                                    fit: BoxFit.fill,
                                    imageUrl: "${widget.menu.image}",
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                          )),
                    ),
                  ],
                ),
                widget.menu.deliveryType == "delivery"
                    ? Padding(
                        padding: const EdgeInsets.only(top: 0, right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset("assets/images/delivery2.png")
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 3, right: 0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(child: Container()),
                              Container(
                                  height: 20,
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  color: Colors.black,
                                  child: Center(
                                      child: Text(
                                    "Pickup Available",
                                    style: TextStyle(color: Colors.white),
                                  )))
                            ],
                          ),
                        ),
                      ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
                  child: StreamBuilder<DocumentSnapshot<Object?>>(
                    stream: context
                        .read<PostCubit>()
                        .getSpecificUser(widget.menu.uid),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => ProfilesView(
                                  uid: widget.menu.uid,
                                ));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    imageUrl: "${snap.data?["image"]}",
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            "assets/images/image_placeholder.jpeg"),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${snap.data?["username"]}',
                                        style: body4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.pin_drop,
                                          color: Colors.greenAccent,
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                            child: Text(
                                                '@${widget.menu.location}',
                                                style: body4)),
                                      ],
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("Reviews")
                                            .where("sellerId",
                                                isEqualTo: widget.menu.uid)
                                            .snapshots(),
                                        builder: (context, snap) {
                                          double stars = 0;
                                          print(
                                              "----------rating----------- ${snap.data?.docs}");
                                          if (snap.data?.docs.isNotEmpty ??
                                              false) {
                                            for (var value in snap.data!.docs) {
                                              print(
                                                  "----------rating----------- ${value["rating"]}");
                                              stars = stars + value["rating"];
                                            }
                                          }

                                          return stars /
                                                      (snap.data?.size ?? 0) >
                                                  0
                                              ? Padding(
                                                  padding: EdgeInsets.zero,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Icon(
                                                            Icons.star_rounded,
                                                            color: orange,
                                                            size: 24,
                                                          ),
                                                          Text(
                                                              '${stars / (snap.data?.size ?? 0)}',
                                                              style: body4),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container();
                                        })
                                  ],
                                ),
                              ),
                              StreamBuilder<QuerySnapshot?>(
                                  stream: context
                                      .read<PostCubit>()
                                      .getFavoritesListByKey(widget.menu.key),
                                  builder: (context, snap) {
                                    print(
                                        "-------------${snap.data?.docs.length}");
                                    if (snap.data?.docs.isNotEmpty ?? false) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            color: primary,
                                            size: 24,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("${snap.data?.docs.length ?? 0}")
                                        ],
                                      );
                                    }
                                    return Container();
                                  })
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${widget.menu.title}', style: title5),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  child: Text('${widget.menu.description}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      softWrap: false,
                      style: body4),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: Container()),
                      Text(
                          '${widget.formatCurrency.format(double.parse(widget.menu.price))}',
                          style: title5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
