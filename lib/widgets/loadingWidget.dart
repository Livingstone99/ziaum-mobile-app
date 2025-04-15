import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/colors.dart';

class CustomLoadingWidget extends ConsumerWidget {
  final double size;

  const CustomLoadingWidget({super.key, this.size = 40});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: primaryColor,
      size: size,
    );
  }
}
