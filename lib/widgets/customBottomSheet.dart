import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:switch_app/models/selectedContactModel.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/utils/utils.dart';
import 'package:switch_app/widgets/countryCard.dart';
import 'package:switch_app/widgets/customSnackbar.dart';

import '../constants/colors.dart';
import '../providers/transactionProvider.dart';
import '../screens/home/transactionConversionScreen.dart';
import 'textWidget.dart';

class CustomBottomSheet {
  void selectCountryBottomSheet(BuildContext context,
      {String daispora = "diaspora"}) {
    showMaterialModalBottomSheet(
        isDismissible: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Consumer(builder: (context, ref, _) {
              return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView.builder(
                    itemCount: ref
                        .read(allCountryListProvider)
                        .where((element) => element.countryType == daispora)
                        .length,
                    itemBuilder: (context, index) {
                      final country = ref
                          .read(allCountryListProvider)
                          .where((element) => element.countryType == daispora)
                          .elementAt(index);

                      return bottomCountry(ref, country, diaspora: daispora);
                    },
                  ));
            });
          });
        });
  }

  void getContacts(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    onChanged: (query) => ref
                        .read(filteredContactsProvider.notifier)
                        .filterContacts(query),
                    decoration: InputDecoration(
                      hintText: 'Search contacts...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Contact List
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final filteredContacts =
                            ref.watch(filteredContactsProvider);
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: filteredContacts.length,
                          itemBuilder: (context, index) {
                            Contact contact = filteredContacts[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: TextWidget(
                                  text: contact.displayName != null
                                      ? contact.displayName[0].toUpperCase()
                                      : "?",
                                  // style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: TextWidget(
                                  text: contact.displayName ?? "Unknown"),
                              subtitle: TextWidget(
                                text: contact.phones.isNotEmpty
                                    ? contact.phones.first.number
                                    : "No number",
                                textColor: Colors.grey.shade600,
                              ),
                              onTap: () {
                                print(contact.phones.first.number);
                                print(ref
                                    .read(selectedtransactionCountryProvider)
                                    .countryCode!);
                                print(cleanPhoneNumber(
                                    contact.phones.first.number,
                                    defaultCountryCode: ref
                                        .read(
                                            selectedtransactionCountryProvider)
                                        .countryCode!));
                                if (!isValidCountryPrefixNumber(
                                    cleanPhoneNumber(
                                        contact.phones.first.number,
                                        defaultCountryCode: ref
                                            .read(
                                                selectedtransactionCountryProvider)
                                            .countryCode!),
                                    ref
                                        .read(
                                            selectedtransactionCountryProvider)
                                        .numberPrefixes!)) {
                                  CustomSnackbar.showSnackbar(
                                      title: "Erreur",
                                      message:
                                          "le numéro de contact sélectionné n'est pas valide");
                                  return;
                                }
                                if (validatePhoneNumber(
                                    cleanPhoneNumber(
                                        contact.phones.first.number,
                                        defaultCountryCode: ref
                                            .read(
                                                selectedtransactionCountryProvider)
                                            .countryCode!),
                                    expectedLength: ref
                                        .read(
                                            selectedtransactionCountryProvider)
                                        .phoneNumberLimit!)) {
                                  ref
                                          .read(selectedContactProvider.notifier)
                                          .state =
                                      SelectedContactModel(
                                          name:
                                              contact.displayName.toUpperCase(),
                                          phoneNumber:
                                              contact.phones.first.number);
                                  Map data = {
                                    "beneficiary_name": contact.displayName,
                                    "beneficiary_number": cleanPhoneNumber(
                                        contact.phones.first.number,
                                        defaultCountryCode: ref
                                            .read(
                                                selectedtransactionCountryProvider)
                                            .countryCode!),
                                    "receiver_country": ref
                                        .read(
                                            selectedtransactionCountryProvider)
                                        .id,
                                    "mobile_money_operator":
                                        ref.read(selectedOperatorProvider).id
                                  };
                                  ref
                                      .read(transactionDetailProvider.notifier)
                                      .state = data;
                                  Get.to(TransactionConversionScreen());
                                } else {
                                  CustomSnackbar.showSnackbar(
                                      title: "Erreur",
                                      message:
                                          "Le numéro de téléphone n'est pas valide");
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
