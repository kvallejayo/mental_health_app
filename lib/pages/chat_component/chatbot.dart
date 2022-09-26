// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBotPage> {
  TextEditingController messageFieldController = TextEditingController();
  final messsages = List<Map>.filled(1, {"data": 0, "message": "Buenos Días"}, growable: true);

  Future<void> getBotResponse(message) async {

    /*
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/jsons/chatbot_secret.json").build();
    Dialogflow dialogflow = Dialogflow(
      authGoogle: authGoogle,
      language: Language.spanishLatinAmerica,
    );

    print("antes de respuesta");
    AIResponse aiResponse = await dialogflow.detectIntent(message);
    print("despues de respuesta");
    print(aiResponse.getListMessage());

    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
    print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());

     */

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat bot",
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                "Today, ${DateFormat("Hm").format(DateTime.now())}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: messsages.length,
                itemBuilder: (context, index) => chat(
                    messsages[index]["message"].toString(),
                    messsages[index]["data"],
                ),
              ),
            ),

            SizedBox(height: 20,),

            Divider(
              height: 5.0,
              color: Colors.greenAccent,
            ),
            Container(
              child: ListTile(
                leading: IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.greenAccent,
                    size: 35,
                  ),
                ),
                title: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1),
                  ),
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: messageFieldController,
                    decoration: InputDecoration(
                      hintText: "Enter a Message...",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: (value) {},
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.send,
                    size: 30.0,
                    color: Colors.greenAccent,
                  ),
                  onPressed: () async {
                    if (messageFieldController.text.isNotEmpty) {
                      await getBotResponse(messageFieldController.text);
                      setState(() {
                        messsages.insert(0, {"data": 1, "message": messageFieldController.text});
                      });
                      messageFieldController.clear();
                      log(messsages.toString());
                    }
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 15.0,)
          ],
        ),
      ),
    );
  }

  //for better one i have use the bubble package check out the pubspec.yaml

  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0 ? Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/icons/bot.png"),
            ),
          ) : Container(),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: Bubble(
              radius: Radius.circular(15.0),
              color: data == 0 ? Color.fromRGBO(23, 157, 139, 1) : Colors.orangeAccent,
              elevation: 0.0,
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data == 1 ? Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage("assets/usuario.png"),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
