import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/flutter_flow/flutter_flow_util.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key, required this.notificationKey, required this.title,required this.time}) : super(key: key);

  final String title;
  final String time;
  final String notificationKey;

  @override
  Widget build(BuildContext context) {
    return  SwipeActionCell(
      key: ObjectKey(notificationKey), ///this key is necessary
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: "delete",
            onTap: (CompletionHandler handler) async {
              await FirebaseFirestore.instance.collection("notifications").doc(notificationKey).delete();
            },
            color: Colors.red),
      ],
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
        child: ListView(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Color(0x430F1113),
                          offset: Offset(0, 1),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: 1,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                child: Text("Order update", style: title4),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                    title.toString(),
                                    style: body3),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4,),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                          child: Row(
                            children: [
                              Text("${DateFormat("MMM dd, yyyy").format(DateTime.parse(time))}",style: TextStyle(color: primary, fontWeight: FontWeight.w400),),
                              Expanded(child: Container()),
                              Text("${DateFormat("h:mma").format(DateTime.parse(time))}",style: TextStyle(color: primary, fontWeight: FontWeight.w300),),
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
