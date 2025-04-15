
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/providers/transactionProvider.dart';
import 'package:switch_app/screens/home/homeScreen.dart';
import 'package:switch_app/widgets/iconButton.dart';
import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/textWidget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class PendingTransactionDetailScreen extends ConsumerStatefulWidget {
  const PendingTransactionDetailScreen({super.key});

  @override
  _PendingTransactionDetailScreenState createState() =>
      _PendingTransactionDetailScreenState();
}

class _PendingTransactionDetailScreenState
    extends ConsumerState<PendingTransactionDetailScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey _globalKey = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(transactionProvider.notifier)
          .getTransactionDetails(ref.read(transactionIdProvider));
// await transaction.
    });
    super.initState();
  }

  Future<void> _captureAndShare() async {
    try {
      // Capture the screen
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the image to a temporary file
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/transaction_details.png';
      File(imagePath).writeAsBytesSync(pngBytes);

      // Share the image
      await Share.shareXFiles([XFile(imagePath)],
          text: 'Check out my transaction details!');
    } catch (e) {
      print('Error: $e');
    }
  }

  void _copyToClipboard(BuildContext context, transactionId) {
    Clipboard.setData(ClipboardData(text: transactionId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Transaction ID copied!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(transactionProvider);
    final transactionModel = ref.watch(selectedTransactionProvider);
    // String currency = transactionModel.receiverCountry.currency
    num totalAmount = transactionModel.receivedAmount ?? 0;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.offAll(HomeScreen());
            },
            color: dark,
            icon: Icon(Icons.arrow_back)),
        backgroundColor: bgColor,
        elevation: 0,
        actions: [
          CustomIconButton(
            icon: Icons.share_outlined,
            onTap:
                //  _captureAndShare
                () async {
              screenshotController
                  .capture(delay: Duration(milliseconds: 10))
                  .then((capturedImage) async {
                Share.shareXFiles(
                    [XFile.fromData(capturedImage!, mimeType: "png")]);
              }).catchError((onError) {
                // print(onError);
              });
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Future.wait([
             ref
                .read(transactionProvider.notifier)
                .checkTransactionStatus(
                {"disburse_invoice": "ly0RxKArY5h4UHPOr0Vx"}),
         
          ]);
         
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: transaction.loading
              ? Center(child: CustomLoadingWidget())
              : Screenshot(
                  controller: screenshotController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: "Détails de la transaction",
                        fontSize: 22,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextWidget(
                        text:
                            "${transactionModel.amount} ${ref.read(selectedCountryProvider).currency!.abbreviation}",
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // TextWidget(
                      //   text:
                      //       "transféré depuis la carte MasterCard numéro XXXX-XXXX-XXXX-1929",
                      //   fontSize: 15,
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(color: iconBtnColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: "Taux de chane du jour",
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextWidget(
                              text:
                                  "1 ${ref.read(selectedCountryProvider).currency!.abbreviation} = ${transactionModel.baseRateSnapshot} ${transactionModel.receiverCountry!.currency!.abbreviation}",
                              fontSize: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(color: iconBtnColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _detailCard(context,
                                title: "Date & heure",
                                subtitle:
                                    DateFormat("HH:mm, d'th of' MMM, yyyy")
                                        .format(transactionModel.createdAt!)),
                            _detailCard(context,
                                title: "Statut card",
                                subtitle: "${transactionModel.cardStatus}",
                                status: 1),
                            _detailCard(context,
                                title: "Statut mobile money",
                                subtitle:
                                    "${transactionModel.mobileMoneyStatus}",
                                status: 1),
                            _detailCard(context,
                                title: "Motant envoyé",
                                subtitle:
                                    "${transactionModel.amount} ${ref.read(selectedCountryProvider).currency!.abbreviation}"),
                            _detailCard(context,
                                title: "Fais",
                                subtitle:
                                    "${transactionModel.totalFee} ${ref.read(selectedCountryProvider).currency!.abbreviation}"),
                            _detailCard(context,
                                title: "Montant reçu",
                                subtitle:
                                    "$totalAmount ${transactionModel.receiverCountry!.currency!.abbreviation}"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(color: iconBtnColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _detailCard(context,
                                title: "Pays",
                                subtitle:
                                    "${transactionModel.receiverCountry!.countryName}"),
                            _detailCard(
                              context,
                              title: "Bénéficiaire",
                              subtitle: "${transactionModel.beneficiaryName}",
                            ),
                            // _detailCard(context,
                            //     title: "Motant envoyé", subtitle: "1000 EUR"),
                            _detailCard(context,
                                title: "Numero de téléphone",
                                subtitle:
                                    "${transactionModel.beneficiaryNumber}"),
                            _detailCard(context,
                                title: "Canal",
                                subtitle:
                                    "${transactionModel.mobileMoneyOperator!.name}"),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(color: iconBtnColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: "ID  de la transaction",
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: TextWidget(
                                    text: transactionModel.transactionId,
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.copy, size: 18),
                                  onPressed: () => _copyToClipboard(
                                      context, transactionModel.transactionId),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

Widget _detailCard(BuildContext context,
    {String? title, String? subtitle, int status = 10}) {
  return Container(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        TextWidget(
          text: title,
        ),
        Spacer(),
        TextWidget(
          text: subtitle,
          textColor: (status != 10) ? primaryColor : dark,
        ),
      ],
    ),
  );
}
