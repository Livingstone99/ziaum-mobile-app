import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switch_app/constants/colors.dart';

final sendNewsLetter = StateProvider<bool>((ref) {
  return false;
});
final acceptTermsAndCondition = StateProvider<bool>((ref) {
  return false;
});

class CustomCheckBox extends ConsumerStatefulWidget {
  final String? label;
  final bool checked;
  // final ValueChanged<bool> onChanged;

  const CustomCheckBox({
    Key? key,
    this.label,
    this.checked = false,
    // required this.onChanged,
  }) : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends ConsumerState<CustomCheckBox> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("clicked check ${widget.checked}");
        // widget.onChanged(!widget.checked);
        setState(() {
          checked = !checked;
        });
        if (widget.label == "newsletter") {
          ref.read(sendNewsLetter.notifier).state = checked;
        } else if (widget.label == "terms and condition") {
          ref.read(acceptTermsAndCondition.notifier).state = checked;
        }
      },
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.transparent,
          border: Border.all(color: greyColor, width: 1),
        ),
        child: checked
            ? const Center(
                child: Icon(
                  Icons.check,
                  size: 23,
                  color: primaryColor, // White checkmark on green background
                ),
              )
            : null,
      ),
    );
  }
}
