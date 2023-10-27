import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/models/userdata.dart';
import 'package:fullpro/pages/Authentication/register.dart';
import 'package:fullpro/pages/INTEGRATION/Profile/profile.dart';
import 'package:fullpro/pages/INTEGRATION/Profile/settings.dart';
import 'package:fullpro/pages/language.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/about.dart';
import 'package:fullpro/pages/profile/account.dart';
import 'package:fullpro/pages/profile/addresses.dart';
import 'package:fullpro/pages/terms.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fullpro/widgets/ProfileWidget.dart';
import 'package:fullpro/widgets/bottomNav.dart';

import '../utils/userpreferences.dart';

class ProfileButtonWithBottomSheet extends StatefulWidget {
  const ProfileButtonWithBottomSheet({
    Key? key,
    required this.getUserName,
    required this.getuserPhone,
  }) : super(key: key);

  final String? getUserName;
  final String? getuserPhone;

  @override
  State<ProfileButtonWithBottomSheet> createState() => _ProfileButtonWithBottomSheetState();
}

class _ProfileButtonWithBottomSheetState extends State<ProfileButtonWithBottomSheet> {
  String? getUserName = '';
  String? getuserPhone = '';
  String? getuserEmail = '';

  void getUserInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    final UserRef = FirebaseDatabase.instance.ref().child("users").child(userid!);
    UserRef.once().then((e) async {
      final DataSnapshot = e.snapshot;

      currentUserInfo = UserData.fromSnapshot(DataSnapshot);
      if (mounted) {
        var connectivityResults = await Connectivity().checkConnectivity();

        if (connectivityResults != ConnectivityResult.mobile && connectivityResults != ConnectivityResult.wifi) {
          //
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No Internet Connection',
              ),
            ),
          );
        } else {
          setState(() {
            if (currentUserInfo?.fullName.toString() == null) {
              getUserName = UserPreferences.getUsername() ?? '';
            } else {
              getUserName = currentUserInfo?.fullName.toString();
              UserPreferences.setUsername(getUserName!);
            }
            if (currentUserInfo?.phone.toString() == null) {
              getuserPhone = UserPreferences.getUserPhone() ?? '';
            } else {
              getuserPhone = currentUserInfo?.phone.toString();
              UserPreferences.setUserPhone(getuserPhone!);
            }
            if (currentUserInfo?.email.toString() == null) {
              getuserEmail = UserPreferences.getUserEmail() ?? '';
            } else {
              getuserEmail = currentUserInfo?.email.toString();
              UserPreferences.setUserEmail(getuserEmail!);
            }
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> share() async {
      await FlutterShare.share(
        title: appName!,
        text: Locales.string(context, 'txt_share'),
        linkUrl: "https://play.google.com/store/apps/details?id=$packageName",
      );
    }

    return MaterialButton(
      elevation: 0.0,
      hoverElevation: 0.0,
      focusElevation: 0.0,
      highlightElevation: 0.0,
      // color: Static.themeColor[500],
      color: Colors.white,
      minWidth: 15,
      height: 15,
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(5),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: Padding(
                    padding: const EdgeInsets.only(left: 34, top: 10, right: 34, bottom: 10),
                    child: Column(
                      //  physics: const BouncingScrollPhysics(),
                      children: [
                        /* Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(
                              onPressed: () => Navigator.pop(context),
                              elevation: 0.0,
                              hoverElevation: 0.0,
                              focusElevation: 0.0,
                              highlightElevation: 0.0,
                              color: Colors.transparent,
                              minWidth: 20,
                              height: 20,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(5),
                              child: SvgPicture.asset('images/svg_icons/arrowLeft.svg'),
                            ),
                          ],
                        ),*/

                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset('images/svg_icons/arrowLeft.svg'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: 60,
                            height: 60,
                            child: ProfileWidget(
                              imagePath: 'images/user_icon.png',
                              onClicked: () async {},
                            )),
                        const SizedBox(height: 24),
                        // ignore: prefer_if_null_operators
                        buildName(UserPreferences.getUsername() != null ? UserPreferences.getUsername() : getUserName),
                        const SizedBox(height: 10),

                        //
                        //
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Static.dashboardCard,
                            ),
                            child: Column(
                              children: [
                                ProfileButton(
                                  buttonName: Locales.string(context, 'lbl_account'),
                                  onCLicked: () {
                                    Navigator.pop(context);
                                    //

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Account()));
                                    //    Navigator.push(context, MaterialPageRoute(builder: (context) => const Account()));
                                  },
                                  icon: FeatherIcons.user,
                                ),

                                const Divider(color: Colors.black12),
                                ProfileButton(
                                  buttonName: "Ajustes",
                                  onCLicked: () {
                                    bool isPuchased = false;
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(currentUser!, isPuchased)));
                                  },
                                  icon: FeatherIcons.mapPin,
                                ),

                                const Divider(color: Colors.black12),
                                ProfileButton(
                                  buttonName: Locales.string(context, 'lbl_address'),
                                  onCLicked: () {
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Addresses()));
                                  },
                                  icon: FeatherIcons.mapPin,
                                ),
                                const Divider(color: Colors.black12),
                                ProfileButton(
                                  buttonName: Locales.string(context, 'lbl_language'),
                                  onCLicked: () {
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Language()));
                                  },
                                  icon: FeatherIcons.globe,
                                ),
                                // const Divider(color: Colors.black12),
                                // ProfileButton(
                                //   buttonName: 'Wallet',
                                //   onCLicked: () {
                                //     Loader.page(context, Wallet());
                                //   },
                                //   icon: FeatherIcons.dollarSign,
                                // ),
                              ],
                            ),
                          ),
                        ),
                        //
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Static.dashboardCard,
                            ),
                            child: Column(
                              children: [
                                ProfileButton(
                                  buttonName: Locales.string(context, 'lbl_invite_friends'),
                                  onCLicked: () {
                                    Navigator.pop(context);
                                    //
                                    share();
                                  },
                                  icon: FeatherIcons.share2,
                                ),
                                const Divider(color: Colors.black12),
                                ProfileButton(
                                  buttonName: Locales.string(context, 'lbl_terms_and_conditions'),
                                  onCLicked: () {
                                    Navigator.pop(context);
                                    Loader.page(context, const TermsPage());
                                    //
                                  },
                                  icon: FeatherIcons.clipboard,
                                ),
                                const Divider(color: Colors.black12),
                                ProfileButton(
                                  buttonName: Locales.string(context, 'lbl_about'),
                                  onCLicked: () {
                                    Navigator.pop(context);
                                    Loader.page(context, const AboutPage());
                                  },
                                  icon: FeatherIcons.info,
                                ),
                                const Divider(color: Colors.black12),
                                ProfileButton(
                                  buttonName: Locales.string(context, 'lbl_logout'),
                                  onCLicked: () {
                                    Navigator.pop(context);
                                    _signOut().then((value) => Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Register()), (route) => false));
                                  },
                                  icon: FeatherIcons.logOut,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
        /*  showMaterialModalBottomSheet(
        backgroundColor: Static.dashboardBG,
        duration: const Duration(milliseconds: 200),
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) =>
      );*/
      },

      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'images/icons/iconDrawer.svg',
                  //   color: Colors.black,
                  width: 40,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget buildName(String? getUserName) => Column(
        children: [
          Text(
            '${UserPreferences.getUsername() ?? getUserName}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            '${UserPreferences.getUserPhone() ?? widget.getuserPhone}',
            style: const TextStyle(color: Static.colorTextLight),
          )
        ],
      );
}

class ProfileButton extends StatelessWidget {
  final String buttonName;
  final IconData icon;
  final Function() onCLicked;
  //
  const ProfileButton({
    required this.buttonName,
    required this.icon,
    required this.onCLicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: MaterialButton(
        elevation: 0.0,
        highlightElevation: 0.0,
        onPressed: onCLicked,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Static.themeColor[500],
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            Text(buttonName),
            const Icon(FeatherIcons.chevronRight),
          ],
        ),
      ),
    );
  }
}
