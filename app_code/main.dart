import 'package:flutter/material.dart';

import 'BLE.dart';
import 'Setting.dart';
import 'game1.dart';
import 'game2.dart';
import 'game3.dart';
import 'game4.dart';
import 'functions.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BLE_Connection(),
      child: MaterialApp(
       title: 'Flutter Demo',
       theme: darkTheme,
       home: const MyHomePage(title: 'Flutter Demo Home Page'),
       debugShowCheckedModeBanner: false,
       ),
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
    stopBackgroundMusic(bgMusicPlayer);
    stopBackgroundMusic(gameMusicPlayer);
    playBackgroundMusic(bgMusicPlayer);
  }

  @override
  void dispose() {
    // bgMusicPlayer.dispose();  // Stop music when app closes
    // gameMusicPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // void _playBackgroundMusic() async {
  //   await bgMusicPlayer.stop(); // Stop any existing music before playing
  //   await bgMusicPlayer.setReleaseMode(ReleaseMode.loop); // Ensure looping
  //   await bgMusicPlayer.play(AssetSource('background_music.mp3'));
  //
  //   // Ensure only one instance of looping occurs
  //   bgMusicPlayer.onPlayerComplete.listen((event) async {
  //     await bgMusicPlayer.seek(Duration.zero); // Restart the music
  //     await bgMusicPlayer.resume();
  //   });
  // }
  //
  // void _stopBackgroundMusic() async {
  //   await bgMusicPlayer.stop();  // Stop background music when switching to game
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.detached)
    {
      BLE_Connection().disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<BLE_Connection>();
    Future.delayed(Duration.zero,() {
      asyncAlertESPNNow(const ConnectPage(homescreen: MyHomePage(title: "")), context);
    });
    return Scaffold(
      body: backgroundGradient(
         Center(
           child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2),
//-----------------------------------Image Logo--------------------------------//
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
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),  // Ensures the image respects the rounded corners
                  child: Image.asset(
                    'assets/Game_Logo_2.png',
                    fit: BoxFit.cover,  // Makes sure the image covers the whole container
                    width: double.infinity, // Forces the image to take the full width
                    height: double.infinity, // Forces the image to take the full height
                  ),
                ),
              ),


//--------------------------------Start Button---------------------------------//
      Padding(
      padding: const EdgeInsets.only(top: 50), // Adjust this value to move it down
      child: GestureDetector(
        onTap: () {
          // Play the click sound first
          final player2 = AudioPlayer(); // Create a new instance for each press
          player2.play(AssetSource('button_sound.mp3')).then((_)
          {
            // After playing the sound, handle navigation
            if (BLE_Connection().esp_device != null) {
              Future.delayed(const Duration(milliseconds: 200), () { // Small delay to ensure sound plays
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChoosingGame()),
                );
              });
            } else {
              Future.delayed(const Duration(milliseconds: 200), () {
                showAlert(
                  const ConnectPage(homescreen: MyHomePage(title: "")),
                  context,
                );
              });
            }
          }).catchError((error) {
            print("Error playing sound: $error"); // Handle errors gracefully
          });
        },
        child: Container(
          padding: const EdgeInsets.all(0), // Ensures image stays inside the border
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Ensures the image corners match the border
            child: Image.asset(
              'assets/play_button.png',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),

//---------------------------------Bluetooth Connection Page---------------------------------//
              GestureDetector(
                onTap: () {
                  final player2 = AudioPlayer();
                  player2.play(AssetSource('button_sound.mp3')); // Play sound instantly

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConnectPage(homescreen: MyHomePage(title: "")),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/settings_button.png',  // Replace with the correct image path
                  width: 200,  // Adjust as needed
                  height: 150,
                  fit: BoxFit.cover,  // Ensures the image scales properly
                ),
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
    
    var appState = context.watch<BLE_Connection>();
    Future.delayed(Duration.zero,() {
      asyncAlertBluetooth(const ConnectPage(homescreen: MyHomePage(title: "")), context);
      asyncAlertESPNNow(const ConnectPage(homescreen: MyHomePage(title: "")), context);
    });
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
//---------------------------------------------Game 1 & Game 2--------------------------------------------//
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
//----------------------------------------------Game 1 & Game 2 info----------------------------------//
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
//---------------------------------------Game 3 & Game 4-----------------------------//
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
//--------------------------------------Game 3 & Game 4 info--------------------------------------//
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
//------------------------------------------- Game 5 -----------------------------------------------------//
                           ElevatedButton(
                                    onPressed: () => {
                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const Game1Settings(homescreen: MyHomePage(title: ""),gameState: 5,)))
                                    }, 
                                      child: displayTextAndIcon(5, context, [10,10,46,46])),
//----------------------------------------- Game 5 info -------------------------------------------------//
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
