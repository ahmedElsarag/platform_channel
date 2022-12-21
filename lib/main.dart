import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Platform channel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const batteryChannel = MethodChannel('elsarag.batteryLevel');
  String batteryLevel = '....';
  String isCharging = '....';
  String chargingMethod = '.....';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(
              'Battery level is: $batteryLevel',
            ),
            const SizedBox(height: 20,),
            Text(
              'Battery status: $isCharging',
            ), const SizedBox(height: 20,),
            Text(
              'charging method: $chargingMethod',
            ),
            ElevatedButton(onPressed: (){
                getBatteryLevel();
                getChargingStatus();
                getChargingMethod();
            }, child: const Text('Get battery level'))
          ],
        ),
      ),
    );
  }

  Future getBatteryLevel()async{
    try{
      String result = await batteryChannel.invokeMethod('getBatteryLevel');
      setState(() {
        batteryLevel = result.toString();
      });
    }on PlatformException catch(e){
      batteryLevel = "Failed to get battery level: ${e.message}";
    }

  }

  Future getChargingStatus() async{
    try{
      bool result = await batteryChannel.invokeMethod('getChargingStatus');
      setState(() {
        isCharging = result?'charging':'not charging';
      });

    }on PlatformException catch(e){
      isCharging = "failed to get status";
    }
  }

  Future getChargingMethod() async{
    try{
      String result = await batteryChannel.invokeMethod('getChargingMethod');
      setState(() {
        chargingMethod = result;
      });

    }on PlatformException catch(e){
      isCharging = "failed to get method";
    }
  }
}
