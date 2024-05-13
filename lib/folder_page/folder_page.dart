import 'package:flutter/material.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildFolderItem(context, index);
        },
      ),
    );
  }

  Widget _buildFolderItem(BuildContext context, int index) {
    print('selectedItem: $selectedItem');
    return Container(
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
                'Folder Name $index',
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
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Edit',
                    child: Row(
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
                  const PopupMenuItem<String>(
                    value: 'Delete',
                    child: Row(
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
          const Text('Description'),
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
                child: const Text('0 words'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
