import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage>
    with SingleTickerProviderStateMixin {

      int secondes = 0;
      int minute = 0;
      bool status = false;  
      Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.1),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              record();
            }, 
            icon: const Icon(Icons.mic, size: 40, color: Colors.red)
          )
        ],
      ),
      body: SizedBox(),
    );
  }

  void startTimer({required void Function(void Function()) setState}) {

    timer = Timer.periodic(const Duration(seconds: 1), (seconde) {
      if(status) {
        setState(() {
          secondes= secondes+1;
          if(secondes == 60) {
            minute++;
            secondes = 0;
          }
        });
      }
    });
  }

  // String formatTime(int seconde) {
  //   int minutes = secondes 
  // }
  
  Future<void> record() async {

    var audio = AudioRecorder();

    var patht = await getTemporaryDirectory();

    secondes = 0;
    minute = 0;

    await Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {

          return Container(
          height: MediaQuery.of(context).size.height/1.5,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
            ),
            
          ),
          child: Column(
            children: [
              createText(
                text: "Dictaphone",
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
              createText(
                text: "utiliser votre microphone", 
                fontSize: 14
              ),
        
              Padding(
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.red
                        )
                      ),
                    ),
        
                    Positioned(
                      top: 10,
                      right: 10,
                      bottom: 10,
                      left: 10,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.red
                          )
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () async {
                              
                              setState(() {
                                status = !status;
                              });

        
                              if(await audio.hasPermission()) {
                                if(status) {
                                  startTimer(setState: setState);
                                  await audio.start(const RecordConfig(), path: "$patht/audio.m4a");
                                } else {
                                  await audio.pause();
                                }
                              } else {
        
                              }
                            },
                            icon: Icon(
                              status ? Icons.pause:Icons.play_arrow,
                              size: 40, 
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
        
              createText(
                text: "${minute.toString().padLeft(2, '0')}:$secondes",
                fontSize: 14
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    var path = await audio.stop();
                    timer!.cancel();
        
                    print(path);
                  }, 
                  child: Text(
                    "Enregistrer",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                  )
                ),
              )
            ],
          ),
        );
        },
      )
    );
  }
  
  createText({required String text, required double fontSize, FontWeight? fontWeight}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight
        ),
      ),
    );
  }
}