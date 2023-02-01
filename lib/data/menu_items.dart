import 'package:bukateria/models/menu_item_model.dart';
import 'package:flutter/material.dart';

class MenuItems {
  static List<PopItem> menuItems = [report, /*share,*/ logout];
  static List<PopItem> menuChefItems = [/*share,*/ edit, delete, pause,logout];
  static List<PopItem> menuChefItemsUnPause = [/*share,*/ edit, delete, unPause,logout];

  static var report = PopItem(text: "Report", icon: Icons.settings);
 // static var share = PopItem(text: "Share", icon: Icons.share);
  static var edit = PopItem(text: "Edit", icon: Icons.edit);
  static var delete = PopItem(text: "Delete", icon: Icons.delete);
  static var pause = PopItem(text: "Pause", icon: Icons.pause);
  static var unPause = PopItem(text: "Restore", icon: Icons.play_arrow);
  static var logout = PopItem(text: "Logout", icon: Icons.logout);
}
