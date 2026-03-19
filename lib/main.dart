import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String aglVersion = "Loading...";
  bool showImage = false;
  final String name = "Harshit Agarwal";

  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  Future<void> loadVersion() async {
    try {
      final file = File('/etc/os-release');
      if (await file.exists()) {
        final content = await file.readAsString();

        final lines = content.split('\n');
        final versionLine = lines.firstWhere(
          (l) => l.startsWith('VERSION='),
          orElse: () => '',
        );

        setState(() {
          aglVersion = versionLine.isNotEmpty
              ? versionLine.split('=')[1].replaceAll('"', '')
              : "Unknown";
        });
      } else {
        setState(() {
          aglVersion = "File not found";
        });
      }
    } catch (e) {
      setState(() {
        aglVersion = "Error reading";
      });
    }
  }

  Future<void> playSound() async {
    await player.play(AssetSource('sound.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("AGL Demo App")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "AGL Version: $aglVersion",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text("Name: $name", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showImage = !showImage;
                  });
                },
                child: const Text("Show Image"),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: playSound,
                child: const Text("Play Sound"),
              ),

              const SizedBox(height: 20),

              if (showImage) Image.asset('assets/agl.webp', width: 200),
            ],
          ),
        ),
      ),
    );
  }
}
