// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'auth/login_screen.dart';

//profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {

  final ChatUser user; 

  
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          //app bar
          appBar: AppBar(title: const Text('Profile Screen')),

          // floating button to log out
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: FloatingActionButton.extended(
          //       backgroundColor: Colors.redAccent,
          //       onPressed: () async {
          //         //for showing progress dialog
          //         Dialogs.showProgressBar(context);

          //         await APIs.updateActiveStatus(false);

          //         //sign out from app
          //         await APIs.auth.signOut().then((value) async {
          //           await GoogleSignIn().signOut().then((value) {
          //             //for hiding progress dialog
          //             Navigator.pop(context);

          //             //for moving to home screen
          //             Navigator.pop(context);

          //             APIs.auth = FirebaseAuth.instance;

          //             //replacing home screen with login screen
          //             Navigator.pushReplacement(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (_) => const LoginScreen()));
          //           });
          //         });
          //       },
          //       icon: const Icon(Icons.logout),
          //       label: const Text('Logout')),
          // ),

          //body
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // for adding some space
                    SizedBox(width: mq.width, height: mq.height * .03),

                    //user profile picture
                    Stack(
                      children: [
                        //profile picture
                        _image != null
                            ?

                            //local image
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(File(_image!),
                                    width: mq.height * .2,
                                    height: mq.height * .2,
                                    fit: BoxFit.cover))
                            :

                            //image from server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),

                        //edit image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(Icons.edit, color: Colors.blue),
                          ),
                        )
                      ],
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .03),

                    // user username label
                    Text(widget.user.username,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    // for adding some space
                    SizedBox(height: mq.height * .03),

                    //name input field
                    TextFormField(
                      initialValue: widget.user.username,
                      onSaved: (val) => APIs.me.username = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Happy Day',
                          label: const Text('Username')),
                    ),

                    // // for adding some space
                    SizedBox(height: mq.height * .02),

                    // about input field
                    TextFormField(
                      initialValue: widget.user.selfIntro,
                      onSaved: (val) => APIs.me.selfIntro = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.info_outline,
                              color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. write something about yourself',
                          label: const Text('About Me')),
                    ),

                     SizedBox(height: mq.height * .02),

                    // TextFormField(
                    //   initialValue: widget.user.occupation.join(', '),
                    //   decoration: InputDecoration(
                    //       prefixIcon: const Icon(Icons.info_outline,
                    //           color: Colors.blue),
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(12)),
                    //       hintText: 'eg. I work as a...',
                    //       label: const Text('Occupation')),
                    // ),

                    // SizedBox(height: mq.height * .02),

                    Card(
                      elevation: 4, // Adds a shadow to the card
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   'Self Intro',
                            //   style: TextStyle(
                            //     color: Colors.blue,
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // SizedBox(height: 8), 
                            // Text(
                            //   widget.user.selfIntro,
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //   ),
                            // ),
                            // SizedBox(height: 50),
                            Text(
                              'Occupation',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8), 
                            Text(
                              widget.user.occupation.join(',\n '),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 50),
                            Text(
                              'Education History',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8), // Add some spacing
                            Text(
                              widget.user.eduHistory.join(',\n '),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 50),
                            Text(
                              'Skills ',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.user.skills.join(',\n '),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 50),
                            Text(
                              'Experience ',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.user.experience.join(',\n '),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: mq.height * .05),

                    // Card(
                    //     elevation: 4, // Adds a shadow to the card
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(16),
                    //       child:
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             'skills',
                    //             style: TextStyle(
                    //               color: Colors.blue,
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //           SizedBox(height: 8), // Add some spacing
                    //           Text(
                    //             widget.user.skills.join(',\n '),
                    //             style: TextStyle(
                    //               fontSize: 16,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),

                    //   SizedBox(height: mq.height * .02),

                    // Card(
                    //     elevation: 4, // Adds a shadow to the card
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(16),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             'Experience',
                    //             style: TextStyle(
                    //               color: Colors.blue,
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //           SizedBox(height: 8), // Add some spacing
                    //           Text(
                    //             widget.user.experience.join(',\n '), // Display the experience as a comma-separated string
                    //             style: TextStyle(
                    //               fontSize: 16,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),

                    // for adding some space
                    SizedBox(height: mq.height * .02),

                    // update profile button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: Size(mq.width * .5, mq.height * .06)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackbar(
                                context, 'Profile Updated Successfully!');
                          });
                        }
                      },
                      icon: const Icon(Icons.edit, size: 28),
                      label:
                          const Text('UPDATE', style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(height: mq.height * .05),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image2.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera_icon2.png')),
                ],
              )
            ],
          );
        });
  }
}
