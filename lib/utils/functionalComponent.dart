import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:switch_app/widgets/textWidget.dart';

import '../constants/colors.dart';

void warnCustomScaffoldMessenger(BuildContext context,
    {String? text, int second = 2}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      text!,
      style: GoogleFonts.nunito(
        textStyle: Theme.of(context).textTheme.headlineLarge,
        fontSize: 16,
        color: dark,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    ),
    backgroundColor: Color.fromARGB(255, 200, 206, 242),
    dismissDirection: DismissDirection.horizontal,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    duration: Duration(seconds: second),
  ));
}

// Future bottomSheet(
//   BuildContext context, {
//   String? text,
//   String? btnText,
//   void Function()? onTap,
// }) {
//   return showMaterialModalBottomSheet(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(50.0),
//       ),
//       bounce: true,
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, setState) {
//             return Container(
//               padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20))),
//               height: MediaQuery.of(context).size.height * 0.65,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 7,
//                     width: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.blueGrey,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   const Text("Vous avez oublié votre code secret?",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       )),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   const Text(
//                       "Appelez le support FocusPay pour réinitialiser le code secret.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w300,
//                         color: Colors.black,
//                       )),
//                   const SizedBox(
//                     height: 60,
//                   ),
//                   CustomTextField(
//                     onTap: () {
//                       final Uri callLaunchUri = Uri(
//                           scheme: 'tel', path: '+22654500000'

//                           // queryParameters: <String, String>{
//                           //   'body': Uri.encodeComponent(
//                           //       'Example Subject & Symbols are allowed!'),
//                           // },
//                           );
//                       launchUrl(callLaunchUri);
//                     },
//                   )
//                 ],
//               ),
//             );
//           },
//         );
//       });
// }

showDialogAlert(BuildContext context,
    {String? message,
    String? title,
    String closeText = "close",
    String continueText = "ok",
    bool hideContinueBtn = false,
    final void Function()? closeOnTap,
    final void Function()? onTap}) {
  // set up the buttons

  Widget cancelButton = TextButton(
    onPressed: closeOnTap ??
        () {
          Navigator.of(context).pop();
        },
    child: TextWidget(text: closeText, textColor: Colors.grey),
  );
  Widget continueButton = TextButton(
      onPressed: onTap ??
          () {
            Navigator.of(context).pop();
          },
      child: TextWidget(text: continueText));
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          text: title!,
          fontSize: 20,
          textColor: primaryColor,
          fontWeight: FontWeight.w600,
        )
      ],
    ),
    content: TextWidget(
      text: message!,
      textAlign: TextAlign.center,
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    actions: hideContinueBtn ? [cancelButton] : [cancelButton, continueButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return alert;
    },
  );
}
