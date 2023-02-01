import 'package:bukateria/models/ingredients.dart';
import 'package:bukateria/models/user_model.dart';

class MenusModel {
  String? title;
  String? description;
  String? uid;
  String? location;
 // List<Ingredients>? ingredients;
  DateTime? created_at;
  String? image;
  //bool? likes;
  String? deliveryType;
  String? price;
  String? key;
  bool? isVideo;
  int? distance;
  String? productStatus;
  //double? stars;

  MenusModel.getInstance();

  MenusModel({
    this.title,
    this.description,
    this.price,
    this.location,
    this.deliveryType,
    this.uid,
    this.image,
    this.created_at,
    this.productStatus,
    this.isVideo,
    this.key,
    this.distance
});

/*  factory MenusModel.fromJson(Map<String, dynamic> json) => MenusModel(
        title: json['title'],
        description: json['description'],
        user: json['user'],
        location: json['location'],
        ingredients: json['ingredients'],
        createdAt: json['createdAt'],
        image: json['image'],
        deliveyStatus: json['deliveyStatus'],
        likes: json['likes'],
        amount: json['amount'],
        stars: json['stars'],
      );*/

  /*Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'user': user,
        'location': location,
        'deliveyStatus': deliveyStatus,
        'ingredients': ingredients,
        'createdAt': createdAt,
        'image': image,
        'likes': likes,
        'stars': title,
        'amount': amount
      };*/
}
