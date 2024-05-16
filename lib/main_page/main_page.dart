import 'package:flutter/material.dart';
import 'package:untitled1/folder_page/add_folder_dialog.dart';

import 'package:untitled1/profile_page/profile_page.dart';

import '../folder_page/folder_page.dart';
import '../home_page/home_page.dart';
import '../router/router_manager.dart';
import '../topic_page/topic_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Widget> bottomBarPages;
  late GlobalKey _folderPageKey;
  late GlobalKey _topicPageKey;
  late final List<FloatingActionButton?> floatingActionButtonList;
  late final List<PreferredSizeWidget?> appBarList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _folderPageKey = GlobalKey();
    _topicPageKey = GlobalKey();

    bottomBarPages = [
      const HomePage(),
      TopicPage(
        key: _topicPageKey,
      ),
      FolderPage(
        key: _folderPageKey,
      ),
      const ProfilePage(),
    ];

    floatingActionButtonList = [
      null,
      FloatingActionButton(
        backgroundColor: const Color(0xffd0d4ec),
        shape: const CircleBorder(),
        onPressed: () async {
          await Navigator.pushNamed(context, Routes.addTopicPage);

          _topicPageKey.currentState?.setState(() {});
        },
        child: const Icon(
          Icons.add,
          color: Color(0xff647ebb),
        ),
      ),
      FloatingActionButton(
        backgroundColor: const Color(0xffd0d4ec),
        shape: const CircleBorder(),
        onPressed: () async{
          await showDialog(
            context: context,
            builder: (_) => AddFolderDialog(),
          );
          _folderPageKey.currentState?.setState(() {});
        },
        child: const Icon(
          Icons.add,
          color: Color(0xff647ebb),
        ),
      ),
      null
    ];
    appBarList = [
      AppBar(
        backgroundColor: const Color(0xffe2e9ff),
        title: const Text(
          'Home',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1b2794)),
        ),
        centerTitle: true,
      ),
      AppBar(
        backgroundColor: const Color(0xffe2e9ff),
        title: const Text(
          'Topic',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1b2794)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.starredWordPage);
              },
              icon: const Icon(
                Icons.star,
                color: Colors.orange,
              ))
        ],
      ),
      AppBar(
        backgroundColor: const Color(0xffe2e9ff),
        title: const Text(
          'Folder',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1b2794)),
        ),
        centerTitle: true,
      ),
      // AppBar(
      //   backgroundColor: const Color(0xffe2e9ff),
      //   title: const Text(
      //     'Profile',
      //     style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1b2794)),
      //   ),
      //   centerTitle: true,
      // ),
      null,
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
      appBar: appBarList[_selectedIndex],
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      floatingActionButton: floatingActionButtonList[_selectedIndex],
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
