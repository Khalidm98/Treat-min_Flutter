import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'available_screen.dart';
import '../api/entities.dart';
import '../localizations/app_localizations.dart';
import '../models/entity.dart';
import '../providers/app_data.dart';
import '../utils/enumerations.dart';
import '../widgets/background_image.dart';
import '../widgets/input_field.dart';

class SelectScreen extends StatefulWidget {
  static const routeName = '/select';

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  final _controller = TextEditingController();
  Entity _entity = Entity.clinic;
  AppData _appData;
  List _list = [];
  List _searchList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _entity = ModalRoute.of(context).settings.arguments;
      _appData = Provider.of<AppData>(context, listen: false);
      _list = _appData.getEntities(context, _entity);
      if (_list.isEmpty) {
        await EntityAPI.getEntities(context, _entity);
        _list = _appData.getEntities(context, _entity);
      }
      _searchList = _list.map((entity) => entity).toList();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String keyword) {
    _searchList.clear();
    keyword = keyword.replaceAll(' ', '').toLowerCase();
    if (keyword.isEmpty) {
      setState(() {
        _searchList = _list.map((entity) => entity).toList();
      });
      return;
    }

    _list.forEach((entity) {
      final name = entity.name.replaceAll(' ', '').toLowerCase();
      if (name.contains(keyword)) {
        _searchList.add(entity);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strEntity = entityToString(_entity);
    setAppLocalization(context);

    if (_list.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(t(strEntity))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(t(strEntity))),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: BackgroundImage(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Theme(
                  data: inputTheme(context),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: t('search'),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          _controller.clear();
                          _search('');
                        },
                      ),
                    ),
                    onChanged: _search,
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
                    itemCount: _searchList.length,
                    separatorBuilder: (_, __) {
                      return const Divider(
                          thickness: 1, height: 1, indent: 10, endIndent: 10);
                    },
                    itemBuilder: (_, index) {
                      final id = _searchList[index].id;
                      return ListTile(
                        leading: _entity == Entity.service
                            ? Image.asset(
                                'assets/icons/nav_bar/heart_outlined.png',
                                width: 40,
                                height: 40,
                              )
                            : id <= AppData.maxClinicID
                                ? Image.asset(
                                    'assets/icons/$strEntity/$id.png',
                                    width: 40,
                                    height: 40,
                                  )
                                : Image.network(
                                    'https://www.treat-min.com/'
                                    'media/photos/$strEntity/$id.png',
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
                          _searchList[index].name,
                          textScaleFactor: 0.8,
                          style: theme.textTheme.headline5,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AvailableScreen.routeName,
                            arguments: _entity == Entity.clinic
                                ? Clinic.fromJson(_searchList[index])
                                : Service.fromJson(_searchList[index]),
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
