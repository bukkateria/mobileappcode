class RecipeMethod {
  String description;
  String image;
  RecipeMethod({
    required this.description,
    required this.image,
  });

  factory RecipeMethod.fromJson(Map<String, dynamic> json) => RecipeMethod(
        image: json['image'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'description': description,
      };
}
