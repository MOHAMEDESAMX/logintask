import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logintask/Core/utils/Colors.dart';
import 'package:logintask/Core/widgets/custombuttom';
import 'package:logintask/Core/widgets/customtextformfiled';
import 'package:logintask/features/Auth/signup.dart';
import 'package:logintask/features/Home/Home.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState()=> _LoginState();
  }


  class _LoginState extends State<Login> {

    bool isNotVisable = true;
    bool isLoading = false;
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();





  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText('Login',
                            textStyle: TextStyle(
                              fontSize: 40,
                              color: AppColors.text,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                      isRepeatingAnimation: true,
                    ),
                  const SizedBox(height: 40,),
                  //Email
                CusomTextFormFeald(
                  mycontroller: email,
                  validator: (value){
                    if (value!.isEmpty){
                      return "please enter your email";
                    }
                    return null;
                  },
                  prefixIcon: Icons.email,
                  lable: 'Email',
                  suffixIcon: null,),
                  const SizedBox(height: 25,),
                  //pass
                  CusomTextFormFeald(
                    mycontroller: password,
                    obscureText: isNotVisable,
                    validator: (value) {
                        if (value!.isEmpty) {
                          return 'PLease Enter Your Password';
                        }
                        return null;
                      },
                      
                      lable: "Password",
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isNotVisable = !isNotVisable;
                          });
                        },
                        icon: Icon((isNotVisable)
                            ? Icons.visibility_off
                            : Icons.remove_red_eye_rounded),
                        color: AppColors.text,
                      ),),
                      const SizedBox(height: 5,),
                      //Forget Password
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 10),
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () async {
                          if (email.text == "") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "please enter your email first",
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ));
                            return;
                          }
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email.text);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "we sent Reset password link to your email"),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'invalid-email') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "The email address is badly formatted \n make sure that email like xxx@xxx.xx"),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ));
                            } else if (e.code == 'user-not-found') {
                              // ignore: avoid_print
                              print('No user found for that email.');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("No user found for that email"),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ));
                            }
                          }
                        },
                        child: Text(
                          "Forget Password ?",
                          style: TextStyle(fontSize: 12, color: AppColors.text),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    isLoading
                    ? CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.button),
                    )
                    : Custom_Button(
                            text: 'Login',
                            onPressed: () async {
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: email.text,
                                    password: password.text,
                                  );
                                  if (credential.user!.emailVerified) {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => const Home(),
                                      ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text("Please verify your email ♥"),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.blueAccent,
                                    ));
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text("No user found for that email"),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else if (e.code == 'wrong-password') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Wrong password provided for that user"),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else if (e.code == 'invalid-email') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "The email address is badly formatted \n make sure that email like xxx@xxx.xx"),
                                      duration: Duration(seconds: 5),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                }
                              }
                          ),
                          const SizedBox(height: 40,),
                          Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(color: AppColors.text),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'or',
                            style:
                                TextStyle(color: AppColors.text, fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: AppColors.text),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage('https://yt3.googleusercontent.com/viNp17XpEF-AwWwOZSj_TvgobO1CGmUUgcTtQoAG40YaYctYMoUqaRup0rTxxxfQvWw3MvhXesw=s900-c-k-c0x00ffffff-no-rj'),
                                )),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        InkWell(
                          onTap: () async {
                            
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage('https://img.utdstc.com/icon/dca/e7e/dcae7e1859fae0ea28e192cf8dd36720f55ccbcccab1010106beac7351f03ccb:200'),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        Text('If you don\'t have account.',
                            style: TextStyle(
                                color: AppColors.text,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const signup()));
                            },
                            child: Text(
                              'Create one !',
                              style: TextStyle(
                                  color: AppColors.button,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500),
                            ))
                      ],
                    )
                ],
              )
              ),),),
      ),
      ),
    );
  }
    
  }