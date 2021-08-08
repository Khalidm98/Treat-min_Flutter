import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './available_screen.dart';
import '../api/entities.dart';
import '../localizations/app_localizations.dart';
import '../models/screens_data.dart';
import '../providers/app_data.dart';
import '../utils/enumerations.dart';
import '../widgets/background_image.dart';
import '../widgets/input_field.dart';

class SelectScreen extends StatefulWidget {
  static const String routeName = '/select';

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  final controller = TextEditingController();
  Entity entity = Entity.clinic;
  AppData appData;
  List list = [];
  List searchList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      entity = ModalRoute.of(context).settings.arguments;
      appData = Provider.of<AppData>(context, listen: false);
      list = appData.getEntities(context, entity);
      if (list.isEmpty) {
        final response = await EntityAPI.getEntities(context, entity);
        if (!response) {
          Navigator.pop(context);
        }
        list = appData.getEntities(context, entity);
      }
      searchList = json.decode(json.encode(list));
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search(String keyword) {
    searchList.clear();
    keyword = keyword.replaceAll(' ', '').toLowerCase();
    if (keyword.isEmpty) {
      searchList = json.decode(json.encode(list));
      setState(() {});
      return;
    }

    list.forEach((entity) {
      final name = entity['name'].replaceAll(' ', '').toLowerCase();
      if (name.contains(keyword)) {
        searchList.add(entity);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strEntity = entityToString(entity);
    setAppLocalization(context);

    if (list.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(t(strEntity))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final baseURL = 'https://www.treat-min.com/media/photos/$strEntity';
    final maxID = appData.maxID(entity);
    return Scaffold(
      appBar: AppBar(title: Text(t(strEntity))),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BackgroundImage(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Theme(
                  data: inputTheme(context),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: t('search'),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          controller.clear();
                          search('');
                        },
                      ),
                    ),
                    onChanged: search,
                  ),
                ),
              ),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowGlow();
                    return;
                  },
                  child: ListView.separated(
                    itemCount: searchList.length,
                    separatorBuilder: (_, __) {
                      return const Divider(
                          thickness: 1, height: 1, indent: 10, endIndent: 10);
                    },
                    itemBuilder: (_, index) {
                      final id = searchList[index]['id'];
                      return ListTile(
                        leading: entity == Entity.service
                            ? Image.asset(
                                'assets/icons/nav_bar/heart_outlined.png',
                                width: 40,
                                height: 40,
                              )
                            : id <= maxID
                                ? Image.asset(
                                    'assets/icons/$strEntity/$id.png',
                                    width: 40,
                                    height: 40,
                                  )
                                : Image.network(
                                    '$baseURL/$id.png',
                                    width: 40,
                                    height: 40,
                                    errorBuilder: (_, __, ___) {
                                      return Image.asset(
                                        'assets/icons/nav_bar/heart_outlined.png',
                                        width: 40,
                                        height: 40,
                                      );
                                    },
                                  ),
                        title: Text(
                          searchList[index]['name'],
                          textScaleFactor: 0.8,
                          style: theme.textTheme.headline5,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AvailableScreen.routeName,
                            arguments:
                                AvailableScreenData(searchList[index], entity),
                          );
                        },
                      );
                    },
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
