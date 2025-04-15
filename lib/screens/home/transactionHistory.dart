import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/transactionProvider.dart';
import 'package:switch_app/screens/home/transactionStatementScreen.dart';
import 'package:switch_app/widgets/custom_textfield.dart';
import 'package:switch_app/widgets/historyCard.dart';
import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/textWidget.dart';

class TransactionHistory extends ConsumerStatefulWidget {
  const TransactionHistory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionHistoryState();
}

class _TransactionHistoryState extends ConsumerState<TransactionHistory> {
  // State variable to store the search query
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(transactionProvider);

    // Filter transactions based on the search query
    final filteredTransactions = ref.watch(transactionListProvider).where((e) {
      return e.beneficiaryName!
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: dark,
          ),
        ),
        elevation: 0,
        title: TextWidget(
          text: "Historique des transferts",
          fontSize: 17,
        ),
      ),
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Fixed Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CustomTextField(
                    hintText: "Rechercher par nom...",
                    prefixIcon: Icon(Icons.search, color: dark),
                    onChange: (value) {
                      // Update the search query as the user types
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Get.to(TransactionStatementScreen());
                    },
                    icon: Icon(Icons.calendar_month_outlined))
              ],
            ),
          ),
          // Transaction List
          Expanded(
            child: transaction.loading
                ? Center(child: CustomLoadingWidget())
                : RefreshIndicator(
                    onRefresh: () async {
                      ref
                          .read(transactionProvider.notifier)
                          .getAllTransaction();
                    },
                    child: filteredTransactions.isEmpty
                        ? Center(
                            child: TextWidget(
                              text: searchQuery.isEmpty
                                  ? "Aucune transaction."
                                  : "Aucun résultat trouvé.",
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredTransactions.length,
                            itemBuilder: (context, index) {
                              return HistoryCard(
                                transaction: filteredTransactions[index],
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
