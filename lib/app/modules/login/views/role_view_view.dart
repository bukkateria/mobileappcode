import 'package:bukateria/app/modules/dashboard/views/dashboard_view.dart';
import 'package:bukateria/app/modules/dashboard/views/vendor_dashboard.dart';
import 'package:bukateria/app/modules/profiles/views/profiles_view.dart';
import 'package:bukateria/common_views.dart';
import 'package:bukateria/flutter_flow/flutter_flow_theme.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../../../cubit/role_view_cubit/roleview_cubit.dart';

class RoleRedirectWidget extends StatefulWidget {
  const RoleRedirectWidget({Key? key}) : super(key: key);

  @override
  _RoleRedirectWidgetState createState() => _RoleRedirectWidgetState();
}

class _RoleRedirectWidgetState extends State<RoleRedirectWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoleViewCubit, RoleViewState>(
      listener: (context, state) {
        print("-----------------${state.status}");
        if (state.status == RoleViewStatus.success) {
          context.read<RoleViewCubit>().setUserType("YES");
        } else if (state.status == RoleViewStatus.saved) {
          if (state.userType == "foodie") {
            Get.offAll(() => DashboardView());
          } else {
            Get.offAll(() => VendorDashboard());
          }
        }
      },
      child: BlocBuilder<RoleViewCubit, RoleViewState>(
        builder: (context, state) {
          return StreamBuilder<auth.User>(
              stream: context.read<RoleViewCubit>().getUser(),
              builder: (context, data) {
                return Scaffold(
                  key: scaffoldKey,
                  backgroundColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                  body: SafeArea(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: const AssetImage(
                                  "assets/images/big_logo.png"),
                              colorFilter: ColorFilter.mode(
                                  white.withOpacity(0.1), BlendMode.modulate))),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 30, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    GestureDetector(
                                      onTap: () => context
                                          .read<RoleViewCubit>()
                                          .updateUserType(
                                              "foodie", data.data?.uid ?? ""),
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEEEEEE),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: Image.asset(
                                              'assets/images/foodie.jpg',
                                            ).image,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Foodie',
                                      style: title3,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GestureDetector(
                                    onTap: () => context
                                        .read<RoleViewCubit>()
                                        .updateUserType(
                                            "vendor", data.data?.uid ?? ""),
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEEEEEE),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.asset(
                                            'assets/images/vendor.jpg',
                                          ).image,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Chef',
                                    style: title3,
                                  ),
                                ],
                              ),
                            ],
                          ),
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
