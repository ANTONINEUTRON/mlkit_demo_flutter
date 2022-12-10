import 'package:flutter/material.dart';

class SelectableItem extends StatelessWidget {
  const SelectableItem({Key? key, required this.text, required this.page}) : super(key: key);

  final String text;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> page)
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
