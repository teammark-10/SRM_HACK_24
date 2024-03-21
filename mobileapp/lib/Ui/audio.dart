import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../models/databaseMethods.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key, required this.subject});
  final subject;
  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final player = AudioPlayer();
  String url = '';
  Stream? notes;
  @override
  void initState() {
    DataBaseMethods().getNotes().then((val) {
      setState(() {
        notes = val;
      });
    });
    if (widget.subject == "Chemistry") {
      setState(() {
        url =
            'https://firebasestorage.googleapis.com/v0/b/studiesy.appspot.com/o/test%2FChemistry.mp3?alt=media&token=cede807b-7883-4247-a1a5-d01c74eb63b4&_gl=1*1se6257*_ga*NzcyOTg4NjkuMTY4MjEwNDExMw..*_ga_CW55HF8NVT*MTY5NjA1NDEyOC44Mi4xLjE2OTYwNTQ2MjcuNTguMC4w';
      });
    } else if (widget.subject == "Physics") {
      setState(() {
        url =
            'https://firebasestorage.googleapis.com/v0/b/studiesy.appspot.com/o/test%2FPhysics.mp3?alt=media&token=8bb0108e-f371-47dc-8d8f-99405b96394b&_gl=1*1cbah9s*_ga*NzcyOTg4NjkuMTY4MjEwNDExMw..*_ga_CW55HF8NVT*MTY5NjA1NDEyOC44Mi4xLjE2OTYwNTQ0NzEuMzguMC4w';
      });
    } else if (widget.subject == 'Mathematics') {
      setState(() {
        url =
            'https://firebasestorage.googleapis.com/v0/b/studiesy.appspot.com/o/test%2FMathematics.mp3?alt=media&token=9c63c255-6552-46bd-afe3-3746a062351f&_gl=1*1v6wlc2*_ga*NzcyOTg4NjkuMTY4MjEwNDExMw..*_ga_CW55HF8NVT*MTY5NjA1NDEyOC44Mi4xLjE2OTYwNTQ1NTAuNjAuMC4w';
      });
    } else {
      setState(() {
        url =
            'https://firebasestorage.googleapis.com/v0/b/studiesy.appspot.com/o/test%2FEnglish.mp3?alt=media&token=a1d6cfb5-02c0-4252-a1ac-bf278af0c723&_gl=1*azjmr8*_ga*NzcyOTg4NjkuMTY4MjEwNDExMw..*_ga_CW55HF8NVT*MTY5NjA1NDEyOC44Mi4xLjE2OTYwNTQ1ODIuMjguMC4w';
      });
    }

    print(url);
    super.initState();
  }

  bool isPlaying = false;
  bool isLoading = false;

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8070eb),
      body: SafeArea(
        child: Column(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Press Button to hear Audio of the Summary',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Color.fromARGB(255, 243, 239, 239),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: ElevatedButton(
                onPressed: () {
                  togglePlayPause();
                  if (isPlaying) {
                    playMusic(url);
                  } else {
                    player.pause();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isLoading)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    else if (!isLoading && isPlaying)
                      const Icon(
                        Icons.pause,
                        size: 50.0,
                      )
                    else
                      const Icon(
                        Icons.play_arrow,
                        size: 50.0,
                      ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Please wait, your audio is loading',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> playMusic(String url) async {
    setState(() {
      isLoading = true; // Set loading to true while loading the audio
    });
    await player.play(UrlSource(url));
    setState(() {
      isLoading = false; // Set loading to false after loading the audio
    });
  }
}
