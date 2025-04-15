import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/providers/transactionProvider.dart';
import 'package:switch_app/services/shared_preference.dart';
import 'package:switch_app/utils/paymenthelper.dart';
import 'package:switch_app/utils/utils.dart';
import 'package:switch_app/widgets/amountCustomForm.dart';
import 'package:switch_app/widgets/customSnackbar.dart';
import 'package:switch_app/widgets/custombutton.dart';
import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/textWidget.dart';

class TransactionConversionScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<TransactionConversionScreen> createState() =>
      _TransactionConversionScreenState();
}

class _TransactionConversionScreenState
    extends ConsumerState<TransactionConversionScreen> {
  final TextEditingController foriegnCurrency = TextEditingController();
  final TextEditingController localCurrency = TextEditingController();
  num foriegnAmount = 0;
  num localAmount = 0;
  num foriegnBaseConversionAmount = 0;
  num localBaseConversionAmount = 0;
  num calculatedFee = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //fetch conversion rate here
      int currencyId =
          ref.read(selectedtransactionCountryProvider).currency!.id!;
      Future.wait([
        ref.read(ConfigProvider.notifier).getLatestCurrency(currencyId),
        ref
            .read(ConfigProvider.notifier)
            .getLatestConfig(ref.read(selectedCountryProvider).id!),
      ]);
    });
  }

  Future<void> confirmPayment() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      // setState(() {
      //   step = 0;
      // });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment succesfully completed'),
        ),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: ${e}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);
    final senderCountry = ref.watch(selectedCountryProvider);
    final currency = ref.watch(selectedCurrencyProvider);
    final receiverCountry = ref.watch(selectedtransactionCountryProvider);
    final transferDetailMap = ref.watch(transactionDetailProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: TextWidget(
          text: "Transfert d'argent",
          fontSize: 24,
          fontWeight: FontWeight.bold,
          // style: TextStyle(
          //   fontFamily: 'Times New Roman',
          //   fontSize: 24,
          //   fontWeight: FontWeight.bold,
          //   color: Colors.black,
          // ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAmountBox(
                      senderCountry.currency!.abbreviation!, foriegnCurrency,
                      (value) {
                    if (value.isEmpty) {
                      setState(() {
                        localCurrency.text = '';
                        foriegnAmount = 0;
                        localAmount = 0;
                        calculatedFee = 0;
                      });

                      return;
                    }

                    localCurrency.text = (double.parse(value) *
                            roundUpToTwoDecimalPlaces(double.parse(
                                currency.conversionRateToBaseCurrency!)))
                        .toString();
                    setState(() {
                      localAmount =
                          roundDownToHundred(double.parse(localCurrency.text));
                      foriegnAmount = roundUpToTwoDecimalPlaces(
                          double.parse(foriegnCurrency.text));
                      calculatedFee = roundUpToTwoDecimalPlaces(
                          double.parse(foriegnCurrency.text) *
                              (double.parse(senderCountry.fee!)) /
                              100);
                    });
                  }),
                  Icon(
                    Icons.swap_horiz,
                    color: Colors.green,
                    size: 40,
                  ),
                  _buildAmountBox(
                      receiverCountry.currency!.abbreviation!, localCurrency,
                      (value) {
                    if (value.isEmpty) {
                      setState(() {
                        foriegnCurrency.text = '';
                        foriegnAmount = 0;
                        localAmount = 0;
                        calculatedFee = 0;
                      });

                      return;
                    }

                    foriegnCurrency.text = roundUpToTwoDecimalPlaces(
                            (int.parse(value) /
                                double.parse(
                                    currency.conversionRateToBaseCurrency!)))
                        .toString();
                    setState(() {
                      localAmount =
                          roundDownToHundred(double.parse(localCurrency.text));
                      foriegnAmount = roundUpToTwoDecimalPlaces(
                          double.parse(foriegnCurrency.text));
                      calculatedFee = roundUpToTwoDecimalPlaces(
                          double.parse(foriegnCurrency.text) *
                              (double.parse(senderCountry.fee!)) /
                              100);
                    });
                  }),
                ],
              ),
              SizedBox(height: 20),
              _buildDetailRow("Taux de change",
                  "1 ${ref.read(selectedCountryProvider).currency!.abbreviation}=${currency.conversionRateToBaseCurrency} ${currency.abbreviation}"),
              _buildDetailRow("Montant du transfert",
                  "${foriegnCurrency.text} ${senderCountry.currency!.abbreviation}"),
              _buildDetailRow("Frais du transfert",
                  "${calculatedFee} ${senderCountry.currency!.abbreviation}"),
              _buildDetailRow("Total à payer",
                  "${((foriegnAmount + calculatedFee) * 100).ceil() / 100} ${senderCountry.currency!.abbreviation}"),

              _MobileMoneyWidget(context,
                  title: "Benifiary operator",
                  subject: ref.read(selectedOperatorProvider).name!,
                  assets: ref.read(selectedOperatorProvider).icon),
              _MobileMoneyWidget(context,
                  title: "Benifiary number",
                  subject: ref
                          .read(selectedtransactionCountryProvider)
                          .countryCode! +
                      " " +
                      transferDetailMap["beneficiary_number"],
                  country: true,
                  assets: ref.read(selectedtransactionCountryProvider).image),
              _buildDetailRow("Le bénéficiaire reçoit",
                  "${localAmount} ${receiverCountry.currency!.abbreviation}",
                  isBold: true),
              // Spacer(),
              transactionState.loading
                  ? Center(child: CustomLoadingWidget())
                  : CustomButton(
                      buttonText: "Continue",
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        if (foriegnAmount == 0) {
                          CustomSnackbar.showSnackbar(
                              title: "Erreur",
                              message: "Enter a valide amount",
                              seconds: 3);
                          return;
                        }
                        if (foriegnAmount <
                            ref
                                .read(selectedCountryProvider)
                                .minTransactionAmount!) {
                          CustomSnackbar.showSnackbar(
                              title: "Erreur",
                              message:
                                  "Amount is less than the minimum transaction amount ${ref.read(selectedCountryProvider).minTransactionAmount!}",
                              seconds: 3);
                          return;
                        }
                        if (foriegnAmount >
                            ref
                                .read(selectedCountryProvider)
                                .maxTransactionAmount!) {
                          CustomSnackbar.showSnackbar(
                              title: "Erreur",
                              message:
                                  "Amount is greater than the maximum transaction amount ${ref.read(selectedCountryProvider).maxTransactionAmount!}",
                              seconds: 3);
                          return;
                        }

                        // Initialize transaction data
                        Map paypaldata = {
                          "amount":
                              ((foriegnAmount + calculatedFee) * 100).ceil() /
                                  100,
                          "received_amount": localAmount,

                          "currency": receiverCountry.currency!.abbreviation,
                          "statement": "this is for payment",
                          // "transaction_id": ref.read(transactionIdProvider),
                          "card_status": "pending",
                          // "reference_id": ref.read(transactionIdProvider),
                          "base_rate_snapshot":
                              currency.conversionRateToBaseCurrency,
                          "total_fee": calculatedFee,
                          "userId": Preference().userId,
                          "transaction_type":
                              (ref.read(paypalOrStripeProvider) ==
                                      "enable_stripe")
                                  ? "stripe_credit"
                                  : "paypal_credit"
                        };
                        Map stripedata = {
                          "amount":
                              ((foriegnAmount + calculatedFee) * 100).ceil() /
                                  100 *
                                  100,
                          "received_amount": localAmount,
                          "currency": receiverCountry.currency!.abbreviation,
                          "statement": "this is for payment",
                          // "transaction_id": ref.read(transactionIdProvider),
                          "card_status": "pending",
                          // "reference_id": ref.read(transactionIdProvider),
                          "base_rate_snapshot":
                              currency.conversionRateToBaseCurrency,
                          "total_fee": calculatedFee,

                          "userId": Preference().userId,
                          "transaction_type":
                              (ref.read(paypalOrStripeProvider) ==
                                      "enable_stripe")
                                  ? "stripe_credit"
                                  : "paypal_credit"
                        };

                        // try {
                        // Step 1: Initiate the transaction
                        // PaymentHelper().

                        // Merge transactionDetailMap into paypalData and stripeData
                        paypaldata.addAll(ref.read(transactionDetailProvider));
                        stripedata.addAll(ref.read(transactionDetailProvider));
                        bool isInitiated = await ref
                            .read(transactionProvider.notifier)
                            .initiateTransaction(paypaldata);

                        if (isInitiated) {
                          print(("initialization was successful"));
                          // Update payment ID with transaction ID

                          paypaldata.addAll({
                            "transaction_id": ref.read(transactionIdProvider),
                            "reference_id": ref.read(transactionIdProvider),
                          });
                          stripedata.addAll({
                            "transaction_id": ref.read(transactionIdProvider),
                            "reference_id": ref.read(transactionIdProvider),
                          });
                          // Step 2: Create the Payment Intent
                          if (ref.read(paypalOrStripeProvider) ==
                              "enable_paypal") {
                            PaymentHelper.checkoutWithPayPal(
                                context: context,
                                amount: paypaldata["amount"],
                                transactionId: paypaldata["transaction_id"],
                                onSuccessCallback: (Map data) {
                                  print("paypal callback on success");
                                  print(data);
                                });
                            return;
                          }
                          if (ref.read(paypalOrStripeProvider) ==
                              "enable_stripe") {
                            print("stripe data");
                            print(stripedata);

                            bool paymentIntentCreated = await ref
                                .read(transactionProvider.notifier)
                                .createPaymentIntent(stripedata);

                            if (paymentIntentCreated) {
                              print("payment intent was created successfully");
                              // Step 3: Process Payment
                              await PaymentHelper().makePayment(ref, context);
                            } else {
                              // Handle error in creating payment intent
                              CustomSnackbar.showSnackbar(
                                  title: "error",
                                  message: "Failed to create payment intent");
                            }
                          }
                        } else {
                          // Handle error in initiating transaction
                          CustomSnackbar.showSnackbar(
                              title: "Error",
                              message: "Failed to initiate transaction");
                        }
                        // } catch (e) {
                        //   // Catch unexpected errors and log them
                        //   print("Error: $e");
                        //   CustomSnackbar.showSnackbar(
                        //       title: "Error",
                        //       message: "An unexpected error occurred");
                        // }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountBox(String currency, TextEditingController controller,
      void Function(String) onChange) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currency,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: AmountCustomTextField(
                controller: controller,
                textInputType: TextInputType.number,
                autoFocus: true,
                onChange: onChange,
              )),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: title,
          ),
          TextWidget(
            text: value,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}

Widget _MobileMoneyWidget(BuildContext context,
    {String? title, String? assets, String? subject, bool country = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        TextWidget(
          text: title,
          textColor: greyColor,
          // fontSize: 13,
        ),
        Spacer(),
        Container(
            height: country ? 20 : 40,
            width: country ? 20 : 40,
            decoration: BoxDecoration(
              color: Color.fromARGB(105, 221, 221, 221),
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.fill,
                // opacity: 0.4,
                image: CachedNetworkImageProvider(assets!),
              ),
            )),
        SizedBox(
          width: 10,
        ),
        TextWidget(
          text: subject,
          fontSize: country ? 15 : 16,
          // letterspacing: 2,
        ),
        // Icon(
        //   FontAwesomeIcons.chevronDown,
        //   size: 20,
        // )
      ],
    ),
  );
}
