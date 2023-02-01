import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MethodWidget extends StatelessWidget {
  MethodWidget({Key? key, required this.text, this.image}) : super(key: key);

  final String text;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(
          leading: Icon(
            Icons.check_circle,
            color: Colors.black,
            size: 30,
          ),
          title: Text(
            '$text',
            style: body3,
          ),
          dense: false,
        ),
        Align(
          alignment: AlignmentDirectional(0.7, 0),
          child: CachedNetworkImage(
            width: 250,
            height: 100,
            fit: BoxFit.cover,
            imageUrl: "${image}",
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ],
    );
  }
}
