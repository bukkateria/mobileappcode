import 'dart:developer';

import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/data/menus_list.dart';
import 'package:bukateria/models/explore_model.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/explore_card.dart';
import 'package:bukateria/widgets/search_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';

import '../controllers/vlog_controller.dart';

class VlogView extends StatelessWidget {
  const VlogView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {},
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
              stream: context.read<PostCubit>().getExplore(),
              builder: (context, snap) {
                if (snap.hasData) {
                  return Scaffold(
                      appBar: AppBar(
                          elevation: 0,
                          centerTitle: true,
                          backgroundColor: primary,
                          title: Text("Explore",
                              style: title3.copyWith(color: white))),
                      body: Column(
                        children: [
                          Expanded(
                            child: (snap.data?.docs.isNotEmpty ?? false)
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: snap.data?.docs.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      ExploreModel model = ExploreModel(
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
                                        isVideo: snap.data?.docs[index]
                                            ["isVideo"],
                                      );
                                      // log('${index + 1} : explore uid : ${model.uid}');

                                      return ExploreCard(
                                        explore: model,
                                      );
                                    })
                                : Center(child: Text("No Explore found")),
                          ),
                        ],
                      ));
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
