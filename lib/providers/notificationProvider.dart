
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:switch_app/models/notifcationModel.dart';
import 'package:switch_app/services/notificationService.dart';

import '../models/responseModel/authResponseModel.dart';

import '../widgets/customSnackbar.dart';
import 'authProvider.dart';

class NotificationNotifier extends StateNotifier<AuthResponse> {
  Ref ref;
  NotificationNotifier(this.ref) : super(AuthResponse());

  void instantiateAuth() {
    state = state.copyWith(
      // merchantCategory: [],
      loading: false,
    );
  }

  Future<void> getAllNotification() async {
    state = state.copyWith(loading: true);
    final response = await NotificationService().getAllNotifcation();
    if (response.statusCode == 200) {
      print(response);

      List<NotificationModel> _notificationList = [];
      for (var item in response.data) {
        _notificationList.add(NotificationModel.fromJson(item));
      }
      print("operator length");
      print(_notificationList.length);
      ref.read(notificationListProvider.notifier).state = _notificationList;
      state = state.copyWith(loading: false);
    } else {
      if (response.statusCode == 401) {
             ref.read(AuthProvider.notifier).logoutUser();

      }
      state = state.copyWith(loading: false);
      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }
}

final NotificationProvider =
    StateNotifierProvider<NotificationNotifier, AuthResponse>((ref) {
  return NotificationNotifier(ref);
});

final notificationListProvider = StateProvider<List<NotificationModel>>((ref) {
  return [];
});
final selectedNotificationProvider = StateProvider<NotificationModel>((ref) {
  return NotificationModel();
});
