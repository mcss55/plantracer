import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'my_app.dart';

void main() {
  initializeDateFormatting('az', null).then((_) {
    runApp(MyApp());
  });
}