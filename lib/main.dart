import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Earnings Tracker',
      // Apply dark theme to the app
      home: EarningsPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en'),
        Locale('cs')
      ],
    );
  }
}

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  _EarningsPageState createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  double _earnedMoney = 0.0;

  void _calculateEarnings() {
    if (_startDate == null || _endDate == null || _earnedMoney <= 0) {
      return;
    }

    DateTime now = DateTime.now();
    if (now.isBefore(_startDate!) || now.isAfter(_endDate!)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Špatné datum'),
            content: const Text('Datum příjezdu nesmí být v budoucnu.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    int daysPassed = _endDate!.difference(_startDate!).inDays;
    int daysRemaining = _endDate!.difference(now).inDays;
    int currentDay = now.difference(_startDate!).inDays + 1;

    double earningsForWholePeriod = _earnedMoney * daysPassed;
    double earningsFromDateToCurrent = _earnedMoney * currentDay;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Motivační kalkulačka'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Výdělek za celkovou dobu: ${earningsForWholePeriod.toStringAsFixed(2)} Kč'),
              const SizedBox(height: 10),
              Text('Výdělek k dnešnímu dni: ${earningsFromDateToCurrent.toStringAsFixed(2)} Kč'),
              const SizedBox(height: 10),
              Text('Počet proběhlých dnů: $currentDay'),
              SizedBox(height: 10),
              Text('Počet zbývajících dní: $daysRemaining'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      locale: Locale('cs', 'CZ'), // Czech
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // Apply dark theme to the date picker
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivační kalkulačka'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      const Text(
                        'Příjezd',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        _startDate == null ? 'Nevybráno' : DateFormat.yMd('cs').format(_startDate!),
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        child: const Text('Vyber'),
                        onPressed: () {
                          _selectDate(context, true);
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Odjezd',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        _endDate == null ? 'Nevybráno' : DateFormat.yMd('cs').format(_endDate!),
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        child: const Text('Vyber'),
                        onPressed: () {
                          _selectDate(context, false);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Zadej částku výdělku za jeden den',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                keyboardAppearance: Brightness.dark,
                onChanged: (value) {
                  setState(() {
                    _earnedMoney = double.parse(value);
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Částka',
                  hintText: 'Zadej částku',
                  labelStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
                width: 100,
              ),
              ElevatedButton(
                onPressed: _calculateEarnings,
                child: const Text('Vypočítej'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}