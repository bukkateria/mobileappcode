import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  Stream<DocumentSnapshot?> get specificUser;
  Stream<DocumentSnapshot?> get userDetails;
  Stream<QuerySnapshot?> get getSpecificFollower;
  Stream<QuerySnapshot?> get getAllFollower;
  Future<auth.User?> signup({required String email, required String password});
  Future<auth.User?> signin({required String email, required String password});
  Future<bool?> updatePassword({required String password});
  Future<Map<String,Object>?> submitUser({required String email,required String username,required String userType,required String uid});
  Future<Map<String,Object>?> updateUser({String? email, String? userType, String? image, String? name,String? password, required String uid});
  Future<Map<String,Object>?> followUser({
    required String followedUID,
    required String followingUID
  });
  Future<bool?> unFollowUser({
    required String followedUID,
    required String followingUID
  });
}
