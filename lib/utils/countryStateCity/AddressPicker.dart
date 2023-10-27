import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/utils/countryStateCity/cityModel.dart';
import 'package:fullpro/utils/countryStateCity/countryModel.dart';
import 'package:fullpro/utils/countryStateCity/stateModel.dart';

class CountryStateCityPicker extends StatefulWidget {
  TextEditingController country;
  TextEditingController state;
  TextEditingController city;
  InputBorder? textFieldInputBorder;

  CountryStateCityPicker({required this.country, required this.state, required this.city, this.textFieldInputBorder});

  @override
  _CountryStateCityPickerState createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  List<CountryModel> _countryList = [];
  final List<StateModel> _stateList = [];
  final List<CityModel> _cityList = [];

  List<CountryModel> _countrySubList = [];
  List<StateModel> _stateSubList = [];
  List<CityModel> _citySubList = [];
  String _title = '';

  @override
  void initState() {
    super.initState();
    _getCountry();
  }

  Future<void> _getCountry() async {
    _countryList.clear();
    var jsonString = await rootBundle.loadString('lib/utils/countryStateCity/country.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _countryList = body.map((dynamic item) => CountryModel.fromJson(item)).toList();
      _countrySubList = _countryList;
    });
  }

  Future<void> _getState(String countryId) async {
    _stateList.clear();
    _cityList.clear();
    List<StateModel> _subStateList = [];
    var jsonString = await rootBundle.loadString('lib/utils/countryStateCity/state.json');
    List<dynamic> body = json.decode(jsonString);

    _subStateList = body.map((dynamic item) => StateModel.fromJson(item)).toList();
    for (var element in _subStateList) {
      if (element.countryId == countryId) {
        setState(() {
          _stateList.add(element);
        });
      }
    }
    _stateSubList = _stateList;
  }

  Future<void> _getCity(String stateId) async {
    _cityList.clear();
    List<CityModel> _subCityList = [];
    var jsonString = await rootBundle.loadString('lib/utils/countryStateCity/city.json');
    List<dynamic> body = json.decode(jsonString);

    _subCityList = body.map((dynamic item) => CityModel.fromJson(item)).toList();
    for (var element in _subCityList) {
      if (element.stateId == stateId) {
        setState(() {
          _cityList.add(element);
        });
      }
    }
    _citySubList = _cityList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Country TextField
        TextField(
          controller: widget.country,
          onTap: () {
            setState(() => _title = Locales.string(context, 'lbl_country'));
            _showDialog(context);
          },
          decoration: InputDecoration(
              isDense: true,
              hintText: Locales.string(context, 'lbl_select_country'),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              border: widget.textFieldInputBorder ?? const OutlineInputBorder()),
          readOnly: true,
        ),
        const SizedBox(height: 8.0),

        ///State TextField
        TextField(
          controller: widget.state,
          onTap: () {
            setState(() => _title = Locales.string(context, 'lbl_state'));
            if (widget.country.text.isNotEmpty) {
              _showDialog(context);
            } else {
              _showSnackBar(Locales.string(context, 'lbl_select_country'));
            }
          },
          decoration: InputDecoration(
              isDense: true,
              hintText: Locales.string(context, 'lbl_select_state'),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              border: widget.textFieldInputBorder ?? const OutlineInputBorder()),
          readOnly: true,
        ),
        const SizedBox(height: 8.0),

        ///City TextField
        TextField(
          controller: widget.city,
          onTap: () {
            setState(() => _title = Locales.string(context, 'lbl_city'));
            if (widget.state.text.isNotEmpty) {
              _showDialog(context);
            } else {
              _showSnackBar(Locales.string(context, 'lbl_select_state'));
            }
          },
          decoration: InputDecoration(
              isDense: true,
              hintText: Locales.string(context, 'lbl_select_city'),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              border: widget.textFieldInputBorder ?? const OutlineInputBorder()),
          readOnly: true,
        ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    TextEditingController _controller2 = TextEditingController();
    TextEditingController _controller3 = TextEditingController();

    showGeneralDialog(
      barrierLabel: _title,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      context: context,
      pageBuilder: (context, __, ___) {
        return Material(
          color: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * .7,
                  margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(_title, style: TextStyle(color: Colors.grey.shade800, fontSize: 17, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),

                      ///Text Field
                      TextField(
                        controller: _title == Locales.string(context, 'lbl_country')
                            ? _controller
                            : _title == Locales.string(context, 'lbl_state')
                                ? _controller2
                                : _controller3,
                        onChanged: (val) {
                          setState(() {
                            if (_title == Locales.string(context, 'lbl_country')) {
                              _countrySubList = _countryList
                                  .where((element) => element.name.toLowerCase().contains(_controller.text.toLowerCase()))
                                  .toList();
                            } else if (_title == Locales.string(context, 'lbl_state')) {
                              _stateSubList = _stateList
                                  .where((element) => element.name.toLowerCase().contains(_controller2.text.toLowerCase()))
                                  .toList();
                            } else if (_title == Locales.string(context, 'lbl_city')) {
                              _citySubList = _cityList
                                  .where((element) => element.name.toLowerCase().contains(_controller3.text.toLowerCase()))
                                  .toList();
                            }
                          });
                        },
                        style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: Locales.string(context, 'lbl_search'),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                            isDense: true,
                            prefixIcon: const Icon(Icons.search)),
                      ),

                      ///Dropdown Items
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: _title == Locales.string(context, 'lbl_country')
                                ? _countrySubList.length
                                : _title == Locales.string(context, 'lbl_state')
                                    ? _stateSubList.length
                                    : _citySubList.length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  setState(() {
                                    if (_title == Locales.string(context, 'lbl_country')) {
                                      widget.country.text = _countrySubList[index].name;
                                      _getState(_countrySubList[index].id);
                                      _countrySubList = _countryList;
                                      widget.state.clear();
                                      widget.city.clear();
                                    } else if (_title == Locales.string(context, 'lbl_state')) {
                                      widget.state.text = _stateSubList[index].name;
                                      _getCity(_stateSubList[index].id);
                                      _stateSubList = _stateList;
                                      widget.city.clear();
                                    } else if (_title == Locales.string(context, 'lbl_city')) {
                                      widget.city.text = _citySubList[index].name;
                                      _citySubList = _cityList;
                                    }
                                  });
                                  _controller.clear();
                                  _controller2.clear();
                                  _controller3.clear();
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
                                  child: Text(
                                    _title == Locales.string(context, 'lbl_country')
                                        ? _countrySubList[index].name
                                        : _title == Locales.string(context, 'lbl_state')
                                            ? _stateSubList[index].name
                                            : _citySubList[index].name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto.Bold',
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_title == Locales.string(context, 'lbl_city') && _citySubList.isEmpty) {
                            widget.city.text = _controller3.text;
                          }
                          _countrySubList = _countryList;
                          _stateSubList = _stateList;
                          _citySubList = _cityList;

                          _controller.clear();
                          _controller2.clear();
                          _controller3.clear();
                          Navigator.pop(context);
                        },
                        child: Text(Locales.string(context, 'lbl_close')),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16.0))));
  }
}
