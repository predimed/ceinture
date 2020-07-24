import 'package:ceinture/core/helpers/ble/ble_scanner.dart';
import 'package:ceinture/features/launcher/presentation/widgets/device_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/core/utils/utils.dart';
import 'package:flutter_blue/flutter_blue.dart' as fl;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {

  fl.FlutterBlue flutterBlue = fl.FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {
loadDevice() ;
return Consumer2<BleScanner, BleScannerState>(
      builder: (_, bleScanner, bleScannerState, __) => DeviceListWidget(
        scannerState: bleScannerState,
        startScan: bleScanner.startScan,
        stopScan: bleScanner.stopScan,
      ),
    );
  }


  void loadDevice(){

// Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

// Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (fl.ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

// Stop scanning
    flutterBlue.stopScan();
  }

}