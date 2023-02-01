import 'package:bukateria/app/modules/login/views/role_view_view.dart';
import 'package:bukateria/app/modules/login/views/social_login_view.dart';
import 'package:bukateria/app/modules/menus/views/create_menu_view.dart';
import 'package:bukateria/app/modules/pages/create.dart';
import 'package:bukateria/app/modules/profiles/controllers/profiles_controller.dart';
import 'package:bukateria/app/modules/recipes/views/create_recipe_view.dart';
import 'package:bukateria/app/modules/vlog/views/add_vlog_view.dart';
import 'package:bukateria/common_views.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/data/menu_items.dart';
import 'package:bukateria/models/menu_item_model.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PopMenu extends StatelessWidget {
  String? postType;
  final post;
  final reportedUserUID;
  final reportedPostUID;
  PopMenu({ this.postType, this.reportedPostUID, this.reportedUserUID, this.post, Key? key}) : super(key: key){
  }
  ProfilesController controller = Get.put(ProfilesController());

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
        listener: (context, state) {
          if (state.status == PostStatus.unPublish && state.productStatus == "Recipe") {
            Get.back();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully un publish")));
            Get.back();

          }else if (state.status == PostStatus.publish ) {
            Get.back();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully published")));

          }else if (state.status == PostStatus.reported && state.productStatus == "Reported" ) {
            Get.back();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reported")));
            Get.back();

          }else if (state.status == PostStatus.unPublish && state.productStatus == "Menu") {
            Get.back();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully un publish")));
            Get.back();

          }else if (state.status == PostStatus.error) {
             Get.back();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong!")));
          }else if(state.status == PostStatus.pausing){

            // CommonViews.showProgressDialog(context);

          }
        },
        child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
    return PopupMenuButton<PopItem>(
      padding: EdgeInsets.zero,
        onSelected: ((item) {

          if (item == MenuItems.report) {
            Get.defaultDialog(
              radius: 10,

              titleStyle: title4,
              confirmTextColor: primary,
              titlePadding: EdgeInsets.only(top: 20),
              title: "Report/Block",
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              content: Column(
                children: [
                  Text(
                      "Please only report inappropriate content like nudity, hate speech or advertisement.",
                      style: body4),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        "Blocked from following or talking to me",
                        style: body4,
                      ),
                      value: controller.checkedValue.value,
                      onChanged: (newValue) {
                        controller.checkedValue.value = newValue!;
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  )
                ],
              ),
              confirm: TextButton(
                onPressed: () {
                  if(controller.checkedValue.isFalse){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select the check")));
                  }
                  context.read<PostCubit>().reportUser(reportedUserUID, FirebaseAuth.instance.currentUser?.uid ?? "", "Blocked from following or talking to me", reportedPostUID);
                },
                child: Text(
                  "Report",
                  style: body3.copyWith(color: primary),
                ),
              ),
              cancel: TextButton(
                  onPressed: () => Get.back(), child: Text("Cancel")),
            );
          }

          if (item == MenuItems.logout) {
            Get.offAll(() => SocialLoginView());
          }


          if (item == MenuItems.edit) {
            if(postType == "recipe"){
              Get.off(() => AddRecipe(recipe: post,));
            }else if(postType == "menu"){
              Get.off(() => AddMenu(menu: post,));
            }else if(postType == "explore"){
              Get.off(() => AddVlog());
            }
          }
          print("9098(()))(((())))(((()))) ${item.text}  ${post.key}   ${item == MenuItems.pause}");
          if (item == MenuItems.pause) {
            if(postType == "recipe"){
              if(post.productStatus == "UNPUBLISH"){
                context.read<PostCubit>().updateRecipeStatus(post.key, post.uid);
              }else {
                context.read<PostCubit>().pauseRecipeStatus(post.key, post.uid);
              }
            }else if(postType == "menu"){
              /*if(post.productStatus == "UNPUBLISH"){
                context.read<PostCubit>().updateMenuStatus(post.key, post.uid);
              }else {*/
                context.read<PostCubit>().pauseMenuStatus(post.key, post.uid);
             // }
            }else if(postType == "explore"){
             // Get.off(() => AddVlog());
            }
          }


          if (item == MenuItems.unPause) {

            if(postType == "recipe"){
                context.read<PostCubit>().updateRecipeStatus(post.key, post.uid);
            }else if(postType == "menu"){
              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("click ${post.key}  ${post.uid}")));
                context.read<PostCubit>().updateMenuStatus(post.key, post.uid);

            }else if(postType == "explore"){
              // Get.off(() => AddVlog());
            }
          }

          if (item == MenuItems.delete) {
            if(postType == "recipe"){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  content: Text("Do you want to delete this recipe?"),
                  actions: [
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green)
                        ),
                        onPressed: (){
                          context.read<PostCubit>().deleteRecipe(post.key);
                          Get.back();
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
             /* context.read<PostCubit>().deleteRecipe(post.key);
              Get.back();*/
            }else if(postType == "menu"){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  content: Text("Do you want to delete this menu?"),
                  actions: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green)
                        ),
                        onPressed: (){
                          context.read<PostCubit>().deleteMenu(post.key);
                          Get.back();
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
             // Get.back();
            }else if(postType == "explore"){

              Get.off(() => AddVlog());
            }
          }


        }),
        itemBuilder: (context) => [
          ...(post != null ? post.productStatus == "PUBLISH"? MenuItems.menuChefItems: MenuItems.menuChefItemsUnPause : MenuItems.menuItems)
                  .map((PopItem item) => PopupMenuItem<PopItem>(
                      value: item,
                      child: Row(
                        children: [
                          Icon(item.icon),
                          SizedBox(
                            width: 10,
                          ),
                          Text(item.text)
                        ],
                      )))
            ]);
        },
        ),
    );
  }
}
