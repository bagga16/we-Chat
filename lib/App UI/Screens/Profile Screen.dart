import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/App%20UI/Screens/auth/Login%20screen.dart';
import 'package:we_chat/Models/chat%20User.dart';
import 'package:we_chat/Utils/Dialoges.dart';
import 'package:we_chat/components/Apis.dart';
import 'package:we_chat/components/text/app_text.dart';

class Profile_Screen extends StatefulWidget {
  final ChatUser user;
  const Profile_Screen({super.key, required this.user});

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 61, 199, 132),
            centerTitle: true,
            leading: Icon(CupertinoIcons.home),
            title: Text('Profile'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              )
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent.shade200,
              onPressed: () async {
                //for showing Progreebar
                Dialogs.showProgressBar(context);
                await APIs.auth.signOut();
                await GoogleSignIn().signOut().then((value) async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => Login_Screen1()),
                  );
                });
              },
              icon: Icon(Icons.logout),
              label: Text(
                'Logout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            height: 130,
                            width: 130,
                            fit: BoxFit.fill,
                            // height: MediaQuery.of(context).size.height * .06,
                            // width: MediaQuery.of(context).size.height * .06,

                            imageUrl: widget.user.image,
                            errorWidget: (context, url, error) => CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: -22,
                          child: MaterialButton(
                            onPressed: () {},
                            elevation: 1,
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomText(
                    title: widget.user.email,
                    fontSize: 16,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'eg: Ahmad Raza',
                        label: Text('Name'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextFormField(
                        initialValue: widget.user.about,
                        onSaved: (val) => APIs.me.about = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.info_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'eg. feeling happy',
                          label: Text('About'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Container(
                    height: 47,
                    width: MediaQuery.of(context).size.width - 160,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 61, 199, 132),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackbar(
                                  context, 'User info Updated Successfuly');
                            });
                          }
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 28,
                        ),
                        label: Text(
                          'Update ',
                          style: TextStyle(fontSize: 20, letterSpacing: 1),
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}