// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyInputField extends StatefulWidget {
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final Color backgroundColor;
  final Color borderColor;
  final Color labelColor;
  final bool isPasswordField;
  late bool obscureText;
  final bool enabled;
  final bool hintInsteadOfLabel;

  MyInputField({
    Key? key,
    this.labelText,
    required this.controller,
    this.inputType = TextInputType.text,
    this.backgroundColor = const Color(0xFFE8E3EE),
    this.borderColor = const Color(0xFF7115D3),
    this.labelColor = const Color(0xFF9996B7),
    this.isPasswordField = false,
    this.obscureText = false,
    this.enabled = true,
    this.hintInsteadOfLabel = false,
  }) : super(key: key);

  @override
  State<MyInputField> createState() => _MyInputFieldState();
}

class _MyInputFieldState extends State<MyInputField> {
  late Widget suffixIcon;

  @override
  void initState() {
    if (widget.isPasswordField){
      widget.obscureText = true;
    }
    super.initState();
    widget.controller?.addListener(() {setState(() {});});
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isPasswordField && widget.enabled){
      suffixIcon = IconButton(
        icon: widget.obscureText ? Icon(Icons.visibility, color: widget.borderColor)
            : Icon(Icons.visibility_off, color: widget.borderColor,),
        onPressed: (){
          setState(() {
            widget.obscureText = !widget.obscureText;
          });
        },
      );
    } else {
      suffixIcon = widget.controller!.text.isEmpty ? Container(width: 0,): IconButton(
        icon: Icon(Icons.close, color: widget.borderColor,),
        onPressed: (){ widget.controller?.clear(); },
      );
    }

    return TextField(
      enabled: widget.enabled,
      keyboardType: widget.inputType,
      controller: widget.controller,
      obscureText: widget.isPasswordField && !widget.enabled ? true : widget.obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        fillColor: widget.enabled ? widget.backgroundColor : Colors.white,
        filled: true,
        labelText: !widget.hintInsteadOfLabel ? widget.labelText : null,
        labelStyle: TextStyle(
          color: widget.labelColor,
          fontSize: 18,
        ),
        hintText: widget.hintInsteadOfLabel ? widget.labelText : null,
        hintStyle: TextStyle(
          color: widget.labelColor,
          fontSize: 18,
        ),
        suffixIcon: widget.enabled ? suffixIcon : SizedBox(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 2,
            color: widget.borderColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 2,
            color: widget.borderColor,
          ),
        ),
      ),
    );
  }
}
