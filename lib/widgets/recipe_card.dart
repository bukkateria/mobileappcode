import 'package:bukateria/app/modules/recipes/views/recipe_detail_view.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/*class RecipeCard extends StatelessWidget {
  RecipeCard({Key? key, required this.recipe}) : super(key: key);

  final recipe;



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.to(() => RecipeDetailView(recipe: recipe)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              height: 150,
              fit: BoxFit.cover,
              imageUrl: "${recipe.image}",
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
          child: GestureDetector(
              onTap: () => Get.to(() => RecipeDetailView(recipe: recipe)),
              child: Text('${recipe.title}',
                  textAlign: TextAlign.start, style: title6)),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('${recipe.category}', style: body5),
            // Text('${recipe.duration}', style: body5),
          ],
        ),
      ],
    );
  }
}*/

class RecipeCard extends StatefulWidget {
  final recipe;
  const RecipeCard({required this.recipe, Key? key}) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  VideoPlayerController? _controller;

  bool isPlaying = false;

  @override
  void initState() {
    print("------isVideo-------${widget.recipe.isVideo}");
    if (widget.recipe.isVideo) {
      _controller = VideoPlayerController.network(widget.recipe.image,
          videoPlayerOptions: VideoPlayerOptions())
        ..initialize().then((_) {
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.recipe.isVideo) {
      _controller?.dispose();
      isPlaying = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      if (widget.recipe.isVideo) {
        _controller = VideoPlayerController.network(widget.recipe.image,
            videoPlayerOptions: VideoPlayerOptions())
          ..initialize().then((_) {
            setState(() {});
          });
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.to(() => RecipeDetailView(recipe: widget.recipe)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: widget.recipe.isVideo
                ? Container(
                    height: 150,
                    child: Stack(
                      children: [
                        _controller != null
                            ? VideoPlayer(_controller!)
                            : Container(),
                        Center(
                          child: IconButton(
                            onPressed: () {
                              /*if(isPlaying){
                        isPlaying= false;
                        _controller.pause();
                      }else{
                        isPlaying = true;
                        _controller.play();
                      }
                      setState((){});*/
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
                : CachedNetworkImage(
                    height: 150,
                    fit: BoxFit.cover,
                    imageUrl: "${widget.recipe.image}",
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
          child: GestureDetector(
              onTap: () =>
                  Get.to(() => RecipeDetailView(recipe: widget.recipe)),
              child: Text('${widget.recipe.title}',
                  textAlign: TextAlign.start, style: title6)),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('${widget.recipe.category}', style: body5),
            // Text('${recipe.duration}', style: body5),
          ],
        ),
      ],
    );
  }
}
