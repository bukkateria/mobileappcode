import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Privacy Policy",
              style: title4.copyWith(color: white),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Nunc nonummy metus. Praesent nonummy mi in odio. Aenean vulputate eleifend tellus. In dui magna, posuere eget, vestibulum et, tempor auctor, justo. Etiam ultricies nisi vel augue.Donec venenatis vulputate lorem. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Cras risus ipsum, faucibus ut, ullamcorper id, varius ac, leo. Fusce commodo aliquam arcu. Vivamus aliquet elit ac nisl.Etiam iaculis nunc ac metus. Nulla sit amet est. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Fusce id purus.. Cras risus ipsum, faucibus ut, ullamcorper id, varius ac, leo.Etiam iaculis nunc ac metus. Aenean massa. Quisque rutrum. Nullam nulla eros, ultricies sit amet, nonummy id, imperdiet feugiat, pede. Maecenas nec odio et ante tincidunt tempus.Pellentesque commodo eros a enim. Praesent turpis. Curabitur ullamcorper ultricies nisi. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Curabitur ullamcorper ultricies nisi.",
                style: body3,
              )
            ],
          ),
        ));
  }
}
