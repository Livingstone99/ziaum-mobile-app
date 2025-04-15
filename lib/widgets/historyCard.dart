import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/models/transactionModel.dart';
import 'package:switch_app/providers/transactionProvider.dart';
import 'package:switch_app/screens/home/transactionDetailScreen.dart';
import 'package:switch_app/widgets/textWidget.dart';
import 'package:intl/intl.dart';

class HistoryCard extends ConsumerWidget {
  final TransactionModel? transaction;
  const HistoryCard({super.key, this.transaction});

  // Helper function to get the icon and color based on the transaction status
  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'created':
        return Icon(Icons.access_time, color: Colors.blue);
      case 'pending':
        return Icon(Icons.pending_outlined, color: Colors.orange);
      case 'success':
        return Icon(Icons.check_circle_outline, color: Colors.green);
      case 'failed':
        return Icon(Icons.error_outline, color: Colors.red);
      default:
        return Icon(Icons.help_outline_outlined, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(transactionIdProvider.notifier).state =
            transaction!.transactionId!;
        ref.read(selectedTransactionProvider.notifier).state = transaction!;
        Get.to(TransactionDetailScreen());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            // Country flag image
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: CachedNetworkImageProvider(
                      transaction!.receiverCountry!.image!),
                ),
              ),
            ),
            SizedBox(width: 20),
            // Beneficiary details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextWidget(
                      text: transaction!.beneficiaryName!
                          .split(" ") // Split the name into individual words
                          .map((word) => word.isNotEmpty
                              ? word[0].toUpperCase() +
                                  word.substring(1).toLowerCase()
                              : "")
                          .join(" "), // Join the words back with spaces
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // TextWidget(
                  //   text: transaction!.beneficiaryNumber,
                  //   fontSize: 14,
                  //   textColor: Colors.grey,
                  // ),
                  SizedBox(height: 4),
                  TextWidget(
                    text: DateFormat("HH:mm, d'th of' MMM, yyyy")
                        .format(transaction!.createdAt!),
                    fontSize: 12,
                    textColor: Colors.grey,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            // Transaction amount and status icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextWidget(
                  text: "${transaction!.amount}EUR",
                  fontSize: 12,
                  // fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 4),
                _getStatusIcon(transaction!.mobileMoneyStatus ?? "null"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
