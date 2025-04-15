import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/providers/transactionProvider.dart';
import 'package:switch_app/widgets/customSnackbar.dart';
import 'package:switch_app/widgets/loadingWidget.dart';
import 'package:switch_app/widgets/textWidget.dart'; // For date formatting

class TransactionStatementScreen extends ConsumerStatefulWidget {
  const TransactionStatementScreen({super.key});

  @override
  ConsumerState<TransactionStatementScreen> createState() =>
      _TransactionStatementScreenState();
}

class _TransactionStatementScreenState
    extends ConsumerState<TransactionStatementScreen> {
  // Variables to store selected dates and format
  DateTime? startDate;
  DateTime? endDate;
  String selectedFormat = 'PDF'; // Default format

  // List of formats for the dropdown
  final List<String> formats = ['PDF', 'Excel'];

  // Function to show the date picker in a bottom sheet
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              // Header for the bottom sheet
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isStartDate
                          ? 'Sélectionner la date de début'
                          : 'Sélectionner la date de fin',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Date picker
              Expanded(
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  onDateChanged: (DateTime date) {
                    Navigator.pop(context, date); // Return the selected date
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  // Function to handle export
  void _exportTransactions() {
    if (startDate == null || endDate == null) {
      CustomSnackbar.showSnackbar(
          title: "Erreur",
          message: "Veuillez sélectionner une date de début et de fin.");

      return;
    }

    if (startDate!.isAfter(endDate!)) {
      CustomSnackbar.showSnackbar(
          title: "Erreur",
          message: "La date de début doit être antérieure à la date de fin.");

      return;
    }

    // TODO: Implement export logic based on selected format

    print(
        'Exporting transactions from ${DateFormat('yyyy-MM-dd').format(startDate!)} to ${DateFormat('yyyy-MM-dd').format(endDate!)} in $selectedFormat format.');
    Map<String, dynamic> data = {
      "start_date": startDate.toString().split(' ')[0],
      "end_date": endDate.toString().split(' ')[0],
    };
    print(data);

    ref.read(transactionProvider.notifier).fetchByDateTransaction(data);
  }

  @override
  Widget build(BuildContext context) {
    final transactionProv = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const TextWidget(text: 'Query les transactions'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: dark,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Date Picker
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date de début',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              controller: TextEditingController(
                text: startDate != null
                    ? DateFormat('yyyy-MM-dd').format(startDate!)
                    : '',
              ),
            ),
            const SizedBox(height: 20),

            // End Date Picker
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date de fin',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
              controller: TextEditingController(
                text: endDate != null
                    ? DateFormat('yyyy-MM-dd').format(endDate!)
                    : '',
              ),
            ),
            const SizedBox(height: 20),

            // Format Dropdown
            // DropdownButtonFormField<String>(
            //   value: selectedFormat,
            //   decoration: const InputDecoration(
            //     labelText: 'Format',
            //   ),
            //   items: formats.map((String format) {
            //     return DropdownMenuItem<String>(
            //       value: format,
            //       child: Text(format),
            //     );
            //   }).toList(),
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       selectedFormat = newValue!;
            //     });
            //   },
            // ),
            // const SizedBox(height: 20),

            // Export Button

            transactionProv.loading
                ? Center(
                    child: CustomLoadingWidget(),
                  )
                : Center(
                    child: SizedBox(
                      width: double.infinity, // Full width
                      child: ElevatedButton(
                        onPressed: _exportTransactions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5), // Custom border radius
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16), // Optional: Add padding
                        ),
                        child: const TextWidget(
                          text: 'confirmer',
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
