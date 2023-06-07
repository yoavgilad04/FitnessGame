import 'package:fitnessgame_app/game1.dart';
import 'package:fitnessgame_app/Setting.dart';
import 'package:flutter/material.dart';

import 'game2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 74.0, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),
          titleLarge: TextStyle(fontSize: 55.0, fontWeight: FontWeight.bold, 
                                fontStyle: FontStyle.italic, fontFamily: 'RobotoSlab', color: Color.fromARGB(255, 14, 91, 155)),
          bodyMedium: TextStyle(fontSize: 30.0, fontFamily: 'Oswald',color: Colors.white),
          bodySmall: TextStyle(fontSize: 15.0, fontFamily: 'Oswald',color: Colors.black)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.green,
          )
        )
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

 

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(flex: 2),
            Text("Fitness Game",
                style: Theme.of(context).textTheme.titleLarge),
            const Spacer(flex: 3),
            ElevatedButton(
              onPressed: () => {
                 Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => const ChoosingGame()),
                           )
              }, 
              child: Text("Let's Start!",
                        style: Theme.of(context).textTheme.bodyMedium)
            ),
            const Spacer(),
            ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style!.
                          copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
              onPressed: () => {
                    Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ConnectPage(homescreen: const MyHomePage(title: ""))),
                            )
              },
              child: Text("Setting",
                        style: Theme.of(context).textTheme.bodyMedium)
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class ChoosingGame extends StatelessWidget{
  const ChoosingGame({super.key});

  @override
  Widget build(BuildContext context)
  {
      return Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              iconSize: 50,
              onPressed: () {
                  Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyHomePage(title: "")),
                          );
              },
              icon: const Icon(Icons.home)),
            Column( 
              children: [
                const Spacer(),
                Text("Choose Your\n Game : ",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 45),
                      softWrap: true,
                      textAlign: TextAlign.center),
                const Spacer(),
            Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style!.
                          copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent)),
                    onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Game1Start(homescreen: MyHomePage(title: "")))
                                  )
                                }, 
                    child: Text("Game 1",
                            style: Theme.of(context).textTheme.bodyMedium),
                  ),
                            
                ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style!.
                          copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent)),
                onPressed: () => {
                          Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Game2Start(homescreen: MyHomePage(title: ""))))
                },
                child: Text("Game 2",
                          style: Theme.of(context).textTheme.bodyMedium)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style!.
                          copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
                onPressed: () => {}, 
                child: Text("Game 3",
                          style: Theme.of(context).textTheme.bodyMedium)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style!.
                          copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                  onPressed: () {
                                  Navigator.pop(context);
                  }, 
                  child:  Text("Back",
                  style: Theme.of(context).textTheme.bodyMedium)),
            ),
            const Spacer(),
              ],  
            )
          ]),
      );
  }
}


