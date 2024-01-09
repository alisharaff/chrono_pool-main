import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/applocal.dart';
import '../components/shared_pref_helper.dart';
import '../controller/settings_controller.dart';
import '../controller/timer.dart';
import '../model/score.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<CountdownTimerState> countdownKey =
      GlobalKey<CountdownTimerState>();
  GlobalKey<CountdownTimer2State> countdownKey2 =
      GlobalKey<CountdownTimer2State>();

  bool isTimerRunning = false;
  bool isTimerRunningMinu = false;

  bool isFirstTap = true;
  int timeMinutes = 0;
  @override
  void initState() {
    super.initState();
    getValueFromSharedPreferences2();
    isFirstTap = true;
    isTimerRunningMinu = false;
  }

  Future<int> getStoredData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedData =
        prefs.getInt(key) ?? 0; // Default value is 0 if the key doesn't exist
    return storedData;
  }

  Future<void> getValueFromSharedPreferences2() async {
    timeMinutes = await getStoredData(DataType.MATCH_TIME.name);
    setState(() {});
    print(timeMinutes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const Icon(Icons.logo_dev),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed("/Settings");
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 65.0,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onDoubleTap: isFirstTap
                        ? () {
                            countdownKey.currentState?.updateTimerValue();
                            setState(() {
                              isFirstTap = false;
                            });
                          }
                        : null,
                    child: Center(
                      child: Text(
                        "${getLang(context, "extention")}",
                        style: TextStyle(
                            fontSize: 30,
                            color: isFirstTap ? Colors.blue : Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FutureBuilder<String?>(
                  future: SharedPreferencesHelper.getPlayer1Name(),
                  builder: (context, snapshot) {
                    String player1Name = snapshot.data ?? 'Player 1';
                    return Text(
                      "$player1Name  ${context.watch<Score>().player1Score ?? 0}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  },
                ),
                const Spacer(),
                FutureBuilder<String?>(
                  future: SharedPreferencesHelper.getPlayer2Name(),
                  builder: (context, snapshot) {
                    String player2Name = snapshot.data ?? 'Player 2';
                    return Text(
                      "$player2Name  ${context.watch<Score>().player2Score ?? 0}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  },
                ),
              ],
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isTimerRunning) {
                    isTimerRunning = false;
                    countdownKey.currentState?.stopTimer();
                    //countdownKey2.currentState?.stopTimer();
                  } else {
                    isTimerRunning = true;
                    countdownKey.currentState?.startTimer();
                  }
                  if (isTimerRunningMinu == false) {
                    countdownKey2.currentState?.startTimer();
                    isTimerRunningMinu = true;
                  }
                });
              },
              onDoubleTap: () {
                setState(() {
                  isFirstTap = true;
                  isTimerRunning = false;
                  countdownKey.currentState?.resetTimer();
                });
              },
              child: Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${getLang(context, "match_time")}: ",
                            style: const TextStyle(color: Colors.white)),
                        CountdownTimer2(key: countdownKey2),
                      ],
                    ),
                    CountdownTimer(
                        key: countdownKey, isRunning: isTimerRunning),
                  ],
                ),
              ),
            ),
          ),
          Image.network(
            'https://upload.wikimedia.org/wikipedia/fr/b/b2/Logo_Parcs_nationaux_de_France.png',
            height: 150.0,
          )
        ],
      ),
    );
  }
}
