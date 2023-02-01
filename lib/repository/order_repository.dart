
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class OrderRepository{
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseReference;

  String sellerId = "";
  String buyerId = "";

  OrderRepository(
      {auth.FirebaseAuth? firebaseAuth, FirebaseFirestore? firestoreReference})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _firebaseReference = firestoreReference ?? FirebaseFirestore.instance;

  Future<Map<String, Object>?> placeOrder(
      {required String orderId,
        required String orderStatus,
        required String deliveryType,
        required String buyerId,
        required String sellerId,
        required String menuId,
        required String dateTime,
       }) async {
    try {
      var map = <String, Object>{};
      map["orderId"] = orderId;
      map["orderStatus"] = orderStatus;
      map["deliveryType"] = deliveryType;
      map["buyerId"] = buyerId;
      map["sellerId"] = sellerId;
      map["menuId"] = menuId;
      map["dateTime"] = dateTime;

      await _firebaseReference.collection("Order").doc(orderId).set(map);


      return {"result": true};
    } catch (_) {
      throw Exception();
    }
  }

  Future<Map<String, Object>?> updateOrderStatus(
      {required String orderId, required String orderStatus}) async {
    try {
      var map = <String, Object>{};

      map["orderStatus"] = orderStatus;

      await _firebaseReference.collection("Order").doc(orderId).update(map);

      return map;
    } catch (_) {
      throw Exception();
    }
  }

  static String serverToken ="key=AAAARIk41jE:APA91bFysIN0NA4drzXop3mBhXkvBVh38hRfIAbO1kjn9aqbnHNpdWb0fgnn0fM_OU4mscxj__r242AzObJhHj3RSAgZboGYTkLJ75xbWsWjecYiqlGKEfxIsjOtODGJ8pq0WS-JhT_P";
  void sendNotificationToDriver(String token ,String name, context, String message) async
  {


    Map<String,String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken
    };

    Map notificationMap = {
      'body': message,
      'title': name
    };

    Map mapData = {
      'click_action':'FLUTTER_NOTIFICATION_CLICK',
      'id':'1',
      'status':'done',
      'ride_request_id': '1'
    };

    Map sendNotificationMap = {

      "notification" : notificationMap,
      "data": mapData,
      "priority":"high",
      "to": token
    };

    //Get.snackbar("done", "done");
    var res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );

    print("---------------result --------------- ${res.statusCode}  ${res.body}");

  }

  Future<void> getToken(context) async{

    final FirebaseMessaging firebaseMessaging =  FirebaseMessaging.instance;

    String? token = await firebaseMessaging.getToken();
    FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "token" : token
    });

    //FirebaseMessaging.getInstance().subscribeTopic(“/topics/”)
    firebaseMessaging.subscribeToTopic("allUsers");


    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      event.data['data'];
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
    });

  }

  giveReviews(
      String description,
      double rating,
      String buyerId,
      String sellerId,
      String menuId) async {
    Map<String,dynamic> map = {};
    map["comments"] = description;
    map["rating"] = rating;
    map["buyerId"] = buyerId;
    map["sellerId"] = sellerId;
    map["menuId"] = menuId;

    String key = FirebaseFirestore.instance.collection("Reviews").doc().id;
    map["key"] = key;

    await FirebaseFirestore.instance.collection("Reviews").doc(key).set(map);

  }


  // TODO: implement getSpecificFavorite
  Stream<QuerySnapshot<Object?>?> get getChefOrdersList => _firebaseReference.collection("Order").where("sellerId", isEqualTo: sellerId).snapshots();

  Stream<QuerySnapshot<Object?>?> get getFoodieOrdersList => _firebaseReference.collection("Order").where("buyerId", isEqualTo: buyerId).snapshots();


}