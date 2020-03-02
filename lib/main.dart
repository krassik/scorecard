import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'dart:math';
// import 'package:intl/intl.dart';


void main() {
  try {
    fb.initializeApp();
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scorecard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(title: 'Select from the following actions:'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  String title;

  void setTitle(t) {
    title = t;
  }

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _counter = 0;
  static fs.Firestore _store = fb.firestore();
  static final rng = Random();

  final List<Function> actions = [
    () => _store.doc('').collection('tests').add({'pass':rng.nextBool()}),
    () => _store.doc('').collection('tests').get().then((snap) {
          final passedN = snap.docs.where((docSnap) => docSnap.data()['pass'] == true ).length;
          return passedN / snap.size * 100;
        }),
    () {},
    () {},
    () {},
    () {},
    () {},
  ];
   
  void _incrementCounter() {
    setState(() {
      _counter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List<Widget>.generate(
            actions.length,
            (index) => RaisedButton(
                  child: Text('Action $index'),
                  onPressed: () {
                    actions[index]().then((result) {
                      // widget.title = 'Quality: ${ NumberFormat("###.0#", "en_US").format(result) } %';
                      widget.title = 'Quality: $result %';
                      _incrementCounter();
                    });
                  },
                )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Text('$_counter'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}