import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/entities.dart';
import '../localizations/app_localizations.dart';
import '../models/entity_details.dart';
import '../models/entity.dart';
import '../providers/app_data.dart';
import '../widgets/background_image.dart';
import '../widgets/clinic_card.dart';
import '../widgets/modal_sheet_list_tile.dart';
import '../widgets/search_field.dart';
import '../widgets/service_card.dart';

class AvailableScreen extends StatefulWidget {
  static const routeName = '/available';

  @override
  _AvailableScreenState createState() => _AvailableScreenState();
}

class _AvailableScreenState extends State<AvailableScreen> {
  // LatLng _location;
  List _details;
  List _filterList = [];
  List _searchList = [];
  List _cards = [];

  List<City> _cities;
  List<Area> _areas;
  List<Hospital> _hospitals;

  City _city;
  Area _area;
  Hospital _hospital;

  bool _filterSelected = false;
  bool _filterOn = false;
  bool _searchOn = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final entity = ModalRoute.of(context).settings.arguments;
      final response = await EntityAPI.getEntityDetails(context, entity);
      final list = json.decode(response)['details'];
      _details = [];
      if (entity is Clinic) {
        list.forEach((json) => _details.add(ClinicDetail.fromJson(json)));
        _cards = _details.map((detail) {
          return ClinicCard(detail: detail, clinicId: entity.id);
        }).toList();
      } else if (entity is Service) {
        list.forEach((json) => _details.add(ServiceDetail.fromJson(json)));
        _cards = _details.map((detail) {
          return ServiceCard(detail: detail, serviceId: entity.id);
        }).toList();
      }
      await _prepareFilters();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _prepareFilters() async {
    final appData = Provider.of<AppData>(context, listen: false);

    _cities = appData.getCities(context);
    if (_cities.isEmpty) {
      await EntityAPI.getCities(context);
      _cities = appData.getCities(context);
    }

    _areas = appData.getAreas(context);
    if (_areas.isEmpty) {
      await EntityAPI.getAreas(context);
      _areas = appData.getAreas(context);
    }

    _hospitals = appData.getHospitals();
    if (_hospitals.isEmpty) {
      await EntityAPI.getHospitals(context);
      _hospitals = appData.getHospitals();
    }
  }

  void _filter() {
    _filterList.clear();

    if (_hospital != null) {
      _filterList = _details.where((detail) {
        return detail.hospital.name.contains(_hospital.name);
      }).toList();
    } else if (_area != null) {
      _filterList = _details.where((detail) {
        return detail.hospital.area == _area.id;
      }).toList();
    } else if (_city != null) {
      _filterList = _details.where((detail) {
        return detail.hospital.city == _city.id;
      }).toList();
    } else {
      return;
    }
    setState(() {
      _filterSelected = true;
    });
  }

  String _removeWhitespace(String text) {
    return text.replaceAll(' ', '').toLowerCase();
  }

  void _search(String keyword) {
    _searchList.clear();
    keyword = _removeWhitespace(keyword);
    if (keyword.isEmpty) {
      setState(() {
        _controller.clear();
      });
      return;
    }

    final entity = ModalRoute.of(context).settings.arguments;
    if (entity is Clinic) {
      _details.forEach((detail) {
        if (_removeWhitespace(detail.doctor.name).contains(keyword) ||
            _removeWhitespace(detail.doctor.title).contains(keyword) ||
            detail.price.toString().contains(keyword)) {
          _searchList.add(detail);
        }
      });
    } else {
      _details.forEach((detail) {
        if (detail.price.toString().contains(keyword)) {
          _searchList.add(detail);
        }
      });
    }
    setState(() {});
  }

  void onSortClick(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                color: theme.primaryColorLight,
                alignment: Alignment.center,
                child: Text(
                  t('sort_by'),
                  style: theme.textTheme.headline5.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              ModalSheetListTile(
                text: t('price_low'),
                value: Provider.of<AppData>(context).sortingVars[0],
                onSwitchChange:
                    Provider.of<AppData>(context).changeSortPriceLowHigh,
              ),
              ModalSheetListTile(
                text: t('price_high'),
                value: Provider.of<AppData>(context).sortingVars[1],
                onSwitchChange:
                    Provider.of<AppData>(context).changeSortPriceHighLow,
              ),
              // ModalSheetListTile(
              //   text: t('nearest'),
              //   value: Provider.of<AppData>(context).sortingVars[2],
              //   onSwitchChange: () async {
              //     final nearest =
              //         Provider.of<AppData>(context).sortingVars[2];
              //     if (nearest) {
              //       Provider.of<AppData>(context).changeSortNearest();
              //     } else {
              //       final location = await getLocation();
              //       if (location != null) {
              //         _location = LatLng(location.latitude, location.longitude);
              //         Provider.of<AppData>(context).changeSortNearest();
              //       }
              //     }
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  List<ClinicCard> clinicListSorter(
      BuildContext context, List<ClinicCard> entityDetailsList) {
    if (Provider.of<AppData>(context).sortingVars[0] == true) {
      entityDetailsList
          .sort((a, b) => a.detail.price.compareTo(b.detail.price));
      return entityDetailsList;
    } else if (Provider.of<AppData>(context).sortingVars[1] == true) {
      entityDetailsList
          .sort((a, b) => a.detail.price.compareTo(b.detail.price));
      return entityDetailsList.reversed.toList();
    }
    // else if (Provider.of<AppData>(context).sortingVars[2] == true) {
    //   entityDetailsList.sort((a, b) {
    //     final distA = distance(
    //       _location,
    //       LatLng(a.clinicCardData.hospital.lat, a.clinicCardData.hospital.lng),
    //     );
    //     final distB = distance(
    //       _location,
    //       LatLng(b.clinicCardData.hospital.lat, b.clinicCardData.hospital.lng),
    //     );
    //     return distA.compareTo(distB);
    //   });
    //   return entityDetailsList;
    // }
    else {
      return entityDetailsList;
    }
  }

  List<ServiceCard> sorListSorter(
      BuildContext context, List<ServiceCard> entityDetailsList) {
    if (Provider.of<AppData>(context).sortingVars[0] == true) {
      entityDetailsList
          .sort((a, b) => a.detail.price.compareTo(b.detail.price));
      return entityDetailsList;
    } else if (Provider.of<AppData>(context).sortingVars[1] == true) {
      entityDetailsList
          .sort((a, b) => a.detail.price.compareTo(b.detail.price));
      return entityDetailsList.reversed.toList();
    }
    // else if (Provider.of<AppData>(context).sortingVars[2] == true) {
    //   entityDetailsList.sort((a, b) {
    //     final distA = distance(
    //       _location,
    //       LatLng(a.sorCardData.hospital.lat, a.sorCardData.hospital.lng),
    //     );
    //     final distB = distance(
    //       _location,
    //       LatLng(b.sorCardData.hospital.lat, b.sorCardData.hospital.lng),
    //     );
    //     return distA.compareTo(distB);
    //   });
    //   return entityDetailsList;
    // }
    else {
      return entityDetailsList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appData = Provider.of<AppData>(context);
    final entity = ModalRoute.of(context).settings.arguments as NamedEntity;
    setAppLocalization(context);

    if (_details == null) {
      return Scaffold(
        appBar: AppBar(title: Text(entity.name)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_details.length == 0) {
      return Scaffold(
        appBar: AppBar(title: Text(entity.name)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/doctor_sad.png', height: 400),
            const SizedBox(height: 20),
            Text(
              t('no_details'),
              style:
                  theme.textTheme.headline6.copyWith(color: theme.accentColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    List list = [];
    if (_filterSelected && _controller.text.isNotEmpty) {
      list = _filterList.where((detail) {
        return _searchList.contains(detail);
      }).toList();
    } else if (_filterSelected) {
      list = _filterList;
    } else if (_controller.text.isNotEmpty) {
      list = _searchList;
    } else {
      list = _details;
    }

    if (entity is Clinic) {
      _cards = list.map((detail) {
        return ClinicCard(detail: detail, clinicId: entity.id);
      }).toList();
    } else {
      _cards = list.map((detail) {
        return ServiceCard(detail: detail, serviceId: entity.id);
      }).toList();
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text(entity.name)),
      body: BackgroundImage(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: FittedBox(
                          child: Text(
                            _filterOn ? t('close_filter') : t('filter'),
                            textScaleFactor: 0.8,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _filterOn = !_filterOn;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            theme.primaryColor,
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        child: FittedBox(
                          child: Text(
                            _searchOn ? t('close_search') : t('open_search'),
                            textScaleFactor: 0.8,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _searchOn = !_searchOn;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            theme.primaryColor,
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        child: FittedBox(
                          child: Text(t('sort'), textScaleFactor: 0.8),
                        ),
                        onPressed: () {
                          onSortClick(context, theme);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            theme.primaryColor,
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 40),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_filterOn)
                Container(
                  margin:
                      const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: theme.primaryColor),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(t('city'), style: theme.textTheme.headline6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                dropdownColor: theme.primaryColor,
                                iconEnabledColor: Colors.white,
                                //isExpanded: true,
                                value: _city,
                                hint: Text(
                                  t('all'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _city = newValue;
                                    _area = null;
                                    _hospital = null;
                                    _areas =
                                        appData.getCityAreas(context, _city.id);
                                    _hospitals =
                                        appData.getCityHospitals(_city.id);
                                  });
                                },
                                items: _cities.map((City city) {
                                  return DropdownMenuItem(
                                    value: city,
                                    child: Text(
                                      city.name,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(t('area'), style: theme.textTheme.headline6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                dropdownColor: theme.primaryColor,
                                iconEnabledColor: Colors.white,
                                //isExpanded: true,
                                value: _area,
                                hint: Text(
                                  _areas.length == 0 ? t('none') : t('all'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _area = newValue;
                                    _hospital = null;
                                    _hospitals =
                                        appData.getAreaHospitals(_area.id);
                                  });
                                },
                                items: _areas.map((Area area) {
                                  return DropdownMenuItem(
                                    value: area,
                                    child: Text(
                                      area.name,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(t('hospital'), style: theme.textTheme.headline6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                dropdownColor: theme.primaryColor,
                                iconEnabledColor: Colors.white,
                                // isExpanded: true,
                                value: _hospital,
                                hint: Text(
                                  _hospitals.length == 0 ? t('none') : t('all'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _hospital = newValue;
                                  });
                                },
                                items: _hospitals.map((Hospital hospital) {
                                  return DropdownMenuItem(
                                    value: hospital,
                                    child: Text(
                                      hospital.name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                theme.errorColor,
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(120, 40),
                              ),
                            ),
                            child: Text(t('reset'), textScaleFactor: 0.8),
                            onPressed: () {
                              setState(() {
                                _city = _area = _hospital = null;
                                _areas = appData.getAreas(context);
                                _hospitals = appData.getHospitals();
                                _filterSelected = false;
                              });
                            },
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                theme.primaryColor,
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(120, 40),
                              ),
                            ),
                            child: Text(t('filter'), textScaleFactor: 0.8),
                            onPressed: _filter,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (_searchOn)
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                  child: SearchField(
                    controller: _controller,
                    onChanged: _search,
                    hintText: entity is Clinic
                        ? t('search_clinic')
                        : t('search_service'),
                  ),
                ),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowGlow();
                    return;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: _cards.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: _cards[index],
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
