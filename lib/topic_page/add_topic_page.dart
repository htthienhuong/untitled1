import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled1/Services/WordServices.dart';

import '../Models/TopicModel.dart';
import '../Models/word_model.dart';
import '../Services/TopicServices.dart';
import '../Services/WordServices.dart';
import '../app_data/app_data.dart';

class AddTopicPage extends StatefulWidget {
  const AddTopicPage({super.key});

  @override
  State<AddTopicPage> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage> {
  String? filePath;

  final List<WordModel> wordModelList = [];
  String? topicId;

  int itemWordCount = 2;
  final _formKey = GlobalKey<FormState>();
  bool public = false;
  String? dropDownValue = 'Private';
  late String topicName;
  String? url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wordModelList.add(WordModel());
    wordModelList.add(WordModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          backgroundColor: const Color(0xff1b2794),
          shape: const CircleBorder(),
          onPressed: () {
            wordModelList.add(WordModel());
            _formKey.currentState?.save();
            setState(() {
              wordModelList.add(WordModel());
            });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xffe2e9ff),
        centerTitle: true,
        title: const Text(
          "Create Topic",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1b2794)),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff647ebb),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _importCsv();
            },
            icon: const Icon(FontAwesomeIcons.fileCsv),
            color: const Color(0xff647ebb),
          ),
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                topicId = await TopicService().addTopicWithUserReference(
                  topic: TopicModel(
                      topicName: topicName,
                      isPublic: public,
                      userId: AppData.userModel.id,
                      userAvatarUrl: AppData.userModel.avatarUrl,
                      userName: AppData.userModel.name),
                );

                for (WordModel word in wordModelList) {
                  await WordService()
                      .addWord(word.english!, word.vietnam!, topicId!);
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            icon: const Icon(
              Icons.done,
              size: 32,
              color: Color(0xff647ebb),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromARGB(150, 255, 204, 204),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Epilogue"),
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Topic',
                            border: UnderlineInputBorder(),
                            hintStyle:
                                TextStyle(height: 2.5, fontFamily: "Epilogue")),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          topicName = newValue!;
                          print('add topic done');
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Topic',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        width: double.maxFinite,
                        child: DropdownButtonFormField(
                          value: dropDownValue, // this
                          items: ["Private", "Public"]
                              .map<DropdownMenuItem<String>>((String value) =>
                                  DropdownMenuItem<String>(
                                      value:
                                          value, // add this property an pass the _value to it
                                      child: Text(
                                        value,
                                      )))
                              .toList(),
                          onChanged: (value) {
                            if (value == 'Public') {
                              public = true;
                            } else {
                              public = false;
                            }
                            print("public: $public");
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: wordModelList.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  _formKey.currentState?.save();
                                  setState(() {
                                    wordModelList.removeAt(index);
                                  });
                                },
                                confirmDismiss: (direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm"),
                                        content: const Text(
                                            "Are you sure you wish to delete this word?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text(
                                              "DELETE",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text(
                                              "CANCEL",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 40.0),
                                    child: Icon(
                                      Icons.delete,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                key: UniqueKey(),
                                child: _buildItemWord(index));
                          }),
                    ],
                  ))),
        ),
      ),
    );
  }

  Widget _buildItemWord(int index) {
    TextEditingController defController =
        TextEditingController(text: wordModelList[index].vietnam);
    TextEditingController wordController =
        TextEditingController(text: wordModelList[index].english);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 189, 205, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: wordController,
            style: TextStyle(
                fontSize: 20,
                height: 2,
                fontWeight: FontWeight.w500,
                fontFamily: "Epilogue"),
            decoration: const InputDecoration.collapsed(
              hintText: 'Word',
              border: UnderlineInputBorder(),
              hintStyle: TextStyle(
                  fontSize: 20,
                  height: 2,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Epilogue"),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (newValue) {
              if (index < wordModelList.length) {
                wordModelList[index].english = newValue;
              }
            },
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            'Word',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontFamily: "Epilogue"),
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: defController,
            style: TextStyle(
                fontSize: 20,
                height: 2,
                fontWeight: FontWeight.w500,
                fontFamily: "Epilogue"),
            onTap: () {
              defController.selection = TextSelection(
                  baseOffset: 0, extentOffset: defController.value.text.length);
            },
            decoration: const InputDecoration.collapsed(
                hintText: 'Definition',
                border: UnderlineInputBorder(),
                hintStyle: TextStyle(
                    fontSize: 20,
                    height: 2,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Epilogue")),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (newValue) {
              if (index < wordModelList.length) {
                wordModelList[index].vietnam = newValue;
              }
            },
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            'Definition',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontFamily: "Epilogue"),
          ),
        ],
      ),
    );
  }

  void _importCsv() async {
    setState(() {
      wordModelList.clear();
    });
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null || !result.files.first.name.endsWith('.csv')) return;
    print(result.files.first.name);
    filePath = result.files.first.path!;

    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    print(fields);
    if (fields[0][0] == 'English' && fields[0][1] == 'Vietnamese') {
      for (int i = 1; i < fields.length; i++) {
        wordModelList.add(WordModel());

        setState(() {
          wordModelList[wordModelList.length - 1].english = fields[i][0];
          wordModelList[wordModelList.length - 1].vietnam = fields[i][1];
        });
      }
    }
  }
}
