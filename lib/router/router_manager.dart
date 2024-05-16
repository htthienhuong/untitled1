import 'package:flutter/material.dart';
import 'package:untitled1/Models/TopicModel.dart';
import 'package:untitled1/auth/login_screen.dart';
import 'package:untitled1/topic_page/add_topic_page.dart';
import 'package:untitled1/topic_page/topic_detail_page.dart';
import 'package:untitled1/topic_page/update_topic_page.dart';

import 'package:untitled1/folder_page/folder_detail_page.dart';
import 'package:untitled1/folder_page/folder_addTopic_page.dart';

import '../Models/Folder.dart';
import '../Models/word_model.dart';
import '../learnning/flash_card_page.dart';
import '../learnning/learning_page.dart';
import '../main_page/main_page.dart';

class Routes {
  static const String mainPage = "/mainPage";
  static const String addTopicPage = "/addTopicPage";
  static const String updateTopicPage = "/updateTopicPage";
  static const String topicDetailPage = "/topicDetailPage";
  static const String flashCardPage = '/flashCardPage';
  static const String learningPage = '/learningPage';
  static const String folderDetailPage = '/folderDetailPage';
  static const String folderAddTopicPage = '/folderAddTopicPage';

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
      case Routes.flashCardPage:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => FlashCardPage(
              wordModels: args[0],
              isBack: args[1],
            ));

      case Routes.loginPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const LoginScreen());
      case Routes.learningPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => LearningPage(
              wordModels: routeSettings.arguments as List<WordModel>,
            ));
      case Routes.folderDetailPage:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => FolderDetailPage(
                folder: routeSettings.arguments as Folder));
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