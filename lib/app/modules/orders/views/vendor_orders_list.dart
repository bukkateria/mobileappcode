import 'package:auto_size_text/auto_size_text.dart';
import 'package:bukateria/common_views.dart';
import 'package:bukateria/cubit/order_cubit/order_cubit.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/flutter_flow/flutter_flow_icon_button.dart';
import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/order_item.dart';
import 'package:bukateria/widgets/vendor_order_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorOrderList extends StatefulWidget {
  const VendorOrderList({Key? key}) : super(key: key);

  @override
  _VendorOrderListState createState() => _VendorOrderListState();
}

class _VendorOrderListState extends State<VendorOrderList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        print("---------${state}");
        if (state.status == OrderStatus.processing) {
          Get.back();
          CommonViews.showProgressDialog(context);
        } else if (state.status == OrderStatus.success) {
          Get.back();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order successfully placed!')));
        } else if (state.status == OrderStatus.error) {
          Get.back();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Something went wrong!')));
        }
      },
      child: BlocBuilder<OrderCubit, OrderState>(
        bloc: context.read<OrderCubit>(),
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
            stream: context.read<OrderCubit>().getChefOrderList(FirebaseAuth.instance.currentUser?.uid ?? ""),
              builder: (context,list){
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'Orders',
                  style: title3.copyWith(color: white),
                ),
                centerTitle: true,
                elevation: 1,
              ),
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              body: list.data?.docs.isEmpty ?? false ? Center(
                child: Text("Not found"),
              ):ListView.builder(
                itemCount: list.data?.docs.length,
                itemBuilder: (context, index) {
                  if(list.data?.docs.isNotEmpty ?? false) {
                    print("--------------${list.data?.docs[index]["menuId"]}");
                    return StreamBuilder<QuerySnapshot>(
                        stream: context.read<PostCubit>().getMenuByKey(
                            list.data?.docs[index]["menuId"]),
                        builder: (context, snapMenu) {
                         // if(snapMenu.data?.exists ?? false) {
                            return StreamBuilder<DocumentSnapshot>(
                                stream: context.read<PostCubit>()
                                    .getSpecificUser(
                                    list.data?.docs[index]["buyerId"]),
                                builder: (context, snapUser) {
                                  print("------------- ${snapMenu.data?.docs[0]["title"] ?? ""}");
                                  return SwipeActionCell(
                                    key: ObjectKey(list.data?.docs[index]["orderId"]), ///this key is necessary
                                    trailingActions: <SwipeAction>[
                                      SwipeAction(
                                          title: "delete",
                                          onTap: (CompletionHandler handler) async {
                                            await FirebaseFirestore.instance.collection("Order").doc(list.data?.docs[index]["orderId"]).delete();
                                          },
                                          color: Colors.red),
                                    ],
                                    child: VendorOrderItem(
                                      title: "${snapMenu.data?.docs[0]["title"] ?? ""}",
                                      cost: "${snapMenu.data?.docs[0]["price"]}",
                                      seller: "${snapUser.data?["name"]}",
                                      image: "${snapMenu.data?.docs[0]["image"]}",
                                      status: list.data
                                          ?.docs[index]["orderStatus"],
                                      buyerName: "${snapUser.data?["name"]}",
                                      deliveryType: "${snapMenu
                                          .data?.docs[0]["deliveryType"]}",
                                      phone: "${snapUser.data?["phone"]}",
                                      orderId: list.data?.docs[index]["orderId"],
                                      orderDate: list.data
                                          ?.docs[index]["dateTime"],
                                      orderStatus: list.data
                                          ?.docs[index]["orderStatus"],
                                      location: "${snapUser.data?["address"]}",
                                      buyerId: "${list.data
                                          ?.docs[index]["buyerId"]}",
                                    ),
                                  );
                                });
                          // }else{
                          //   return Container();
                          // }
                        });
                  }else{
                    return Center(child: Text("No Order"),);
                  }
                },
              ),
            );
          });
        },
      ),
    );
  }
}
