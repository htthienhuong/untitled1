import 'package:flutter/material.dart';
import 'package:untitled1/Models/TopicModel.dart';
import 'package:untitled1/auth/login_screen.dart';
import 'package:untitled1/leader_boad_page/leading_board_page.dart';
import 'package:untitled1/learnning/typing_test_page.dart';
import 'package:untitled1/topic_page/add_topic_page.dart';
import 'package:untitled1/topic_page/starred_word_page.dart';
import 'package:untitled1/folder_page/folder_detail_page.dart';
import 'package:untitled1/folder_page/folder_addTopic_page.dart';

import 'package:untitled1/topic_page/topic_detail_page.dart';
import 'package:untitled1/topic_page/update_topic_page.dart';

import '../Models/word_model.dart';
import '../Models/Folder.dart';
import '../learnning/flash_card_page.dart';
import '../learnning/multichoice_test_page.dart';
import '../main_page/main_page.dart';

class Routes {
  static const String mainPage = "/mainPage";
  static const String addTopicPage = "/addTopicPage";
  static const String updateTopicPage = "/updateTopicPage";
  static const String topicDetailPage = "/topicDetailPage";
  static const String starredWordPage = "/starredWordPage";
  static const String flashCardPage = '/flashCardPage';
  static const String typingPage = '/typingPage';
  static const String learningPage = '/learningPage';
  static const String leaderBoardPage = "/leaderBoardPage";
  static const String folderDetailPage = "/folderDetailPage";
  static const String folderAddTopicPage = "/folderAddTopicPage";

  static const String loginPage = "/";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.mainPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const MainPage());
      case Routes.addTopicPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => const AddTopicPage());
      case Routes.updateTopicPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => UpdateTopicPage(
                topicModel: routeSettings.arguments as TopicModel));
      case Routes.topicDetailPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => TopicDetailPage(
                topicModel: routeSettings.arguments as TopicModel));
      case Routes.leaderBoardPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) =>
                LeadingBoardPage(id: routeSettings.arguments as String));
      case Routes.starredWordPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => const StarredWordPage());
      case Routes.flashCardPage:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => FlashCardPage(
                  wordModels: args[0],
                  isBack: args[1],
                ));
      case Routes.typingPage:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => TypingTestPage(
                  wordModels: routeSettings.arguments as List<WordModel>,
                ));

      case Routes.loginPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const LoginScreen());
      case Routes.learningPage:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        print('arg[0]: ${args[0]}');
        print('args[1]: ${args[1]}');
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => MultichoiceTestPage(
                  wordModels: args[0] as List<WordModel>,
                  topicId: args[1],
                ));
      case Routes.folderDetailPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) =>
                FolderDetailPage(folder: routeSettings.arguments as Folder));
      case Routes.folderAddTopicPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => AddTopicToFolderPage(
                arguments: routeSettings.arguments as List<dynamic>));
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('No route found'),
              ),
              body: const Center(
                  child: Text(
                'No route found',
                style: TextStyle(color: Colors.white),
              )),
            ));
  }
}
