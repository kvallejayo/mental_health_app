// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/models/Affimation.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';

import '../../themes/my_colors.dart';
import '../../utils/endpoints.dart';

class ModifyAffirmation extends StatefulWidget {

  DataBaseHelper dataBaseHelper = DataBaseHelper();
  final String userId;
  Affirmation affirmation;

  ModifyAffirmation({
    Key? key,
    required this.userId,
    required this.affirmation,
  }) : super(key: key);

  @override
  State<ModifyAffirmation> createState() => _ModifyAffirmationState();
}

class _ModifyAffirmationState extends State<ModifyAffirmation> {
  TextEditingController affirmationNewMessage = TextEditingController();

  @override
  void initState(){
    affirmationNewMessage.text = widget.affirmation.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(child: BackgroundImage('assets/2.jpg')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TitleHeader("Afirmaciones"),
                    H1Label("Modificar afirmación"),
                    ModifyAffirmationMessageField(),
                    H1Label("Afirmaciones recomendadas"),
                    ListContainer()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ModifyAffirmationMessageField() {
    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
          ],
          color: Color.fromRGBO(226, 238, 239, 10),
          borderRadius: BorderRadius.circular(9.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: affirmationNewMessage,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      focusColor: const Color.fromRGBO(146, 150, 187, 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(232, 227, 238, 10),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 3, color: Colors.red),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3,),

            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(104, 174, 174, 6),),
                ),
                child: Text(
                  "MODIFICAR AFIRMACIÓN",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  final username = await UserSecureStorage.getUsername() ?? '';
                  final password = await UserSecureStorage.getPassword() ?? '';
                  widget.affirmation.message = affirmationNewMessage.text;

                  Affirmation? updatedAffirmation = await widget.dataBaseHelper.updateAffirmation(
                    widget.userId,
                    username,
                    password,
                    widget.affirmation,
                  );

                  Alert(
                    context: context,
                    type: updatedAffirmation != null ? AlertType.success : AlertType.error,
                    title: updatedAffirmation != null ? "MODIFICACIÓN EXITOSA" : "MODIFICACIÓN FALLIDA",
                    desc: updatedAffirmation != null ? "¡Se modificó su afirmación!" : "Oops! Hubo un error.",
                    buttons: [
                      DialogButton(
                        width: 120,
                        color: waterGreen,
                        child: Text(
                          "Aceptar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ).show();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
        color: Color.fromRGBO(107, 174, 174, 10), shape: BoxShape.circle);
  }

  BoxDecoration timeBoxDecoration() {
    return BoxDecoration(
      color: Color.fromRGBO(107, 174, 174, 10),
      borderRadius: BorderRadius.circular(25),
    );
  }

  Widget ListContainer() {
    List<String> favorites = [
      '"Yo estoy feliz con quien soy aqui y ahora."',
      '"Celebraré cada meta que logre con gratitud y alegría."',
      '"Soy feliz y libre porque en el viaje."',
      '"Soy capaz. Tengo potencial para triunfar."',
      '"Creo en un mundo libre de estrés para mi."',
      '"Mi ansiedad no controla mi vida. Yo la controlo."',
      '"Todo va a estar bien."'
    ];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 3)
        ], color: Colors.white, borderRadius: BorderRadius.circular(9.0)),
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              for (int i = 0; i < favorites.length; i++)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.favorite,
                          color: Color.fromRGBO(219, 167, 138, 10),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          favorites[i].toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


}


