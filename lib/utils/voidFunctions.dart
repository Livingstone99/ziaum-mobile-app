import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../widgets/textWidget.dart';

void showAlertDialog(
    {String? title,
    String? message,
    bool continueBtnActive = true,
    String closeBtnText = "Ferme",
    String continueBtnText = "Continuer",
    bool hideCloseBtn = false,
    bool hideContinueBtn = false,
    void Function()? onTapClose,
    void Function()? onTapContinue}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          TextWidget(
            text: title,
          ),
          const Divider()
        ],
      ),
      content: TextWidget(
        text: message,
      ),
      actions: [
        hideCloseBtn
            ? Container()
            : TextButton(
                onPressed: onTapClose,
                style: TextButton.styleFrom(
                  backgroundColor: continueBtnActive ? bgColor : primaryColor,
                  // onPrimary: Colors.white,
                  shadowColor: greyColor,
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                child: TextWidget(
                  text: closeBtnText,
                  textColor: continueBtnActive ? Colors.black : bgColor,
                ),
              ),
        hideContinueBtn
            ? Container()
            : TextButton(
                onPressed: onTapContinue,
                style: TextButton.styleFrom(
                  backgroundColor: continueBtnActive ? primaryColor : bgColor,
                  // onPrimary: Colors.white,
                  shadowColor: greyColor,
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                child: TextWidget(
                  text: continueBtnText,
                  textColor: continueBtnActive ? bgColor : Colors.black,
                ),
              ),
      ],
    ),
  );
}

extension capitalization on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

void allcountryDropDown(BuildContext context) {
  showCountryPicker(
    context: context,
    //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
    exclude: <String>['KN', 'MF'],
    favorite: <String>['SE'],
    //Optional. Shows phone code before the country name.
    showPhoneCode: true,
    onSelect: (Country country) {
      print('Select country: ${country.displayName}');
    },
    // // Optional. Sheet moves when keyboard opens.
    // moveAlongWithKeyboard: false,
    // Optional. Sets the theme for the country list picker.
    countryListTheme: CountryListThemeData(
      // Optional. Sets the border radius for the bottomsheet.
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.0),
        topRight: Radius.circular(40.0),
      ),
      // Optional. Styles the search field.
      inputDecoration: InputDecoration(
        labelText: 'Search',
        hintText: 'Start typing to search',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF8C98A8).withOpacity(0.2),
          ),
        ),
      ),
      // Optional. Styles the text in the search field
      searchTextStyle: TextStyle(
        color: Colors.blue,
        fontSize: 18,
      ),
    ),
  );
}
