import 'package:bukateria/app/modules/recipes/views/recipe_detail_view.dart';
import 'package:bukateria/common_views.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

/*class ProfileExploreCard extends StatelessWidget {
  ProfileExploreCard({Key? key, required this.exploreModel}) : super(key: key){
  }


}*/
class ProfileExploreCard extends StatefulWidget {
  final exploreModel;
  const ProfileExploreCard({Key? key,required this.exploreModel}) : super(key: key);

  @override
  State<ProfileExploreCard> createState() => _ProfileExploreCardState();
}

class _ProfileExploreCardState extends State<ProfileExploreCard> {
  late VideoPlayerController _controller;

  bool isPlaying = false;

 @override
  void initState() {
   if(widget.exploreModel.isVideo) {
     _controller = VideoPlayerController.network(
         widget.exploreModel.image)
       ..initialize().then((_) {
         setState(() {});
       });
   }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.exploreModel.isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(listener: (context, state) {

      /*if (state.status == PostStatus.deleted) {
        Get.back();
        *//*SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Deleted!")));
        });*//*
      }else if(state.status == PostStatus.deleting){
        CommonViews.showProgressDialog(context);
      }*/
    }, child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state)
    {
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     children: [
          //       Padding(
          //         padding: EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
          //         child: Container(
          //           width: 30,
          //           height: 30,
          //           clipBehavior: Clip.antiAlias,
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //           ),
          //           child: Image.asset(
          //             '${recipe.user.avatar}',
          //           ),
          //         ),
          //       ),
          //       Text('${recipe.user.firstName} ${recipe.user.lastName}',
          //           style: body5),
          //     ],
          //   ),
          // ),
          GestureDetector(
            //onTap: () => Get.to(() => RecipeDetailView(recipe: recipe)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  widget.exploreModel.isVideo ? Container(
                    height: 150,
                    child: Stack(
                      children: [
                        VideoPlayer(_controller),
                        Center(child: IconButton(
                          onPressed: () {
                            /*if (isPlaying) {
                              isPlaying = false;
                              _controller.pause();
                            } else {
                              isPlaying = true;
                              _controller.play();
                            }
                            setState(() {});*/
                          },
                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 30, color: Colors.white,),
                          color: Colors.white,
                        ),)
                      ],
                    ),
                  )
                      : CachedNetworkImage(
                    height: 150,
                    fit: BoxFit.cover,
                    imageUrl: "${widget.exploreModel.image}",
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  IconButton(onPressed: () {
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        content: Text("Do you want to delete this explore?"),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.green)
                              ),
                              onPressed: (){
                                context.read<PostCubit>().deleteExplore(
                                    widget.exploreModel.key);
                                Get.back();
                              }, child: Text("Yes",style: TextStyle(color: Colors.white))),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.red)
                              ),
                              onPressed: (){
                                Get.back();
                              }, child: Text("No",style: TextStyle(color: Colors.white),)),
                        ],
                      );
                    });

                  },
                      icon: Icon(
                        Icons.delete, color: Colors.redAccent, size: 24,)),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
            child: GestureDetector(
              //onTap: () => Get.to(() => RecipeDetailView(recipe: recipe)),
                child: Text('${widget.exploreModel.title}',
                    textAlign: TextAlign.start, style: title6)),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                  "Date: " +
                      DateFormat('MMM dd, yyyy').format(
                          widget.exploreModel.created_at),
                  style: body5),
            ],
          ),
        ],
      );
    }
    ), );
  }
}

