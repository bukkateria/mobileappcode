part of 'account_cubit.dart';

enum AccountStatus { initial, submitting,contactSubmitting, updateSubmitting, contactError, updateError, success, contactSuccess, updateSuccess, error, missingField }

class AccountState extends Equatable {
  final String? email;
  final String? password;
  final String? image;
  final String? userType;
  final String? name;
  final String? phone;
  final String? address;
  final AccountStatus? status;
   AccountState(
      { this.email, this.password, this.status,this.phone, this.address, this.image, this.name,this.userType});

  factory AccountState.initial() {
    return AccountState(email: '', password: '', image: '', phone: '', address: '', name: '', userType: '', status: AccountStatus.initial);
  }

  AccountState copyWith(
      {String? email, String? password,String? image, String? name,String? phone, String? address,String? userType, AccountStatus? status}) {
    return AccountState(
        email: email ?? this.email,
        password: password ?? this.password,
        image: image ?? this.image,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        userType: userType ?? this.userType,
        status: status ?? this.status);
  }



  @override
  List<Object> get props => [email ?? "", password ?? "",phone ?? "", address ?? "",name ?? "", image ?? "",userType ?? "", status ?? ""];
}
