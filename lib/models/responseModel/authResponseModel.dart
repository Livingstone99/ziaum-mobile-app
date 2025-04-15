


import '../userModel.dart';

class AuthResponse {
  late bool loading;
  late List<UserModel>? merchants;
  // late List<CategoryModel>? merchantCategory;

  late bool showDialog;
  late bool otpsent;

  AuthResponse(
      {this.loading = false,
      this.showDialog = false,
      this.otpsent = false,
      this.merchants,
      // this.merchantCategory
      });
  AuthResponse.fromJson(Map<String, dynamic> json) {
    loading = json['loading'];
    showDialog = json['show_dialog'] ?? false;
  }
  AuthResponse copyWith({
    bool? loading,
    List<UserModel>? merchants,
    // List<CategoryModel>? merchantCategory,
    bool? showDialog,
    bool? otpsent,
  }) {
    return AuthResponse(
      merchants: merchants ?? this.merchants,
      // merchantCategory: merchantCategory ?? this.merchantCategory,
      loading: loading ?? this.loading,
      showDialog: showDialog ?? this.showDialog,
      otpsent: otpsent ?? this.otpsent,
    );
  }
}
