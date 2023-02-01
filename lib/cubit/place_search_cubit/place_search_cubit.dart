import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bukateria/my_preference.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:bukateria/repository/postRepository/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'place_search_state.dart';

class PlaceSearchCubit extends Cubit<PlaceSearchState> {
  final AuthRepository _authRepository;
  final PostRepository _postRepository;

  List<dynamic> placeList= [];
  List<dynamic> result = [];


  PlaceSearchCubit(
      {required AuthRepository authRepository,
        required PostRepository postRepository})
      : _authRepository = authRepository,
        _postRepository = postRepository,
        super(PlaceSearchState.initial());


  void searchPlace(String input) async {

    emit(state.copyWith(status: PlaceSearchStatus.submitting));

    _postRepository.searchPlaces(input);

    placeList = json.decode(await _postRepository.searchPlaces(input))['predictions'];

    emit(state.copyWith(status: PlaceSearchStatus.success, placesList: placeList));
  }

  getUser(){
    return _authRepository.user;
  }
}
