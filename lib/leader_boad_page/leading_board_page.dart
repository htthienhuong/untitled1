import 'package:flutter/material.dart';
import 'package:untitled1/Services/RecordService.dart';

import 'leading_board_model.dart';

class LeadingBoardPage extends StatefulWidget {
  final String id;
  const LeadingBoardPage({super.key, required this.id});

  @override
  State<LeadingBoardPage> createState() => _LeadingBoardPageState();
}

class _LeadingBoardPageState extends State<LeadingBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe2e9ff),
        elevation: 4,
        title: const Text(
          'Leading Board',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xff1b2794)),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff647ebb),
          ),
        ),
      ),
      body: FutureBuilder<List<LeadingBoardModel>>(
        future: RecordService().getRecordsByTopicId(widget.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<LeadingBoardModel>> snapshot) {
          if (snapshot.hasData) {
            List<LeadingBoardModel> leadingBoardModelList = snapshot.data!;
            leadingBoardModelList.sort((a, b) {
              if(a.point < b.point){
                return 1;
              }
              else if(a.point == b.point){
                return 0;
              }
              else{
                return -1;
              }
            },);
            print("--------------------------------------");
            print('data: $leadingBoardModelList');

            return MyBoard(leadingBoardModelList: leadingBoardModelList);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/background_leading_board.jpg'),
                      fit: BoxFit.cover)),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class MyBoard extends StatefulWidget {
  final List<LeadingBoardModel> leadingBoardModelList;
  const MyBoard({super.key, required this.leadingBoardModelList});

  @override
  State<MyBoard> createState() => _MyBoardState();
}

class _MyBoardState extends State<MyBoard> {
  @override
  Widget build(BuildContext context) {
    print('leadingBoardModelList: ${widget.leadingBoardModelList}');
    return
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background_leading_board.jpg'),
                fit: BoxFit.cover)),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          '#${index + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 24),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 6,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(
                                  'assets/images/default_profile.png'),
                              image: NetworkImage(widget
                                  .leadingBoardModelList[index].userAvatar),
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/images/htth_avt.png'),),

                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.leadingBoardModelList[index].userName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      '${widget.leadingBoardModelList[index].point}point Pts',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: widget.leadingBoardModelList.length,
        ),
      );
  }
}
