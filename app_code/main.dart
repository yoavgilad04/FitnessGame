import 'package:flutter/material.dart';
import 'BLE.dart';
import 'Setting.dart';
import 'functions.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'game1.dart';
import 'game2.dart';
import 'game3.dart';
import 'game4.dart';
import 'game5.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  void initState() {
    super.initState();
    initAudio();
    WidgetsBinding.instance.addObserver(this);
    stopBackgroundMusic(bgMusicPlayer);
    stopBackgroundMusic(gameMusicPlayer);
    playBackgroundMusic(bgMusicPlayer);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      BLE_Connection().disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<BLE_Connection>();
    Future.delayed(Duration.zero, () {
      asyncAlertESPNNow(const ConnectPage(homescreen: MyHomePage(title: "")), context);
    });

    return Scaffold(
      body: backgroundGradient(
        Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(flex: 2),

                  // -----------------------------------Image Logo--------------------------------//
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
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/Game_Logo_2.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),

                  // --------------------------------Start Button---------------------------------//
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: GestureDetector(
                      onTap: () {
                        final player2 = AudioPlayer();
                        player2.play(AssetSource('button_sound.mp3')).then((_) {
                          if (BLE_Connection().esp_device != null) {
                            Future.delayed(const Duration(milliseconds: 200), () {
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
                          print("Error playing sound: $error");
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
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

                  // ---------------------------------Bluetooth Connection Page---------------------------------//
                  GestureDetector(
                    onTap: () {
                      final player2 = AudioPlayer();
                      player2.play(AssetSource('button_sound.mp3'));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConnectPage(homescreen: MyHomePage(title: "")),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/settings_button.png',
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),

            // 🔊 Speaker Icon - Bottom Right Corner
            Positioned(
              bottom: 20,
              right: 20,
              child: IconButton(
                icon: Icon(
                  isMute ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    if (!isMute) {
                      stopBackgroundMusic(bgMusicPlayer);
                      stopBackgroundMusic(gameMusicPlayer);
                      isMute = !isMute;
                    } else {
                      isMute = !isMute;
                      playBackgroundMusic(bgMusicPlayer);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChoosingGame extends StatelessWidget {
  const ChoosingGame({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<BLE_Connection>();
    Future.delayed(Duration.zero, () {
      asyncAlertBluetooth(const ConnectPage(homescreen: MyHomePage(title: "")), context);
      asyncAlertESPNNow(const ConnectPage(homescreen: MyHomePage(title: "")), context);
    });
    return Scaffold(
      body: backgroundGradient(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            homeIcon(const MyHomePage(title: ""), context),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Choose Your\n Game : ",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 45),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Column(children: [
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Game1Settings(homescreen: MyHomePage(title: ""), gameState: 1),
                                  )
                              )
                            },
                            child: displayTextAndIcon(1, context, [10, 10, 4, 4]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 10),
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Game2Settings(homescreen: MyHomePage(title: "")),
                                  )
                              )
                            },
                            child: displayTextAndIcon(2, context, [10, 10, 8.5, 8.5]),
                          ),
                        ),
                      ]),
                      Row(children: [
                        const Spacer(flex: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 60),
                          child: IconButton(
                            iconSize: 35,
                            onPressed: () {
                              gameExp(1, context);
                            },
                            icon: const Icon(Icons.info),
                          ),
                        ),
                        const Spacer(flex: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 60),
                          child: IconButton(
                            iconSize: 35,
                            onPressed: () {
                              gameExp(2, context);
                            },
                            icon: const Icon(Icons.info),
                          ),
                        ),
                        const Spacer(flex: 5),
                      ]),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Game3Settings(homescreen: MyHomePage(title: "")),
                                  )
                              )
                            },
                            child: displayTextAndIcon(3, context, [10, 10, 8, 8]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 10),
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Game4Settings(homescreen: MyHomePage(title: "")),
                                  )
                              )
                            },
                            child: displayTextAndIcon(4, context, [10, 10, 32.5, 32.5]),
                          ),
                        ),
                      ]),
                      Row(children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: IconButton(
                            iconSize: 35,
                            onPressed: () {
                              gameExp(3, context);
                            },
                            icon: const Icon(Icons.info),
                          ),
                        ),
                        const Spacer(flex: 2),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: IconButton(
                            iconSize: 35,
                            onPressed: () {
                              gameExp(4, context);
                            },
                            icon: const Icon(Icons.info),
                          ),
                        ),
                        const Spacer(),
                      ]),
                      ElevatedButton(
                        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Game1Settings(homescreen: MyHomePage(title: ""), gameState: 5),
                              )
                          )
                        },
                        child: displayTextAndIcon(5, context, [10, 10, 46, 46]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: IconButton(
                          iconSize: 35,
                          onPressed: () {
                            gameExp(5, context);
                          },
                          icon: const Icon(Icons.info),
                        ),
                      ),
                    ]),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
