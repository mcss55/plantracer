import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantracer/utils.dart';

class CreatePage extends StatefulWidget {
  final String headerText;

  // Create constructor to get the header text
  CreatePage({Key? key, required this.headerText}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = pickedDate;
        } else {
          _selectedEndDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var headerText = widget.headerText;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('$headerText yarat',
            style: TextStyle(
                color: getTextColor(context),
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: headerText == 'Task' ? taskForm() : planForm(),
    );
  }

  Widget taskForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Başlık',
              labelStyle: TextStyle(fontSize: 18),
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Açıklama',
              labelStyle: TextStyle(fontSize: 18),
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Bitiş Tarihi',
              labelStyle: TextStyle(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Widget planForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              cursorColor: getTextColor(context),
              style: TextStyle(fontSize: 18, color: getTextColor(context)),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: getTextColor(context)),
                ),
                hintStyle: TextStyle(color: getTextColor(context)),
                labelText: 'Başlıq',
                labelStyle: TextStyle(fontSize: 18, color: getTextColor(context)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => _selectDate(context, true),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedStartDate == null
                    ? 'Başlanğıc tarixi'
                    : DateFormat('dd/MM/yyyy').format(_selectedStartDate!),
                style: TextStyle(fontSize: 18, color: getTextColor(context)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => _selectDate(context, false),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedEndDate == null
                    ? 'Bitiş tarixi'
                    : DateFormat('dd/MM/yyyy').format(_selectedEndDate!),
                style: TextStyle(fontSize: 18, color: getTextColor(context))
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: getTextColor(context)
            ),
            onPressed: () {
              // Save the plan with datahelp
            },
            child:  Text('Yadda saxla', style: TextStyle(color: Theme.of(context).primaryColor))
          ),
        ],
      ),
    );
  }
}