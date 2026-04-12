import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  
   // Request microphone and camera permissions before starting the app
  final statuses = await [Permission.microphone, Permission.camera].request();
  
  // Log permission status for debugging
  debugPrint('Microphone permission: ${statuses[Permission.microphone]}');
  debugPrint('Camera permission: ${statuses[Permission.camera]}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Stack(
          children: [ 
            Center( 
              child: YOLOView(
                modelPath: 'sustain_yolo11n_obb',
                task: YOLOTask.obb, // Specify the oriented bounding box task
                confidenceThreshold: 0.5,
                useGpu: false,
                showNativeUI: false,
                streamingConfig: const YOLOStreamingConfig.custom(
                  includeOBB: true, 
                  includeDetections: true, 
                  throttleInterval: Duration.zero
                ),
                lensFacing: LensFacing.back, // Use back camera
                onResult: (results) {
                  // next few lines for debugging
                  debugPrint('YOLO onResult called with ${results.length} results');
                  for (final result in results) {
                    debugPrint('Detected: ${result.className} with confidence ${result.confidence}');
                  }
                },
              ),
            ),
          ],
      )
    );
  }
}
