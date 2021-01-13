import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Filler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _formKey = GlobalKey<FormState>();
  Map<String, bool> categories = {
    'Airways': false,
    'Flights': false,
    'Footwear': false,
    'Sandals': false,
    'Slippers': false,
    'Shoes': false,
    'Clothing': false,
    'Smartphones': false,
    'Mobiles': false,
    'Earphones': false,
    'Music': false,
    'Headphones': false,
    'Speakers': false,
    'Food Outlets': false,
    'Automobile': false,
    'Social Media': false,
    'Television': false,
    'Washing Machine': false,
    'AC': false,
    'Laptops': false,
    'Watches': false,
    'Notebooks': false,
    'Search Engines': false,
    'Chat Messengers': false,
    'E-Commerce': false,
    'Cosmetics': false,
    'Sanitary Ware': false,
    'OTT Apps': false,
    'Music Apps': false,
    'Travel Sites': false,
    'Education Apps': false,
    'Banks': false
  };

  getCheckBoxItems() {
    categories.forEach((key, value) {
      if(value == true) {
        object.category.add(key);
      }
    });
  }

  Object object = Object();

  var finalObjects = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Filler'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      onSaved: (val) => setState(() => object.name = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Origin'),
                      onSaved: (val) => setState(() => object.origin = val),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Production (Comma seperated without spaces)'),
                      onSaved: (val) => setState(() => object.production = val.split(',')),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'URL'),
                      onSaved: (val) => setState(() => object.url = val),
                    ),
                    TextFormField(
                      initialValue: '1',
                      decoration: InputDecoration(labelText: 'Version'),
                      onSaved: (val) => setState(() => object.version = int.parse(val)),
                    ),
                    GridView.count(
                      childAspectRatio: 6,
                      shrinkWrap: true,
                      crossAxisCount: 6,
                      children: categories.keys.map((String key) {
                        return new CheckboxListTile(
                          title: new Text(key),
                          value: categories[key],
                          activeColor: Colors.pink,
                          checkColor: Colors.white,
                          onChanged: (bool value) {
                            setState(() {
                              categories[key] = value;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    RaisedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        _formKey.currentState.save();
                        getCheckBoxItems();
                        finalObjects.add(jsonEncode(object.toJson()));
                        object = Object();
                        print(finalObjects);
                        _formKey.currentState.reset();
                        categories.forEach((key, value) {
                          categories[key] = false;
                          setState(() {
                          });
                        });
                        saveFile(finalObjects.toString());
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Object {
  String name, origin, url;
  List<String> category = [];
  List<String> production = [];
  int version;

  Map<String, dynamic> toJson() => {
    'name': name,
    'origin': origin,
    'url': url,
    'category': category,
    'production': production,
    'version': version
  };
}

void saveFile(String text) {

// prepare
  final bytes = utf8.encode(text);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'output.json';
  html.document.body.children.add(anchor);

// download
  anchor.click();

// cleanup
  html.document.body.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}