// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final picker = ImagePicker();

  List<String> events = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    events.add(state.toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return FGBGNotifier(
      onEvent: (event) {
        events.add(event.toString());
        setState(() {});
      },
      child: MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        events.clear();
                        setState(() {});
                      },
                      child: const Text("Clear"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        events.add("// Opening camera");
                        setState(() {});
                        await picker.pickImage(source: ImageSource.camera);
                      },
                      child: const Text("Take Image"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        events.add("// Opening gallery");
                        setState(() {});
                        await picker.pickImage(source: ImageSource.gallery);
                      },
                      child: const Text("Pick Image"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        events.add("// Prompting biometric");
                        setState(() {});
                        var auth = LocalAuthentication();

                        await auth.authenticate(
                            options: const AuthenticationOptions(
                              stickyAuth: true,
                            ),
                            localizedReason: 'Test');
                      },
                      child: const Text("FaceID"),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [for (var e in events) Text(e)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
