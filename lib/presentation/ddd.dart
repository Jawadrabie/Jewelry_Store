import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ddd extends StatelessWidget {
  const ddd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("قلي شو عم تحس؟"),),
      body: Center(child: Text("اتصلو ع داديخي وقلولو صباح الخير ",style: TextStyle (fontSize:30 ),)),
    );
  }
}
