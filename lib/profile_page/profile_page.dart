import 'package:flutter/material.dart';
import 'package:untitled1/Services/UserServices.dart';
import 'package:untitled1/app_data/app_data.dart';

import '../Models/UserModel.dart';

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
    return FutureBuilder(
      future: UserService().getUserById(AppData.userModel.id),
      builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
        if (snapshot.hasData) {
          UserModel userModel = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      image: DecorationImage(
                          image: AssetImage('assets/images/bg.png'),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(300),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: FadeInImage(
                              placeholder: const AssetImage(
                                  'assets/images/htth_avt.png'),
                              image: NetworkImage(userModel.avatarUrl ?? ''),
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/htth_avt.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          userModel.name,
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
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'USERNAME',
                      style: TextStyle(
                          color: Color(0xff711819),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 45,
                      child: const TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Email',
                      style: TextStyle(
                          color: Color(0xff711819),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 45,
                      child: const TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'PASSWORD',
                      style: TextStyle(
                          color: Color(0xff711819),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 45,
                      child: const TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'CONFIRM PASSWORD',
                      style: TextStyle(
                          color: Color(0xff711819),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 45,
                      child: const TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: const Color(0xff5260a6)),
                            onPressed: () {},
                            child: const Text(
                              'Update',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ))
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('error');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
