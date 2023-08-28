import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {

  const TextFieldWidget({
    super.key,
    required this.maxLine,
    required this.hintText,
    required this.txtController,
    
  });

  final String hintText;
  final int maxLine;
  final TextEditingController txtController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.grey.shade200,borderRadius: BorderRadius.circular(8)),
      child:TextField(
        
        controller: txtController,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText),
          maxLines: maxLine,
          
        
      ));
  }
}