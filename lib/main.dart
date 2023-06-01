import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earnings Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EarningsPage(),
    );
  }
}

class EarningsPage extends StatefulWidget {
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
             title: Text('Invalid Date'),
             content: Text('Please enter a valid date range.'),
             actions: [
               TextButton(
                 child: Text('OK'),
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

     int daysPassed = _endDate!.difference(_startDate!).inDays + 1;
     int daysRemaining = _endDate!.difference(now).inDays;
     int currentDay = now.difference(_startDate!).inDays + 1;

     double earningsForWholePeriod = _earnedMoney * daysPassed;
     double earningsFromDateToCurrent = _earnedMoney * currentDay;

     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text('Earnings Calculation'),
           content: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               Text('Earnings for the whole period: \$${earningsForWholePeriod.toStringAsFixed(2)}'),
               SizedBox(height: 10),
               Text('Earnings from start date to current date: \$${earningsFromDateToCurrent.toStringAsFixed(2)}'),
               SizedBox(height: 10),
               Text('Current Day: $currentDay'),
               SizedBox(height: 10),
               Text('Days Remaining: $daysRemaining'),
             ],
           ),
           actions: [
             TextButton(
               child: Text('OK'),
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
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
        title: Text('Earnings Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Set Start and End Dates',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    Text('Start Date'),
                    SizedBox(height: 10.0),
                    Text(_startDate == null ? 'Not set' : DateFormat('yyyy-MM-dd').format(_startDate!)),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      child: Text('Select'),
                      onPressed: () {
                        _selectDate(context, true);
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('End Date'),
                    SizedBox(height: 10.0),
                    Text(_endDate == null ? 'Not set' : DateFormat('yyyy-MM-dd').format(_endDate!)),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      child: Text('Select'),
                      onPressed: () {
                        _selectDate(context, false);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Enter Earned Money for One Day',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _earnedMoney = double.parse(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Earned Money',
                hintText: 'Enter amount',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Calculate'),
              onPressed: _calculateEarnings,
            ),
          ],
        ),
      ),
    );
  }
}