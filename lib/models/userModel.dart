import 'package:switch_app/models/countryModel.dart';

class UserModel {
  final String? id;
  final String? userType;
  final String? firstName;
  final String? lastName;
  final String?
      refMerchantId; // Using refMerchant's ID (if referencing other users)
  final bool? status;
  final String? gender;
  final String? image; // If image functionality is enabled
  final String? phoneNumber;
  final String? email;
  final String? homeAddress;
  final String? profession;
  final String? employee;
  final CountryModel? country; // Using country ID or country name as reference
  final bool? isStaff;
  final bool? kycVerified;
  final bool? isActive;
  final bool? isVerified;
  final String? otpField;

  UserModel({
    this.id,
    this.userType = 'unsubscriber',
    this.firstName,
    this.lastName,
    this.refMerchantId,
    this.status = false,
    this.gender,
    this.image,
    this.phoneNumber,
    this.email,
    this.homeAddress = '',
    this.profession = '',
    this.employee = '',
    this.country,
    this.isStaff = false,
    this.kycVerified = false,
    this.isActive = true,
    this.isVerified = false,
    this.otpField,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userType: json['user_type'] ?? 'unsubscriber',
      firstName: json['first_name'],
      lastName: json['last_name'],
      refMerchantId: json['refMerchant'],
      status: json['status'] ?? false,
      gender: json['gender'],
      image: json['image'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      homeAddress: json['home_address'] ?? '',
      profession: json['profession'] ?? '',
      employee: json['employee'] ?? '',
      country: (json['country'] == null)
          ? CountryModel()
          : CountryModel.fromJson(json['country']),
      isStaff: json['is_staff'] ?? false,
      kycVerified: json['kyc_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      isVerified: json['is_verified'] ?? false,
      otpField: json['otp_field'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_type': userType,
      'first_name': firstName,
      'last_name': lastName,
      'refMerchant': refMerchantId,
      'status': status,
      'gender': gender,
      'image': image,
      'phone_number': phoneNumber,
      'email': email,
      'home_address': homeAddress,
      'profession': profession,
      'employee': employee,
      'country': country,
      'is_staff': isStaff,
      'kyc_verified': kycVerified,
      'is_active': isActive,
      'is_verified': isVerified,
      'otp_field': otpField,
    };
  }
}
