import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/models/countryModel.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/screens/home/TransactionScreen.dart';
import 'package:switch_app/widgets/textWidget.dart';

import '../constants/colors.dart';

class CountryDropDownWidet extends ConsumerStatefulWidget {
  final List<CountryModel> items;
  final ValueChanged<String> onSelected;

  const CountryDropDownWidet({
    Key? key,
    required this.items,
    required this.onSelected,
  }) : super(key: key);

  @override
  _CountryDropDownWidetState createState() => _CountryDropDownWidetState();
}

class _CountryDropDownWidetState extends ConsumerState<CountryDropDownWidet> {
  String? selectedValue;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        hint: TextWidget(
          text: "Sélectionner un pays",
        ),
        value: selectedValue,
        isExpanded: true,
        underline: SizedBox(), // Remove default underline
        icon: Icon(FontAwesomeIcons.chevronDown,
            size: 20, color: Colors.grey.shade700),
        style: TextStyle(color: Colors.black, fontSize: 16),
        onChanged: (
          value,
        ) {
          setState(() {
            selectedValue = value;
          });
          widget.onSelected(value!);
          print("selceted name $value");
          ref.read(selectedtransactionCountryProvider.notifier).state = ref
              .read(allCountryListProvider)
              .firstWhere((element) => element.countryName == value);

          ref.read(selectedOperatorProvider.notifier).state = OperatorModel();
          Get.to(TransactionScreen());
        },
        dropdownColor: Colors.white,
        items: widget.items.map<DropdownMenuItem<String>>((CountryModel item) {
          return DropdownMenuItem<String>(
            value: item.countryName,
            child: Row(
              children: [
                Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bgColor,
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        // opacity: 0.4,
                        image: CachedNetworkImageProvider(
                          item.image!,
                        ),
                      ),
                    )),
                SizedBox(width: 10),
                TextWidget(text: item.countryName, fontSize: 14),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
