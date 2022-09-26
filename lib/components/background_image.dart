// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';


class BackgroundImage extends StatelessWidget {
  String name;
  BackgroundImage(
    this.name
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(name),
        ),
      ),
    );
  }
}
