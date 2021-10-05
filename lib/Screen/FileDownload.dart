import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;
import 'package:creditscore/Common/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
const debug = true;
class FileDownload extends StatefulWidget {
  const FileDownload({Key key}) : super(key: key);

  @override
  _FileDownloadState createState() => _FileDownloadState();
}

class _FileDownloadState extends State<FileDownload> {

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);

    super.initState();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }
  void _bindBackgroundIsolate() {
    bool isSuccess = ui.IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
    });
  }
  void _unbindBackgroundIsolate() {
    ui.IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    ui.IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
  Future<String> _findLocalPath() async {
    final platform = Theme.of(context).platform;
    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss:a').format(dateTime);
  }
  Future<void> requestDownload(String _url, String _name) async {
    final dir = await getApplicationDocumentsDirectory();
//From path_provider package
    String _localPath =
        (await _findLocalPath()) + Platform.pathSeparator + 'My Badge';

    final savedDir = Directory(_localPath);
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    await savedDir.create(recursive: true).then((value) async {
      String _taskid = await FlutterDownloader.enqueue(
        url: _url,
        fileName: "RAM"+ "_" + _name + "_" + formattedDateTime + ".pdf",
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true,
      );
      print("ram123" + _taskid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: SafeArea(child:
      Scaffold(body: Container(child:Column(children: [
        SizedBox(height: 200,),
        Center(child:Container(
          height: 50.0,
          alignment: Alignment.center,

          child: RaisedButton(
            onPressed: () async {
              requestDownload('http://darwinlogic.com/uploads/education/iOS_Programming_Guide.pdf', "My Badge");
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            padding: EdgeInsets.all(0.0),
            color: Rmpick,
            splashColor: Rmpick,
            elevation: 10,
            child: Ink(
              decoration: BoxDecoration(
                //color: Color(0xff0066ff),
                  gradient: LinearGradient(
                    colors: [
                      Rmlightblue,
                      Rmpick,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                alignment: Alignment.center,

                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      "Download",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    Spacer(),
                    Card(
                      //color: Color(0xCDA3C5EC),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0)),
                      child: SizedBox(
                        width: 35.0,
                        height: 35.0,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Rmpick,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),)
      ],),)),),);
  }
}
