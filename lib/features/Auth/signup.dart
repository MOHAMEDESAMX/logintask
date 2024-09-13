import 'package:flutter/material.dart';
import 'package:logintask/Core/utils/Colors.dart';
import 'package:logintask/Core/widgets/custombuttom';
import 'package:logintask/Core/widgets/customtextformfiled';
import 'package:logintask/features/Auth/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';


class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupstate();
  }


  bool isNotVisable = true;

  class _signupstate extends State<signup> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Confirmpassword = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 40,
                        color: AppColors.text,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    children: [
                      SizedBox(
                        width: 180,
                        child: CusomTextFormFeald(
                          mycontroller: firstname,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'PLease Enter Your First Name';
                            }
                            return null;
                          },
                          prefixIcon: Icons.person,
                          lable: 'First Name',
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 180,
                        child: CusomTextFormFeald(
                          mycontroller: lastname,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'PLease Enter Your Last Name';
                            }
                            return null;
                          },
                          prefixIcon: Icons.person,
                          lable: 'Last Name',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  CusomTextFormFeald(
                    mycontroller: email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'PLease Enter Your Email';
                      }
                      return null;
                    },
                    prefixIcon: Icons.email,
                    lable: 'Email',
                  ),
                  const SizedBox(height: 15,),
                  CusomTextFormFeald(
                    mycontroller: password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'PLease Enter Your Password';
                      }
                      return null;
                    },
                    obscureText: isNotVisable,
                    prefixIcon: Icons.lock,
                    lable: 'Password',
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
                    ),
                  ),
                  const SizedBox(height: 15,),
                  CusomTextFormFeald(
                    mycontroller: Confirmpassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'PLease Enter Your Password';
                      }
                      return null;
                    },
                    obscureText: isNotVisable,
                    prefixIcon: Icons.lock,
                    lable: 'Confirm Password',
                  ),
                  const SizedBox(height: 20,),
                  Custom_Button(
                    text: 'Sign Up',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // Check if passwords match
                        if (password.text != Confirmpassword.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Passwords do not match"),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        try {
                          // Create user with email and password
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          // Send email verification
                          await credential.user!.sendEmailVerification();

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Saved successfully"),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ));

                          // Navigate to login screen
                          Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Login()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-email') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "The email address is badly formatted \n make sure that email includes xxx@xxx.xx"),
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "The password provided is too weak \n Password should be at least 6 characters"),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "The account already exists for that email"),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(color: AppColors.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'or',
                          style: TextStyle(color: AppColors.text, fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: AppColors.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      Text('Already I have account',
                          style: TextStyle(
                              color: AppColors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Login()));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: AppColors.button,
                                fontSize: 19,
                                fontWeight: FontWeight.w500),
                          ))
                    ],
                  )
                  ],
                ),
              )),),
        ),
      ) ,);
  }

    
  }