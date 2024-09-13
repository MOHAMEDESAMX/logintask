import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("success"),
        actions: [
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.all(20),
          child:SizedBox(child: Text("signed in successfuly",style: TextStyle(fontSize: 30,color: Colors.green),),)
        )
      ),
    );
  }
  
}