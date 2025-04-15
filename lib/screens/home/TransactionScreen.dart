import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/models/countryModel.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/providers/transactionProvider.dart';
import 'package:switch_app/screens/home/transactionConversionScreen.dart';
import 'package:switch_app/services/shared_preference.dart';
import 'package:switch_app/utils/utils.dart';
import 'package:switch_app/widgets/customSnackbar.dart';
import 'package:switch_app/widgets/custombutton.dart';

import '../../widgets/customBottomSheet.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/textWidget.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool unavailability = true;
  String? numberError;
  String? nameError;
  bool operatorNotSelected = false;

  void setPaypalOrStripe() {
    CountryModel countryModel = ref.read(selectedCountryProvider);

    bool isPaypalEnabled = countryModel.enablePaypal ?? false;
    bool isStripeEnabled = countryModel.enableStripe ?? false;

    String? state;
    if (isPaypalEnabled && isStripeEnabled) {
      state = ""; // Both enabled
      unavailability = false;
    } else if (isPaypalEnabled) {
      state = "enable_paypal"; // Only PayPal enabled
      unavailability = false;
    } else if (isStripeEnabled) {
      state = "enable_stripe"; // Only Stripe enabled
      unavailability = false;
    } else {
      unavailability = true; // Neither enabled
    }

    setState(() {}); // Update UI
    ref.read(paypalOrStripeProvider.notifier).state = state ?? "";
  }

  @override
  void initState() {
    print("token token");
    print(Preference().token);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //fetch conversion rate here
      int currencyId =
          ref.read(selectedtransactionCountryProvider).currency!.id!;
      Future.wait([
        ref.read(ConfigProvider.notifier).getLatestCurrency(currencyId),
        ref
            .read(ConfigProvider.notifier)
            .getLatestConfig(ref.read(selectedCountryProvider).id!),
      ]).then((value) => setPaypalOrStripe());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedContactProv = ref.watch(selectedContactProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: dark,
            )),
        elevation: 0,
        backgroundColor: bgColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                    text: "Transfert d'argent",
                    fontSize: 25,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _countryDropDown(context,
                  title: "pays d'origine",
                  countryName: ref.read(selectedCountryProvider).countryName,
                  assets: ref.read(selectedCountryProvider).image),
              _countryDropDown(context,
                  title: "pays de destination",
                  countryName:
                      ref.read(selectedtransactionCountryProvider).countryName,
                  assets: ref.read(selectedtransactionCountryProvider).image),
              // PaymentSelectionRow(),
              // PaymentSelectionWidget(),
              _selectPlatform(
                context,
                title: "Mobile money",
              ),
              (ref.read(selectedtransactionCountryProvider).operators!.isEmpty)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextWidget(
                        text: "no service available ",
                      ),
                    )
                  : Wrap(
                      spacing: 40,
                      runSpacing: 20,
                      // alignment: WrapAlignment.center,
                      // runAlignment: WrapAlignment.center,
                      children: [
                        ...ref
                            .read(selectedtransactionCountryProvider)
                            .operators!
                            .map(
                              (e) =>
                                  _networkCard(context, ref, operatorModel: e),
                            ),
                      ],
                    ),
              Divider(
                color: operatorNotSelected
                    ? Colors.red
                    : const Color.fromARGB(255, 208, 207, 207),
              ),
              operatorNotSelected
                  ? TextWidget(
                      text: "Select an operator",
                      textAlign: TextAlign.left,
                      textColor: Colors.red,
                      fontSize: 10,
                    )
                  : SizedBox(),
              SizedBox(
                height: 20,
              ),

              _selectPlatform2(context, title: "Envoyer à"),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                labelText: "Benefiary name",
                hintText: " ",
                controller: nameController,
                errorText: nameError,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: GestureDetector(
                      // onTap: () {
                      //   CustomBottomSheet().selectCountryBottomSheet(context,
                      //       daispora: "non_diaspora");
                      // },
                      child: CustomTextField(
                        prefixIcon: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                // padding: const EdgeInsets.only(right: 8),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(ref
                                        .watch(
                                            selectedtransactionCountryProvider)
                                        .image!),
                                  ),
                                ),
                              ),
                            ),
                            TextWidget(
                              text: ref
                                  .watch(selectedtransactionCountryProvider)
                                  .countryCode!,
                              letterspacing: 2,
                              fontWeight: FontWeight.w500,
                              // fontSize: 12,
                            )
                          ],
                        ),

                        enableForm: false,
                        // suffixIcon: Icon(Icons.arrow_drop_down_circle_outlined),
                        // hintText: ".......",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: CustomTextField(
                      labelText: "Numero de telephone",
                      textInputType: TextInputType.number,
                      controller: phoneNumberController,
                      errorText: numberError,
                      space: false,
                      letterspacing: 2,
                      maxLimit: ref
                          .watch(selectedtransactionCountryProvider)
                          .phoneNumberLimit!,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.contacts_outlined,
                      size: 30,
                    ),
                    onPressed: () {
                      if (ref.read(selectedOperatorProvider).name == null) {
                        CustomSnackbar.showSnackbar(
                            title: "Sélection manquante",
                            message:
                                "choisissez un réseau avant de sélectionner un contact");
                        return;
                      }
                      ref
                          .read(filteredContactsProvider.notifier)
                          .resetContacts();
                      CustomBottomSheet().getContacts(context, ref);
                    },
                  )
                ],
              ),

              // _selectPlatform(
              //   context,
              //   title: "Virement bancaire",
              // ),
              // Spacer(),
              SizedBox(
                height: 30,
              ),
              CustomButton(
                buttonText: "Continuer",
                onTap: () {
                  setState(() {
                    numberError = null;
                    nameError = null;
                    operatorNotSelected = false;
                  });
                  if (ref.read(selectedOperatorProvider).name == null) {
                    setState(() {
                      operatorNotSelected = true;
                    });
                    CustomSnackbar.showSnackbar(
                        title: "ERREUR", message: "Sélectionnez un opérateur");
                    return;
                  } else if (nameController.text.trim().isEmpty) {
                    setState(() {
                      nameError =
                          "Veuillez entrer votre nom et prénom pour continuer";
                    });

                    CustomSnackbar.showSnackbar(
                        title: "ERREUR",
                        message: "Fournir un nom de bénéficiaire");
                    return;
                  } else if (phoneNumberController.text.isEmpty) {
                    setState(() {
                      numberError = "Veuillez entrer un numéro";
                    });

                    CustomSnackbar.showSnackbar(
                        title: "ERREUR", message: "Veuillez entrer un numéro");

                    return;
                  } else if (!isValidCountryPrefixNumber(
                      phoneNumberController.text,
                      ref
                          .read(selectedtransactionCountryProvider)
                          .numberPrefixes!)) {
                    setState(() {
                      numberError = "Veuillez entrer un numéro valide";
                    });
                    CustomSnackbar.showSnackbar(
                        title: "ERREUR",
                        message: "Veuillez entrer un numéro valide");
                    return;
                  } else {
                    FocusScope.of(context).unfocus();
                    if (unavailability) {
                      CustomSnackbar.showSnackbar(
                        title: "ERREUR",
                        message: "Stripe et Paypal ne sont pas disponibles",
                      );
                      return;
                    }
                    Map data = {
                      "beneficiary_name": nameController.text.trim(),
                      "beneficiary_number": phoneNumberController.text,
                      "receiver_country":
                          ref.read(selectedtransactionCountryProvider).id,
                      "mobile_money_operator":
                          ref.read(selectedOperatorProvider).id
                    };
                    ref.read(transactionDetailProvider.notifier).state = data;
                    Get.to(TransactionConversionScreen());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _countryDropDown(
  BuildContext context, {
  String? title,
  String? assets,
  String? countryName,
  int type = 1,
}) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: iconBtnColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          (type == 1)
              ? Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(105, 221, 221, 221),
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      // opacity: 0.4,
                      image: CachedNetworkImageProvider(assets!),
                    ),
                  ))
              : SizedBox(),
          SizedBox(
            width: 10,
          ),
          (type == 1)
              ? TextWidget(
                  text: countryName,
                  fontSize: 16,
                )
              : SizedBox(),
          Spacer(
            flex: 1,
          ),
          TextWidget(
            text: title,
            textColor: (type == 1) ? greyColor : dark,
            fontSize: 13,
          ),
          Spacer(),
          // Icon(
          //   FontAwesomeIcons.chevronDown,
          //   size: 20,
          // )
        ],
      ),
    ),
  );
}

Widget _selectPlatform(
  BuildContext context, {
  String? title,
}) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: iconBtnColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          TextWidget(
            text: title,
            textColor: dark,
            fontSize: 16,
          ),
          Spacer(),
          Icon(
            FontAwesomeIcons.chevronDown,
            size: 20,
          )
        ],
      ),
    ),
  );
}

Widget _selectPlatform2(
  BuildContext context, {
  String? title,
}) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: iconBtnColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          TextWidget(
            text: title,
            textColor: dark,
            fontSize: 16,
          ),
        ],
      ),
    ),
  );
}

Widget _networkCard(BuildContext context, WidgetRef ref,
    {OperatorModel? operatorModel}) {
  bool selected = ref.watch(selectedOperatorProvider) == operatorModel;
  return GestureDetector(
    onTap: () {
      ref.read(selectedOperatorProvider.notifier).state = operatorModel;
      // Get.to(TransactionConversionScreen());
    },
    child: Container(
        // height: 87,
        width: 111,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              color: selected ? Colors.blue : Colors.transparent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // padding: const EdgeInsets.only(right: 8),
              height: 85,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    operatorModel!.icon!,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextWidget(
              text: operatorModel.name,
              fontSize: 12,
            )
          ],
        )),
  );
}
