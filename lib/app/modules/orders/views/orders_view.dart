import 'package:auto_size_text/auto_size_text.dart';
import 'package:bukateria/cubit/order_cubit/order_cubit.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/flutter_flow/flutter_flow_icon_button.dart';
import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/order_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({Key? key}) : super(key: key);

  @override
  _HistoryWidgetState createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'My Orders',
          style: title3,
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 44,
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24,
              ),
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
          ),
        ],
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: context.read<OrderCubit>().getFoodieOrderList(
                          FirebaseAuth.instance.currentUser?.uid ?? ""),
                      builder: (context, list) {
                        if(list.data!=null) {
                          if(list.data?.docs.isNotEmpty ?? false) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: list.data?.docs.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                print("----s-s-s-s-s-s------- ${list.data?.docs[index]["menuId"].toString().trim() ?? ""}");
                                return StreamBuilder<QuerySnapshot>(
                                    stream: context.read<PostCubit>().getMenuByKey(list.data?.docs[index]["menuId"].toString().trim() ?? ""),
                                    builder: (context,snapMenu){
                                      //print("---------asd--${snapMenu.data!.docs.first.data()}  ${snapMenu.data!=null}");
                                      if(snapMenu.data?.docs.isNotEmpty ?? false) {
                                        return StreamBuilder<DocumentSnapshot>(
                                            stream: context.read<PostCubit>()
                                                .getSpecificUser(list.data
                                                ?.docs[index]["sellerId"]),
                                            builder: (context, snapUser) {
                                              if (snapUser.data != null) {
                                                print("[[[[[[[[[[[ ${snapMenu
                                                    .data?.docs[0]["title"]} ]]]]]]]]]]]]]]");
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
                                                  child: OrderItem(
                                                    location: "${snapUser.data?["address"] ?? ""}",
                                                    title: "${snapMenu
                                                        .data?.docs[0]["title"] ?? ""}",
                                                    cost: "${snapMenu
                                                        .data?.docs[0]["price"] ?? "0"}",
                                                    seller: "${snapUser
                                                        .data?["name"] ?? ""}",
                                                    image: "${snapMenu
                                                        .data?.docs[0]["image"] ?? ""}",
                                                    status: list.data
                                                    ?.docs[index]["orderStatus"] ??
                                                        "",
                                                    isVideo: snapMenu
                                                        .data?.docs[0]["isVideo"] ??
                                                        false,
                                                    buyerId: list.data
                                                    ?.docs[index]["buyerId"] ??
                                                        "",
                                                    menuId: list.data
                                                    ?.docs[index]["menuId"] ??
                                                        "",
                                                    orderId: list.data
                                                        ?.docs[index]["orderId"] ??
                                                        "",
                                                    sellerId: list.data
                                                        ?.docs[index]["sellerId"] ??
                                                        "",
                                                    deliveryType: list.data
                                                        ?.docs[index]["deliveryType"] ??
                                                        "",
                                                    menuKey: list.data
                                                        ?.docs[index]["menuId"] ??
                                                        "",

                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            });
                                      }else{
                                        return Container();
                                      }
                                    });
                              },
                            );
                          }else{
                            return Center(
                              child: Text("Not found"),
                            );
                          }
                        }else{
                          return Center(
                            child: Text("Please Wait"),
                          );
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
