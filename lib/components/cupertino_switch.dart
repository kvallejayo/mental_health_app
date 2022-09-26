import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoSwitchComponent extends StatefulWidget {
  bool _switchValue1;
  bool _switchValue2;
  bool _switchValue3;
  CupertinoSwitchComponent(
      [this._switchValue1=true,
      this._switchValue2=true, 
      this._switchValue3=true]);
  @override
  State<CupertinoSwitchComponent> createState() =>
      _CupertinoSwitchComponentState();
}

class _CupertinoSwitchComponentState extends State<CupertinoSwitchComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
          ],
          color: Color.fromRGBO(226, 238, 239, 10),
          borderRadius: BorderRadius.circular(9.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Incluir afirmaciones random",
                  style: TextStyle(fontSize: 18),
                ),
                CupertinoSwitch(
                  value: widget._switchValue1,
                  onChanged: (value) {
                    setState(() {
                      widget._switchValue1 = value;
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Incluir afirmaciones favoritas",
                  style: TextStyle(fontSize: 18),
                ),
                CupertinoSwitch(
                  value: widget._switchValue2,
                  onChanged: (value) {
                    setState(() {
                      widget._switchValue2 = value;
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recibir afirmaciones diarias",
                  style: TextStyle(fontSize: 18),
                ),
                CupertinoSwitch(
                  value: widget._switchValue3,
                  onChanged: (value) {
                    setState(() {
                      widget._switchValue3 = value;
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: myBoxDecoration(),
                          child: Text("L",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white))),
                      // ignore: prefer_const_constructors
                      Text(
                        "M",
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: myBoxDecoration(),
                          child: Text("M",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white))),
                      Text(
                        "J",
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: myBoxDecoration(),
                          child: Text("V",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white))),
                      Text(
                        "S",
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: myBoxDecoration(),
                          child: Text("D",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white))),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(8.0),
                  decoration: timeBoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "07:15 AM",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.timer,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                )
              ],
            )
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
}
