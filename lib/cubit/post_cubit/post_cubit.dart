import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:bukateria/repository/postRepository/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final AuthRepository _authRepository;
  final PostRepository _postRepository;

  PostCubit(
      {required AuthRepository authRepository,
      required PostRepository postRepository})
      : _authRepository = authRepository,
        _postRepository = postRepository,
        super(PostState.initial());

  void titleChanged(String value) {
    emit(state.copyWith(title: value, status: PostStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value, status: PostStatus.initial));
  }

  void typeOfCuisineChanged(String value) {
    emit(state.copyWith(typeOfCuisine: value, status: PostStatus.initial));
  }

  void recipeCategoryChanged(String value) {
    emit(state.copyWith(recipeCategory: value, status: PostStatus.initial));
  }

  void priceChanged(String value) {
    emit(state.copyWith(price: value, status: PostStatus.initial));
  }

  void locationChanged(String value) {
    emit(state.copyWith(location: value, status: PostStatus.initial));
  }

  void delvieryTypeChanged(String value) {
    emit(state.copyWith(deliveryType: value, status: PostStatus.initial));
  }

  void productStatusChanged(String value) {
    emit(state.copyWith(productStatus: value, status: PostStatus.initial));
  }

  void imageChanged(File value) {
    emit(state.copyWith(image: value, status: PostStatus.initial));
  }

  void ingredientsChanged(List<Map<String, dynamic>> value) {
    emit(state.copyWith(ingredients: value, status: PostStatus.initial));
  }

  void methodsChanged(List<Map<String, dynamic>> value) {
    emit(state.copyWith(methods: value, status: PostStatus.initial));
  }

  void PostWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: PostStatus.submitting));
    /* try {
      await _authRepository.post(email: state.email, password: state.password);
      emit(state.copyWith(status: PostStatus.success));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }*/
  }

  deleteExplore(String key){
    emit(PostState(status: PostStatus.deleting));
    _postRepository.deleteExplore(key).then((value) {
      emit(PostState(status: PostStatus.deleted));
    });
  }

  deleteMenu(String key){
    emit(PostState(status: PostStatus.deleting));
    _postRepository.deleteMenu(key).then((value) {
      emit(PostState(status: PostStatus.deleted));
    });
  }
  deleteRecipe(String key){
    emit(PostState(status: PostStatus.deleting));
    _postRepository.deleteRecipe(key).then((value) {
      emit(PostState(status: PostStatus.deleted));
    });
  }

 Future<bool> deleteIngredient(String key,String parentKey) async {
    emit(PostState(status: PostStatus.deleting));
    bool v = await _postRepository.deleteIngredient(parentKey,key) ?? false;
   return v;
  }

  Future<bool> deleteMethod(String key,String parentKey) async {
    emit(PostState(status: PostStatus.deleting));
    bool v = await _postRepository.deleteMethod(parentKey,key) ?? false;
    return v;
  }

  void postExploreCredentials(
      String imageName, String uid, bool isVideo) async {
    if (!state.isValidExplore) return;
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      if (isVideo) {
        _postRepository
            .uploadVideo(state.image!, imageName)
            .then((value) async {
          print("--------------- ${value} ----------");
          _postRepository
              .addExplorePost(
                  title: state.title ?? "",
                  description: state.description ?? "",
                  productStatus: state.productStatus ?? "init",
                  image: value ?? "",
                  isVideo: isVideo,
                  uid: uid)
              .then((value) {
            emit(state.copyWith(
                status: PostStatus.save, key: value?["key"].toString()));
          });
        });
      } else {
        _postRepository
            .uploadImage(imageFile: state.image!, name: imageName, uid: uid)
            .then((value) async {
          print("--------------- ${value} ----------");
          _postRepository
              .addExplorePost(
                  title: state.title ?? "",
                  description: state.description ?? "",
                  productStatus: state.productStatus ?? "init",
                  image: value ?? "",
                  isVideo: isVideo,
                  uid: uid)
              .then((value) {
            emit(state.copyWith(
                status: PostStatus.save, key: value?["key"].toString()));
          });
        });
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void updateExploreStatus(
    String key,
    String uid,
  ) async {
    if (!state.isValidExplore) return;
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      _postRepository.updateExplorePost(key: key, uid: uid).then((value) {
        emit(state.copyWith(status: PostStatus.publish));
      });
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void pauseExploreStatus(
      String key,
      String uid,
      ) async {

    emit(state.copyWith(status: PostStatus.submitting));
    try {
      _postRepository.pauseExplorePost(key: key, uid: uid).then((value) {
        emit(state.copyWith(status: PostStatus.unPublish));
      });
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void pauseMenuStatus(
      String key,
      String uid,
      ) async {

    emit(state.copyWith(status: PostStatus.pausing));
    try {
      print("-----------------------${key} ${uid}");
      _postRepository.pauseMenuPost(key: key, uid: uid).then((value) {
        emit(state.copyWith(status: PostStatus.unPublish, productStatus: "Menu"));
      });
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }
//8017
  void pauseRecipeStatus(
      String key,
      String uid,
      ) async {
    emit(state.copyWith(status: PostStatus.pausing));
    try {
      _postRepository.pauseRecipePost(key: key, uid: uid).then((value) {
        emit(state.copyWith(status: PostStatus.unPublish,productStatus: "Recipe"));
      });
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  getPauseMenus(String uid) {
    _postRepository.menuKey = uid;
    return _postRepository.getMyPausedMenu;
  }

  getPauseRecipes(String uid) {
    _postRepository.recipeKey = uid;
    return _postRepository.getMyPausedRecipe;
  }

  getExplore() {
    return _postRepository.getExplores;
  }

  getMenus(String searchKey) {

    /*if(searchKey.isNotEmpty) {
      _postRepository.menuSearchKey = searchKey;
      return _postRepository.getSearchMenus;
    }else{*/
      return _postRepository.getMenus;
    //}
  }

  getRecipes() {
    return _postRepository.getAllRecipe;
  }

  getAllRecipes(String searchKey) {

    if(searchKey.isNotEmpty){
      _postRepository.recipeKey= searchKey;
      return _postRepository.getAllSearchRecipe;
    }else {
      return _postRepository.getAllRecipe;
    }
  }

  getRelatedRecipes(String uid) {
    _postRepository.recipeKey = uid;
    return _postRepository.getRelatedRecipe;
  }

  getRelatedMenus(String uid) {
    _postRepository.menuKey = uid;
    return _postRepository.getRelatedMenu;
  }

  getMenuByKey(String key) {
    _postRepository.menuKey = key;
    return _postRepository.getMenuByKey;
  }

  getRelatedExplore(String uid) {
    _postRepository.exploreKey = uid;
    return _postRepository.getRelatedExplore;
  }

  getComments(String productId) {
    _postRepository.productId = productId;
    return _postRepository.getCommentsByProductId;
  }

  getUser() {
    return _authRepository.user;
  }

  getSpecificUser(String uid) {
    _authRepository.uid = uid;
    return _authRepository.specificUser;
  }

  getIngredients(String key) {
    _postRepository.ingredientsKey = key;
    return _postRepository.getIngredients;
  }

  getMethods(String key) {
    _postRepository.methodKey = key;
    return _postRepository.getMethods;
  }

  getSpecificFollow(String followedUID, String followingUID) {
    _authRepository.followedUID = followedUID;
    _authRepository.followingUID = followingUID;
    print("-------------------$followingUID   $followedUID");
    return _authRepository.getSpecificFollower;
  }

  getAllFollowers(String followedUID) {
    _authRepository.followedUID = followedUID;
    return _authRepository.getAllFollower;
  }

  getSpecificFavorite(String productID) {
    _postRepository.favoriteKey = productID;
    return _postRepository.getSpecificFavorite;
  }

  getMyFavorites() {
    return _postRepository.getMyFavorites;
  }

  getFavoritesListByKey(String key) {
    _postRepository.favoriteKey = key;
    return _postRepository.getFavoritesListByKey;
  }

  void postMenuCredentials(String imageName, String uid, bool isVideo) async {
    if (!state.isValidExplore) return;
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      if (isVideo) {
        _postRepository
            .uploadVideo(state.image!, imageName)
            .then((value) async {
          _postRepository
              .addMenuPost(
                  title: state.title ?? "",
                  description: state.description ?? "",
                  productStatus: state.productStatus ?? "init",
                  image: value ?? "",
                  price: state.price ?? "",
                  location: state.location ?? "",
                  deliveryType: state.deliveryType ?? "",
                  isVideo: isVideo,
                  uid: uid)
              .then((value) {
            emit(state.copyWith(
                status: PostStatus.save, key: value?["key"].toString()));
          });
        });
      } else {
        _postRepository
            .uploadImage(imageFile: state.image!, name: imageName, uid: uid)
            .then((value) async {
          print("--------------- ${value} ----------");
          _postRepository
              .addMenuPost(
                  title: state.title ?? "",
                  description: state.description ?? "",
                  productStatus: state.productStatus ?? "init",
                  image: value ?? "",
                  price: state.price ?? "",
                  location: state.location ?? "",
                  deliveryType: state.deliveryType ?? "",
                  isVideo: isVideo,
                  uid: uid)
              .then((value) {
            emit(state.copyWith(
                status: PostStatus.save, key: value?["key"].toString()));
          });
        });
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void updateMenuDetails(
      String key,
      String uid,
      bool isVideo,
      ) async {
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      if(state.image != null){
        if (isVideo) {
          _postRepository
              .uploadVideo(state.image!, "")
              .then((value) async {
            _postRepository
                .updateMenuDetails(
                title: state.title ,
                description: state.description,
                image: value ,
                price: state.price,
                location: state.location,
                deliveryType: state.deliveryType,
                isVideo: isVideo,
                key: key,
                uid: uid)
                .then((value) {
              emit(state.copyWith(
                  status: PostStatus.updated));
            });
          });
        } else {
          _postRepository
              .uploadImage(imageFile: state.image!, name: "", uid: uid)
              .then((value) async {
            print("--------------- ${value} ----------");
            _postRepository
                .updateMenuDetails(
                title: state.title ,
                description: state.description,
                image: value ,
                price: state.price,
                location: state.location,
                deliveryType: state.deliveryType,
                isVideo: isVideo,
                key: key,
                uid: uid)
                .then((value) {
              emit(state.copyWith(
                  status: PostStatus.updated));
            });
          });
        }
      }else{
        _postRepository
            .updateMenuDetails(
            title: state.title ,
            description: state.description,
            price: state.price,
            location: state.location,
            deliveryType: state.deliveryType,
            isVideo: isVideo,
            key: key,
            uid: uid)
            .then((value) {
          emit(state.copyWith(
              status: PostStatus.updated));
        });
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void updateMenuStatus(
    String key,
    String uid,
  ) async {
   // if (!state.isValidExplore) return;
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      _postRepository.updateMenuPost(key: key, uid: uid).then((value) {
        emit(state.copyWith(status: PostStatus.publish));
      });
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void postRecipeCredentials(String imageName, String uid, bool isVideo) async {
    if (!state.isValidExplore) return;
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      if (isVideo) {
        _postRepository
            .uploadVideo(state.image!, imageName)
            .then((value) async {
          _postRepository
              .addRecipePost(
                  title: state.title ?? "",
                  description: state.description ?? "",
                  productStatus: state.productStatus ?? "init",
                  image: value ?? "",
                  category: state.recipeCategory ?? "",
                  ingredients: state.ingredients ?? [],
                  methods: state.methods ?? [],
                  cuisine: state.typeOfCuisine ?? "",
                  isVideo: isVideo,
                  uid: uid)
              .then((value) {
            emit(state.copyWith(
                status: PostStatus.save, key: value?["key"].toString()));
          });
        });
      } else {
        _postRepository
            .uploadImage(imageFile: state.image!, name: imageName, uid: uid)
            .then((value) async {
          print("--------------- ${value} ----------");
          _postRepository
              .addRecipePost(
                  title: state.title ?? "",
                  description: state.description ?? "",
                  productStatus: state.productStatus ?? "init",
                  image: value ?? "",
                  category: state.recipeCategory ?? "",
                  ingredients: state.ingredients ?? [],
                  methods: state.methods ?? [],
                  cuisine: state.typeOfCuisine ?? "",
                  isVideo: isVideo,
                  uid: uid)
              .then((value) {
            emit(state.copyWith(
                status: PostStatus.save, key: value?["key"].toString()));
          });
        });
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void updateRecipeCredentials(
      String imageName, String key, String uid, bool isVideo) async {
   // if (!state.isValidExplore) return;
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      if(state.image == null){
        _postRepository
            .updateRecipeDetails(
            key: key,
            title: state.title,
            description: state.description ?? "",
            category: state.recipeCategory ?? "",
            ingredients: state.ingredients ?? [],
            methods: state.methods ?? [],
            cuisine: state.typeOfCuisine ?? "",
            isVideo: isVideo,
            uid: uid)
            .then((value) {
          emit(state.copyWith(status: PostStatus.updated));
        });
      }else {
        if (isVideo) {
          _postRepository
              .uploadVideo(state.image!, imageName)
              .then((value) async {
            _postRepository
                .updateRecipeDetails(
                key: key,
                title: state.title,
                description: state.description,
                image: value,
                category: state.recipeCategory,
                ingredients: state.ingredients,
                methods: state.methods,
                cuisine: state.typeOfCuisine,
                isVideo: isVideo,
                uid: uid)
                .then((value) {
              emit(state.copyWith(status: PostStatus.updated));
            });
          });
        }
        else {
          _postRepository
              .uploadImage(imageFile: state.image!, name: imageName, uid: uid)
              .then((value) async {
            print("--------------- ${value} ----------");
            _postRepository
                .updateRecipeDetails(
                key: key,
                title: state.title,
                description: state.description,
                productStatus: state.productStatus,
                image: value,
                category: state.recipeCategory,
                ingredients: state.ingredients,
                methods: state.methods,
                cuisine: state.typeOfCuisine,
                isVideo: isVideo,
                uid: uid)
                .then((value) {
              emit(state.copyWith(status: PostStatus.updated));
            });
          });
        }
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void updateRecipeStatus(
    String key,
    String uid,
  ) async {
   // if (!state.isValidExplore) return;
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      _postRepository.updateRecipePost(key: key, uid: uid).then((value) {
        emit(state.copyWith(status: PostStatus.publish));
      });
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void reportUser(String reportedUser, String reportedBy, String reason,postId) async {
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      if (reportedBy != reportedUser) {
        _authRepository
            .reportUser(reportedUser: reportedUser, reportedBy: reportedBy,reason: reason, postId:  postId)
            .then((value) {
          emit(state.copyWith(
              status: PostStatus.reported, productStatus: "Reported", key: value?["key"].toString()));
        });
      } else {
        emit(state.copyWith(status: PostStatus.error));
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void addFollow(String followedUID, String followingUID) async {
   // emit(state.copyWith(status: PostStatus.submitting));
    try {
      if (followedUID != followingUID) {
        _authRepository
            .followUser(followedUID: followedUID, followingUID: followingUID)
            .then((value) {
          emit(state.copyWith(
              status: PostStatus.success, key: value?["key"].toString()));
        });
      } else {
        emit(state.copyWith(status: PostStatus.error));
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void unFollow(String followedUID, String followingUID) async {
    emit(state.copyWith(status: PostStatus.submitting));

    try {
      if (followedUID != followingUID) {
        await _authRepository
            .unFollowUser(followedUID: followedUID, followingUID: followingUID)
            .then((value) {
          emit(state.copyWith(
            status: PostStatus.success,
          ));
        });
      } else {
        emit(state.copyWith(status: PostStatus.error));
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void addComment(String productId, String commentedBy, String comment,
      String productOwner, postType) async {
    //emit(state.copyWith(status: PostStatus.submitting));
    try {
      _postRepository
          .addComment(
              productID: productId,
              comment: comment,
              productOwnerId: productOwner,
              postType: postType,
              commentedBy: commentedBy)
          .then((value) {
        emit(state.copyWith(
            status: PostStatus.success, key: value?["key"].toString()));
      });
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  Future<void> getCurrentPosition() async {
    var position = await _authRepository.determinePosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    //print(placemarks);
    if(placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      // String address =  '${place.locality}, ${place.administrativeArea}, ${place.country}';
      String address =
          '${place.subAdministrativeArea}, ${place.administrativeArea}';
      Map<String, dynamic> map = {};
      map["lat"] = position.latitude;
      map["long"] = position.longitude;
      map["address"] = address;
      emit(
          state.copyWith(
              status: PostStatus.locationFound, currentLocation: map));
    }
  }

  void addFavorite(String ownerUID, String favoritesUID, String productID,
      String postType) async {
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      _postRepository
          .addFavorites(
              ownerUID: ownerUID,
              favoritesUID: favoritesUID,
              productID: productID,
              postType: postType)
          .then((value) {
        emit(state.copyWith(
            status: PostStatus.success, key: value?["key"].toString()));
      });
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void removeFavorite(String ownerUID, String favoritesUID, String productID,
      String postType) async {
    emit(state.copyWith(status: PostStatus.submitting));
    try {
      _postRepository
          .disLike(
              ownerUID: ownerUID,
              favoritesUID: favoritesUID,
              /*productID: productID,
              postType: postType*/)
          .then((value) {
        emit(state.copyWith(
            status: PostStatus.success, key: value?["key"].toString()));
      });
    } catch (_) {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  Future<Map<String, dynamic>> getDistance(String currentAddress, String postAddress) async {
    String distance = await _postRepository.getDistance(currentAddress, postAddress);
    Map<String,dynamic> map = jsonDecode(distance);
    return map;
  }

/*  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    String address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

  }*/
}
