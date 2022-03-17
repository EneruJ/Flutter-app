import 'package:flutter/material.dart';
import 'package:tp/age.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
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
                'Bravo ! Tu peux passer à l\'exercice 2 ou retourner sur le compteur.',
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
            ]),
      ),
    );
  }
}
