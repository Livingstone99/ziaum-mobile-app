import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/widgets/textWidget.dart';

final selectedMonthProvider = StateProvider<int>((ref) {
  return 1;
});

class MonthsScrollView extends ConsumerWidget {
  final List<String> months = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      height: 60, // Adjust the height based on your needs
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              ref.read(selectedMonthProvider.notifier).state = index;
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: (ref.watch(selectedMonthProvider) == index)
                    ? primaryColor2
                    : iconBtnColor,
                borderRadius: BorderRadius.circular(8.0),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.2),
                //     spreadRadius: 2,
                //     blurRadius: 5,
                //     offset: Offset(0, 3),
                //   ),
                // ],
              ),
              child: Center(
                child: TextWidget(
                    text: months[index],
                    textColor: (ref.watch(selectedMonthProvider) == index)
                        ? bgColor
                        : dark),
              ),
            ),
          );
        },
      ),
    );
  }
}
