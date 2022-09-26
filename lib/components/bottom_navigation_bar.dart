// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../pages/graph_component/graphs.dart';
import '../pages/home.dart';
import '../pages/learn_component/learn.dart';
import '../pages/profile.dart';
import '../pages/chat_with_mindy.dart';

class BottomNavigation extends StatefulWidget {
  final String idSend;

  bool isTheSameHome;
  bool homeColorIcon;

  bool isTheSameLearn;
  bool learnColorIcon;

  bool isTheSameQuiz;
  bool quizColorIcon;

  bool isTheSameGraph;
  bool graphColorIcon;

  bool isTheSameProfile;
  bool profileColorIcon;

  bool isTheSameChatMindy;
  bool mindyColorIcon;

  BottomNavigation({
    required this.idSend,
    this.isTheSameHome = false,
    this.homeColorIcon = true,
    this.isTheSameLearn = false,
    this.learnColorIcon = true,
    this.isTheSameQuiz = false,
    this.quizColorIcon = true,
    this.isTheSameGraph = false,
    this.graphColorIcon = true,
    this.isTheSameProfile = false,
    this.profileColorIcon = true,
    this.isTheSameChatMindy = false,
    this.mindyColorIcon = true,
  });


  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  var routes = ['/home', '/learn', '/chatbot', '/graph', '/profile'];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color.fromRGBO(254, 246, 238, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Image.asset(
              widget.homeColorIcon ? 'assets/icons/home gray.png' : 'assets/icons/home action.png',
              scale: 10,
            ),
            color: widget.homeColorIcon ? null : Colors.lightGreenAccent,
            splashColor: Color.fromRGBO(67, 58, 108, 10),
            onPressed: () {
              widget.isTheSameHome ? null : Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage(widget.idSend))
              ).then((value) => setState(() {}));
            },
          ),
          IconButton(
            icon: Image.asset(
              widget.learnColorIcon ? 'assets/icons/info gray.png' : 'assets/icons/info action.png',
              scale: 10,
            ),
            color: widget.homeColorIcon ? null : Colors.lightGreenAccent,
            splashColor: Color.fromRGBO(67, 58, 108, 10),
            onPressed: () {
              widget.isTheSameLearn ? null : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LearnPage(widget.idSend),
                ),
              ).then((value) => setState(() {}));
            },
          ),

          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Image.asset(
                widget.quizColorIcon ? 'assets/icons/bot_button.png' : 'assets/icons/bot_button_selected.png',
                scale: 5,
              ),
              constraints: BoxConstraints(minWidth: 100, minHeight: 52.5, maxWidth: double.infinity),
              onPressed: () {

                widget.isTheSameChatMindy ? null : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatWithMindy(userId: widget.idSend,),
                  ),
                );

                /*

                dynamic user = {
                  'userId': widget.idSend, //Replace it with the userId of the logged in user
                  'password': 'secret' //Put password here if user has password, ignore otherwise
                };

                dynamic conversationObject = {
                  'appId': 'sdfgfdgdfg',// The APP_ID obtained from kommunicate dashboard.
                };
                KommunicateFlutterPlugin.buildConversation({})
                    .then((clientConversationId){
                      print("Conversation builder success : " + clientConversationId.toString());
                    })
                    .catchError((error) {
                      print("Conversation builder error : " + error.toString());
                    });

                 */
              },
            ),
          ),

          IconButton(
            icon: Image.asset(
              widget.graphColorIcon ? 'assets/icons/graphics gray.png' : 'assets/icons/graphics action.png',
              scale: 10,
            ),
            color: widget.homeColorIcon ? null : Colors.lightGreenAccent,
            splashColor: Color.fromRGBO(67, 58, 108, 10),
            onPressed: () {
              widget.isTheSameGraph ? null : Navigator.push(context, MaterialPageRoute(builder: (context) => GraphPage(widget.idSend))).then((value) => setState(() {}));
            },
          ),
          IconButton(
            icon: Image.asset(
              widget.profileColorIcon ? 'assets/icons/profile.png' : 'assets/icons/profile action.png',
              scale: 10,
            ),
            color: widget.homeColorIcon ? null : Colors.lightGreenAccent,
            splashColor: Color.fromRGBO(67, 58, 108, 10),
            onPressed: () {
              widget.isTheSameProfile ? null : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: widget.idSend,),
                ),
              ).then((value) => setState(() {}));
            },
          ),
        ],
      ),
    );
  }
}
