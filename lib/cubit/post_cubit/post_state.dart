part of 'post_cubit.dart';

enum PostStatus { initial, submitting, success,save,publish,unPublish, error,locationFound, updated, deleted,deleting,pausing,paused,reported }

class PostState extends Equatable {
  final String? title;
  final String? description;
  final String? typeOfCuisine;
  final String? recipeCategory;
  final String? productStatus;
  final String? key;
  final String? price;
  final String? location;
  final Map<String,dynamic>? currentLocation;
  final String? deliveryType;
  final File? image;
  final List<Map<String,dynamic>>? ingredients;
  final List<Map<String,dynamic>>? methods;
  final PostStatus status;
  const PostState(
      {this.title, this.description,this.currentLocation, this.typeOfCuisine,this.recipeCategory,this.productStatus, this.key,this.price,this.location,this.deliveryType, this.image, this.ingredients,this.methods, required this.status});

  factory PostState.initial() {
    return PostState( status: PostStatus.initial);
  }

  PostState copyWith(
      {String? title, String? description, String? typeOfCuisine,Map<String,dynamic>? currentLocation,String? recipeCategory,String? productStatus,String? key,String? price,String? location,String? deliveryType, File? image, List<Map<String,dynamic>>? ingredients, List<Map<String,dynamic>>? methods, PostStatus? status}) {
    return PostState(
        title: title ?? this.title,
        description: description ?? this.description,
        currentLocation: currentLocation ?? this.currentLocation,
        typeOfCuisine: typeOfCuisine ?? this.typeOfCuisine,
        recipeCategory: recipeCategory ?? this.recipeCategory,
        productStatus: productStatus ?? this.productStatus,
        key: key ?? this.key,
        price: price ?? this.price,
        location: location ?? this.location,
        deliveryType: deliveryType ?? this.deliveryType,
        image: image ?? this.image,
        ingredients: ingredients ?? this.ingredients,
        methods: methods ?? this.methods,
        status: status ?? this.status);
  }

  bool get isValid => title != null && description != null && typeOfCuisine != null && recipeCategory != null && productStatus != null && image != null && ingredients != null && methods != null;

  bool get isValidExplore => title != null && description != null && productStatus != null && image != null;

  @override
  List<Object> get props => [title ?? "", description ?? "",currentLocation ?? {}, typeOfCuisine ?? "",recipeCategory ?? "",productStatus ?? "",key ?? "",price ?? "",location ?? "",deliveryType ?? "",image ?? "", ingredients ?? "",methods ?? "", status];
}
