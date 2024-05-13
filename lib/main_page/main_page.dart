import 'package:flutter/material.dart';
import 'package:untitled1/profile_page/profile_page.dart';

import '../folder_page/folder_page.dart';
import '../home_page/home_page.dart';
import '../topic_page/topic_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Widget> bottomBarPages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bottomBarPages = [
      const HomePage(),
      const TopicPage(),
      const FolderPage(),
      const ProfilePage(),
    ];
  }

  final _pageController = PageController(initialPage: 0);

  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  final List<IconData> iconList = [
    Icons.home,
    Icons.topic,
    Icons.folder_outlined,
    Icons.person
  ];

  @override
  Widget build(BuildContext context) {
    print('Build main');
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                elevation: 10,
                backgroundColor: const Color(0xffd0d4ec),
                selectedItemColor: const Color(0xff647ebb),
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.business),
                    label: 'Topic',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.school),
                    label: 'Folder',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _changePage,
              ),
            )
          : null,
    );
  }

  void _changePage(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}
