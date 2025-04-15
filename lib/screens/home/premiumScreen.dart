import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/widgets/bulletinWidget.dart';
import 'package:switch_app/widgets/custombutton.dart';
import 'package:switch_app/widgets/textWidget.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: "Passer en Premium",
                fontSize: 25,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 137,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/pana.svg",
                      height: 125,
                      // width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: 150,
                        child: BulletList())
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              TextWidget(
                text:
                    "Lorem ipsum dolor sit amet consectetur. Mi amet ullamcorper vitae venenatis molestie proin vestibulum. Vitae velit habitant sit est.",
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _premiumWidget(context),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 45, vertical: 30),
                    decoration: BoxDecoration(
                        color: iconBtnColor,
                        // border: Border.all(color: secondaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        TextWidget(
                          text: "12",
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        TextWidget(
                          text: "mois",
                        ),
                        TextWidget(
                          text: "6.00£/mois",
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              CustomButton(buttonText: "S'abonner")
            ],
          ),
        ));
  }
}

Widget _premiumWidget(BuildContext context) {
  return Container(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 30),
          decoration: BoxDecoration(
              color: Color.fromRGBO(250, 243, 229, 1),
              border: Border.all(color: secondaryColor),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              TextWidget(
                text: "12",
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              TextWidget(
                text: "mois",
              ),
              TextWidget(
                text: "6.00£/mois",
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        Positioned(
          top: -25,
          child: Container(
            width: 190,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/png/star.png"),
                TextWidget(
                  text: "Best Seller",
                  textColor: bgColor,
                ),
                Image.asset("assets/png/star.png"),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
