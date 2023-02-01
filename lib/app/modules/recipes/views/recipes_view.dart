import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/models/recipe_model.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/recipe_card.dart';
import 'package:bukateria/widgets/search_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RecipesView extends StatefulWidget {
  const RecipesView({Key? key}) : super(key: key);

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  final _controller = ValueNotifier<bool>(false);

// ...
  @override
  void initState() {
    super.initState();
  }

  String searchKey = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(listener: (context, state) {

    }, child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state)
    {
      return StreamBuilder<QuerySnapshot>(
          stream:  context.read<PostCubit>().getAllRecipes(""),
    builder: (context,snap){

     /*
      List<QuerySnapshot> list = [];
      list = snap.data.docs;

      print("--------length--------${snap.data?.docs.length}");
      snap.data?.docs.forEach((element) {
        element["list"].forEach((element1){
          list.add(element1);
          print("----------${list.length}");
        });
      });*/
      List<DocumentSnapshot> list = [];
      snap.data?.docs.forEach((element) {
        if(element["title"].toString().toLowerCase().contains(searchKey.toLowerCase())){
          list.add(element);
        }
      });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 110,
        backgroundColor: primary,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(
                    //   "Ikeja, Lagos",
                    //   style: body3.copyWith(color: white),
                    // ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {
                showSearch(context: context, delegate: MenuSearchDelegate())
              },
              child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(10)),
                  height: 45,
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: dark,
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (val) {
                            setState(() {
                              searchKey = val;
                            });
                          },
                          autofocus: false,
                          obscureText: false,
                          keyboardType: TextInputType.text,

                          decoration: InputDecoration(
                            // labelText: 'Description',
                            hintText: 'Search Recipe',
                            hintStyle: body3,
                          ),
                          maxLines: 1,
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: list.isNotEmpty ? GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: list.length ?? 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.7,
                ),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  RecipeModel model = RecipeModel(
                    key: list[index]["key"],
                    title: list[index]["title"],
                    description: list[index]["description"],
                    productStatus: list[index]["productStatus"],
                    created_at: (list[index]["created_at"] as Timestamp).toDate(),
                    image: list[index]["image"],
                    isVideo: list[index]["isVideo"],
                    uid: list[index]["uid"],
                    cuisine: list[index]["cuisine"],
                    category: list[index]["category"],
                  );
                  print("------isVideo-------${model.isVideo}");
                  return RecipeCard(recipe: model);
                },
              ) : Center(child: Text("No Recipe found")),
            ),
          ],
        ),
      ),
    );
    });
    },),
    );
  }
}
