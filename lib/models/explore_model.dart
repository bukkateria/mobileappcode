class ExploreModel {
  String? key;
  String? title;
  String? description;
  String? productStatus;
  DateTime? created_at;
  String? uid;
  String? image;
  bool? isVideo;

  ExploreModel.getInstance();

  ExploreModel(
      {this.key,
      this.title,
      this.description,
      this.productStatus,
      this.created_at,
      this.uid,
      this.isVideo,
      this.image});
}
