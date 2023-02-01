import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/notification_item.dart';
import 'package:bukateria/widgets/related_recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/menus_model.dart';
import '../../menus/views/menu_detail_view.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({Key? key}) : super(key: key);

  @override
  _FavouritesViewState createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'Favourites',
          style: title3,
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: StreamBuilder<QuerySnapshot?>(
            stream: context.read<PostCubit>().getMyFavorites(),
            builder: (context,snap){

           return ListView.builder(
               itemCount: snap.data?.docs.length ?? 0,
               itemBuilder: (context, index){

              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: context.read<PostCubit>().getMenuByKey(snap.data?.docs[index]["productID"]),
                  builder: (context, snap1){
                    if(snap1.data?.exists ?? false) {
                      if (snap1.data?["key"] != null) {
                        MenusModel model = MenusModel(
                          key: snap1.data?["key"],
                          title: snap1.data?["title"],
                          description: snap1.data?
                          ["description"],
                          productStatus: snap1.data?
                          ["productStatus"],
                          created_at: (snap1.data?
                          ["created_at"] as Timestamp) != null ? (snap1.data?
                          ["created_at"] as Timestamp).toDate() : null,
                          image: snap1.data?["image"],
                          uid: snap1.data?["uid"],
                          isVideo: snap1.data?["isVideo"],
                          deliveryType: snap1.data?
                          ["deliveryType"],
                          price: snap1.data?["price"],
                          location: snap1.data?
                          ["location"],
                        );
                        return InkWell(
                          onTap: () =>
                              Get.to(() => MenuDetailView(menu: model)),
                          child: RelatedRecipe(
                            title: "${snap1.data?["title"]}",
                            text: "${snap1.data?["description"]}",
                            isVideo: snap1.data?["isVideo"] ?? false,
                            image: "${snap1.data?["image"]}",
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }else{
                      return Container();
                    }
              },),
              );
            });
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
          },),
        ),
      ),
    );
  }
}
