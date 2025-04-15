import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/models/countryModel.dart';
import 'package:switch_app/providers/authProvider.dart';
import 'package:switch_app/providers/configProvider.dart';
import 'package:switch_app/providers/notificationProvider.dart';
import 'package:switch_app/providers/transactionProvider.dart';
import 'package:switch_app/screens/home/notificationScreen.dart';
import 'package:switch_app/screens/home/settingScreen.dart';
import 'package:switch_app/screens/home/transactionHistory.dart';
import 'package:switch_app/services/shared_preference.dart';
import 'package:switch_app/utils/utils.dart';
import 'package:switch_app/widgets/carousel.dart';
import 'package:switch_app/widgets/countryDropdown.dart';
import 'package:switch_app/widgets/historyCard.dart';
import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/textWidget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // String? playerId = await getOneSignalPlayerId();
      // print("this is player id $playerId");
      // if (playerId != null) {
      //   ref.read(AuthProvider.notifier).updateUser({
      //     'one_signal_id': playerId,
      //   });
      // }
      Future.wait([
        ref.read(transactionProvider.notifier).getHomeTransaction(),
        ref.read(transactionProvider.notifier).getAllTransaction(),
        handleLogin(),
        ref.read(AuthProvider.notifier).getLocalContact()
      ], eagerError: false);

      ref.read(transactionIdProvider.notifier).state = "";
      print("token");
      print(Preference().token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(AuthProvider);
    final userModel = ref.watch(userModelProvider);
    final transactionState = ref.watch(transactionProvider);

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: bgColor,
      //   elevation: 0,
      //   centerTitle: false,
      //   leading: TextWidget(
      //     text: "Bonjour Ahmed",
      //   ),
      //   actions: [
      //     CustomIconButton(
      //       icon: Icons.settings_outlined,
      //     ),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     CustomIconButton(
      //       icon: Icons.star_border_rounded,
      //     ),
      //     SizedBox(
      //       width: 10,
      //     ),
      //   ],
      // ),
      body: RefreshIndicator(
        onRefresh: () async {
          String? playerId = await getOneSignalPlayerId();
          print("this is player id $playerId");
          if (playerId != null) {
            ref.read(AuthProvider.notifier).updateUser({
              'one_signal_id': playerId,
            });
          }
          await ref.read(transactionProvider.notifier).getHomeTransaction();
          print("token");
          print(Preference().token);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              // backgroundColor: primaryColor,
              elevation: 0,
              expandedHeight: 100,
              pinned: true,
              stretch: true,
              centerTitle: false,
              // floating: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.zero,
                title: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: TextWidget(
                          maxLine: 1,
                          text:
                              "Bonjour ${userModel.lastName!.capitalizeFirst}",
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Get.to(SettingScreen());
                          },
                          icon: Icon(Icons.settings_outlined)),
                      IconButton(
                          onPressed: () async {
                            Get.to(NotificationListScreen());

                            await ref
                                .read(NotificationProvider.notifier)
                                .getAllNotification();
                          },
                          icon: Icon(Icons.notifications_outlined)),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextWidget(
                      text:
                          "Où souhaitez-vous envoyer de l’argent aujourd'hui?",
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // _countryDropDown(context),
                    CountryDropDownWidet(
                        items: ref
                            .read(allCountryListProvider)
                            .where((country) =>
                                country.countryType == "non_diaspora")
                            .toList(),
                        onSelected: (String country) {}),
                    SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //     height: 90,
                    //     width: MediaQuery.of(context).size.width,
                    //     child: ListView(
                    //       scrollDirection: Axis.horizontal,
                    //       children: [
                    //         ...ref
                    //             .read(allCountryListProvider)
                    //             .where((country) =>
                    //                 country.countryType == "non_diaspora")
                    //             .map((e) => CountryCard(
                    //                   countryModel: e,
                    //                 ))
                    //       ],
                    //     )),
                    // Row(
                    //   children: [
                    //     TextWidget(
                    //       text: "Abonnement",
                    //       textColor: Color.fromARGB(255, 214, 160, 44),
                    //       fontSize: 16,
                    //     ),
                    //     Image.asset("assets/png/star.png")
                    //   ],
                    // ),
                    // TextWidget(
                    //   text:
                    //       "Avec une souscription premium, changez votre façon d’envoyer de l’argent.",
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // CustomButton(
                    //   buttonText: "Passer en premium",
                    //   btnColor: secondaryColor,
                    //   borderColor: secondaryColor,
                    //   onTap: () {
                    //     Get.to(PremiumScreen());
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 40,
                    // ),
                    (ref.read(selectedCountryProvider).ads == null ||
                            ref.read(selectedCountryProvider).ads!.isEmpty)
                        ? TextWidget(
                            text: "Aucune publicité disponible",
                          )
                        : CarouselWidget(
                            adsList:
                                ref.read(selectedCountryProvider).ads ?? [],
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(TransactionHistory());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                            // color: iconBtnColor,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          children: [
                            TextWidget(
                              text: "Récentes transactions",
                            ),
                            Spacer(),
                            TextWidget(
                              text: "Historique",
                            )
                          ],
                        ),
                      ),
                    ),
                    // Divider(),
                    transactionState.loading
                        ? Center(
                            child: CustomLoadingWidget(),
                          )
                        : (ref.watch(hometransactionListProvider).isEmpty)
                            ? Center(
                                child: TextWidget(text: "Aucune Transaction"),
                              )
                            : Column(children: [
                                ...ref.watch(hometransactionListProvider).map(
                                      (e) => HistoryCard(
                                        transaction: e,
                                      ),
                                    )
                              ])
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _countryDropDown(BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Get.to(TransactionScreen());
      CountryDropDownWidet(
          items: [CountryModel(image: "totalReq", countryCode: "+233")],
          onSelected: (String) {});
    },
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: greyColorReg)),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          TextWidget(
            text: "Sélectionner un pays",
          ),
          Spacer(),
          Icon(Icons.arrow_drop_down_circle_outlined)
        ],
      ),
    ),
  );
}
