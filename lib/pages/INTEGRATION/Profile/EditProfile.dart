import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

//import 'package:firebase_admob/firebase_admob.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:fullpro/pages/INTEGRATION/models/user_model.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:image_cropper/image_cropper.dart';

//import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as i;

class EditProfile extends StatefulWidget {
  final User currentUser;

  EditProfile(this.currentUser);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final TextEditingController aboutCtlr = new TextEditingController();

  final TextEditingController companyCtlr = new TextEditingController();

  final TextEditingController livingCtlr = new TextEditingController();

  final TextEditingController jobCtlr = new TextEditingController();

  final TextEditingController universityCtlr = new TextEditingController();

  bool visibleAge = false;

  bool visibleDistance = true;

  var showMe;

  Map editInfo = {};

  // Ads _ads = new Ads();

  // late BannerAd _ad;

  Map testMap = {'edit': 'thanks'};

  @override
  void initState() {
    super.initState();

    print('---------------------${widget.currentUser.phoneNumber}');

    aboutCtlr.text = widget.currentUser.editInfo!['about'] ?? '';

    companyCtlr.text = widget.currentUser.editInfo!['company'] ?? '';

    livingCtlr.text = widget.currentUser.editInfo!['living_in'] ?? '';

    universityCtlr.text = widget.currentUser.editInfo!['university'] ?? '';

    jobCtlr.text = widget.currentUser.editInfo!['job_title'] ?? '';

    setState(() {
      showMe = widget.currentUser.editInfo!['userGender'] ?? '';

      visibleAge = widget.currentUser.editInfo!['showMyAge'] ?? false;

      visibleDistance = widget.currentUser.editInfo!['DistanceVisible'] ?? true;
    });

    // _ad = _ads.myBanner();

    super.initState();

    // _ad

    //   ..load()

    //   ..show();
  }

  @override
  void dispose() {
    super.dispose();

    print('-------------------------${editInfo.length}');

    if (editInfo.length > 0) {
      updateData();
    }

    // _ads.disable(_ad);
  }

  Future updateData() async {
    print('---------------------${widget.currentUser.id}');

    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.currentUser.id)
        .set({'editInfo': editInfo, 'age': widget.currentUser.age}, SetOptions(merge: true));
  }

  Future source(BuildContext context, currentUser, bool isProfilePicture) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text(isProfilePicture ? "Update profile picture".toString() : "Add pictures".toString()),
              content: Text(
                "Select source".toString(),
              ),
              insetAnimationCurve: Curves.decelerate,
              actions: currentUser.imageUrl.length < 9
                  ? <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_camera,
                                size: 28,
                              ),
                              Text(
                                " Camera".toString(),
                                style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);

                            showDialog(
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.camera, context, currentUser, isProfilePicture);

                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_library,
                                size: 28,
                              ),
                              Text(
                                " Gallery".toString(),
                                style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);

                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.gallery, context, currentUser, isProfilePicture);

                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                    ]
                  : [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Icon(Icons.error),
                            Text(
                              "Can't uplaod more than 9 pictures".toString(),
                              style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
                            ),
                          ],
                        )),
                      )
                    ]);
        });
  }

  Future getImage(ImageSource imageSource, context, currentUser, isProfilePicture) async {
    ImagePicker imagePicker = ImagePicker();

    try {
      var image = await imagePicker.pickImage(source: imageSource);

      if (image != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop',
                toolbarColor: primaryColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              title: 'Crop',
            )
          ],
        );

        if (croppedFile != null) {
          await uploadFile(await compressimage(croppedFile), currentUser, isProfilePicture);
        }
      }

      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future uploadFile(File image, User currentUser, isProfilePicture) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('users/${currentUser.id}/${image.hashCode}.jpg');

    UploadTask uploadTask = storageReference.putFile(image);

    //if (uploadTask.isInProgress == true) {}

    //if (await uploadTask.onComplete != null) {

    await uploadTask.whenComplete(() {
      storageReference.getDownloadURL().then((fileURL) async {
        Map<String, dynamic> updateObject = {
          "Pictures": FieldValue.arrayUnion([
            fileURL,
          ])
        };

        try {
          if (isProfilePicture) {
            //currentUser.imageUrl.removeAt(0);

            //  currentUser.imageUrl!.insert(0, fileURL);

            print("object");

            await FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.id)
                .set({"Pictures": currentUser.imageUrl}, SetOptions(merge: true));
          } else {
            await FirebaseFirestore.instance.collection("Users").doc(currentUser.id).set(updateObject, SetOptions(merge: true));

            //   widget.currentUser.imageUrl!.add(fileURL);
          }

          if (mounted) setState(() {});
        } catch (err) {
          print("Error: $err");
        }
      });
    });
  }

  Future compressimage(CroppedFile image) async {
    final File croppedToFileImage = File(image.path);

    final tempdir = await getTemporaryDirectory();

    final path = tempdir.path;

    i.Image? imagefile = i.decodeImage(croppedToFileImage.readAsBytesSync());

    final compressedImagefile = File('$path.jpg')..writeAsBytesSync(i.encodeJpg(imagefile!, quality: 80));

    // setState(() {

    return compressedImagefile;

    // });
  }

  @override
  Widget build(BuildContext context) {
    // Profile _profile = new Profile(widget.currentUser);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          title: Text(
            "Edit Profile".toString(),
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: primaryColor),
      body: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)), color: Colors.white),
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * .65,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        childAspectRatio: MediaQuery.of(context).size.aspectRatio * 1.5,
                        crossAxisSpacing: 4,
                        padding: EdgeInsets.all(10),
                        children: List.generate(9, (index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: widget.currentUser.imageUrl!.length > index
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),

                                        // image: DecorationImage(

                                        //     fit: BoxFit.cover,

                                        //     image: CachedNetworkImageProvider(

                                        //       widget.currentUser.imageUrl[index],

                                        //     )),
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(style: BorderStyle.solid, width: 1, color: secondryColor)),
                                child: Stack(
                                  children: <Widget>[
                                    widget.currentUser.imageUrl!.length > index
                                        ? CachedNetworkImage(
                                            height: MediaQuery.of(context).size.height * .2,
                                            fit: BoxFit.cover,
                                            imageUrl: widget.currentUser.imageUrl![index] ?? '',
                                            placeholder: (context, url) => Center(
                                              child: CupertinoActivityIndicator(
                                                radius: 10,
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.error,
                                                    color: Colors.black,
                                                    size: 25,
                                                  ),
                                                  Text(
                                                    "Enable to load".toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),

                                    // Center(

                                    //     child:

                                    //         widget.currentUser.imageUrl.length >

                                    //                 index

                                    //             ? CupertinoActivityIndicator(

                                    //                 radius: 10,

                                    //               )

                                    //             : Container()),

                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(

                                          // width: 12,

                                          // height: 16,

                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: widget.currentUser.imageUrl!.length > index ? Colors.white : primaryColor,
                                          ),
                                          child: widget.currentUser.imageUrl!.length > index
                                              ? InkWell(
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: primaryColor,
                                                    size: 22,
                                                  ),
                                                  onTap: () async {
                                                    if (widget.currentUser.imageUrl!.length > 1) {
                                                      _deletePicture(index);
                                                    } else {
                                                      source(context, widget.currentUser, true);
                                                    }
                                                  },
                                                )
                                              : InkWell(
                                                  child: Icon(
                                                    Icons.add_circle_outline,
                                                    size: 22,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () => source(context, widget.currentUser, false),
                                                )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                  InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                              primaryColor.withOpacity(.5),
                              primaryColor.withOpacity(.8),
                              primaryColor,
                              primaryColor,
                            ])),
                        height: 50,
                        width: 340,
                        child: Center(
                            child: Text(
                          "Add media".toString(),
                          style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {
                      await source(context, widget.currentUser, false);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListBody(
                      mainAxis: Axis.vertical,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "About ",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: aboutCtlr,
                            cursorColor: primaryColor,
                            maxLines: 10,
                            minLines: 3,
                            placeholder: "About you".toString(),
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'about': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Job title".toString(),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: jobCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Add job title".toString(),
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'job_title': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Company".toString(),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: companyCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Add company".toString(),
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'company': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "University".toString(),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: universityCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Add university".toString(),
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'university': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Living in".toString(),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: livingCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Add city".toString(),
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'living_in': text});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              "I am".toString(),
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
                            ),
                            subtitle: DropdownButton(
                              iconEnabledColor: primaryColor,
                              iconDisabledColor: secondryColor,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Man".toString()),
                                  value: "man",
                                ),
                                DropdownMenuItem(child: Text("Woman".toString()), value: "woman"),
                                DropdownMenuItem(child: Text("Other".toString()), value: "other"),
                              ],
                              onChanged: (val) {
                                editInfo.addAll({'userGender': val});

                                setState(() {
                                  showMe = val;
                                });
                              },
                              value: showMe,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                            title: Text(
                              "Control your profile".toString(),
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
                            ),
                            subtitle: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Don't Show My Age".toString()),
                                      ),
                                      Switch(
                                          activeColor: primaryColor,
                                          value: visibleAge,
                                          onChanged: (value) {
                                            editInfo.addAll({'showMyAge': value});

                                            setState(() {
                                              visibleAge = value;
                                            });
                                          })
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Make My Distance Visible".toString()),
                                      ),
                                      Switch(
                                          activeColor: primaryColor,
                                          value: visibleDistance,
                                          onChanged: (value) {
                                            editInfo.addAll({'DistanceVisible': value});

                                            setState(() {
                                              visibleDistance = value;
                                            });
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deletePicture(index) async {
    if (widget.currentUser.imageUrl![index] != null) {
      try {
        Reference _ref = await FirebaseStorage.instance.refFromURL(widget.currentUser.imageUrl![index]);

        print(_ref.fullPath);

        await _ref.delete();
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      //   widget.currentUser.imageUrl!.removeAt(index);
    });

    var temp = [];

    temp.add(widget.currentUser.imageUrl);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc("${widget.currentUser.id}")
        .set({"Pictures": temp[0]}, SetOptions(merge: true));
  }
}
