import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:switch_app/screens/home/homeScreen.dart';
import 'package:switch_app/widgets/textWidget.dart';

import '../providers/transactionProvider.dart';
import 'functionalComponent.dart';

class PaymentHelper {
  // Set clientId and secretKey as static variables
  static String clientId = dotenv.env["CLIENT_ID"]!;
  static String secretKey = dotenv.env["CLIENT_SECRET"]!;

  static void checkoutWithPayPal({
    required BuildContext context,
    required double amount,
    required String transactionId,
    required Function(Map<String, dynamic>)
        onSuccessCallback, // Custom callback for successful transactions
  }) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId: clientId,
        secretKey: secretKey,
        transactions: [
          {
            "amount": {
              "total": amount.toStringAsFixed(2),
              "currency": "USD",
              "details": {
                "subtotal": amount.toStringAsFixed(2),
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "Payment for user id.",
            "transactionId": {"transaction_id": transactionId}
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map<String, dynamic> params) async {
          log("Transaction successful: $params");
          onSuccessCallback(params); // Call the custom success callback
          Navigator.pop(context);
        },
        onError: (error) {
          log("Error during transaction: $error");
          Navigator.pop(context);
        },
        onCancel: () {
          print('Transaction cancelled.');
          Navigator.pop(context);
        },
      ),
    ));
  }

  Future<void> makePayment(
    WidgetRef ref,
    BuildContext context,
  ) async {
    try {
      //STEP 1: Create Payment Intent
      //  String paymentIntent = await createPaymentIntent('100', 'USD');
      //print(555555555);
      if (ref.read(stripeSecretProvider).isEmpty) {
        warnCustomScaffoldMessenger(context,
            text: "payment initialization failed try again ");
      }
      //print(888888888888);

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: ref
                      .read(stripeSecretProvider), //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Ikay'))
          .then((value) {
        //STEP 3: Display Payment sheet
        displayPaymentSheet(context, ref);
      });
    } catch (err) {
      print(err);
      throw Exception(err);
    }
  }

  displayPaymentSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    //print("this is order id from  provider ${ref.read(orderIdProvider)}");
    FocusScope.of(context).unfocus();
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        ref.read(transactionProvider.notifier).isLoading(true);

        await ref.read(transactionProvider.notifier).confirmPayment({
          "order_id": ref.read(transactionIdProvider),
          "payment_intent": ref.read(stripeSecretProvider)
        }).then((value) {
          ref.read(transactionProvider.notifier).isLoading(false);
          Get.offAll(HomeScreen());
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (_) => const ViewAllOrderScreen()),
          //     (route) => false);
          // ref.read(CartItemsProvider.notifier).clearCart();

          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 100.0,
                        ),
                        SizedBox(height: 10.0),
                        TextWidget(text: "Payment Successful!"),
                      ],
                    ),
                  ));
        });

        // ref.read(stripeSecretProvider.notifier).state = "";
      }).onError((error, stackTrace) {
        print("this is error $error");
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                TextWidget(text: "Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      //print('$e');
    }
  }
}
