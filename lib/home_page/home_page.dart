import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black)),
            child: Row(
              children: [
                const Expanded(child: TextField()),
                const VerticalDivider(
                  color: Colors.black,
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              ],
            ),
          ),
          const Text(
            'Community',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildTopicItem(context, index);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopicItem(BuildContext context, int index) {
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
                'Topic Name $index',
                style: const TextStyle(fontSize: 20),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xffacbdd0),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('0 words'),
              ),
            ],
          ),
          const Text('Description'),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/images/htth_avt.png'),
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
          )
        ],
      ),
    );
  }

  final List<String> myCoolStrings = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Some other item'
  ];
  final List<String> _results = []; // Empty at start

  void _handleSearch(String input) {
    _results.clear();
    for (var str in myCoolStrings) {
      if (str.toLowerCase().contains(input.toLowerCase())) {
        setState(() {
          _results.add(str);
        });
      }
    }
  }
}
