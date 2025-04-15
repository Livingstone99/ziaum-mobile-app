import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define an enum to represent payment options
enum PaymentOption { paypal, stripe }

// Riverpod provider to hold the selected payment option state
final selectedPaymentProvider = StateProvider<PaymentOption?>((ref) => null);

class PaymentSelectionRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the currently selected payment option
    final selectedPayment = ref.watch(selectedPaymentProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPaymentOption(
          context,
          ref,
          PaymentOption.paypal,
          'assets/png/paypal_logo.png', // Replace with your PayPal image path
          selectedPayment == PaymentOption.paypal,
        ),
        const SizedBox(width: 20),
        _buildPaymentOption(
          context,
          ref,
          PaymentOption.stripe,
          'assets/png/stripe_logo.png', // Replace with your Stripe image path
          selectedPayment == PaymentOption.stripe,
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    WidgetRef ref,
    PaymentOption option,
    String imagePath,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        // Update the selected payment option on tap
        ref.read(selectedPaymentProvider.notifier).state = option;
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.6, // Dim unselected images
          child: Image.asset(
            imagePath,
            width: 80,
            height: 80,
          ),
        ),
      ),
    );
  }
}
