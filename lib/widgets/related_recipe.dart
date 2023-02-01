import 'package:auto_size_text/auto_size_text.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/*class RelatedRecipe extends StatelessWidget {
  const RelatedRecipe(
      {Key? key, required this.text, required this.isVideo, required this.title, required this.image})
      : super(key: key);

  final String title;
  final String text;
  final String image;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: Color(0x411D2429),
            offset: Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  imageUrl: "${image}",
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 8, 4, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$title', style: title6),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                        child: AutoSizeText('$text',
                            textAlign: TextAlign.start, style: body4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

class RelatedRecipe extends StatefulWidget {
  const RelatedRecipe(
      {Key? key, required this.text, required this.isVideo, required this.title, required this.image})
      : super(key: key);

  final String title;
  final String text;
  final String image;
  final bool isVideo;

  @override
  State<RelatedRecipe> createState() => _RelatedRecipeState();
}

class _RelatedRecipeState extends State<RelatedRecipe> {
   VideoPlayerController? _controller;

  bool isPlaying = false;

  @override
  void initState() {
    if(widget.isVideo != null) {
      if (widget.isVideo) {
        _controller = VideoPlayerController.network(
            widget.image,
            videoPlayerOptions: VideoPlayerOptions()
        )
          ..initialize().then((_) {
            setState(() {});
          });
      }
    }
    super.initState();
  }


@override
  void dispose() {
    if(widget.isVideo){
    _controller?.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: Color(0x411D2429),
            offset: Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.isVideo ? Container(
                  height: 80,
                  width: 80,
                  child: Stack(
                    children: [
                      _controller != null ? VideoPlayer(_controller!) : Container(),
                      Center(child: IconButton(
                        onPressed: (){
                          if(isPlaying){
                            isPlaying= false;
                            _controller?.pause();
                          }else{
                            isPlaying = true;
                            _controller?.play();
                          }
                          setState((){});
                        },
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,size: 30,color: Colors.white,), color: Colors.white,
                      ),)
                    ],
                  ),
                ): CachedNetworkImage(
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  imageUrl: "${widget.image}",
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 8, 4, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.title}', style: title6),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                        child: AutoSizeText('${widget.text}',
                            textAlign: TextAlign.start, style: body4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

