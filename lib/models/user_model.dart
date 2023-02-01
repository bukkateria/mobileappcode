class UserModel {
  String? firstName;
  String? lastName;
  String? brandName;
  String? platFormName;
  String? email;
  String? pickUpAddress;
  bool? isVendor;
  String? deliveryAddress;
  String? phone;
  String? avatar;

  UserModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.pickUpAddress,
      this.isVendor = false,
      this.deliveryAddress,
      this.phone,
      this.avatar,
      this.brandName,
      this.platFormName});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json['firstName'],
        lastName: json['firstName'],
        email: json['firstName'],
        pickUpAddress: json['firstName'],
        isVendor: json['firstName'],
        deliveryAddress: json['firstName'],
        phone: json['firstName'],
        avatar: json['firstName'],
        brandName: json['firstName'],
        platFormName: json['firstName'],
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'pickUpAddress': pickUpAddress,
        'isVendor': isVendor,
        'deliveryAddress': deliveryAddress,
        'phone': phone,
        'avatar': avatar,
        'brandName': brandName,
        'platFormName': platFormName,
      };
}
