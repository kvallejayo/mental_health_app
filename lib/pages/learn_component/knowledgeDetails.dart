// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mental_health_app/Components/background_image.dart';
import 'package:mental_health_app/Components/my_labels.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/bottom_navigation_bar.dart';
import '../../themes/my_colors.dart';

class KnowledgeDetails extends StatefulWidget {
  final String userId;
  final Map<String,dynamic> knowledgeInfo;
  const KnowledgeDetails({Key? key, required this.userId, required this.knowledgeInfo}) : super(key: key);

  @override
  State<KnowledgeDetails> createState() => _KnowledgeDetailsState();
}

class _KnowledgeDetailsState extends State<KnowledgeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage('assets/fondos/info.png'),
            SingleChildScrollView(
              child: Column(
                children: [
                  TitleHeader("Aprender algo nuevo"),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        H1Label(widget.knowledgeInfo["title"]),
                        mindyMessage(
                          content: Text(widget.knowledgeInfo["concept"]),
                        ),
                        widget.knowledgeInfo["moreInfo"] == "" ? SizedBox() : Column(
                          children: [
                            H1Label("Más información"),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(widget.knowledgeInfo["moreInfo"],),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        widget.knowledgeInfo["image"] == "" ? SizedBox() : Image.asset(
                          widget.knowledgeInfo["image"],
                          width: 180,
                        ),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Video:",
                            style: TextStyle(
                              color: Color(0xFF9296BB),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        widget.knowledgeInfo["videoButtonImg"] == "" ? SizedBox() : GestureDetector(
                          child: Image.asset(
                            widget.knowledgeInfo["videoButtonImg"],
                          ),
                          onTap: () async {
                            final url = Uri.parse(widget.knowledgeInfo["video"]);
                            if (!await launchUrl(url)) {
                              Fluttertoast.showToast(
                                msg: 'Error de conexion con $url',
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        isTheSameLearn: true,
        learnColorIcon: false,
        idSend: widget.userId,
      ),
    );
  }

  Widget mindyMessage({required Widget content}){
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 250,
              decoration: BoxDecoration(
                color: lightWaterGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: content,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset("assets/bot_emocionado.png", width: 100,),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mindy",
                    style: TextStyle(
                      color: Color(0xFF7C7C88),
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
