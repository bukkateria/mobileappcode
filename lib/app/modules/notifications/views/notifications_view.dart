import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/notification_item.dart';
import 'package:bukateria/widgets/related_recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
          style: title3,
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("notifications").where("receiverId",isEqualTo: FirebaseAuth.instance.currentUser?.uid??"").snapshots(),
            builder: (context,snap){
              if(snap.hasData) {
                return ListView.builder(
                    itemCount: snap.data?.docs.length,
                    itemBuilder: (context, index) {
                  return NotificationItem(
                      title: snap.data?.docs[index]['message'] ?? "",
                      time: snap.data?.docs[index]['createdAt'] ?? "",
                      notificationKey: snap.data?.docs[index].id ?? "",
                  );
                });
              }else{
                return Center(child: Text("Loading"),);
              }
            },
          )

          /*Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     Padding(
              //       padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 12),
              //       child: Text(
              //         'This Week',
              //         style: FlutterFlowTheme.of(context).bodyText2,
              //       ),
              //     ),
              //   ],
              // ),
              NotificationItem(title: 'Notifications of orders'),
              NotificationItem(title: 'Cancellation of orders'),
              NotificationItem(title: 'Messages from Bukkateria'),
            ],
          )*/,
        ),
      ),
    );
  }
}
