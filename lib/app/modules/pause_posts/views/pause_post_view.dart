import 'package:bukateria/app/modules/menus/views/menu_detail_view.dart';
import 'package:bukateria/app/modules/recipes/views/recipe_detail_view.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/models/menus_model.dart';
import 'package:bukateria/models/recipe_model.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../widgets/related_recipe.dart';

class PausePostView extends StatefulWidget {
  const PausePostView({Key? key}) : super(key: key);

  @override
  State<PausePostView> createState() => _PausePostViewState();
}

class _PausePostViewState extends State<PausePostView>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var _controller;

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
          'Paused Post',
          style: title3,
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
        bottom: TabBar(
          controller: _controller,
          labelColor: Colors.redAccent,
          indicatorColor: Colors.redAccent,
          tabs: [
            Tab(
              text: "Menu",
            ),
            Tab(
              text: "Recipe",
            ),
          ],
        ),
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TabBarView(
                controller: _controller,
                children: [menuTabView(), recipeTabView()])),
      ),
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
