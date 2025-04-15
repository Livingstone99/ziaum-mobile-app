import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/services/shared_preference.dart';
import 'package:switch_app/widgets/accountCreationCountryDropdown.dart';
import 'package:switch_app/widgets/customSnackbar.dart';
import 'package:switch_app/widgets/custom_textfield.dart';
import 'package:switch_app/widgets/custombutton.dart';
import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/textWidget.dart';


class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  String? _selectedGender;
  final TextEditingController emailController =
      TextEditingController(text: Preference().email);
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController proffesionController = TextEditingController();
  final TextEditingController merchantCodeController =
      TextEditingController(text: "");
  final TextEditingController employeeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String? firstNameError;
  String? lastNameError;
  String? numberError;
  String? cityError;
  String? postalCodeError;
  String? addressError;
  String? proffesionError;
  String? employeeError;

  bool _isGenderSelected = true; // Tracks whether a selection has been mad
  @override
  void initState() {
    Preference().emailVerified
        ? emailController.text = Preference().email
        : emailController.text = "";
    super.initState();
  }

  void _validateForm() {
    setState(() {
      // Reset errors
      firstNameError = null;
      lastNameError = null;
      numberError = null;
      cityError = null;
      postalCodeError = null;
      addressError = null;
      proffesionError = null;
      employeeError = null;

      // Validate first name
      if (firstNameController.text.isEmpty) {
        firstNameError = "Le nom est obligatoire";
      }

      // Validate last name
      if (lastNameController.text.isEmpty) {
        lastNameError = "Le prenom est obligatoire";
      } // Validate last name
      if (phoneNumberController.text.isEmpty) {
        numberError = "Le numero est obligatoire";
      }
      if (cityController.text.isEmpty) {
        cityError = "Le city est obligatoire";
      }
      if (postalCodeController.text.isEmpty) {
        postalCodeError = "Le postal code est obligatoire";
      }
      if (addressController.text.isEmpty) {
        addressError = "L'address est obligatoire";
      }
      if (proffesionController.text.isEmpty) {
        proffesionError = "Le proffesion est obligatoire";
      }
      if (employeeController.text.isEmpty) {
        employeeError = "L'employee est obligatoire";
      }

      _isGenderSelected =
          _selectedGender != null; // Check if a gender is selected

      if (_isGenderSelected) {
        // Proceed with form submission
        print("Selected Gender: $_selectedGender");
      } else {
        // Show error message
        print("Please select a gender");
      }
      // If no errors, proceed with form submission
      if (firstNameError == null && lastNameError == null) {
        // Submit the form
        print("Form submitted successfully");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(AuthProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: dark,
        //   ),
        // ),
        // backgroundColor: bgColor,
      ),
      // backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: "Commençons votre inscription",
              fontSize: 21,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(
              height: 20,
            ),
            TextWidget(
              text:
                  "Remplissez correctement les champs ci-dessous ${Preference().email}",
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            SizedBox(
              height: 20,
            ),
            // CustomTextField(
            //   labelText: "Pays de résidence",
            //   hintText: "Selectionner votre pays",
            //   enableForm: false,
            //   suffixIcon: Icon(Icons.arrow_drop_down_circle_outlined),
            //   // hintText: ".......",
            // ),

            CustomTextField(
              labelText: "Nom",
              hintText: "Traore",
              errorText: firstNameError,
              controller: firstNameController,
              textInputType: TextInputType.name,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              labelText: "prenom",
              hintText: "Abdoulaye",
              errorText: lastNameError,
              controller: lastNameController,
              textInputType: TextInputType.name,

              // hintText: ".......",
            ),

            Row(
              children: [
                Radio<String>(
                  value: 'M',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                      _isGenderSelected = true;
                    });
                  },
                ),
                TextWidget(text: 'Homme'),
                Radio<String>(
                  value: 'F',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                      _isGenderSelected = true;
                    });
                  },
                ),
                TextWidget(text: 'Femme'),
              ],
            ),
            if (!_isGenderSelected) // Show error message if no selection is made
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextWidget(
                  text: "Please select a gender",
                  fontSize: 12,
                  textColor: Color.fromARGB(255, 172, 17, 6),
                ),
              ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              labelText: "Email",
              hintText: "Ecrire ici",
              controller: emailController,
              enableForm: false,
            ),
            SizedBox(height: 24),
            AccountCreationCountryDropDown(
                items: ref
                    .read(allCountryListProvider)
                    .where((country) => country.countryType == "diaspora")
                    .toList(),
                onSelected: (String country) {}),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              labelText: "Ville",
              hintText: "Ecrire ici",
              controller: cityController,
              errorText: cityError,
              textInputType: TextInputType.name,
            ),
            SizedBox(height: 24),

            CustomTextField(
              labelText: "Rue et numero",
              hintText: "Ecrire ici",
              controller: addressController,
              textInputType: TextInputType.name,
              errorText: addressError,
            ),
            SizedBox(height: 24),
            CustomTextField(
              labelText: "Code postal",
              hintText: "Ecrire ici",
              controller: postalCodeController,
              errorText: postalCodeError,
              textInputType: TextInputType.name,
            ),
            SizedBox(height: 24),

            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: GestureDetector(
                    // onTap: () {
                    //   CustomBottomSheet().selectCountryBottomSheet(context);
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
                                      .watch(selectedCountryProvider)
                                      .image!),
                                ),
                              ),
                            ),
                          ),
                          TextWidget(
                            text:
                                ref.watch(selectedCountryProvider).countryCode!,
                          )
                        ],
                      ),

                      enableForm: false,
                      // suffixIcon: Icon(Icons.arrow_drop_down_circle_outlined),
                      // hintText: ".......",
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: CustomTextField(
                    labelText: "Numero de telephone",
                    textInputType: TextInputType.number,
                    controller: phoneNumberController,
                    errorText: numberError,
                    onChange: (value) {
                      // if (ref.read(selectedCountryProvider).phoneNumberLimit ==
                      //     null) {
                      //   CustomSnackbar.showSnackbar(
                      //       title: "Erreur",
                      //       message:
                      //           "Confirm a country before entering a number");
                      //   phoneNumberController.text = "";
                      //   return;
                      // }
                    },
                    maxLimit:
                        ref.watch(selectedCountryProvider).phoneNumberLimit ??
                            10,
                  ),
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: CustomTextField(
                    labelText: "Profession",
                    hintText: "Ecrire ici",
                    controller: proffesionController,
                    errorText: proffesionError,
                    // hintText: ".......",
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: CustomTextField(
                    labelText: "Employeur",
                    hintText: "Ecrire ici",
                    controller: employeeController,
                    errorText: employeeError,
                    // hintText: ".......",
                  ),
                ),
              ],
            ),
            CustomTextField(
              labelText: "Code marchand",
              hintText: "Ecrire ici",
              controller: merchantCodeController,
              textInputType: TextInputType.text,
            ),
            SizedBox(
              height: 10,
            ),

            SizedBox(
              height: 100,
            ),
            authProvider.loading
                ? Center(
                    child: CustomLoadingWidget(),
                  )
                : CustomButton(
                    buttonText: "Continuer",
                    onTap: () async {
                      _validateForm();

                      if (firstNameController.text.trim().isEmpty ||
                          lastNameController.text.trim().isEmpty ||
                          phoneNumberController.text.trim().isEmpty ||
                          proffesionController.text.trim().isEmpty ||
                          employeeController.text.trim().isEmpty ||
                          postalCodeController.text.trim().isEmpty ||
                          cityController.text.trim().isEmpty ||
                          employeeController.text.trim().isEmpty ||
                          !_isGenderSelected ||
                          ref.read(selectedCountryProvider).id == "" ||
                          addressController.text.trim().isEmpty) {
                        CustomSnackbar.showSnackbar(
                            title: "erreur", message: "Provide all details");
                      }

                      Map data = {
                        "first_name": firstNameController.text,
                        "last_name": lastNameController.text,
                        "email": emailController.text,

                        // "password": passwordController.text,
                        "phone_number": phoneNumberController.text,
                        "gender": _selectedGender,
                        // "employee": employeeController.text,
                        "user_type": "unsubscriber",
                        "country": ref.read(selectedCountryProvider).id,
                        "city": cityController.text,
                        "address": addressController.text,
                        "profession": proffesionController.text,
                        "employee": employeeController.text,
                        "postal_code": postalCodeController.text,
                        "sign_info_submitted": true,
                        "merchant_code": merchantCodeController.text,
                        // "password": "password"
                        ...ref.read(beforeAccountData)
                      };
                      // ref.read(createAccountData.notifier).state = data;

                      //       Map data = ref.read(createAccountData);
                      // data.addAll({"password": passwordController.text});
                      await ref.read(AuthProvider.notifier).createAccount(data);
                    },
                  ),
            // Spacer()
          ],
        ),
      ),
    );
  }
}
