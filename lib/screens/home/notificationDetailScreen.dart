import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/notificationProvider.dart';
import 'package:switch_app/widgets/textWidget.dart';
import 'package:intl/intl.dart';

class NotificationDdetailScreen extends ConsumerStatefulWidget {
  const NotificationDdetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationDdetailScreenState();
}

class _NotificationDdetailScreenState
    extends ConsumerState<NotificationDdetailScreen> {
  @override
  Widget build(BuildContext context) {
    final notficationDetails = ref.watch(selectedNotificationProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: TextWidget(
          text: "Notification Details",
        ),
        leading: BackButton(
          color: dark,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: notficationDetails.subject,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            Divider(),
            const SizedBox(height: 10),
            TextWidget(
              text: notficationDetails.message,
            ),
            const SizedBox(height: 40),
            Divider(),
            TextWidget(
              text: DateFormat("HH:mm, d'th of' MMM, yyyy")
                  .format(notficationDetails.createdAt!),
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
