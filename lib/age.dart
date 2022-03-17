import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

void main() {
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Création d'une barre d'onglet permettant de naviguer entre les 2 parties de l'exercice.
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: "Calcul d'âge "),
                Tab(text: "Différence entre 2 dates"),
              ],
            ),
            title: const Text('Calcul de dates'),
          ),
          body: const TabBarView(
            children: [
              AgeCalcScreen(),
              DateDiffScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class AgeCalcScreen extends StatefulWidget {
  const AgeCalcScreen({Key? key}) : super(key: key);
  @override
  State<AgeCalcScreen> createState() => _AgeCalcState();
}

class _AgeCalcState extends State<AgeCalcScreen> {
  DateTime? _selectedDate;
  int year = 0;
  int age = 0;
  int months = 0;
  int days = 0;
  int difference = 0;
  int minutes = 0;
  int secondes = 0;
  DateTime? _timeString;

  // Déclaration d'une fonction permettant d'afficher le calendrier et calculer l'âge en fonction de la date sélectionnée.
  void _presentDatePicker() {
    // Déclaration d'un calendrier allant de 1955 à maintenant.
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1955),
            lastDate: DateTime.now())
        .then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }
      // Lorsque la date est sélectionnée, on la récupère et calcule l'âge de l'utilisateur en fonction d'elle.
      setState(() {
        _selectedDate = pickedDate;
        year = _selectedDate!.year;
        age = DateTime.now().year - year;
        difference = DateTime.now().difference(_selectedDate!).inDays;
        months = (difference % 365 / 30).floor();
        days = (difference % 365 % 30).floor();
        if (DateTime.now().month < _selectedDate!.month) {
          age = age - 1;
        }
      });
    });
  }

  @override
  // Déclaration de fonctions permettant de changer à chaque seconde le temps affichée sur l'application.
  void initState() {
    _timeString = DateTime.now();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        _timeString = now;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: _presentDatePicker,
                  child: const Text('Choisis ta date d\'anniversaire')),
              Container(
                padding: const EdgeInsets.all(30),
                alignment: Alignment.center,
                child: Text(
                  // Affiche l'âge de l'utilisateur uniquement lorsque qu'une date est sélectionnée, sinon affiche un message indiquant qu'aucune date est sélectionnée.
                  _selectedDate != null
                      ? 'Tu as ' +
                          age.toString() +
                          ' ans ' +
                          months.toString() +
                          ' mois ' +
                          days.toString() +
                          ' jours ' +
                          "\n" +
                          _timeString!.hour.toString() +
                          ' heures ' +
                          _timeString!.minute.toString() +
                          ' minutes  ' +
                          _timeString!.second.toString() +
                          ' secondes.'
                      : 'Pas de date sélectionnée :)',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ]),
      ),
    );
  }
}

class DateDiffScreen extends StatefulWidget {
  const DateDiffScreen({Key? key}) : super(key: key);
  @override
  State<DateDiffScreen> createState() => _DateDiffState();
}

class _DateDiffState extends State<DateDiffScreen> {
  int? differenceDF;
  int minutes = 0;
  int secondes = 0;
  String? _selectedF;
  String? _selectedD;
  String? aff;

  // Déclaration d'une fonction permettant de calculer la différence entre 2 dates.
  void _dateDifference() {
    setState(() {
      DateTime dateD = DateTime.parse(_selectedD!);
      DateTime dateF = DateTime.parse(_selectedF!);
      differenceDF = dateF.difference(dateD).inDays;
      aff = 'La différence entre le ' +
          _selectedD.toString() +
          ' et le ' +
          _selectedF.toString() +
          ' est de ' +
          (differenceDF! / 365).floor().toString() +
          ' ans, ' +
          (differenceDF! % 365 / 30).floor().toString() +
          ' mois et ' +
          (differenceDF! % 365 % 30).floor().toString() +
          ' jours.';
    });
  }

  // Déclaration de 2 fonctions permettant de créer 2 calendriers pour sélectionner les 2 dates à comparer.
  void _presentDatePickerCompareD() {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1995),
            lastDate: DateTime.now())
        .then((pickedDD) {
      // Check if no date is
      _selectedD = DateFormat('yyyy-MM-dd').format(pickedDD!);
      if (_selectedD == null || _selectedF == null) {
        return;
      }
    });
  }

  void _presentDatePickerCompareF() {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1995),
            lastDate: DateTime.now())
        .then((pickedDF) {
      // Check if no date is selected
      _selectedF = DateFormat('yyyy-MM-dd').format(pickedDF!);
      // Appelle la fonction _dateDifference uniquement lorsque les 2 dates à comparer sont sélectionnées.
      if (_selectedD == null || _selectedF == null) {
        return;
      } else {
        _dateDifference();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: _presentDatePickerCompareD,
                  child: const Text('Date de départ')),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ElevatedButton(
                    onPressed: _presentDatePickerCompareF,
                    child: const Text('Date d\'arrivée')),
                // display the selected date
              ),
              Container(
                padding: const EdgeInsets.all(30),
                child: Text(
                  differenceDF != null ? aff! : 'Pas de dates sélectionnées :)',
                  style: const TextStyle(fontSize: 20),
                ),
              )
            ]),
      ),
    );
  }
}
