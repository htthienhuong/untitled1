import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled1/Services/UserServices.dart';
import 'package:untitled1/app_data/app_data.dart';

import '../Models/UserModel.dart';
import '../utilities/pick_upload_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  image: DecorationImage(
                      image: NetworkImage(AppData.userModel.avatarUrl!),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? image = await pickImage();
                        if (image != null) {
                          String newUrl = await UserService().updateUserAvatar(
                              AppData.userModel.id, image.files.first.bytes!);
                          setState(() {
                            AppData.userModel.avatarUrl = newUrl;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(300),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(
                                  'assets/images/htth_avt.png'),
                              image: NetworkImage(
                                  AppData.userModel.avatarUrl ?? ''),
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/htth_avt.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      AppData.userModel.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 16, right: 8),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[400]),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                ),
              )
            ],
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User information',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontSize: 20),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromRGBO(179, 179, 179, 1.0)),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(188, 185, 185, 1.0),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        Color.fromRGBO(179, 179, 179, 1.0)))),
                        child: GestureDetector(
                          onTap: () async {
                            TextEditingController textController =
                                TextEditingController();
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Change Username'),
                                content: TextField(
                                  controller: textController,
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                      hintText: "Enter your new name"),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: const Text('Confirm'),
                                    onPressed: () async {
                                      if (textController.text.isNotEmpty) {
                                        await UserService().updateUserName(
                                            AppData.userModel.id,
                                            textController.text);
                                        setState(() {
                                          AppData.userModel.name =
                                              textController.text;
                                        });
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: ListTile(
                            title: const Text(
                              'Username',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              AppData.userModel.name,
                            ),
                            trailing: const Icon(Icons.navigate_next),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        Color.fromRGBO(179, 179, 179, 1.0)))),
                        child: ListTile(
                          title: const Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            AppData.userModel.email,
                          ),
                          trailing: const Icon(Icons.navigate_next),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(10, 10), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Log out',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Pacifico",
                              fontSize: 24),
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
