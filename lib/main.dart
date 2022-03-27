import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tp/note.dart';
import 'dart:async';
import 'package:intl/intl.dart';


void main() async {
  await Hive.initFlutter();
  // Open the NoteBox
  Hive.registerAdapter(NoteAdapter());

  await Hive.openBox('NoteBox');
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.orange
      ),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      // Déclaration des différentes routes de l'exercice permettant la navigation entre la page du compteur et la page de résultat.
      routes: {
        '/': (context) => const FirstScreen(),
        '/second': (context) => const SecondScreen(),
      },
    ),
  );
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _counter = 0;
  String text = "Trouvez le nombre mystère pour accéder au Hello World !";

  // Incrémente la variable _counter lorsque la fonction est appelée.
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    checkCounter();
  }

  // Décrémente la variable _counter lorsque la fonction est appelée.
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
    checkCounter();
  }

  // Si la variable _counter dépasse 10, renvoie l'utilisateur sur la deuxième page SecondScreen et remet le _counter à 0.
  void checkCounter() {
    if (_counter > 10) {
      Navigator.pushNamed(context, '/second');
      _counter = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compteur'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(text),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              FloatingActionButton.extended(
                onPressed: _decrementCounter,
                label: const Text("-"),
                heroTag: "btnDec",
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              FloatingActionButton.extended(
                onPressed: _incrementCounter,
                label: const Text("+"),
                heroTag: "btnInc",
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fin du compteur'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Hello World !',
              ),
              const SizedBox(height: 10),
              const Text(
                'Bravo ! Tu peux passer à l\'exercice 2, l\'exercice 3 ou retourner sur le compteur.',
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                // Renvoie l'utilisateur sur la page du compteur lorsque l'utilisateur clique sur le bouton.
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Retour au compteur'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                // Envoie l'utilisateur sur la page du deuxième exercice lorsque l'utilisateur clique sur le bouton.
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TabBarDemo()));
                },
                child: const Text('Exercice n°2'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                // Envoie l'utilisateur sur la page du deuxième exercice lorsque l'utilisateur clique sur le bouton.
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const NoteApp()));
                },
                child: const Text('Exercice n°3'),
              ),
            ]),
      ),
    );
  }
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
            automaticallyImplyLeading: false,
            leading: IconButton (
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FirstScreen()));
              },
            ),
          ),
          body: const TabBarView(
            children: [
              AgeCalcScreen(),
              DateDiffScreen(),
            ],
          ),
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.orange
      ),
      themeMode: ThemeMode.dark,
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

class NoteApp extends StatelessWidget {
  const NoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.orange
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const InfoScreen(),
    );
  }
}

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final Box contactBox;

  // Delete info from Note box
  _deleteInfo(int index) {
    contactBox.deleteAt(index);
    print('Proposition supprimée à l`\'index: $index');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    contactBox = Hive.box('NoteBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon suivi de job"),
        automaticallyImplyLeading: false,
        leading: IconButton (
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FirstScreen()));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: contactBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Aucune proposition'),
            );
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                var currentBox = box;
                var NoteData = currentBox.getAt(index)!;
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateScreen(
                        index: index,
                        note: NoteData,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(NoteData.name),
                    subtitle: Text("Salaire brut mensuel : " + NoteData.sBrut + " €\nSalaire net mensuel : " + NoteData.sNet + " €\nStatut proposé : " + NoteData.statut + "\nMon sentiment : \n" + NoteData.description),
                    trailing: IconButton(
                      onPressed: () => _deleteInfo(index),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}
class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle proposition'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: AddNoteForm(),
      ),
    );
  }
}

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({Key? key}) : super(key: key);
  @override
  _AddNoteFormState createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  late final Box box;
  late String val = "";
  late double valN = 0.0;
  final _nameController = TextEditingController();
  final _sBrutController = TextEditingController();
  final _statutController = TextEditingController();
  final _sNetController = TextEditingController();
  final _descriptionController = TextEditingController();


  final _NoteFormKey = GlobalKey<FormState>();
  _addInfo() async {
    Note newNote = Note(
      name: _nameController.text,
      sBrut: _sBrutController.text,
      statut: _statutController.text,
      sNet: _sNetController.text,
      description: _descriptionController.text,

    );
    box.add(newNote);
    print('La proposition a été ajouté à la liste!');
  }

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }
  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box('NoteBox');
  }

  void calcSalaire() {
    var dsalaire = double.parse(_sBrutController.text);
    _statutController.text = val;
    if(val == "Cadre (25%)")
    {
      _sNetController.text = ((dsalaire/12) * 0.75).toString();
    }
    else {
      _sNetController.text = ((dsalaire/12) * 0.78).toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _NoteFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nom de l\'entreprise'),
          TextFormField(
            controller: _nameController,
            validator: _fieldValidator,
          ),
          const SizedBox(height: 24.0),
          const Text('Salaire Brut'),
          TextFormField(
            controller: _sBrutController,
            validator: _fieldValidator,
          ),
          const SizedBox(height: 24.0),
          const Text('Statut'),
          ListTile(
            title: const Text("Cadre (25%)"),
            leading: Radio(
              value: "Cadre (25%)",
              groupValue: val,
              onChanged: (v) {
                setState(() {
                  val = v as String;
                  calcSalaire();
                });
              },
              activeColor: Colors.green,
            ),
          ),
          ListTile(
            title: const Text("Non cadre (22%)"),
            leading: Radio(
              value: "Non cadre (22%)",
              groupValue: val,
              onChanged: (v) {
                setState(() {
                  val = v as String;
                  calcSalaire();
                });
              },
              activeColor: Colors.green,
            ),
          ),
          const SizedBox(height: 24.0),
          const Text('Salaire Net'),
          TextFormField(
            enabled: false,
            controller: _sNetController,
            validator: _fieldValidator,
          ),
          const SizedBox(height: 24.0),
          const Text('Description'),
          TextFormField(
            controller: _descriptionController,
            validator: _fieldValidator,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_NoteFormKey.currentState!.validate()) {
                    _addInfo();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Ajouter'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateScreen extends StatefulWidget {
  final int index;
  final Note note;

  const UpdateScreen({
    required this.index,
    required this.note,
  });

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier une proposition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UpdateNoteForm(
          index: widget.index,
          note: widget.note,
        ),
      ),
    );
  }
}
class UpdateNoteForm extends StatefulWidget {
  final int index;
  final Note note;

  const UpdateNoteForm({
    required this.index,
    required this.note,
  });

  @override
  _UpdateNoteFormState createState() => _UpdateNoteFormState();
}
class _UpdateNoteFormState extends State<UpdateNoteForm> {
  final _NoteFormKey = GlobalKey<FormState>();

  late final _nameController;
  late final _sBrutController;
  late final _statutController;
  late final _sNetController;
  late final _descriptionController;
  late final Box box;
  late String val = "";

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  // Update info of Note box
  _updateInfo() {
    Note newNote = Note(
      name: _nameController.text,
      sBrut: _sBrutController.text,
      statut: _statutController.text,
      sNet: _sNetController.text,
      description: _descriptionController.text,
    );

    box.putAt(widget.index, newNote);

    print('Info updated in box!');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box('NoteBox');
    _nameController = TextEditingController(text: widget.note.name);
    _sBrutController = TextEditingController(text: widget.note.sBrut);
    _statutController = TextEditingController(text: widget.note.statut);
    _sNetController = TextEditingController(text: widget.note.sNet);
    _descriptionController = TextEditingController(text: widget.note.description);
  }
  void calcSalaire() {
    var dsalaire = double.parse(_sBrutController.text);
    _statutController.text = val;
    if(val == "Cadre (25%)")
    {
      _sNetController.text = ((dsalaire/12) * 0.75).toString();
    }
    else {
      _sNetController.text = ((dsalaire/12) * 0.78).toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _NoteFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nom de l\'entreprise'),
          TextFormField(
            controller: _nameController,
            validator: _fieldValidator,
          ),
          const SizedBox(height: 24.0),
          const Text('Salaire Brut'),
          TextFormField(
            controller: _sBrutController,
            validator: _fieldValidator,
          ),
          const SizedBox(height: 24.0),
          const Text('Statut'),
          ListTile(
            title: const Text("Cadre (25%)"),
            leading: Radio(
              value: "Cadre (25%)",
              groupValue: val,
              onChanged: (v) {
                setState(() {
                  val = v as String;
                  calcSalaire();
                });
              },
              activeColor: Colors.green,
            ),
          ),
          ListTile(
            title: const Text("Non cadre (22%)"),
            leading: Radio(
              value: "Non cadre (22%)",
              groupValue: val,
              onChanged: (v) {
                setState(() {
                  val = v as String;
                  calcSalaire();
                });
              },
              activeColor: Colors.green,
            ),
          ),
          const SizedBox(height: 24.0),
          const Text('Salaire Net'),
          TextFormField(
            enabled: false,
            controller: _sNetController,
            validator: _fieldValidator,
          ),
          const SizedBox(height: 24.0),
          const Text('Description'),
          TextFormField(
            controller: _descriptionController,
            validator: _fieldValidator,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_NoteFormKey.currentState!.validate()) {
                    _updateInfo();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

