import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bukateria/cubit/order_cubit/order_cubit.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/repository/order_repository.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../app/modules/orders/views/vendor_order_view.dart';

/*class VendorOrderItem extends StatelessWidget {
  const VendorOrderItem({
    required this.title,
    required this.cost,
    required this.seller,
    required this.status,
    required this.buyerName,
    required this.phone,
    required this.image,
    required this.orderId,
    required this.deliveryType,
    required this.orderDate,
    required this.location,
    required this.orderStatus,
    required this.buyerId,
    Key? key,
  }) : super(key: key);

  final String title;
  final String status;
  final String cost;
  final String seller;
  final String buyerName;
  final String phone;
  final String image;
  final String orderId;
  final String deliveryType;
  final String orderDate;
  final String location;
  final String orderStatus;
  final String buyerId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
            context: context,
            builder: ((context) => Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.96,
                        decoration: BoxDecoration(
                          color: white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CachedNetworkImage(
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                  imageUrl: "${widget.image}",
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.title}",
                                      style: title4,
                                    ),
                                    Text(
                                      "Order ID: ${widget.orderId}",
                                      style: title5,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "",
                                      style: body4,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Order Detail', style: title5),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Customer', style: body3),
                                    Text('${widget.buyerName}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Customer Phone', style: body3),
                                    Text('${widget.phone}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Delivery Type', style: body3),
                                    Text('${widget.deliveryType}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Amount', style: body3),
                                    Text('${widget.cost}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Order Date', style: body3),
                                    Text('${widget.orderDate}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Location', style: body3),
                                    Text('${widget.location}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Country', style: body3),
                                    Text('Nigeria',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            orderStatus == "Pending"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderStatus("Accepted");
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderId(orderId);
                                          context
                                              .read<OrderCubit>()
                                              .updateOrderStatus();
                                          FirebaseFirestore.instance.collection("User").doc(buyerId).get().then((value) async {

                                            FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser?.uid ?? "").get().then((valueSender) async {
                                              Map<String,dynamic> notificationData = {};
                                              notificationData["senderId"] = FirebaseAuth.instance.currentUser?.uid??"";
                                              notificationData["receiverId"] = buyerId;
                                              notificationData["message"] = "Order Accepted";
                                              notificationData["createdAt"] = DateTime.now().toString();
                                              FirebaseFirestore.instance.collection("notifications").doc().set(notificationData).then((m) {
                                                context.read<OrderCubit>().sendNotification(value["token"], valueSender["name"], context, "Order Accepted");
                                              });
                                            });
                                          });
                                        },
                                        child: Text(
                                          "Accept",
                                          style: title5.copyWith(color: green),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderStatus("Rejected");
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderId(orderId);
                                          context
                                              .read<OrderCubit>()
                                              .updateOrderStatus();
                                          FirebaseFirestore.instance.collection("User").doc(buyerId).get().then((value) async {

                                            FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser?.uid ?? "").get().then((valueSender) async {
                                              Map<String,dynamic> notificationData = {};
                                              notificationData["senderId"] = FirebaseAuth.instance.currentUser?.uid??"";
                                              notificationData["receiverId"] = buyerId;
                                              notificationData["message"] = "Order Accepted";
                                              notificationData["createdAt"] = DateTime.now().toString();
                                              FirebaseFirestore.instance.collection("notifications").doc().set(notificationData).then((m) {
                                                context.read<OrderCubit>().sendNotification(value["token"], valueSender["name"], context, "Order Rejected");
                                              });
                                             // context.read<OrderCubit>().sendNotification(value["token"], valueSender["name"], context, "Order Rejected");
                                            });
                                          });
                                        },
                                        child: Text("Reject",
                                            style: title5.copyWith(
                                                color: primary)),
                                      )
                                    ],
                                  )
                                : orderStatus == "Accepted"
                                    ? TextButton(
                                        onPressed: () {
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderStatus("Delivered");
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderId(orderId);
                                          context
                                              .read<OrderCubit>()
                                              .updateOrderStatus();
                                          FirebaseFirestore.instance.collection("User").doc(buyerId).get().then((value) async {

                                            FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser?.uid ?? "").get().then((valueSender) async {
                                              Map<String,dynamic> notificationData = {};
                                              notificationData["senderId"] = FirebaseAuth.instance.currentUser?.uid??"";
                                              notificationData["receiverId"] = buyerId;
                                              notificationData["message"] = "Order Accepted";
                                              notificationData["createdAt"] = DateTime.now().toString();
                                              FirebaseFirestore.instance.collection("notifications").doc().set(notificationData).then((m) {
                                                context.read<OrderCubit>().sendNotification(value["token"], valueSender["name"], context, "Order Delivered");
                                              });
                                              //context.read<OrderCubit>().sendNotification(value["token"], valueSender["name"], context, "Order Delivered");
                                            });
                                          });
                                        },
                                        child: Text(
                                          "Deliver",
                                          style: title5.copyWith(color: green),
                                        ),
                                      )
                                    : Text(
                                        "$orderStatus",
                                        style: title5.copyWith(color: green),
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: white,
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
                    child: CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: "${widget.image}",
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                        Text('${widget.title}', style: title5),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                          child: AutoSizeText('$status',
                              style: body4.copyWith(
                                  color: status == 'Accepted'
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
                    orderStatus == "Pending"
                        ? Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Text(
                          "Expires in",
                          style: body5,
                        )) : Container(),
                    orderStatus == "Pending"
                        ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: Text(
                        '1.45min',
                        textAlign: TextAlign.end,
                        style: title6.copyWith(color: primary),
                      ),
                    ) : Container(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Text(
                        'View detail',
                        textAlign: TextAlign.end,
                        style: title6.copyWith(color: blue),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/

class VendorOrderItem extends StatefulWidget {
  const VendorOrderItem({
    required this.title,
    required this.cost,
    required this.seller,
    required this.status,
    required this.buyerName,
    required this.phone,
    required this.image,
    required this.orderId,
    required this.deliveryType,
    required this.orderDate,
    required this.location,
    required this.orderStatus,
    required this.buyerId,
    Key? key,
  }) : super(key: key);

  final String title;
  final String status;
  final String cost;
  final String seller;
  final String buyerName;
  final String phone;
  final String image;
  final String orderId;
  final String deliveryType;
  final String orderDate;
  final String location;
  final String orderStatus;
  final String buyerId;

  @override
  State<VendorOrderItem> createState() => _VendorOrderItemState();
}

class _VendorOrderItemState extends State<VendorOrderItem> {
  DateTime? dateTime;
  DateTime? currentTime;
  int difference = 0;
  String timeText = "";

  OrderCubit orderCubit = OrderCubit(orderRepository: OrderRepository());


  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    print("-------------${widget.orderDate}");
    //2022-10-15 16:35:44.263046
    if (widget.orderStatus == "Pending") {
      dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.orderDate);
      currentTime = DateTime.now();
      dateTime = dateTime?.add(Duration(minutes: 120));
      if (currentTime != null && dateTime != null) {
        difference = currentTime!.difference(dateTime!).inSeconds;
      }
      print("----------------------------------- ${difference}");
      if (difference < 0) {
        timer = Timer.periodic(Duration(seconds: 1), (_) {
          if (difference >= 0) {
            context.read<OrderCubit>().changeOrderStatus("Expired");
            context.read<OrderCubit>().changeOrderId(widget.orderId);
            context.read<OrderCubit>().expireOrderStatus();
            timer?.cancel();
          } else {
            setState(() {
              difference++;
              Duration duration = Duration(seconds: -difference);
              timeText = "${_printDuration(duration)}";
            });
          }
        });
      } else {
        context.read<OrderCubit>().changeOrderStatus("Expired");
        context.read<OrderCubit>().changeOrderId(widget.orderId);
        context.read<OrderCubit>().expireOrderStatus();
        timer?.cancel();
      }
    }
    super.initState();
  }

  Timer? timer;

  @override
  void dispose() {
    if (widget.orderStatus == "Pending") {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
            context: context,
            builder: ((context) => Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.96,
                        decoration: BoxDecoration(
                          color: white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CachedNetworkImage(
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                  imageUrl: "${widget.image}",
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.title}",
                                      style: title4,
                                    ),
                                    Text(
                                      "Order ID: ${widget.orderId}",
                                      style: title5,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "",
                                      style: body4,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Order Detail', style: title5),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Customer', style: body3),
                                    Text('${widget.buyerName}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Customer Phone', style: body3),
                                    Text('${widget.phone}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Delivery Type', style: body3),
                                    Text('${widget.deliveryType}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Amount', style: body3),
                                    Text('${widget.cost}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Order Date', style: body3),
                                    Text('${widget.orderDate.split(" ").first}',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                                widget.deliveryType == "pickup"
                                    ? Container()
                                    : Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Location', style: body3),
                                          Text('${widget.location}',
                                              textAlign: TextAlign.end,
                                              style: body3),
                                        ],
                                      ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Country', style: body3),
                                    Text('Nigeria',
                                        textAlign: TextAlign.end, style: body3),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            widget.orderStatus == "Pending"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderStatus("Accepted");
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderId(widget.orderId);
                                          context
                                              .read<OrderCubit>()
                                              .updateOrderStatus();
                                          FirebaseFirestore.instance
                                              .collection("User")
                                              .doc(widget.buyerId)
                                              .get()
                                              .then((value) async {
                                            FirebaseFirestore.instance
                                                .collection("User")
                                                .doc(FirebaseAuth.instance
                                                        .currentUser?.uid ??
                                                    "")
                                                .get()
                                                .then((valueSender) async {
                                              if (value["notification"] ==
                                                  true) {
                                                Map<String, dynamic>
                                                    notificationData = {};
                                                notificationData["senderId"] =
                                                    FirebaseAuth.instance
                                                            .currentUser?.uid ??
                                                        "";
                                                notificationData["receiverId"] =
                                                    widget.buyerId;
                                                notificationData["message"] =
                                                    "Order Accepted";
                                                notificationData["createdAt"] =
                                                    DateTime.now().toString();
                                                await FirebaseFirestore.instance
                                                    .collection("notifications")
                                                    .doc()
                                                    .set(notificationData);
                                                await orderCubit
                                                    .sendNotification(
                                                    value["token"],
                                                    valueSender["name"],
                                                    context,
                                                    "Order Accepted");
                                              }else{
                                                Map<String, dynamic>
                                                notificationData = {};
                                                notificationData["senderId"] =
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid ??
                                                        "";
                                                notificationData["receiverId"] =
                                                    widget.buyerId;
                                                notificationData["message"] =
                                                "Order Accepted";
                                                notificationData["createdAt"] =
                                                    DateTime.now().toString();
                                                await FirebaseFirestore.instance
                                                    .collection("notifications")
                                                    .doc()
                                                    .set(notificationData);
                                              }
                                            });
                                          });
                                        },
                                        child: Text(
                                          "Accept",
                                          style: title5.copyWith(color: green),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderStatus("Rejected");
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderId(widget.orderId);
                                          context
                                              .read<OrderCubit>()
                                              .updateOrderStatus();
                                          FirebaseFirestore.instance
                                              .collection("User")
                                              .doc(widget.buyerId)
                                              .get()
                                              .then((value) async {
                                            FirebaseFirestore.instance
                                                .collection("User")
                                                .doc(FirebaseAuth.instance
                                                        .currentUser?.uid ??
                                                    "")
                                                .get()
                                                .then((valueSender) async {
                                              if (value["notification"] ==
                                                  true) {
                                                Map<String, dynamic>
                                                    notificationData = {};
                                                notificationData["senderId"] =
                                                    FirebaseAuth.instance
                                                            .currentUser?.uid ??
                                                        "";
                                                notificationData["receiverId"] =
                                                    widget.buyerId;
                                                notificationData["message"] =
                                                    "Order Accepted";
                                                notificationData["createdAt"] =
                                                    DateTime.now().toString();
                                                await FirebaseFirestore.instance
                                                    .collection("notifications")
                                                    .doc()
                                                    .set(notificationData);
                                                await orderCubit
                                                    .sendNotification(
                                                    value["token"],
                                                    valueSender["name"],
                                                    context,
                                                    "Order Rejected");
                                              }else{
                                                Map<String, dynamic>
                                                notificationData = {};
                                                notificationData["senderId"] =
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid ??
                                                        "";
                                                notificationData["receiverId"] =
                                                    widget.buyerId;
                                                notificationData["message"] =
                                                "Order Accepted";
                                                notificationData["createdAt"] =
                                                    DateTime.now().toString();
                                                await FirebaseFirestore.instance
                                                    .collection("notifications")
                                                    .doc()
                                                    .set(notificationData);
                                              }
                                              // context.read<OrderCubit>().sendNotification(value["token"], valueSender["name"], context, "Order Rejected");
                                            });
                                          });
                                        },
                                        child: Text("Reject",
                                            style: title5.copyWith(
                                                color: primary)),
                                      )
                                    ],
                                  )
                                : widget.orderStatus == "Accepted"
                                    ? TextButton(
                                        onPressed: () {
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderStatus("Delivered");
                                          context
                                              .read<OrderCubit>()
                                              .changeOrderId(widget.orderId);
                                          context
                                              .read<OrderCubit>()
                                              .updateOrderStatus();
                                          FirebaseFirestore.instance
                                              .collection("User")
                                              .doc(widget.buyerId)
                                              .get()
                                              .then((value) async {
                                            FirebaseFirestore.instance
                                                .collection("User")
                                                .doc(FirebaseAuth.instance
                                                        .currentUser?.uid ??
                                                    "")
                                                .get()
                                                .then((valueSender) async {
                                              if (value["notification"] ==
                                                  true) {
                                                Map<String, dynamic>
                                                    notificationData = {};
                                                notificationData["senderId"] =
                                                    FirebaseAuth.instance
                                                            .currentUser?.uid ??
                                                        "";
                                                notificationData["receiverId"] =
                                                    widget.buyerId;
                                                notificationData["message"] =
                                                    "Order Accepted";
                                                notificationData["createdAt"] =
                                                    DateTime.now().toString();
                                                await FirebaseFirestore.instance
                                                    .collection("notifications")
                                                    .doc()
                                                    .set(notificationData);
                                                await orderCubit
                                                    .sendNotification(
                                                    value["token"],
                                                    valueSender["name"],
                                                    context,
                                                    "Order Delivered");
                                              }else{
                                                Map<String, dynamic>
                                                notificationData = {};
                                                notificationData["senderId"] =
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid ??
                                                        "";
                                                notificationData["receiverId"] =
                                                    widget.buyerId;
                                                notificationData["message"] =
                                                "Order Accepted";
                                                notificationData["createdAt"] =
                                                    DateTime.now().toString();
                                                await FirebaseFirestore.instance
                                                    .collection("notifications")
                                                    .doc()
                                                    .set(notificationData);
                                              }
                                              //context.read<OrderCubit>().sendNotification(value["token"], valueSender["name"], context, "Order Delivered");
                                            });
                                          });
                                        },
                                        child: Text(
                                          "Deliver",
                                          style: title5.copyWith(color: green),
                                        ),
                                      )
                                    : Text(
                                        "${widget.orderStatus}",
                                        style: title5.copyWith(color: green),
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: white,
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
                    child: CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: "${widget.image}",
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                        Text('${widget.title}', style: title5),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                          child: AutoSizeText('${widget.status}',
                              style: body4.copyWith(
                                  color: widget.status == 'Accepted'
                                      ? green
                                      : widget.status == 'Pending'
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
                    widget.orderStatus == "Pending"
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: Text(
                              "Expires in",
                              style: body5,
                            ))
                        : Container(),
                    widget.orderStatus == "Pending"
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: Text(
                              '$timeText',
                              textAlign: TextAlign.end,
                              style: title6.copyWith(color: primary),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Text(
                        'View detail',
                        textAlign: TextAlign.end,
                        style: title6.copyWith(color: blue),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
