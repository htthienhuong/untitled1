import 'package:flutter/material.dart';
import 'package:untitled1/router/router_manager.dart';
import 'package:untitled1/folder_page/edit_folder_dialog.dart';
import '../app_data/app_data.dart';
import '../Services/FolderService.dart';
import '../Models/Folder.dart';
class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage>
    with SingleTickerProviderStateMixin {
  String? selectedItem;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.green,
            indicatorColor: Colors.green,
            controller: _tabController,
            tabs: const <Tab>[
              Tab(text: "Folder"),
              Tab(text: "Starred"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                FutureBuilder(
                    future: FolderService().getAllFoldersOfUser(AppData.userModel.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Folder>> snapshot) {
                      if (snapshot.hasData) {
                        List<Folder> folderList = snapshot.data!;
                        print(folderList.length);
                        return ListView.builder(
                          itemCount: folderList.length,
                          itemBuilder: (context, index) {
                            return _buildFolderItem(context, folderList[index]);
                          },
                        );
                      } else if (snapshot.hasData) {
                        return const Text('Error');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                Container(color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderItem(BuildContext context, Folder folder) {
    print('selectedItem: $selectedItem');
    return GestureDetector(
        onTap: () {
      Navigator.pushNamed(context, Routes.folderDetailPage,
          arguments: folder);
    },
    child:
      Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffdce1ef),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                folder.folderName,
                style: const TextStyle(fontSize: 20),
              ),
              PopupMenuButton<String>(
                color: const Color(0xffbcc1d0),
                initialValue: selectedItem,
                onSelected: (String item) {
                  setState(() {
                    selectedItem = item;
                  });
                },
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => EditFolderDialog(folder: folder,),
                      );
                      setState(() {});
                    },
                    value: 'Edit',
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.edit_note_outlined,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  const PopupMenuDivider(
                    height: 1,
                  ),
                  PopupMenuItem<String>(
                    onTap: () async {
                      await FolderService().deleteFolderWithUserReference(
                          folder, AppData.userModel.id);
                      setState(() {});
                    },
                    value: 'Delete',
                    child: const Row(
                      children: [
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(folder.description!),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage(
                        placeholder:
                            const AssetImage('assets/images/htth_avt.png'),
                        image: const NetworkImage('xxx'),
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/htth_avt.png'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text('Thien Huong'),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xffacbdd0),
                    borderRadius: BorderRadius.circular(8)),
                child: Text('${folder.Topics?.length ?? 0} topics'),
              ),
            ],
          )
        ],
      ),
    ),
    );
  }
}
