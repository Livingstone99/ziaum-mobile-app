import 'package:flutter/material.dart';
import 'package:switch_app/widgets/textWidget.dart';

class BulletList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      'Zéro frais de transfert',
      'Support prioritaire',
      'Déplafonnement',
      'Cashback',
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '•', // Dot bullet
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.0), // Space between bullet and text
            TextWidget(
              text: items[index],
              fontSize: 13,
            ),
          ],
        );
      },
    );
  }
}
