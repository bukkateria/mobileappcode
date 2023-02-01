import 'package:bukateria/data/menus_list.dart';
import 'package:bukateria/models/recipe_method_model.dart';
import 'package:bukateria/models/recipe_model.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/recipe_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../cubit/post_cubit/post_cubit.dart';

class ProfileRecipeList extends StatelessWidget {
  final uid;
  const ProfileRecipeList({
    this.uid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {},
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
              stream: context.read<PostCubit>().getRelatedRecipes(
                  uid != null ? uid.toString() :FirebaseAuth.instance.currentUser?.uid ?? ""),
              builder: (context, snap) {
                if (snap.hasData) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Recipes",
                          style: title4,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: snap.data?.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.7,
                            ),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              RecipeModel model = RecipeModel(
                                key: snap.data?.docs[index]["key"],
                                title: snap.data?.docs[index]["title"],
                                description: snap.data?.docs[index]
                                    ["description"],
                                productStatus: snap.data?.docs[index]
                                    ["productStatus"],
                                created_at: (snap.data?.docs[index]
                                        ["created_at"] as Timestamp)
                                    .toDate(),
                                image: snap.data?.docs[index]["image"],
                                uid: snap.data?.docs[index]["uid"],
                                isVideo: snap.data?.docs[index]["isVideo"],
                                cuisine: snap.data?.docs[index]["cuisine"],
                                category: snap.data?.docs[index]["category"],
                              );
                              return RecipeCard(recipe: model);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("Loading, please wait... "),
                );
              });
        },
      ),
    );
  }
}
