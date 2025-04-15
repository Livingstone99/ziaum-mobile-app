import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/screens/auth/changePasswordScreen.dart';
import 'package:switch_app/services/shared_preference.dart';

import '../../widgets/textWidget.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(userModelProvider);
    return Scaffold(
      floatingActionButton: IconButton(
          onPressed: () async {
            await Intercom.instance
                .loginIdentifiedUser(email: Preference().email);
            Intercom.instance.displayMessenger();
          },
          icon: Icon(
            Icons.support_agent_outlined,
            size: 50,
          )),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: dark,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
              text: "Mon Profil",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              textColor: primaryColor,
            ),

            _profileCard(context,
                header: "Nom",
                content: userProvider.firstName.toString().capitalizeFirst),
            _profileCard(context,
                header: "Prenom",
                content: userProvider.lastName.toString().capitalizeFirst),
            _profileCard(context,
                header: "Numero", content: userProvider.phoneNumber),
            Row(
              children: [
                TextWidget(
                  text: "Payes",
                ),
                Spacer(),
                // Container(
                //   // padding: const EdgeInsets.only(right: 8),
                //   height: 40,
                //   width: 40,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.rectangle,
                //     image: DecorationImage(
                //       image: CachedNetworkImageProvider(
                //         ref.read(selectedCountryProvider).image!,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: 10,
                ),
                TextWidget(
                  text: ref.read(selectedCountryProvider).countryName,
                )
              ],
            ),
            // _profileCard(context,
            //     header: "Pays", content: countryProvider.name),
            const Divider(
              color: greyColorReg2,
            ),
            TextWidget(
              text: "Paramétres",
              fontSize: 22,
            ),
            SizedBox(
              height: 30,
            ),
            TextWidget(
              text: "Remplissez correctement les informations du bénéficiaire.",
              fontSize: 15,
            ),
            SizedBox(
              height: 20,
            ),
            // _detailCard(context,
            //     iconData: Icons.lock_outline,
            //     title: "Mot de passe",
            //     subTitle: "********"),
            // SizedBox(
            //   height: 30,
            // ),
            // _detailCard(context,
            //     iconData: Icons.pin_outlined,
            //     title: "Pin de retrait",
            //     subTitle: ""),
            // SizedBox(
            //   height: 20,
            // ),
            // SizedBox(
            //   height: 0,
            // ),
            _detailCard(context,
                iconData: Icons.password, title: "Mot de passe", onTap: () {
              Get.to(ChangePasswordScreen());
            }, subTitle: "changez votre mot de passe"),
            SizedBox(
              height: 20,
            ),
            _detailCard(
              context,
              iconData: Icons.exit_to_app,
              title: "Log out",
              subTitle: "se déconnecter de toutes les sessions",
              editable: false,
              onTap: () {
                ref.read(AuthProvider.notifier).logoutUser();
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _detailCard(BuildContext context,
    {IconData? iconData,
    String? title,
    String? subTitle,
    bool noSubtitle = false,
    bool editable = true,
    Function()? onTap}) {
  return GestureDetector(
    onTap: onTap ?? () {}, // Pass the onTap function to GestureDetector
    child: Container(
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(color: ash, shape: BoxShape.circle),
            child: Icon(iconData),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                text: title ?? '', // Use a standard Text widget
                // style: TextStyle(fontSize: 16), // Add your desired text style
              ),
              Visibility(
                  visible: !noSubtitle,
                  maintainAnimation: false,
                  maintainSize: false,
                  maintainState: false,
                  child: TextWidget(
                    text: subTitle ?? '',
                    fontSize: 12, // Add your desired text style
                  )),
            ],
          ),
          Spacer(),
          editable ? Icon(Icons.edit_outlined) : Container()
        ],
      ),
    ),
  );
}

Widget _profileCard(
  BuildContext context, {
  String? header,
  String? content,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        TextWidget(
          text: header,
          fontSize: 17,
        ),
        Spacer(),
        TextWidget(
          text: content,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ],
    ),
  );
}
