// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:csv/csv.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import '../Models/TopicModel.dart';
// import '../Models/word_model.dart';
//
// class AddPage extends StatefulWidget {
//   final TopicModel? topicModel;
//   const AddPage({super.key, this.topicModel});
//
//   @override
//   State<AddPage> createState() => _AddTopicPageState();
// }
//
// class _AddTopicPageState extends State<AddPage> {
//   String? filePath;
//
//   final List<WordModel> wordModelList = [];
//
//   int itemWordCount = 2;
//   TopicModel newTopic = TopicModel();
//   final _formKey = GlobalKey<FormState>();
//   late String TOPIC_ID;
//   late StreamSubscription _subscription;
//   late TopicListBloc topicBloc;
//   bool public = false;
//   String? dropDownValue = 'Private';
//   PlatformFile? image;
//   String? url;
//   final translator = GoogleTranslator();
//
//   @override
//   void initState() {
//     if (widget.topicModel != null) {
//       if (widget.topicModel!.words != null &&
//           widget.topicModel!.words!.isNotEmpty) {
//         itemWordCount = widget.topicModel!.words!.length;
//         for (WordModel wordModel in widget.topicModel!.words!) {
//           wordModelList.add(wordModel.copyWith());
//         }
//       }
//       print('widget.topicModel: ${widget.topicModel!.toJson()}');
//       if (widget.topicModel!.public!) {
//         public = true;
//         dropDownValue = 'Public';
//       }
//     } else {
//       wordModelList.add(WordModel());
//       wordModelList.add(WordModel());
//     }
//     topicBloc = BlocProvider.of<TopicListBloc>(context);
//
//     _subscription = topicBloc.stream.listen((state) {
//       print('_subscription = topicBloc.stream.listen((state): $state');
//       if (state is TopicInsertedState) {
//         TOPIC_ID = state.topicModel.id!;
//         // add word for new topic
//         if (widget.topicModel == null) {
//           for (WordModel wordModel in wordModelList) {
//             wordModel.topicId = TOPIC_ID;
//             context.read<WordCubit>().addWord(wordModel);
//           }
//           Navigator.pop(context);
//         }
//         _subscription.cancel();
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: Container(
//         margin: const EdgeInsets.only(bottom: 50),
//         child: FloatingActionButton(
//           backgroundColor: Colors.black,
//           onPressed: () {
//             wordModelList.add(WordModel());
//
//             setState(() {
//               itemWordCount++;
//             });
//           },
//           child: const Icon(
//             Icons.add,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           widget.topicModel == null ? "Create Topic" : "Update Topic",
//           style: const TextStyle(
//               fontWeight: FontWeight.bold, fontFamily: "Pacifico"),
//         ),
//         actions: [
//           if (widget.topicModel == null)
//             IconButton(
//                 onPressed: () {
//                   _pickFile();
//                 },
//                 icon: const Icon(FontAwesomeIcons.fileCsv)),
//           IconButton(
//             onPressed: () async {
//               if (_formKey.currentState!.validate()) {
//                 _formKey.currentState!.save();
//                 if (widget.topicModel != null) {
//                   if (context.mounted) {
//                     newTopic.words = wordModelList;
//                     newTopic.public = public;
//                     if (image != null) {
//                       url = await ApiService.uploadImage(
//                           image!.extension!, image!.bytes!);
//                       newTopic.url = url!;
//                     }
//                     if (context.mounted) {
//                       context
//                           .read<TopicCubit>()
//                           .updateTopic(widget.topicModel!, newTopic);
//                       Navigator.popUntil(
//                           context, ModalRoute.withName(Routes.topicPage));
//                     }
//                   }
//                 }
//               }
//             },
//             icon: const Icon(
//               Icons.done,
//               size: 32,
//             ),
//           ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 initialValue: widget.topicModel?.name,
//                 decoration: const InputDecoration.collapsed(
//                   hintText: 'Topic',
//                   border: UnderlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter some text';
//                   }
//                   return null;
//                 },
//                 onSaved: (newValue) async {
//                   if (widget.topicModel == null) {
//                     if (image != null) {
//                       url = await ApiService.uploadImage(
//                           image!.extension!, image!.bytes!);
//                     }
//                     if (context.mounted) {
//                       context.read<TopicListBloc>().add(
//                             TopicInsertedEvent(
//                               topicInfo: TopicModel(
//                                   name: newValue,
//                                   public: public,
//                                   url: url ??
//                                       'https://uni-quizlet.s3.ap-southeast-1.amazonaws.com/bf244890818d4c7da00f9de6684893821715178882.jpg'),
//                             ),
//                           );
//                     }
//                   } else {
//                     newTopic.id = widget.topicModel!.id;
//                     newTopic.name = newValue;
//                     for (WordModel wordModel in wordModelList) {
//                       wordModel.topicId = widget.topicModel!.id;
//                     }
//                   }
//                 },
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               const Text(
//                 'Topic',
//                 style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 height: 50,
//                 width: double.maxFinite,
//                 child: DropdownButtonFormField(
//                   value: dropDownValue, // this
//                   items: ["Private", "Public"]
//                       .map<DropdownMenuItem<String>>((String value) =>
//                           DropdownMenuItem<String>(
//                               value:
//                                   value, // add this property an pass the _value to it
//                               child: Text(
//                                 value,
//                               )))
//                       .toList(),
//                   onChanged: (value) {
//                     if (value == 'Public') {
//                       public = true;
//                     } else {
//                       public = false;
//                     }
//                     print("public: $public");
//                   },
//                 ),
//               ),
//               MyImagePicker(
//                 getImage: getImage,
//                 topicModel: widget.topicModel,
//               ),
//               // Center(
//               //   child: GestureDetector(
//               //     onTap: () async {
//               //       var result = await pickImage();
//               //       if (result != null) {
//               //         setState(() {
//               //           image = result.files.first;
//               //         });
//               //       }
//               //     },
//               //     child: Container(
//               //       decoration: BoxDecoration(
//               //           border: Border.all(width: 1),
//               //           borderRadius: BorderRadius.circular(15)),
//               //       height: 200,
//               //       margin:
//               //           const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               //       padding: const EdgeInsets.all(1),
//               //       child: image == null
//               //           ? widget.topicModel != null
//               //               ? ClipRRect(
//               //                   borderRadius: BorderRadius.circular(15),
//               //                   child: FadeInImage(
//               //                     fit: BoxFit.cover,
//               //                     image: NetworkImage(
//               //                       widget.topicModel!.url,
//               //                     ),
//               //                     placeholder: const AssetImage(
//               //                         'assets/images/topic.png'),
//               //                     imageErrorBuilder:
//               //                         (context, error, stackTrace) {
//               //                       return Image.asset(
//               //                           'assets/images/topic.png');
//               //                     },
//               //                   ),
//               //                 )
//               //               : const Center(
//               //                   child: Icon(Icons.add_photo_alternate_outlined))
//               //           : Container(
//               //               decoration: BoxDecoration(
//               //                 border: Border.all(color: Colors.transparent),
//               //                 borderRadius: BorderRadius.circular(15),
//               //                 image: DecorationImage(
//               //                     image: MemoryImage(
//               //                       image!.bytes!,
//               //                     ),
//               //                     fit: BoxFit.cover),
//               //               ),
//               //             ),
//               //     ),
//               //   ),
//               // ),
//               Expanded(
//                 child: ListView.builder(
//                     shrinkWrap: false,
//                     itemCount: wordModelList.length,
//                     itemBuilder: (context, index) {
//                       return Dismissible(
//                           direction: DismissDirection.endToStart,
//                           onDismissed: (direction) {
//                             wordModelList.removeAt(index);
//                           },
//                           confirmDismiss: (direction) async {
//                             return await showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: const Text("Confirm"),
//                                   content: const Text(
//                                       "Are you sure you wish to delete this word?"),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.of(context).pop(true),
//                                       child: const Text(
//                                         "DELETE",
//                                         style: TextStyle(color: Colors.red),
//                                       ),
//                                     ),
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.of(context).pop(false),
//                                       child: const Text(
//                                         "CANCEL",
//                                         style: TextStyle(color: Colors.grey),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                           background: Container(
//                             color: Colors.red,
//                             alignment: Alignment.centerRight,
//                             child: const Padding(
//                               padding: EdgeInsets.only(right: 40.0),
//                               child: Icon(
//                                 Icons.delete,
//                                 size: 40,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           key: UniqueKey(),
//                           child: _buildItemWord(index));
//                     }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void getImage(PlatformFile? image) {
//     this.image = image;
//   }
//
//   Widget _buildItemWord(int index) {
//     TextEditingController defController =
//         TextEditingController(text: wordModelList[index].definition);
//     TextEditingController wordController =
//         TextEditingController(text: wordModelList[index].name);
//     print('controller: $defController');
//
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(10)),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextFormField(
//             controller: wordController,
//             onChanged: (value) async {
//               var defTran;
//               try {
//                 defTran = await translator.translate(value,
//                     to: (ApiService.userModel.languageCode ?? 'vi')
//                         .toLowerCase());
//                 defController.text = defTran.text;
//               } catch (e) {
//                 defController.text = '';
//               }
//             },
//             decoration: const InputDecoration.collapsed(
//               hintText: 'Word',
//               border: UnderlineInputBorder(),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter some text';
//               }
//               return null;
//             },
//             onSaved: (newValue) {
//               if (index < wordModelList.length) {
//                 wordModelList[index].name = newValue;
//               }
//             },
//           ),
//           const SizedBox(
//             height: 8,
//           ),
//           const Text(
//             'Word',
//             style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
//           ),
//           TextFormField(
//             controller: defController,
//             onTap: () {
//               defController.selection = TextSelection(
//                   baseOffset: 0, extentOffset: defController.value.text.length);
//             },
//             decoration: const InputDecoration.collapsed(
//               hintText: 'Definition',
//               border: UnderlineInputBorder(),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter some text';
//               }
//               return null;
//             },
//             onSaved: (newValue) {
//               if (index < wordModelList.length) {
//                 wordModelList[index].definition = newValue;
//               }
//             },
//           ),
//           const SizedBox(
//             height: 8,
//           ),
//           const Text(
//             'Definition',
//             style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _pickFile() async {
//     setState(() {
//       wordModelList.clear();
//     });
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.custom,
//       allowedExtensions: ['csv'],
//     );
//
//     // if no file is picked
//     if (result == null || !result.files.first.name.endsWith('.csv')) return;
//     // we will log the name, size and path of the
//     // first picked file (if multiple are selected)
//     print(result.files.first.name);
//     filePath = result.files.first.path!;
//
//     final input = File(filePath!).openRead();
//     final fields = await input
//         .transform(utf8.decoder)
//         .transform(const CsvToListConverter())
//         .toList();
//     print(fields);
//     if (fields[0][0] == 'Word' && fields[0][1] == 'Definition') {
//       print('length: ${wordModelList.length}');
//
//       for (int i = 1; i < fields.length; i++) {
//         wordModelList.add(WordModel());
//
//         setState(() {
//           wordModelList[wordModelList.length - 1].name = fields[i][0];
//           wordModelList[wordModelList.length - 1].definition = fields[i][1];
//         });
//
//         print('field: ${fields[i]}');
//         print('wordModelList: ${wordModelList[i - 1].name}');
//       }
//     }
//   }
// }
//
// class MyImagePicker extends StatefulWidget {
//   final Function? getImage;
//   final TopicModel? topicModel;
//   const MyImagePicker({super.key, this.topicModel, this.getImage});
//
//   @override
//   State<MyImagePicker> createState() => _MyImagePickerState();
// }
//
// class _MyImagePickerState extends State<MyImagePicker> {
//   PlatformFile? image;
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTap: () async {
//           var result = await pickImage();
//           if (result != null) {
//             setState(() {
//               image = result.files.first;
//             });
//             widget.getImage!(image);
//           }
//         },
//         child: Container(
//           decoration: BoxDecoration(
//               border: Border.all(width: 1),
//               borderRadius: BorderRadius.circular(15)),
//           height: 200,
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           padding: const EdgeInsets.all(1),
//           child: image == null
//               ? widget.topicModel != null
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(15),
//                       child: FadeInImage(
//                         fit: BoxFit.cover,
//                         image: NetworkImage(
//                           widget.topicModel!.url,
//                         ),
//                         placeholder:
//                             const AssetImage('assets/images/topic.png'),
//                         imageErrorBuilder: (context, error, stackTrace) {
//                           return Image.asset('assets/images/topic.png');
//                         },
//                       ),
//                     )
//                   : const Center(
//                       child: Icon(Icons.add_photo_alternate_outlined))
//               : Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.transparent),
//                     borderRadius: BorderRadius.circular(15),
//                     image: DecorationImage(
//                         image: MemoryImage(
//                           image!.bytes!,
//                         ),
//                         fit: BoxFit.cover),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
