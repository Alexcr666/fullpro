import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/widgets/language_item.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);
  static const String id = 'Language';

  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final int _groupValue = 1;
  bool manualAdressExists = false;
  String? countryValue;
  String? stateValue;
  String? cityValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController street = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Static.dashboardCard,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Locales.string(context, 'title_language'),
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Static.dashboardBG,
        elevation: 0.0,
        toolbarHeight: 70,
        leadingWidth: 100,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: secondryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Static.dashboardCard,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LanguageItem(
                                title: Locales.string(context, 'lang_english'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'en' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'en' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'en' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'en' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'en');
                                },
                              ),
                              /* LanguageItem(
                                title: Locales.string(context, 'lang_arabic'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'ar' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'ar' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'ar' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'ar' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'ar');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_afrikaans'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'af' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'af' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'af' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'af' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'af');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_german'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'de' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'de' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'de' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'de' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'de');
                                },
                              ),*/
                              LanguageItem(
                                title: Locales.string(context, 'lang_spanish'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'es' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'es' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'es' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'es' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'es');
                                },
                              ),
                              /* LanguageItem(
                                title: Locales.string(context, 'lang_french'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'fr' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'fr' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'fr' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'fr' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'fr');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_hindi'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'hi' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'hi' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'hi' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'hi' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'hi');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_urdu'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'ur' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'ur' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'ur' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'ur' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'ur');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_indonesian'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'id' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'id' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'id' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'id' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'id');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_japanese'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'ja' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'ja' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'ja' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'ja' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'ja');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_dutch'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'nl' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'nl' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'nl' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'nl' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'nl');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_portuguese'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'pt' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'pt' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'pt' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'pt' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'pt');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_turkish'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'tr' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'tr' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'tr' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'tr' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'tr');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_italian'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'it' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'it' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'it' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'it' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'it');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_korean'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'ko' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'ko' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'ko' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'ko' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'ko');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_nepali'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'ne' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'ne' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'ne' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'ne' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'ne');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_russian'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'ru' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'ru' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'ru' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'ru' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'ru');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_vietnamese'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'vi' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'vi' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'vi' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'vi' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'vi');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_hebrew'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'he' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'he' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'he' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'he' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'he');
                                },
                              ),
                              LanguageItem(
                                title: Locales.string(context, 'lang_thai'),
                                bgColor: Locales.currentLocale(context)!.languageCode == 'th' ? secondryColor : Static.dashboardCard,
                                iconColor: Locales.currentLocale(context)!.languageCode == 'th' ? Colors.white : Colors.black87,
                                textColor: Locales.currentLocale(context)!.languageCode == 'th' ? Colors.white : Colors.black87,
                                prefixWidget: Icon(
                                  Icons.check_circle,
                                  color: Locales.currentLocale(context)!.languageCode == 'th' ? Colors.white : Static.dashboardCard,
                                ),
                                icon: FeatherIcons.globe,
                                onTap: () async {
                                  Locales.change(context, 'th');
                                },
                              ),*/
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
