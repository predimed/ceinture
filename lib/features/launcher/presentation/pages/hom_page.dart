import 'dart:async';

import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/features/launcher/presentation/pages/device_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: primaryColor,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container()

              ),
            ),
            Expanded(
                flex: 10,
                child: Text(
                  translationsUtils.text("app_name"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                )),
          ],
        ),
        backgroundColor: primaryColor,
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(withDevices:[new Guid("0000fff0-0000-1000-8000-00805f9b34fb")],
                timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data.where((element) => element.type==BluetoothDeviceType.le)
                      .map((d) =>  GestureDetector(
                    onTap: () async {
                      //widget.stopScan();
                      await Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  DeviceDetailPage(device: d)));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      color: Colors.grey[200],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            color: selectMenuColor,
                            padding: EdgeInsets.all(5),
                            height: 40,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                d.name,style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.bluetooth, color: selectMenuColor,),
                                      )),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text('${d.id}'),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(Icons.cloud_done, color: selectMenuColor,),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data.where((element) => element.device.type == BluetoothDeviceType.le)
                      .map(
                        (r) {
                          print("the data ==========###################      ${r.advertisementData.toString().toString()}");
                          return GestureDetector(
                            onTap: () async {
                              //widget.stopScan();
                              await Navigator.push<void>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          DeviceDetailPage(device: r.device)));
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              color: Colors.grey[200],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    color: Colors.grey[400],
                                    padding: EdgeInsets.all(5),
                                    height: 40,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        r.device.name,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              padding: EdgeInsets.all(5),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(Icons.bluetooth),
                                              )),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text('${r.device.id}'),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(Icons.cloud_off),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        },
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(
                  Icons.search,
                  color: primaryColor,
                ),
                onPressed: () => FlutterBlue.instance
                    .startScan( withDevices:[new Guid("0000fff0-0000-1000-8000-00805f9b34fb")],
                    timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}
