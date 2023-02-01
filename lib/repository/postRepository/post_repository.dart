import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'base_post_repository.dart';

class PostRepository extends BasePostRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseReference;
  String methodKey = "";
  String ingredientsKey = "";
  String recipeKey = "";
  String menuKey = "";
  String exploreKey = "";
  String userUID = "";
  String favoriteKey = "";
  String productId = "";

  PostRepository(
      {auth.FirebaseAuth? firebaseAuth, FirebaseFirestore? firestoreReference})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _firebaseReference = firestoreReference ?? FirebaseFirestore.instance;

  @override
  Future<String?> uploadImage(
      {required File imageFile,
      required String name,
      required String uid}) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('post_image')
        .child(name + DateTime.now().microsecondsSinceEpoch.toString());
    try {
      await ref.putFile(imageFile);
      String url = await ref.getDownloadURL();
      print('Url' + url);
      return url;
    } on FirebaseException catch (e) {
      print(e);
    }
    return "";
  }

  @override
  Future<Map<String, Object>?> addExplorePost(
      {required String title,
      required String description,
      required String productStatus,
      required String image,
      required bool isVideo,
      required String uid}) async {
    try {
      var map = <String, Object>{};
      map["title"] = title;
      map["description"] = description;
      map["image"] = image;
      map["productStatus"] = productStatus;
      map["uid"] = uid;
      map["isVideo"] = isVideo;
      map["created_at"] = DateTime.now();
      String value = _firebaseReference.collection("Explore").doc().id;
      map["key"] = value;
      await _firebaseReference.collection("Explore").doc(value).set(map);
      return map;
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Map<String, Object>?> updateExplorePost(
      {required String key, required String uid}) async {
    try {
      var map = <String, Object>{};

      map["productStatus"] = "PUBLISH";

      await _firebaseReference.collection("Explore").doc(key).update(map);

      return map;
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Map<String, Object>?> pauseExplorePost(
      {required String key, required String uid}) async {
    try {
      var map = <String, Object>{};

      map["productStatus"] = "UNPUBLISH";

      await _firebaseReference.collection("Explore").doc(key).update(map);

      return map;
    } catch (_) {
      throw Exception();
    }
  }

  Future<bool?> deleteExplore(String key) async {
    await _firebaseReference.collection("Explore").doc(key).delete().then((value) {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  Future<bool?> deleteMenu(String key) async {
    await _firebaseReference.collection("Menu").doc(key).delete().then((value) {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  Future<bool?> deleteRecipe(String key) async {
    await _firebaseReference.collection("Recipe").doc(key).delete().then((value) {
      _firebaseReference.collection("Methods").doc(key).delete().then((value) {
        _firebaseReference.collection("Ingredients").doc(key).delete().then((value) {

          return true;
        });
      });
    });
  }

  Future<bool?> deleteMethod(String parentKey, String key) async {
    await _firebaseReference.collection("Methods").doc(parentKey).collection("list").doc(key).delete().then((value) {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  Future<bool?> deleteIngredient(String parentKey, String key) async {
    await _firebaseReference.collection("ingredients").doc(parentKey).collection("list").doc(key).delete().then((value) {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  @override
  Future<Map<String, Object>?> updateMenuPost(
      {required String key, required String uid}) async {
    try {
      var map = <String, Object>{};

      map["productStatus"] = "PUBLISH";

      await _firebaseReference.collection("Menu").doc(key).update(map);
      print("-----------publish");

      return map;
    } catch (er) {
      print("-----------------$er");
      throw Exception();
    }
  }

  @override
  Future<Map<String, Object>?> pauseMenuPost(
      {required String key, required String uid}) async {
    try {
      var map = <String, Object>{};

      map["productStatus"] = "UNPUBLISH";

      await _firebaseReference.collection("Menu").doc(key).update(map);

      return map;
    } catch (_) {
      throw Exception();
    }
  }

  Future<Map<String, Object>?> updateMenuDetails(
      {
        required String key,
        required String uid,
         String? title,
         String? description,
         String? image,
         String? price,
         String? location,
         String? deliveryType,
         bool? isVideo

      }) async {
    try {
      var map = <String, Object>{};

      map["created_at"] = DateTime.now();
      /*String value = _firebaseReference.collection("Menu").doc().id;
      map["key"] = value;*/
      if(title != null){
        map["title"] = title;
      }
      if(description != null){
        map["description"] = description;
      }
      if(price != null ){
        map["price"] = price;
      }
      if(isVideo!= null){
        map["isVideo"] = isVideo;
      }
      if(image!= null){
        map["image"] = image;
      }
      if(location!= null){
        map["location"] = location;
      }
      if(deliveryType!= null){
        map["deliveryType"] = deliveryType;
      }


      await _firebaseReference.collection("Menu").doc(key).update(map);

      return map;
    } catch (_) {
      throw Exception();
    }
  }

  @override
  // TODO: implement getExplores
  Stream<QuerySnapshot<Object?>?> get getExplores =>
      _firebaseReference.collection("Explore").snapshots();

  String menuSearchKey = "";
  String recipeSearchKey = "";

  @override
  // TODO: implement getExplores
  Stream<QuerySnapshot<Object?>?> get getSearchMenus =>
      _firebaseReference.collection("Menu").where("productStatus",isEqualTo: "PUBLISH").where("location",isEqualTo: menuSearchKey).snapshots();

  @override
  // TODO: implement getExplores
  Stream<QuerySnapshot<Object?>?> get getMenus =>
      _firebaseReference.collection("Menu").where("productStatus",isEqualTo: "PUBLISH").snapshots();


  String kPLACES_API_KEY = "AIzaSyD1-pjN6OGA80NaUTe8IS9McCWHlMvUcHA";

  Future<String> searchPlaces(String input) async {
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY';
    var response = await http.get(Uri.parse(request));

    if (response.body.isNotEmpty) {
      return response.body;
    } else {
      return "Not found!";
    }
  }

  Future<String> getDetails(String place_id) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?key=$kPLACES_API_KEY&placeid=${place_id}";
    var response = await http.get(Uri.parse(url));

    if (response.body.isNotEmpty) {
      return response.body;
    } else {
      return "Not found!";
    }
  }

  Future<String> getDistance(String currentAddress, String postAddress) async {
    String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$currentAddress&destinations=$postAddress&key=AIzaSyD4Z-oOz9PVUkqPRHIiWYFaXATf7ORIJzs";
    var response = await http.get(Uri.parse(url));

    if (response.body.isNotEmpty) {
      return response.body;
    } else {
      return "Not found!";
    }
  }

  @override
  Future<Map<String, Object>?> addMenuPost(
      {required String title,
      required String description,
      required String price,
      required String location,
      required String deliveryType,
      required String productStatus,
      required String image,
      required bool isVideo,
      required String uid}) async {
    try {
      var map = <String, Object>{};
      map["title"] = title;
      map["description"] = description;
      map["image"] = image;
      map["productStatus"] = productStatus;
      map["price"] = price;
      map["isVideo"] = isVideo;
      map["location"] = location;
      map["deliveryType"] = deliveryType;
      map["uid"] = uid;
      map["created_at"] = DateTime.now();
      String value = _firebaseReference.collection("Menu").doc().id;
      map["key"] = value;
      await _firebaseReference.collection("Menu").doc(value).set(map);
      return map;
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Map<String, Object>?> addRecipePost(
      {required String title,
      required String description,
      required String cuisine,
      required String category,
      required List<Map<String,dynamic>> ingredients,
      required List<Map<String, dynamic>> methods,
      required String image,
      required String productStatus,
      required bool isVideo,
      required String uid}) async {
    try {
      var map = <String, Object>{};
      map["title"] = title;
      map["description"] = description;
      map["image"] = image;
      map["cuisine"] = cuisine;
      map["isVideo"] = isVideo;
      map["category"] = category;
      map["productStatus"] = productStatus;
      map["uid"] = uid;
      map["created_at"] = DateTime.now();
      String key = _firebaseReference.collection("Recipe").doc().id;
      map["key"] = key;
      ingredients.forEach((element) async {
        if(element["key"] == null) {
          String ingreKey = _firebaseReference
              .collection("ingredients")
              .doc(key)
              .collection("list")
              .doc()
              .id;
          Map<String, dynamic> mapIng = {};
          mapIng["ingredient"] = element["ingredient"];
          mapIng["key"] = ingreKey;
          await _firebaseReference
              .collection("ingredients")
              .doc(key)
              .collection("list")
              .doc(ingreKey)
              .set(mapIng);
        }
      });

      methods.forEach((element) async {
        if(element["key"] == null) {
          String ingreKey = _firebaseReference
              .collection("Methods")
              .doc(key)
              .collection("list")
              .doc()
              .id;
          Map<String, dynamic> mapMet = {};
          mapMet["text"] = element["text"];
          mapMet["key"] = ingreKey;
          if(element['image'].toString() != '') {
            uploadImage(imageFile: File(element["image"]), name: "", uid: uid)
                .then((value) async {
              mapMet["image"] = value;
              await _firebaseReference
                  .collection("Methods")
                  .doc(key)
                  .collection("list")
                  .doc(ingreKey)
                  .set(mapMet);
            });
          }else{
            mapMet["image"] = "";
          }
        }
      });

      await _firebaseReference.collection("Recipe").doc(key).set(map);
      return map;
    } catch (_) {
      throw Exception();
    }
  }

  Future uploadVideo(File file,String name) async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + name);
      final String today = ('$month-$date');

      //final file =  await ImagePicker.pickVideo(source: ImageSource.gallery);

      Reference ref = FirebaseStorage.instance.ref().child("video").child(today).child(storageId);
      await ref.putFile(file, SettableMetadata(contentType: 'video/mp4'));
      String url = await ref.getDownloadURL();
      print('Url' + url);
      return url;
     /* UploadTask uploadTask = ref.putFile(file, SettableMetadata(contentType: 'video/mp4')); //<- this content type does the trick

    Uri downloadUrl = (await uploadTask.).downloadUrl;

    final String url = downloadUrl.toString();

    print(url);*/

    } catch (error) {
    print(error);
    }

  }

  @override
  Future<Map<String, Object>?> updateRecipePost(
      {required String key, required String uid}) async {
    try {
      var map = <String, Object>{};

      map["productStatus"] = "PUBLISH";

      await _firebaseReference.collection("Recipe").doc(key).update(map);

      return map;
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Map<String, Object>?> pauseRecipePost(
      {required String key, required String uid}) async {
    try {
      var map = <String, Object>{};

      map["productStatus"] = "UNPUBLISH";

      await _firebaseReference.collection("Recipe").doc(key).update(map);

      return map;
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Map<String, Object>?> updateRecipeDetails(
      { required String key,
        required String uid,
         String? title,
         String? description,
         String? cuisine,
         String? category,
         List<Map<String,dynamic>>? ingredients,
         List<Map<String, dynamic>>? methods,
         String? image,
         String? productStatus,
         bool? isVideo,

      }) async {
    try {
      var map = <String, Object>{};
      if(title != null) {
        map["title"] = title;
      }
      if(description != null) {
        map["description"] = description;
      }
      if(image!=null) {
        map["image"] = image;
      }
      if(cuisine != null) {
        map["cuisine"] = cuisine;
      }
      if(isVideo != null) {
        map["isVideo"] = isVideo;
      }
      if(category != null) {
        map["category"] = category;
      }
      if(productStatus != null) {
        map["productStatus"] = productStatus;
      }
      //map["uid"] = uid;
      map["created_at"] = DateTime.now();
     /* String key = _firebaseReference.collection("Recipe").doc().id;
      map["key"] = key;*/

      if(ingredients!= null) {
        ingredients.forEach((element) async {
          if(element["key"] == null) {
            String ingreKey = _firebaseReference
                .collection("ingredients")
                .doc(key)
                .collection("list")
                .doc()
                .id;
            Map<String, dynamic> mapIng = {};
            mapIng["ingredient"] = element["ingredient"];
            mapIng["key"] = ingreKey;
            await _firebaseReference
                .collection("ingredients")
                .doc(key)
                .collection("list")
                .doc(ingreKey)
                .set(mapIng);
          }

        });
      }
      if(methods != null) {
        methods.forEach((element) async {

          if(element["key"] == null) {
            String ingreKey = _firebaseReference
                .collection("Methods")
                .doc(key)
                .collection("list")
                .doc()
                .id;
            Map<String, dynamic> mapMet = {};
            mapMet["text"] = element["text"];
            mapMet["key"] = ingreKey;
            uploadImage(imageFile: File(element["image"]), name: "", uid: uid)
                .then((value) async {
              mapMet["image"] = value;
              await _firebaseReference
                  .collection("Methods")
                  .doc(key)
                  .collection("list")
                  .doc(ingreKey)
                  .set(mapMet);
            });
          }
        });

      }


      await _firebaseReference.collection("Recipe").doc(key).update(map);

      return map;
    } catch (_) {
      throw Exception();
    }
  }

  @override
  // TODO: implement getIngredients
  Stream<QuerySnapshot<Object?>?> get getIngredients => _firebaseReference
      .collection("ingredients")
      .doc(ingredientsKey)
      .collection("list")
      .snapshots();

  @override
  // TODO: implement getMethods
  Stream<QuerySnapshot<Object?>?> get getMethods => _firebaseReference
      .collection("Methods")
      .doc(methodKey)
      .collection("list")
      .snapshots();

  @override
  // TODO: implement getRecipe
  Stream<QuerySnapshot<Object?>?> get getMyPausedRecipe => _firebaseReference.collection("Recipe").where("uid", isEqualTo: recipeKey).where("productStatus", isEqualTo: "UNPUBLISH").snapshots();

  @override
  // TODO: implement getRecipe
  Stream<QuerySnapshot<Object?>?> get getMyPausedMenu => _firebaseReference.collection("Menu").where("uid", isEqualTo: menuKey).where("productStatus", isEqualTo: "UNPUBLISH").snapshots();

  @override
  // TODO: implement getRecipe
  Stream<QuerySnapshot<Object?>?> get getRelatedRecipe => _firebaseReference
      .collection("Recipe")
      .where("uid", isEqualTo: recipeKey)
      .where("productStatus", isEqualTo: "PUBLISH")
      .snapshots();

  @override
  // TODO: implement getRelatedExplore
  Stream<QuerySnapshot<Object?>?> get getRelatedExplore => _firebaseReference
      .collection("Explore")
      .where("uid", isEqualTo: exploreKey)
      .where("productStatus", isEqualTo: "PUBLISH")
      .snapshots();

  @override
  // TODO: implement getRelatedMenu
  Stream<QuerySnapshot<Object?>?> get getRelatedMenu => _firebaseReference
      .collection("Menu")
      .where("uid", isEqualTo: menuKey)
      .where("productStatus", isEqualTo: "PUBLISH")
      .snapshots();

  @override
  // TODO: implement getRelatedMenu
  Stream<QuerySnapshot<Object?>?> get getMenuByKey => FirebaseFirestore.instance
      .collection("Menu").where("key",isEqualTo: menuKey)
      .snapshots();

  @override
  Future<Map<String, Object>?> addFavorites(
      {required String ownerUID,
      required String favoritesUID,
      required String productID,
      required String postType}) async {
    try {
      var map = <String, Object>{};
      map["productOwner"] = ownerUID;
      map["favorites"] = favoritesUID;
      map["productID"] = productID;
      map["postType"] = postType;

      String key = _firebaseReference.collection("Favorite").doc().id;
      map["key"] = key;
      await _firebaseReference.collection("Favorite").doc(key).set(map);
      return map;
    } catch (_) {
      throw Exception();
    }

  }

  @override
  Future<Map<String, Object>?> disLike(
      {required String ownerUID,
        required String favoritesUID
       }) async {
    try{

      _firebaseReference.collection("Favorite").where("productOwner", isEqualTo: ownerUID).where("favorites",  isEqualTo: favoritesUID).get().then((value) {
        value.docs.forEach((doc) {
          _firebaseReference.collection("Favorite").doc(doc.id).delete().then((value) {
            return true;
          });
        });
      });

    }catch(_){

      throw Exception();
    }
    return null;
  }

  @override
  Future<Map<String, Object>?> addComment(
      {required String commentedBy,
        required String comment,
        required String productID,
        required String postType,
        required String productOwnerId}) async {
    try {
      var map = <String, Object>{};
      map["productOwner"] = productOwnerId;
      map["commentedBy"] = commentedBy;
      map["productID"] = productID;
      map["postType"] = postType;
      map["comment"] = comment;
      String key = _firebaseReference.collection("Comment").doc().id;
      map["key"] = key;
      await _firebaseReference.collection("Comment").doc(key).set(map);
      return map;
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Map<String, Object>?> addOrder(
      {required String ownerUID,
      required String userUID,
      required String productID,
      required String postType,
      required String rating}) {
    // TODO: implement addOrder
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object>?> addRatings(
      {required String ownerUID,
      required String reviewerUID,
      required String productID,
      required String postType,
      required String rating}) {
    // TODO: implement addRatings
    throw UnimplementedError();
  }

  @override
  // TODO: implement getAllRecipe
  Stream<QuerySnapshot<Object?>?> get getAllRecipe =>
      _firebaseReference.collection("Recipe").where("productStatus",isEqualTo: "PUBLISH").snapshots();
  
  @override
  // TODO: implement getAllRecipe
  Stream<QuerySnapshot<Object?>?> get getAllSearchRecipe =>
      _firebaseReference.collection("Recipe").where("productStatus",isEqualTo: "PUBLISH").where("title",isEqualTo: recipeSearchKey).snapshots();
  

  @override
  // TODO: implement getAllRecipe
  Stream<QuerySnapshot<Object?>?> get getCommentsByProductId =>
      _firebaseReference.collection("Comment").where("productID", isEqualTo: productId ).snapshots();

  @override
  // TODO: implement getMyFavorites
  Stream<QuerySnapshot<Object?>?> get getMyFavorites => _firebaseReference.collection("Favorite").where("favorites", isEqualTo: auth.FirebaseAuth.instance.currentUser?.uid ?? "").snapshots();

  @override
  // TODO: implement getMyFavorites
  Stream<QuerySnapshot<Object?>?> get getFavoritesListByKey => _firebaseReference.collection("Favorite").where("productID", isEqualTo: favoriteKey).snapshots();


  @override
  // TODO: implement getSpecificFavorite
  Stream<QuerySnapshot<Object?>?> get getSpecificFavorite => _firebaseReference.collection("Favorite").where("productID", isEqualTo: favoriteKey).where("favorites", isEqualTo: auth.FirebaseAuth.instance.currentUser?.uid ?? "").snapshots();
}
