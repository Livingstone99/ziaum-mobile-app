import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switch_app/providers/configProvider.dart';

import '../providers/authProvider.dart';
import '../providers/transactionProvider.dart';
import 'textWidget.dart';

// Define a StateProvider to manage the selected payment method

class PaymentSelectionWidget extends ConsumerWidget {
  const PaymentSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usermodel = ref.watch(userModelProvider); // Watch user model
    final selectedPaymentMethod = ref.watch(paypalOrStripeProvider);
    final countryModel = ref.watch(selectedCountryProvider);
    final selectedPaymentMethodNotifier =
        ref.read(paypalOrStripeProvider.notifier);

    // Logic for determining which options to show
    final showAll = countryModel.enableStripe! && countryModel.enablePaypal!;
    final disableAll =
        !countryModel.enableStripe! && !countryModel.enablePaypal!;
    final showPayPal =
        countryModel.enablePaypal! && !countryModel.enableStripe!;
    final showStripe =
        countryModel.enableStripe! && !countryModel.enablePaypal!;
    final disableSelection = !showAll;

    return Container(
      child: disableAll
          ? TextWidget(
              text: "Both Stripe and Paypal is not enabled",
              textColor: Colors.red,
            )
          : showAll
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'enable_stripe',
                          groupValue: selectedPaymentMethod,
                          onChanged: disableSelection
                              ? null
                              : (String? value) {
                                  selectedPaymentMethodNotifier.state = value!;
                                },
                        ),
                        const TextWidget(text: 'Stripe'),
                      ],
                    ),
                    const SizedBox(width: 20), // Space between radio buttons
                    Row(
                      children: [
                        Radio<String>(
                          value: 'enable_paypal',
                          groupValue: selectedPaymentMethod,
                          onChanged: disableSelection
                              ? null
                              : (String? value) {
                                  selectedPaymentMethodNotifier.state = value!;
                                },
                        ),
                        const TextWidget(text: 'PayPal'),
                      ],
                    ),
                  ],
                )
              : showPayPal
                  ? Row(
                      children: [
                        Radio<String>(
                          value: 'PayPal',
                          groupValue: selectedPaymentMethod,
                          onChanged: disableSelection
                              ? null
                              : (String? value) {
                                  selectedPaymentMethodNotifier.state = value!;
                                },
                        ),
                        const TextWidget(text: 'PayPal'),
                      ],
                    )
                  : Row(
                      children: [
                        Radio<String>(
                          value: 'Stripe',
                          groupValue: selectedPaymentMethod,
                          onChanged: disableSelection
                              ? null
                              : (String? value) {
                                  selectedPaymentMethodNotifier.state = value!;
                                },
                        ),
                        const TextWidget(text: 'Stripe'),
                      ],
                    ),
    );
  }
}
