import 'package:autocomplete_textfield/autocomplete_textfield.dart';


import 'package:flutter/material.dart';


class FirstPage extends StatefulWidget {

  @override

  _FirstPageState createState() => _FirstPageState();

}


class _FirstPageState extends State<FirstPage> {

  List<String> added = [];


  String currentText = "";


  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();


  _FirstPageState() {

    textField = SimpleAutoCompleteTextField(

      key: key,

      decoration: InputDecoration(errorText: "Beans"),

      controller: TextEditingController(text: "Starting Text"),

      suggestions: suggestions,

      textChanged: (text) => currentText = text,

      clearOnSubmit: true,

      textSubmitted: (text) => setState(() {

        if (text != "") {

          added.add(text);

        }

      }),

    );

  }


  List<String> suggestions = [

    "Apple",

    "Armidillo",

    "Actual",

    "Actuary",

    "America",

    "Argentina",

    "Australia",

    "Antarctica",

    "Blueberry",

    "Cheese",

    "Danish",

    "Eclair",

    "Fudge",

    "Granola",

    "Hazelnut",

    "Ice Cream",

    "Jely",

    "Kiwi Fruit",

    "Lamb",

    "Macadamia",

    "Nachos",

    "Oatmeal",

    "Palm Oil",

    "Quail",

    "Rabbit",

    "Salad",

    "T-Bone Steak",

    "Urid Dal",

    "Vanilla",

    "Waffles",

    "Yam",

    "Zest"

  ];


  SimpleAutoCompleteTextField? textField;


  bool showWhichErrorText = false;


  @override

  Widget build(BuildContext context) {

    Column body = Column(children: [

      ListTile(

          title: textField,

          trailing: IconButton(

              icon: Icon(Icons.add),

              onPressed: () {

                textField!.triggerSubmitted();


                showWhichErrorText = !showWhichErrorText;


                textField!.updateDecoration(decoration: InputDecoration(errorText: showWhichErrorText ? "Beans" : "Tomatoes"));

              })),

    ]);


    body.children.addAll(added.map((item) {

      return ListTile(title: Text(item));

    }));


    return Scaffold(

      appBar: AppBar(title: Text('AutoComplete TextField Demo Simple'), actions: [

        IconButton(

            icon: Icon(Icons.edit),

            onPressed: () => showDialog(

                builder: (_) {

                  String text = "";


                  return AlertDialog(title: Text("Change Suggestions"), content: TextField(onChanged: (text) => text = text), actions: [

                    TextButton(

                        onPressed: () {

                          if (text != "") {

                            suggestions.add(text);

                            textField!.updateSuggestions(suggestions);

                          }

                          Navigator.pop(context);

                        },

                        child: Text("Add")),

                  ]);

                },

                context: context))

      ]),

      body: body,

    );

  }

}

