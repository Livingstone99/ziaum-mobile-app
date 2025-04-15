import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/providers/kycprovider.dart';
import 'package:switch_app/screens/auth/waitingScreen.dart';
import 'package:switch_app/widgets/checkBoxWIdget.dart';
import 'package:switch_app/widgets/customSnackbar.dart';
import 'package:switch_app/widgets/custombutton.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/widgets/customDropDownMenu.dart';
import 'package:switch_app/widgets/imageSourceDialog.dart';
import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/textWidget.dart';

class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen> {
  bool newsLetterChecked = false;
  bool termsChecked = false;
  bool selectedDoc = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceDialog(String key) async {
    await showDialog(
      context: context,
      builder: (context) => ImageSourceDialog(
        onImageSourceSelected: (ImageSource source) {
          _pickImage(source, key);
        },
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, String key) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      if (key == "front") {
        ref.read(selectedDocFrontProvider.notifier).state = pickedFile.path;
      } else if (key == "back") {
        ref.read(selectedDocBackProvider.notifier).state = pickedFile.path;
      } else if (key == "residence") {
        ref.read(selectedResidenceDocProvider.notifier).state = pickedFile.path;
      }
    } else {
      print("_pickImage coundnt find a key");
    }
  }

  @override
  Widget build(BuildContext context) {
    final selctedDocumentprov = ref.watch(selectedDocProvider);
    final selectedDocumentFrontprov = ref.watch(selectedDocFrontProvider);
    final selectedDocumentBackprov = ref.watch(selectedDocBackProvider);
    final selectedResidenceDocprov = ref.watch(selectedResidenceDocProvider);
    bool requiresBackView = selctedDocumentprov != "" &&
        selctedDocumentprov !=
            "Passport"; // Only Passport doesn't require back view
    final authProvider = ref.watch(AuthProvider);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
                text: "Continuons votre inscription",
                fontSize: 21,
                fontWeight: FontWeight.w400),
            SizedBox(height: 20),
            TextWidget(
                text: "Remplissez correctement les champs ci-dessous",
                fontSize: 13,
                fontWeight: FontWeight.w300),
            SizedBox(height: 20),
            CustomDropdownMenu(
              header: "Type de piéce",
              subheader: "Sélectionner un type de pièce",
              items: [
                'Permis de séjour Suisse',
                "Carte d'identité Européenne",
                "Permis de conduite Européen",
                'Passport'
              ],
              onSelected: (selectedItem) {
                setState(() {
                  selectedDoc = true;
                 
                });
                ref.read(selectedDocProvider.notifier).state = selectedItem;
                ref.read(selectedDocFrontProvider.notifier).state = "";
                ref.read(selectedDocBackProvider.notifier).state = "";
                ref.read(selectedResidenceDocProvider.notifier).state = "";
              },


              








            ),
            SizedBox(height: 20),
            selectedDoc
                ? Column(
                    children: [
                      _uploadWidget(
                          context, "front", "Pièce d’identité (recto)"),
                      if (requiresBackView)
                        _uploadWidget(
                            context, "back", "Pièce d’identité (verso)"),
                      _uploadWidget(
                          context, "residence", "Justificatif de résidence"),
                    ],
                  )
                : Container(),
            TextWidget(
              text:
                  "Un justificatif de permis de séjour, un document administratif, une facture (eau, électricité), un contrat de travail, une attestation de résidence",
              textColor: Color.fromRGBO(136, 141, 145, 1),
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                CustomCheckBox(
                  label: "newsletter",
                ),
                TextWidget(
                  text:
                      "Souhaitez vous être informés sur de \nnouvelles opportunités par SMS, \nEmail ou via les médias sociaux",
                  fontSize: 12,
                  textColor: greyColor,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                CustomCheckBox(
                  label: "terms and condition",
                ),
                TextWidget(
                  text:
                      "J’ai lu et j’accepte les conditions \ngénérales d’utilisation",
                  fontSize: 12,
                  textColor: greyColor,
                ),
              ],
            ),
            SizedBox(height: 20),
            authProvider.loading
                ? Center(
                    child: CustomLoadingWidget(),
                  )
                : CustomButton(
                    buttonText: "Continuer",
                    btnColor: ref.watch(acceptTermsAndCondition)
                        ? primaryColor
                        : greyColor,
                    borderColor: ref.watch(acceptTermsAndCondition)
                        ? primaryColor
                        : greyColor,
                    onTap: () {
                      if (ref.watch(acceptTermsAndCondition)) {
                        // final kycState = ref.read(kycProvider);
                        if (selectedDocumentFrontprov == "") {
                          CustomSnackbar.showSnackbar(
                            title: "Erreur",
                            message:
                                "Veuillez sélectionner un document et télécharger les images",
                          );
                          return;
                        }
                        if (requiresBackView) {
                          CustomSnackbar.showSnackbar(
                            title: "Erreur",
                            message:
                                "Veuillez sélectionner un document et télécharger les images",
                          );
                          return;
                        }
                        Map<String, dynamic> data = {
                          "receive_newsletter": ref.read(sendNewsLetter)
                        };
                        ref.read(AuthProvider.notifier).DocumentUpload(data);
                      } else {
                        CustomSnackbar.showSnackbar(
                          title: "Acceptez les conditions",
                          message:
                              "Veuillez accepter les conditions d'utilisation",
                        );
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }

  Widget _uploadWidget(BuildContext context, String key, String subtitle) {
    // final imagePath = ref.watch(kycProvider).uploadedImages[key];
    String imagePath = "";
    if (key == "front") {
      imagePath = ref.watch(selectedDocFrontProvider);
    } else if (key == "back") {
      imagePath = ref.watch(selectedDocBackProvider);
    } else if (key == "residence") {
      imagePath = ref.watch(selectedResidenceDocProvider);
    } else {
      print("no key assowciated with upload");
    }

    return GestureDetector(
      onTap: () => _showImageSourceDialog(key),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(color: greyColor),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromRGBO(239, 241, 249, 0.6),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: "Télécharger", fontSize: 12),
                TextWidget(
                    text: subtitle,
                    textColor: greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
                if (imagePath != "")
                  TextWidget(
                      text: "Fichier sélectionné",
                      fontSize: 12,
                      textColor: Colors.green),
              ],
            ),
            Spacer(),
            Icon(Icons.photo_outlined),
          ],
        ),
      ),
    );
  }
}
