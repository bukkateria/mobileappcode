import 'package:bukateria/app/modules/menus/views/menu_detail_view.dart';
import 'package:bukateria/app/modules/recipes/views/recipe_detail_view.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

/*class ProfileMenuCard extends StatelessWidget {
  ProfileMenuCard({Key? key, required this.menu}) : super(key: key);

  final menu;

  late VideoPlayerController _controller;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.to(() => MenuDetailView(menu: menu)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                height: 150,
                fit: BoxFit.cover,
                imageUrl: "${menu.image}",
                errorWidget: (context, url, error) => Icon(Icons.error),
              )),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
          child: GestureDetector(
              onTap: () => Get.to(() => RecipeDetailView(recipe: menu)),
              child: Text('${menu.title}',
                  textAlign: TextAlign.start, style: title6)),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Date: " + DateFormat('MMM dd, yyyy').format(menu.created_at),
                style: body5),
          ],
        ),
      ],
    );
  }
}*/

class ProfileMenuCard extends StatefulWidget {
  final menu;
  const ProfileMenuCard({required this.menu, Key? key}) : super(key: key);

  @override
  State<ProfileMenuCard> createState() => _ProfileMenuCardState();
}

class _ProfileMenuCardState extends State<ProfileMenuCard> {
  late VideoPlayerController _controller;

  bool isPlaying = false;

  @override
  void initState() {
    if(widget.menu.isVideo) {
      _controller = VideoPlayerController.network(
          widget.menu.image)
        ..initialize().then((_) {
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.to(() => MenuDetailView(menu: widget.menu)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: widget.menu.isVideo ? Container(
                height: 150,
                child: Stack(
                  children: [
                    VideoPlayer(_controller),
                    Center(child: IconButton(
                      onPressed: (){
                        if(isPlaying){
                          isPlaying= false;
                          _controller.pause();
                        }else{
                          isPlaying = true;
                          _controller.play();
                        }
                        setState((){});
                      },
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,size: 30,color: Colors.white,), color: Colors.white,
                    ),)
                  ],
                ),
              ):
              CachedNetworkImage(
                height: 150,
                fit: BoxFit.cover,
                imageUrl: "${widget.menu.image}",
                errorWidget: (context, url, error) => Icon(Icons.error),
              )),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
          child: GestureDetector(
              onTap: () => Get.to(() => RecipeDetailView(recipe: widget.menu)),
              child: Text('${widget.menu.title}',
                  textAlign: TextAlign.start, style: title6)),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Date: " + DateFormat('MMM dd, yyyy').format(widget.menu.created_at),
                style: body5),
          ],
        ),
      ],
    );
  }
}

