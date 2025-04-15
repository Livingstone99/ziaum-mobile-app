import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:switch_app/models/transactionModel.dart';
import 'package:switch_app/services/transactionService.dart';
import 'package:switch_app/utils/utils.dart';
import 'package:switch_app/widgets/customSnackbar.dart';

import '../models/responseModel/transactionresponseModel.dart';
import '../screens/home/dateTransactionHistory.dart';
import 'authProvider.dart';

class TransactionNotifier extends StateNotifier<TransactionResponse> {
  Ref ref;

  TransactionNotifier(this.ref) : super(TransactionResponse());

  Future<void> instatiateTransaction() async {
    state = state.copyWith(loading: false);
  }

  Future<bool> createPaymentIntent(Map data) async {
    state = state.copyWith(loading: true);
    final response = await TransactionService().createPaymentIntent(data);
    state = state.copyWith(loading: false);

    if (response.statusCode == 200) {
      ref.read(stripeSecretProvider.notifier).state =
          response.data["client_secret"];
      CustomSnackbar.showSnackbar(
          title: "Progress", message: "Stripe proceess initialized");
      return true;
    } else {
      CustomSnackbar.showSnackbar(
          title: "Error", message: response.data["message"]);
    }
    return false;
  }

  Future<bool> getTransactionDetails(String transactionId) async {
    state = state.copyWith(loading: true);
    final response =
        await TransactionService().getTransactiondetails(transactionId);
    state = state.copyWith(loading: false);

    if (response.statusCode == 200) {
      print(response.data);
      TransactionModel transactionModel =
          TransactionModel.fromJson(response.data);
      ref.read(selectedTransactionProvider.notifier).state = transactionModel;
      // CustomSnackbar.showSnackbar(
      //     title: "Progress", message: "transaction detailed fetched");
      return true;
    } else {
      CustomSnackbar.showSnackbar(
          title: "Error", message: response.data["error"]);
    }
    return false;
  }

  Future checkTransactionStatus(Map data) async {
    if (data["disburse_invoice"] == "") {
      return;
    }
    state = state.copyWith(loading: true);
    final response = await TransactionService().checkTransactionStatus(data);
    state = state.copyWith(loading: false);

    if (response.statusCode == 200) {
      print(response.data);
      TransactionModel transactionModel =
          TransactionModel.fromJson(response.data["transaction_data"]);
      ref.read(selectedTransactionProvider.notifier).state = transactionModel;
      // CustomSnackbar.showSnackbar(
      //     title: "Progress", message: "transaction detailed fetched");
    } else {
      if (response.statusCode == 401 || response.statusCode == 403) {
        logoutUser();
      }
      state = state.copyWith(loading: false);
      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> confirmPayment(Map<String, dynamic> data) async {}
  Future<bool> initiateTransaction(Map data) async {
    state = state.copyWith(loading: true);
    final response = await TransactionService().initiateTransaction(data);
    state = state.copyWith(loading: false);
    if (response.statusCode == 201) {
      // final transaction = TransactionModel.fromJson(response.data);

      ref.read(transactionIdProvider.notifier).state =
          response.data["transaction_id"];
      return true;
    } else {
      print("error occured");
      print(response.data);
      CustomSnackbar.showSnackbar(title: "Error", message: "error occured");
      return false;
    }
  }

  void isLoading(bool loading) {
    state = state.copyWith(loading: loading);
  }

  Future<void> getAllTransaction() async {
    // state = state.copyWith(loading: true);
    final response = await TransactionService().getUserTransactions();
    print("transaction response");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("transaction list");

      List<TransactionModel> _transactionList = [];
      for (var item in response.data) {
        _transactionList.add(TransactionModel.fromJson(item));
      }
      print("operator length");
      print(_transactionList.length);
      ref.read(transactionListProvider.notifier).state = _transactionList;

      // state = state.copyWith(loading: false);
    } else {
      // state = state.copyWith(loading: false);
      if (response.statusCode == 401) {
        ref.read(AuthProvider.notifier).logoutUser();
        ;
      }

      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> getHomeTransaction() async {
    state = state.copyWith(loading: true);
    final response = await TransactionService().getUserHomeTransactions();
    print("transaction response");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("transaction list");

      List<TransactionModel> _transactionList = [];
      for (var item in response.data) {
        _transactionList.add(TransactionModel.fromJson(item));
      }
      print("operator length");
      print(_transactionList.length);

      ref.read(hometransactionListProvider.notifier).state = _transactionList;

      state = state.copyWith(loading: false);
    } else {
      state = state.copyWith(loading: false);
      if (response.statusCode == 401) {
        ref.read(AuthProvider.notifier).logoutUser();
        ;
      }

      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }

  Future<void> fetchByDateTransaction(Map<String, dynamic> data) async {
    state = state.copyWith(loading: true);
    final response = await TransactionService().getByDateTransactions(data);
    print("transaction response");
    print(data);
    print(response);
    if (response.statusCode == 200) {
      print("transaction list");
      List<TransactionModel> _transactionList = [];
      for (var item in response.data) {
        _transactionList.add(TransactionModel.fromJson(item));
      }
      print("operator length");
      print(_transactionList.length);

      ref.read(dateFetchtransactionListProvider.notifier).state =
          _transactionList;
      state = state.copyWith(loading: false);
      Get.to(FetchByDateTransactionHistory());
    } else {
      state = state.copyWith(loading: false);

      if (response.statusCode == 401) {
        ref.read(AuthProvider.notifier).logoutUser();
      }
      CustomSnackbar.showSnackbar(
          title: "Erreur", message: response.statusMessage, seconds: 5);
    }
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionResponse>((ref) {
  return TransactionNotifier(ref);
});

final transactionIdProvider = StateProvider<String>((ref) {
  return "";
});
final transactionDetailProvider = StateProvider<Map>((ref) {
  return {};
});
final paypalOrStripeProvider = StateProvider<String>((ref) {
  return "enable_stripe";
});
final selectedTransactionProvider = StateProvider<TransactionModel>((ref) {
  return TransactionModel();
});
final transactionListProvider = StateProvider<List<TransactionModel>>((ref) {
  return [];
});
final hometransactionListProvider =
    StateProvider<List<TransactionModel>>((ref) {
  return [];
});
final dateFetchtransactionListProvider =
    StateProvider<List<TransactionModel>>((ref) {
  return [];
});
final stripeSecretProvider = StateProvider<String>((ref) {
  return "";
});
