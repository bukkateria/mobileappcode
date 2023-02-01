import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BasePostRepository {
/*  Stream<auth.User?> get user;
  Future<auth.User?> signup({required String email, required String password});
  Future<auth.User?> signin({required String email, required String password});
  Future<Map<String,Object>?> submitUser({required String email,required String userType,required String uid});
  Future<Map<String,Object>?> updateUser({String? email, String? userType,required String uid});*/
  Stream<QuerySnapshot?> get getExplores;
  Stream<QuerySnapshot?> get getMenus;
  Stream<QuerySnapshot?> get getAllRecipe;
  Stream<QuerySnapshot?> get getRelatedRecipe;
  Stream<QuerySnapshot?> get getRelatedMenu;
  Stream<QuerySnapshot?> get getRelatedExplore;
  Stream<QuerySnapshot?> get getIngredients;
  Stream<QuerySnapshot?> get getMethods;
  Stream<QuerySnapshot?> get getSpecificFavorite;
  Stream<QuerySnapshot?> get getMyFavorites;
  Stream<QuerySnapshot?> get getFavoritesListByKey;
  Future<String?> uploadImage({required File imageFile, required String name,required String uid});
  Future<Map<String,Object>?> addExplorePost({required String title,required String description,required String productStatus,required String image,required bool isVideo,required String uid});
  Future<Map<String,Object>?> addMenuPost({required String title,required String description,required String price, required String location , required String deliveryType,required bool isVideo, required String productStatus,required String image,required String uid});
  Future<Map<String,Object>?> addRecipePost({
    required String title,
    required String description,
    required String cuisine,
    required String category ,
    required bool isVideo,
    required List<Map<String,dynamic>> ingredients,
    required List<Map<String,dynamic>> methods,
    required String image,
    required String productStatus,
    required String uid,
  });
  Future<Map<String,Object>?> addFavorites({
    required String ownerUID,
    required String favoritesUID,
    required String productID,
    required String postType,
  });

  Future<Map<String,Object>?> addRatings({
    required String ownerUID,
    required String reviewerUID,
    required String productID,
    required String postType,
    required String rating,
  });

  Future<Map<String,Object>?> addOrder({
    required String ownerUID,
    required String userUID,
    required String productID,
    required String postType,
    required String rating,
  });

  Future<Map<String,Object>?> updateExplorePost({required String key,required String uid});
  Future<Map<String,Object>?> updateMenuPost({required String key,required String uid});
  Future<Map<String,Object>?> updateRecipePost({required String key,required String uid});
}
