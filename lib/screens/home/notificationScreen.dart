import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/screens/home/notificationDetailScreen.dart';
import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/textWidget.dart';
import 'package:intl/intl.dart';
import '../../providers/notificationProvider.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(AuthProvider);
    final notificationProvider = ref.watch(NotificationProvider);
    // final notificationListProvider = ref.watch(notificationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const TextWidget(text: "Notifications"),
        leading: BackButton(
          color: dark,
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.delete),
          //   onPressed: () {
          //     ref.read(notificationProvider.notifier).clearNotifications();
          //   },
          // ),
        ],
      ),
      body: notificationProvider.loading
          ? Center(
              child: CustomLoadingWidget(),
            )
          : ref.watch(notificationListProvider).isEmpty
              ? const Center(
                  child: TextWidget(text: "Aucune notification disponible."),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(NotificationProvider.notifier)
                        .getAllNotification();
                  },
                  child: ListView.builder(
                    itemCount: ref.watch(notificationListProvider).length,
                    itemBuilder: (context, index) {
                      final notification = ref
                          .watch(notificationListProvider)
                          .reversed
                          .toList()[index];

                      return ListTile(
                        // leading: Icon(
                        //   Icons.notifications_active,
                        //   color: Colors.blue,
                        // ),
                        onTap: () {
                          ref
                                  .read(selectedNotificationProvider.notifier)
                                  .state =
                              ref
                                  .read(notificationListProvider)
                                  .reversed
                                  .toList()[index];
                          Get.to(NotificationDdetailScreen());
                        },
                        title: TextWidget(
                          text: notification.subject,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: "${notification.message}",
                              overflow: TextOverflow.ellipsis,
                              maxLine: 2,
                            ),
                            TextWidget(
                              text: DateFormat("HH:mm, d'th of' MMM, yyyy")
                                  .format(notification.createdAt!),
                              fontSize: 12,
                              textColor: primaryColor,
                            ),
                            Divider()
                          ],
                        ),
                        // isThreeLine: true,
                        // trailing: IconButton(
                        //   icon: Icon(
                        //     notification.isRead
                        //         ? Icons.check_circle_outline
                        //         : Icons.mark_email_unread,
                        //   ),
                        //   onPressed: () {
                        //     ref.read(notificationProvider.notifier).markAsRead(index);
                        //   },
                        // ),
                      );
                    },
                  ),
                ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     ref.read(notificationProvider.notifier).fetchNotifications();
      //   },
      //   child: const Icon(Icons.refresh),
      // ),
    );
  }
}
