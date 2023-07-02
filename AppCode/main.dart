import 'package:flutter/material.dart';

import 'package:fitnessgame_app/BLE.dart';
import 'package:fitnessgame_app/Setting.dart';
import 'package:fitnessgame_app/game1.dart';
import 'package:fitnessgame_app/game2.dart';
import 'package:fitnessgame_app/game3.dart';
import 'package:fitnessgame_app/game4.dart';
import 'package:fitnessgame_app/functions.dart';
import 'package:fitnessgame_app/constants.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: darkTheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

 

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  @override
  void initState() 
  {
    super.initState();
    initAudio();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void dispose() {
    player.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.detached)
    {
      BLE_Connection().disconnect();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: backgroundGradient(
         Center(
           child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2),
              
              Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: 280,
                decoration: BoxDecoration(
                      border: Border.all(width: 5.0, color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 7,
                          blurRadius: 10,
                          offset: const Offset(4, 4),
                        )
                      ],
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/Game_Logo.png'),
                      ),     
                  ),             
                ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () => {
                   //if(BLE_Connection().esp_device != null)
                   //{
                   Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => const ChoosingGame()),
                             )
                  // }
                  // else
                  // {
                  //  showAlert(const ConnectPage(homescreen: MyHomePage(title: ""),),
                  //         const ChoosingGame(),context),
                  // }
                }, 
                
                  child: buttonTextDisplay(Text("Let's Start!",
                            style: Theme.of(context).textTheme.displayMedium)),
              ),
              const Spacer(),
              ElevatedButton(
               
               
                onPressed: () => {
                      Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ConnectPage(homescreen:  MyHomePage(title: ""),)),
                              )
                },
                child: buttonTextDisplay(Text("Settings",
                            style: Theme.of(context).textTheme.displayMedium)),
                ),
              const Spacer(flex: 3),
            ],
                 ),
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
        body: backgroundGradient(Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              homeIcon( const MyHomePage(title: ""), context),
              Expanded(
                child: Center(
                  child: Column( 
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Choose Your\n Game : ",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 45),
                            softWrap: true,
                            textAlign: TextAlign.center),
                     const Spacer(),
                     Column(children: [
                          Row(children: [
                                Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 5),
                                      child: ElevatedButton(
                                        onPressed: () => {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const Game1Settings(homescreen: MyHomePage(title: ""), gameState: 1,))
                                                      )
                                                    }, 
                                          child: displayTextAndIcon(1, context,[10,10,4,4]),
                                                  )
                                          ),
                                 Padding(
                                      padding: const EdgeInsets.only(left: 5, right: 10),
                                      child: ElevatedButton(
                                      
                                        onPressed: () => {
                                                  Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => const Game2Settings(homescreen: MyHomePage(title: ""))))
                                        },
                                        child: displayTextAndIcon(2, context,[10,10,8.5,8.5]),
                                        )
                                      
                                    ),
                          ],
                          ),
                          Row(children: [
                                const Spacer(flex: 5,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, bottom: 60),
                                  child: IconButton(
                                    iconSize: 35,
                                    onPressed: () { gameExp(1, context);}, 
                                    icon: const Icon(Icons.info)),
                                ),
                                const Spacer(flex: 10),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, bottom: 60),
                                  child: IconButton(
                                    iconSize: 35,
                                    onPressed: () { gameExp(2, context);}, 
                                    icon: const Icon(Icons.info)),
                                ),
                                const Spacer(flex: 5,),
                          ],),
                          Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 5),
                                  child: ElevatedButton(
                                  onPressed: () => {
                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) =>  const Game3Settings(homescreen: MyHomePage(title: ""))))
                                    }, 
                                    
                                      child: displayTextAndIcon(3, context,[10,10,8,8]),
                                    )
                                  
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 10),
                                  child: ElevatedButton(
                                    onPressed: () => {
                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const Game4Settings(homescreen: MyHomePage(title: ""),)))
                                    }, 
                                      child: displayTextAndIcon(4, context, [10,10,32.5,32.5]),
                                  )
                                ),
                          ],),
                          Row(children: [
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: IconButton(
                                    iconSize: 35,
                                    onPressed: () { gameExp(3, context);}, 
                                    icon: const Icon(Icons.info)),
                                ),
                                const Spacer(flex: 2,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: IconButton(
                                    iconSize: 35,
                                    onPressed: () { gameExp(4, context);}, 
                                    icon: const Icon(Icons.info)),
                                ),
                                const Spacer(),
                          ],),
                           ElevatedButton(
                                    onPressed: () => {
                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const Game1Settings(homescreen: MyHomePage(title: ""),gameState: 5,)))
                                    }, 
                                      child: displayTextAndIcon(5, context, [10,10,46,46])),
                          Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: IconButton(
                                    iconSize: 35,
                                    onPressed: () { gameExp(5, context);}, 
                                    icon: const Icon(Icons.info)),
                                ),
                     ],),
                  const Spacer(flex: 2,),
                    ],  
                  ),
                ),
              )
            ]),
        ),
      );
  }
}
