import 'dart:developer';

import 'package:bukateria/app/modules/pages/google_places_search.dart';
import 'package:bukateria/data/menus_list.dart';
import 'package:bukateria/models/menus_model.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/menu_card.dart';
import 'package:bukateria/widgets/search_delegate.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../cubit/post_cubit/post_cubit.dart';

class MenusView extends StatefulWidget {
  @override
  State<MenusView> createState() => _MenusViewState();
}

class _MenusViewState extends State<MenusView> {
  List<dynamic> map = [];
  // List<MenusModel> list = [];

  //MenusView({Key? key}) : super(key: key);
// ...

  bool showSnack = true;
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().getCurrentPosition();
  }

  String searchKey = "";
  Map<String, int> list = {};
  Widget sort(List<dynamic> map, String currentLocation) {
    //list = [];

    for (int a = 0; a < map.length; a++) {
      var element = map[a];
      //Map<String,dynamic> distanceMap = {};
      // distanceMap["key"] = element["key"];
      //context.read<PostCubit>().getDistance(element["location"],"F98Q+F84, Street, Kudenda 800104, Kaduna, Nigeria" ).then((distance) {
      context
          .read<PostCubit>()
          .getDistance(element["location"], currentLocation)
          .then((distance) {
        list[element["key"]] = distance["rows"][0]["elements"][0]["status"] ==
                "ZERO_RESULTS"
            ? 0
            : distance["rows"][0]["elements"] != null
                ? distance["rows"][0]["elements"][0]["distance"]["value"] !=
                        null
                    ? distance["rows"][0]["elements"][0]["distance"]["value"]
                    : -1
                : -1;

        //print("------------length----------------- ${list.length}");
      });
    }

    /*  for (var element in map)  {

    }*/

    map.sort((a, b) {
      int aKey = list[a["key"]] ?? 0;
      int bKey = list[b["key"]] ?? 0;
      print("--------all");
      return bKey < aKey ? 1 : 0;
    });
    if (list.isNotEmpty) {
      print("--------allaa");
      //setState(() {
      showSnack = false;
      //});
    }
    List<dynamic> searchedList = [];
    map.forEach((element) {
      if (element["location"]
              .toString()
              .toLowerCase()
              .contains(searchKey.toLowerCase()) ||
          element["title"]
              .toString()
              .toLowerCase()
              .contains(searchKey.toLowerCase())) {
        searchedList.add(element);
      }
    });
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primary,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(showSnack ? 100 : 60),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => {
                    showSearch(context: context, delegate: MenuSearchDelegate())
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10)),
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
                                hintText: 'Search Menu',
                                hintStyle: body3,
                              ),
                              maxLines: 1,
                            ),
                          )
                        ],
                      )),
                ),
                showSnack
                    ? Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          "We are sorting the menus for you...",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ))
                    : SizedBox(),
              ],
            ),
          ),
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: const EdgeInsets.only(left: 1, right: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentLocation ?? "Loading Location...",
                        style: body3.copyWith(color: white),
                      ),
                      // GestureDetector(
                      //     onTap: () =>
                      //     {
                      //       setState(() {
                      //         searchKey = "";
                      //       }),
                      //       Get.to(() =>
                      //           PlaceSearch(onSelection: (
                      //               location) {
                      //             setState(() {
                      //               searchKey = location;
                      //             });
                      //           },))
                      //     },
                      //     child: Icon(Icons.search)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('carousel')
                          .doc('images')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        final List imgsList = snapshot.data!.get('image');

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 170,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 5)
                            ],
                          ),
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              disableCenter: true,
                              viewportFraction: 1,
                              autoPlayInterval: Duration(seconds: 7),
                              onPageChanged: (index, reason) {},
                            ),
                            itemCount: imgsList.length,
                            // itemCount: images.length,
                            itemBuilder: (context, index, _) {
                              return InkWell(
                                onTap: () {},
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.network(
                                    imgsList[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchedList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        //print("-----------add--------------${list[index].distance}");
                        /*MenusModel model = MenusModel(
                                        key: list[index]["key"],
                                        title: list[index]["title"],
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
                                        deliveryType: snap.data?.docs[index]
                                            ["deliveryType"],
                                        price: snap.data?.docs[index]["price"],
                                        location: snap.data?.docs[index]
                                            ["location"],
                                      );*/
                        var element = searchedList[index];

                        MenusModel model = MenusModel(
                            key: element["key"],
                            title: element["title"],
                            description: element["description"],
                            productStatus: element["productStatus"],
                            created_at:
                                (element["created_at"] as Timestamp).toDate(),
                            image: element["image"],
                            uid: element["uid"],
                            isVideo: element["isVideo"],
                            deliveryType: element["deliveryType"],
                            price: element["price"],
                            location: element["location"],
                            distance: list[element["key"]]);
                        return MenuCardComponentWidget(
                          menu: model,
                        );
                      }),
                ],
              ),
            ),
          ),
        ));
    //return list;
  }

  List<String> images = [
    'assets/images/fd1.jpg',
    'assets/images/fd2.jpg',
    'assets/images/fd3.jpg',
    'assets/images/fd5.jpg',
    'assets/images/fd6.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {},
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
              stream: context.read<PostCubit>().getMenus(searchKey),
              builder: (context, snap) {
                if (snap.hasData) {
                  if (snap.data!.docs.isEmpty) {
                    return Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: primary,
                        title: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 1, right: 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Loading Location...",
                                      style: body3.copyWith(color: white),
                                    ),
                                    GestureDetector(
                                        onTap: () => {
                                              setState(() {
                                                searchKey = "";
                                              }),
                                              Get.to(() => PlaceSearch(
                                                    onSelection: (location) {
                                                      setState(() {
                                                        searchKey = location;
                                                      });
                                                    },
                                                  ))
                                            },
                                        child: Icon(Icons.search)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: Container()),
                              Text("No menu found"),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    map = snap.data?.docs ?? [];

                    return sort(
                        map,
                        state.currentLocation?["address"] ??
                            "Loading Location...");
                  }
                }
                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: primary,
                    title: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1, right: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Loading Location...",
                                  style: body3.copyWith(color: white),
                                ),
                                GestureDetector(
                                    onTap: () => {
                                          setState(() {
                                            searchKey = "";
                                          }),
                                          Get.to(() => PlaceSearch(
                                                onSelection: (location) {
                                                  setState(() {
                                                    searchKey = location;
                                                  });
                                                },
                                              ))
                                        },
                                    child: Icon(Icons.search)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Container()),
                          Text("Loading, please wait... "),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
