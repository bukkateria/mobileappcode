part of 'place_search_cubit.dart';

enum PlaceSearchStatus { initial, submitting, success, error }

class PlaceSearchState extends Equatable {
  final String? input;
  final List<dynamic>? placesList;
  final PlaceSearchStatus status;
  PlaceSearchState({this.input, this.placesList,  required this.status});

  factory PlaceSearchState.initial() {
    return PlaceSearchState( status: PlaceSearchStatus.initial);
  }

  PlaceSearchState copyWith(
      {String? input, List<dynamic>? placesList,  PlaceSearchStatus? status}) {
    return PlaceSearchState(
        input: input ?? this.input,
        placesList: placesList ?? this.placesList,
        status: status ?? this.status);
  }


  @override
  List<Object> get props => [input ?? '', placesList ?? [],  status];
}
