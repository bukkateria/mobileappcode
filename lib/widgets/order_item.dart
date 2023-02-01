import 'package:auto_size_text/auto_size_text.dart';
import 'package:bukateria/common_views.dart';
import 'package:bukateria/cubit/order_cubit/order_cubit.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrderItem extends StatelessWidget {
  OrderItem({
    required this.title,
    required this.cost,
    required this.seller,
    required this.status,
    required this.image,
    required this.isVideo,
    required this.buyerId,
    required this.menuId,
    required this.orderId,
    required this.sellerId,
    required this.deliveryType,
    required this.menuKey,
    required this.location,
    Key? key,
  }) : super(key: key);

  final String title;
  final String status;
  final String cost;
  final String seller;
  final String sellerId;
  final String image;
  final String buyerId;
  final String menuId;
  final bool isVideo;
  final String orderId;
  final String deliveryType;
  final String menuKey;
  final String location;
  double rating = 0;

  int a = 0;
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x411D2429),
              offset: Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: isVideo
                      ? Container(
                          height: 80,
                          width: 80,
                          child: Stack(
                            children: [
                              VideoPlayer(VideoPlayerController.network(image,
                                  videoPlayerOptions: VideoPlayerOptions())
                                ..initialize().then((_) {})),
                              Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.grey.shade400,
                                  ))
                            ],
                          ),
                        )
                      : CachedNetworkImage(
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          imageUrl: "${image}",
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 4, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$title', style: title5),
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: Row(
                          children: [
                            Icon(Icons.pin_drop,color: Colors.greenAccent,size: 12,),
                            SizedBox(width: 4,),
                            Expanded(
                              child: Text(
                                '\N$location',
                                textAlign: TextAlign.end,
                                style: title6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                        child: AutoSizeText('$status',
                            style: body4.copyWith(
                                color: status == 'Delivered'
                                    ? green
                                    : status == 'Pending'
                                        ? orange
                                        : primary)),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        "$seller",
                        style: body5,
                      )),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 12, 4, 8),
                    child: Text(
                      '\N$cost',
                      textAlign: TextAlign.end,
                      style: title6,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  status == 'Delivered'
                      ? TextButton(
                          onPressed: () {
                            showDialog(context: context, builder: (context){
                              return Dialog(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 12,),
                                      Text("Delivery",
                                          style: title5.copyWith(color: blue)),
                                      SizedBox(height: 12,),
                                      Text("Accept delivery and left rating for chef",
                                          style: title7.copyWith(color: grey)),
                                      SizedBox(height: 16,),
                                      RatingBar.builder(
                                        initialRating: 0,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          this.rating = rating;
                                        },
                                      ),
                                      SizedBox(height: 16,),
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(12),
                                        child: TextFormField(
                                          controller: descriptionController,
                                          onChanged: (_) {},
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            // labelText: 'Description',
                                            hintText: 'Briefly describe your menu here',
                                            hintStyle: body3.copyWith(color: grey),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: greyLight.withOpacity(0.3),
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: greyLight.withOpacity(0.3),
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            filled: true,
                                            fillColor: greyLight.withOpacity(0.2),
                                          ),
                                          maxLines: 4,
                                        ),
                                      ),
                                      ElevatedButton(onPressed: () async{
                                        if(rating == 0){
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Give feedback first")));
                                        }else {
                                          context.read<OrderCubit>()
                                              .changeOrderStatus("Completed");
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderId(orderId);
                                          context.read<OrderCubit>()
                                              .updateOrderStatus();
                                          context.read<OrderCubit>().giveReview(
                                              descriptionController.text,
                                              rating, buyerId, sellerId, menuId);
                                          await FirebaseFirestore.instance.collection(
                                              "User").doc(FirebaseAuth.instance
                                              .currentUser?.uid ?? "").get().then((
                                              value) async {
                                            FirebaseFirestore.instance
                                                .collection("User")
                                                .doc(sellerId)
                                                .get()
                                                .then((valueSender) async {
                                              /*context.read<OrderCubit>()
                                                  .sendNotification(
                                                  valueSender["token"],
                                                  value["name"], context,
                                                  "Order Accepted");*/
                                              if(valueSender["notification"] == true) {
                                                Map<String,
                                                    dynamic> notificationData = {
                                                };
                                                notificationData["senderId"] =
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid ?? "";
                                                notificationData["receiverId"] =
                                                    sellerId;
                                                notificationData["message"] =
                                                "Delivery Confirmed";
                                                notificationData["createdAt"] =
                                                    DateTime.now().toString();
                                                await FirebaseFirestore.instance
                                                    .collection("notifications")
                                                    .doc().set(notificationData);
                                                await context.read<OrderCubit>()
                                                    .sendNotification(
                                                    valueSender["token"],
                                                    value["name"], context,
                                                    "Delivery Confirmed");
                                              }else{
                                                Map<String,
                                                    dynamic> notificationData = {
                                                };
                                                notificationData["senderId"] =
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid ?? "";
                                                notificationData["receiverId"] =
                                                    sellerId;
                                                notificationData["message"] =
                                                "Delivery Confirmed";
                                                notificationData["createdAt"] =
                                                    DateTime.now().toString();
                                                await FirebaseFirestore.instance
                                                    .collection("notifications")
                                                    .doc().set(notificationData);
                                              }

                                              Navigator.pop(context);

                                            });
                                          });

                                        }
                                      }, child: Text("Confirm"))
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                          child: Text("Confirm Delivery",
                              style: title5.copyWith(color: blue)),
                        )
                      : status == 'Completed'
                          ? BlocListener<PostCubit,PostState>(
                      listener: (context, state) {
                        print("---------${state}");
                        if (state.status == OrderStatus.processing) {
                          Get.back();
                          CommonViews.showProgressDialog(context);
                        } else if (state.status ==
                            OrderStatus.success) {
                          Get.back();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Order successfully placed!')));
                        } else if (state.status == OrderStatus.error) {
                          Get.back();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                  Text('Something went wrong!')));
                        }
                      },child: InkWell(
                    onTap:(){
                      a = DateTime.now().microsecondsSinceEpoch;
                      context
                          .read<
                          OrderCubit>()
                          .changeOrderId(
                          "${a}");
                      context
                          .read<
                          OrderCubit>()
                          .changeBuyerId(
                          "${FirebaseAuth.instance.currentUser?.uid ?? ""}");
                      context
                          .read<
                          OrderCubit>()
                          .changeDateTime(
                          "${DateTime.now().toString()}");
                      context
                          .read<
                          OrderCubit>()
                          .changeDeliveryType(
                          "${deliveryType}");
                      context
                          .read<
                          OrderCubit>()
                          .changeMenuId(
                          "${menuKey}");
                      context
                          .read<
                          OrderCubit>()
                          .changeOrderStatus(
                          "Pending");
                      context
                          .read<
                          OrderCubit>()
                          .changeSellerId(
                          "${sellerId}");
                      FirebaseFirestore.instance.collection("User").doc(sellerId).get().then((value) async {

                        FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser?.uid ?? "").get().then((valueSender) async {
                          Map<String,dynamic> notificationData = {};
                          notificationData["senderId"] = FirebaseAuth.instance.currentUser?.uid??"";
                          notificationData["receiverId"] = sellerId;
                          notificationData["message"] = "You have a new order";
                          notificationData["createdAt"] = DateTime.now().toString();
                          FirebaseFirestore.instance.collection("notifications").doc().set(notificationData).then((m) {
                            context.read<OrderCubit>().sendNotification(value["token"], valueSender["name"], context, "You have a new order");

                          });

                        });
                      });
                      context
                          .read<
                          OrderCubit>()
                          .placeOrder();
                    },
                                child: Text("Re-Order",
                                    style: title5.copyWith(color: blue)),
                              )
                          )
                          : Text(""),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
