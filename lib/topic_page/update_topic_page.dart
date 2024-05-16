import 'package:flutter/material.dart';
import 'package:untitled1/Services/TopicServices.dart';
import 'package:untitled1/Services/WordServices.dart';

import '../Models/TopicModel.dart';
import '../Models/word_model.dart';

class UpdateTopicPage extends StatefulWidget {
  final TopicModel topicModel;
  const UpdateTopicPage({super.key, required this.topicModel});

  @override
  State<UpdateTopicPage> createState() => _UpdateTopicPageState();
}

class _UpdateTopicPageState extends State<UpdateTopicPage> {
  String? filePath;

  final List<WordModel> wordModelList = [];
  final List<WordModel> oldWordModelList = [];

  final _formKey = GlobalKey<FormState>();
  bool public = false;
  String? dropDownValue = 'Private';
  late String topicName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
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
          "Edit Topic",
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                for (WordModel word in wordModelList) {
                  if (word.id == null) {
                    WordService().addWord(
                        word.english!, word.vietnam!, widget.topicModel.id!);
                  }
                }
                for (WordModel word in oldWordModelList) {
                  if (wordModelList.contains(word)) {
                    await WordService().updateWord(word);
                  } else {
                    await WordService().deleteWord(word);
                  }
                }
                await TopicService().updateTopicName(widget.topicModel.id!, {
                  'topicName': widget.topicModel.topicName,
                  'isPublic': public
                });
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
      body: FutureBuilder(
        future:
            WordService().getWordListFromRef(widget.topicModel.wordReferences!),
        builder:
            (BuildContext context, AsyncSnapshot<List<WordModel>> snapshot) {
          if (snapshot.hasData) {
            if (wordModelList.isEmpty) {
              wordModelList.addAll(snapshot.data!);
              oldWordModelList.addAll(List.from(snapshot.data!));
            }
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      maxLines: null,
                      initialValue: widget.topicModel.topicName,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Topic',
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        widget.topicModel.topicName = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Topic',
                      style:
                          TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: false,
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
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('error');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildItemWord(int index) {
    TextEditingController defController =
        TextEditingController(text: wordModelList[index].vietnam);
    TextEditingController wordController =
        TextEditingController(text: wordModelList[index].english);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: wordController,
            decoration: const InputDecoration.collapsed(
              hintText: 'Word',
              border: UnderlineInputBorder(),
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
            height: 8,
          ),
          const Text(
            'Word',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: defController,
            onTap: () {
              defController.selection = TextSelection(
                  baseOffset: 0, extentOffset: defController.value.text.length);
            },
            decoration: const InputDecoration.collapsed(
              hintText: 'Definition',
              border: UnderlineInputBorder(),
            ),
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
            height: 8,
          ),
          const Text(
            'Definition',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
