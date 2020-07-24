import 'package:ceinture/core/helpers/ble/ble_device_connector.dart';
import 'package:ceinture/core/helpers/ble/ble_scanner.dart';
import 'package:ceinture/core/helpers/ble/ble_status_monitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ceinture/core/helpers/database_helper.dart';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/features/launcher/presentation/pages/launch_page.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await translationsUtils.init();

  final _ble = FlutterReactiveBle();
  final _scanner = BleScanner(_ble);
  final _monitor = BleStatusMonitor(_ble);
  final _connector = BleDeviceConnector(_ble);
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        StreamProvider<BleScannerState>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => _connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
      ],
      child:MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    DatabaseHelper.initDb();
    super.initState();
    translationsUtils.onLocaleChangedCallback = _onLocaleChanged;
  }

  _onLocaleChanged() async {
    // do anything you need to do if the language changes
    print('Language has been changed to: ${translationsUtils.currentLanguage}');
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Ceinture App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/splash': (context) => SplashPage(),

      },
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.pink[800], //Changing this will change the color of the TabBar
          accentColor: Colors.cyan[600],
          primarySwatch: Colors.blue,
          textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Montserrat',
              bodyColor: primaryColor,
              fontSizeFactor: 0.9,
              fontSizeDelta: 2.0,
              displayColor: primaryColor)),
      //home: SplashPage(),
    );
  }
}
