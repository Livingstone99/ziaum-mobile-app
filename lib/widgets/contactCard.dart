import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import 'textWidget.dart';

class ContactCard extends ConsumerWidget {
  final String? fullName;
  final String? phoneNum;

  const ContactCard({super.key, this.fullName, this.phoneNum});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 70,
          color: primaryColor,
        ),
        const SizedBox(
          width: 7,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: fullName,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            TextWidget(
              text: phoneNum,
            )
          ],
        )
      ],
    );
  }
}
