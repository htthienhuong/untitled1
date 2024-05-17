import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled1/Services/UserServices.dart';
import 'package:untitled1/app_data/app_data.dart';
import 'package:untitled1/router/router_manager.dart';

import '../Models/UserModel.dart';
import '../auth/auth_service.dart';
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
          SizedBox(
            height: 355,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: FadeInImage(
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder:
                          const AssetImage('assets/images/htth_avt.png'),
                      image: NetworkImage(AppData.userModel.avatarUrl ?? ''),
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                        'assets/images/htth_avt.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? image = await pickImage();
                          if (image != null) {
                            String newUrl = await UserService()
                                .updateUserAvatar(AppData.userModel.id,
                                    image.files.first.bytes!);
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
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                  'assets/images/htth_avt.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        AppData.userModel.name,
                        style: const TextStyle(
                            color: Color(0xff04236c),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User information',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1b2794),
                      fontSize: 20),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: const Color(0xffd0d4ec),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xff647ebb),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xffc8d7ef),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Color(0xff647ebb)))),
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1b2794)),
                            ),
                            subtitle: Text(
                              AppData.userModel.name,
                              style: const TextStyle(color: Color(0xff2c38a4)),
                            ),
                            trailing: const Icon(Icons.navigate_next),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Color(0xff647ebb)))),
                        child: ListTile(
                          title: const Text(
                            'Email',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1b2794)),
                          ),
                          subtitle: Text(
                            AppData.userModel.email,
                            style: const TextStyle(color: Color(0xff2c38a4)),
                          ),
                          trailing: const Icon(Icons.navigate_next),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const SimpleDialog(
                                title: Text(
                                  'Change Password',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                children: [UpdatePasswordForm()],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const ListTile(
                            title: Text(
                              'Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1b2794)),
                            ),
                            trailing: Icon(Icons.navigate_next),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: const Color(0xffe2e9ff),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xff647ebb)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await AuthService().signOut();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.loginPage, (route) => false);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Log out',
                          style:
                              TextStyle(color: Color(0xff1b2794), fontSize: 24),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UpdatePasswordForm extends StatefulWidget {
  const UpdatePasswordForm({super.key});

  @override
  State<UpdatePasswordForm> createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<UpdatePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String? newPassword;
  String? oldPassword;
  String? renewPassword;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }

                  return null;
                },
                onSaved: (newValue) {
                  oldPassword = newValue;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: Colors.grey)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (newPassword != renewPassword) {
                    return 'New password now match with re new password';
                  }

                  return null;
                },
                onSaved: (newValue) {
                  newPassword = newValue;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.grey)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (newPassword != renewPassword) {
                    return 'New password now match with re new password';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  renewPassword = newValue;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      elevation: 2,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () async {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      bool isValid = true;
                      try {
                        // await ApiService.updatePassword(
                        //     oldPassword!, newPassword!);
                        await AuthService()
                            .changePassword(oldPassword!, newPassword!);
                      } catch (e) {
                        setState(() {
                          error = e.toString().split('] ')[1];
                          isValid = false;
                        });
                      }
                      if (context.mounted && isValid) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Update password successfully')),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Submit',
                    style:
                        TextStyle(color: Colors.black, fontFamily: "Pacifico"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
