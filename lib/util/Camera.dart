import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:money_mate/util/Popups.dart';

/// Initializes the camera, so that the user can take a picture,
/// which is then displayed on the [DisplayPictureScreen].
/// The user can decide if they would like to use the current picture or take a new one.
///
///Code by Dorian Zimmermann
class InitializeCamera extends StatefulWidget {
  const InitializeCamera({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  InitializeCameraState createState() => InitializeCameraState();
}

class InitializeCameraState extends State<InitializeCamera> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: SizedBox.expand(child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!mounted) return;

            Navigator.pop(context, image.path);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(uniformSnackBar("An error occurred. Please try again."));
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}