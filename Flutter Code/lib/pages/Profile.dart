import 'package:cached_network_image/cached_network_image.dart';
import 'package:expenso/pages/Onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:expenso/Models/User.dart';
import 'package:expenso/providers/UserProvider.dart';
import 'package:expenso/theme/colors.dart';
import 'package:expenso/theme/Style.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _email =
      TextEditingController(text: "andrew@gmail.com");
  TextEditingController dateOfBirth = TextEditingController(text: "04-19-1992");
  TextEditingController bio = TextEditingController(text: " ");
  AppUser? user;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      user = UserProvider.user;
      if (user != null) {
        print(user!.profilePicture);
        _email.text = user!.email;
        bio.text = user!.bio;

        dateOfBirth.text = DateTime.fromMillisecondsSinceEpoch(
                user!.birthdate.millisecondsSinceEpoch)
            .toString()
            .substring(0, 10);
      }

      return user == null
          ? const CircularProgressIndicator.adaptive()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(color: white, boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.01),
                        spreadRadius: 10,
                        blurRadius: 3,
                        // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 60, right: 20, left: 20, bottom: 25),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Profile",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: black),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: mainMargin),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.power_off,
                                    color: primary,
                                  ),
                                  onPressed: () {
                                    FirebaseAuth.instance
                                        .signOut()
                                        .then((value) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Onboarding()),
                                          (route) => false);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: white,
                        boxShadow: [
                          BoxShadow(
                            color: grey.withOpacity(0.01),
                            spreadRadius: 10,
                            blurRadius: 3,
                            // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(2 * subMargin),
                            bottomRight: Radius.circular(2 * subMargin))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, right: 20, left: 20, bottom: 25),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: (size.width - 40) * 0.4,
                                child: Container(
                                  child: Center(
                                    child: Container(
                                      width: 85,
                                      height: 85,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(42.5),
                                        child: CachedNetworkImage(
                                          imageUrl: user!.profilePicture,
                                          fit: BoxFit.fitWidth,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    primary),
                                            backgroundColor: grey,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  width: 85,
                                                  height: 85,
                                                  color: primary,
                                                  child: const Icon(
                                                    CupertinoIcons.person_solid,
                                                    color: primary,
                                                    size: 50,
                                                  )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: (size.width - 40) * 0.6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user!.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: black),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Credit score: ${user!.creditScore}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: black.withOpacity(0.4)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(subMargin),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withOpacity(0.01),
                                  spreadRadius: 10,
                                  blurRadius: 3,
                                  // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 25, bottom: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: primary),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 30,
                                      width: size.width - 80,
                                      child: TextField(
                                        readOnly: true,
                                        controller: _email,
                                        cursorColor: black,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: black),
                                        decoration: const InputDecoration(
                                            hintText: "Email",
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(subMargin),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withOpacity(0.01),
                                  spreadRadius: 10,
                                  blurRadius: 3,
                                  // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 25, bottom: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Date of birth",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: primary),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 30,
                                      width: size.width - 80,
                                      child: TextField(
                                        readOnly: true,
                                        controller: dateOfBirth,
                                        cursorColor: black,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: black),
                                        decoration: const InputDecoration(
                                            hintText: "Date of birth",
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(subMargin),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withOpacity(0.01),
                                  spreadRadius: 10,
                                  blurRadius: 3,
                                  // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 25, bottom: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "bio",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: primary),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 30,
                                      width: size.width - 80,
                                      child: TextField(
                                        controller: bio,
                                        cursorColor: black,
                                        readOnly: true,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: black),
                                        decoration: const InputDecoration(
                                            hintText: "bio",
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
    });
  }
}
