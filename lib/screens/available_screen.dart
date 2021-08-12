import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/entities.dart';
import '../localizations/app_localizations.dart';
import '../models/card_data.dart';
import '../models/filtration.dart';
import '../models/entity.dart';
import '../providers/app_data.dart';
import '../utils/enumerations.dart';
import '../widgets/background_image.dart';
import '../widgets/clinic_card.dart';
import '../widgets/input_field.dart';
import '../widgets/modal_sheet_list_tile.dart';
import '../widgets/service_card.dart';

class AvailableScreen extends StatefulWidget {
  static const routeName = '/available';

  @override
  _AvailableScreenState createState() => _AvailableScreenState();
}

class _AvailableScreenState extends State<AvailableScreen> {
  // LatLng _location;
  String _response = '';
  List<Detail> _details = [];
  List _cards = [];
  AppData _appData;

  List<City> _cities;
  List<Area> _areas;

  bool filterClicked = false;
  bool searchOn = false;

  //entities+detail lists
  ClinicCardData clinicData;
  List<ClinicDetail> clinicDataFiltered = [];
  SORCardData sorData;
  List<ServiceDetail> sorDataFiltered = [];

  //search results
  List<ClinicCard> clinicCardsListSearched = [];
  List<ServiceCard> sorCardsListSearched = [];

  //filter results
  //rendered
  List<ClinicCard> clinicCardsListFiltered = [];
  List<ServiceCard> sorCardsListFiltered = [];

  List<ServiceCard> sorCardsList = [];

  City cityDDV;
  Area areaDDV;
  FiltrationHospital hospitalDDV;
  bool filterOn = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getHospitals(context);
    Future.delayed(Duration.zero, () async {
      final entity = ModalRoute.of(context).settings.arguments;
      _response = await EntityAPI.getEntityDetails(context, entity);
      final list = json.decode(_response)['details'];
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
      setState(() {});

      _appData = Provider.of<AppData>(context, listen: false);
      _prepareFilters();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _prepareFilters() async {
    _cities = _appData.getCities(context);
    if (_cities.isEmpty) {
      await EntityAPI.getCities(context);
      _cities = _appData.getCities(context);
    }

    _areas = _appData.getAreas(context);
    if (_areas.isEmpty) {
      await EntityAPI.getAreas(context);
      _areas = _appData.getAreas(context);
    }
  }

  Widget _noDetails(ThemeData theme, EntityClass entity) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/doctor_sad.png', height: 400),
        const SizedBox(height: 20),
        Text(
          t('no_details'),
          style: theme.textTheme.headline6.copyWith(color: theme.accentColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
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

  String removeWhitespace(String text) {
    String newText = text.replaceAll(" ", "");
    return newText;
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

  Future<void> getHospitals(BuildContext context) async {
    final response = await EntityAPI.getHospitals(context);
    if (!response) {
      Navigator.pop(context);
    }
  }

  List filterCards(
      City city, Area area, FiltrationHospital hospital, Entity entity) {
    List filteredClinics = [];
    List filteredSOR = [];
    if (city != null && area == null && hospital == null) {
      if (entity == Entity.clinic) {
        filteredClinics = clinicData.details
            .where((element) => element.hospital.city.contains(city.name))
            .toList();
        return filteredClinics;
      } else {
        List filteredSOR = sorData.details
            .where((element) => element.hospital.city.contains(city.name))
            .toList();
        return filteredSOR;
      }
    }
    if (city != null && area != null && hospital == null) {
      if (entity == Entity.clinic) {
        filteredClinics = clinicData.details
            .where((element) =>
                element.hospital.city.contains(city.name) &&
                element.hospital.area.contains(area.name))
            .toList();
        return filteredClinics;
      } else {
        List filteredSOR = sorData.details
            .where((element) =>
                element.hospital.city.contains(city.name) &&
                element.hospital.area.contains(area.name))
            .toList();
        return filteredSOR;
      }
    }
    if (city != null && area != null && hospital != null) {
      if (entity == Entity.clinic) {
        filteredClinics = clinicData.details
            .where((element) =>
                element.hospital.city.contains(city.name) &&
                element.hospital.area.contains(area.name) &&
                element.hospital.name == hospital.name)
            .toList();
        return filteredClinics;
      } else {
        List filteredSOR = sorData.details
            .where((element) =>
                element.hospital.city.contains(city.name) &&
                element.hospital.area.contains(area.name) &&
                element.hospital.name == hospital.name)
            .toList();
        return filteredSOR;
      }
    }
    if (city == null && area == null && hospital != null) {
      if (entity == Entity.clinic) {
        filteredClinics = clinicData.details
            .where((element) => element.hospital.name == hospital.name)
            .toList();
        return filteredClinics;
      } else {
        List filteredSOR = sorData.details
            .where((element) => element.hospital.name == hospital.name)
            .toList();
        return filteredSOR;
      }
    }
    if (city != null && area == null && hospital != null) {
      if (entity == Entity.clinic) {
        filteredClinics = clinicData.details
            .where((element) =>
                element.hospital.city.contains(city.name) &&
                element.hospital.name == hospital.name)
            .toList();
        return filteredClinics;
      } else {
        List filteredSOR = sorData.details
            .where((element) =>
                element.hospital.city.contains(city.name) &&
                element.hospital.name == hospital.name)
            .toList();
        return filteredSOR;
      }
    }
    if (city == null && area != null && hospital != null) {
      if (entity == Entity.clinic) {
        filteredClinics = clinicData.details
            .where((element) =>
                element.hospital.area.contains(area.name) &&
                element.hospital.name == hospital.name)
            .toList();
        return filteredClinics;
      } else {
        List filteredSOR = sorData.details
            .where((element) =>
                element.hospital.area.contains(area.name) &&
                element.hospital.name == hospital.name)
            .toList();
        return filteredSOR;
      }
    }
    if (city == null && area != null && hospital == null) {
      if (entity == Entity.clinic) {
        filteredClinics = clinicData.details
            .where((element) => element.hospital.area.contains(area.name))
            .toList();
        return filteredClinics;
      } else {
        List filteredSOR = sorData.details
            .where((element) => element.hospital.area.contains(area.name))
            .toList();
        return filteredSOR;
      }
    }
    if (entity == Entity.clinic) {
      filteredClinics = clinicData.details;
      return filteredClinics;
    } else {
      filteredSOR = sorData.details;
      return filteredSOR;
    }
  }

  onSearchTextChanged(String text) async {
    sorCardsListSearched.clear();
    clinicCardsListSearched.clear();
    text = removeWhitespace(text.toLowerCase());
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    final entity = ModalRoute.of(context).settings.arguments;
    if (entity is Clinic) {
      clinicCardsListFiltered.forEach((clinicCard) {
        if (removeWhitespace(clinicCard.detail.price.toString())
                .contains(text) ||
            removeWhitespace(clinicCard.detail.doctor.name.toLowerCase())
                .contains(text) ||
            removeWhitespace(clinicCard.detail.doctor.title.toLowerCase())
                .contains(text)) {
          clinicCardsListSearched.add(clinicCard);
        }
      });
      setState(() {});
    } else {
      sorCardsListFiltered.forEach((sorCard) {
        if (removeWhitespace(sorCard.detail.price.toString()).contains(text)) {
          sorCardsListSearched.add(sorCard);
        }
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final List<Area> updatedAreasList = appData.getUpdatedAreas(context);
    final List<FiltrationHospital> updatedHospitalsList =
        appData.getUpdatedHospitals(context);
    final theme = Theme.of(context);
    final entity2 = ModalRoute.of(context).settings.arguments as EntityClass;
    setAppLocalization(context);

    if (_response.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(entity2.name)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_details.length == 0) {
      return Scaffold(
        appBar: AppBar(title: Text(entity2.name)),
        body: _noDetails(theme, entity2),
      );
    }

    if (entity2 is Clinic) {
      // print(_response);
      if (filterClicked) {
        clinicCardsListFiltered =
            clinicDataFiltered.asMap().entries.map<ClinicCard>((detail) {
          return ClinicCard(
            clinicId: entity2.id,
            detail: clinicDataFiltered[detail.key],
          );
        }).toList();
      } else {
        clinicCardsListFiltered = _cards;
      }
    } else {
      if (filterClicked) {
        sorCardsListFiltered =
            sorDataFiltered.asMap().entries.map<ServiceCard>((detail) {
          return ServiceCard(
            serviceId: entity2.id,
            detail: sorDataFiltered[detail.key],
          );
        }).toList();
      } else {
        sorCardsListFiltered = _cards;
      }
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text(entity2.name)),
      body: BackgroundImage(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: FittedBox(
                          child: Text(
                            filterOn ? t("close_filter") : t("filter"),
                            textScaleFactor: 0.6,
                            style: theme.textTheme.headline5
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            cityDDV = null;
                            areaDDV = null;
                            hospitalDDV = null;
                            filterOn = !filterOn;
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
                            searchOn ? t("close_search") : t("open_search"),
                            textScaleFactor: 0.6,
                            style: theme.textTheme.headline5
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            searchOn = !searchOn;
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
                            t("sort"),
                            textScaleFactor: 0.6,
                            style: theme.textTheme.headline5
                                .copyWith(color: Colors.white),
                          ),
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
              if (filterOn)
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: theme.primaryColor)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                t("city"),
                                style: theme.textTheme.headline6,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    dropdownColor: theme.primaryColor,
                                    //isExpanded: true,
                                    hint: Text(t("all"),
                                        style: theme.textTheme.headline6
                                            .copyWith(
                                                fontSize: 16,
                                                color: Colors.white)),
                                    value: cityDDV,
                                    elevation: 1,
                                    onChanged: (newValue) {
                                      setState(() {
                                        cityDDV = newValue;
                                      });
                                      areaDDV = null;
                                      hospitalDDV = null;
                                      appData.updateAreas(cityDDV);
                                      appData.updateHospitals(cityDDV, areaDDV);
                                    },
                                    items: _cities
                                        .map<DropdownMenuItem>((City city) {
                                      return DropdownMenuItem(
                                          value: city,
                                          child: Text(city.name,
                                              style: TextStyle(
                                                  color: Colors.white)));
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                t("area"),
                                style: theme.textTheme.headline6,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                  dropdownColor: theme.primaryColor,
                                  //isExpanded: true,
                                  hint: Text(
                                    updatedAreasList.length != 0
                                        ? t("all")
                                        : t("none"),
                                    style: theme.textTheme.headline6.copyWith(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  value: areaDDV,
                                  elevation: 1,
                                  onChanged: (newValue) {
                                    setState(() {
                                      areaDDV = newValue;
                                    });
                                    hospitalDDV = null;
                                    appData.updateHospitals(cityDDV, areaDDV);
                                  },
                                  items: updatedAreasList
                                      .map<DropdownMenuItem>((Area area) {
                                    return DropdownMenuItem(
                                        value: area,
                                        child: Text(
                                          area.name,
                                          style: TextStyle(color: Colors.white),
                                        ));
                                  }).toList(),
                                )),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: [
                          Text(
                            t("hospital"),
                            style: theme.textTheme.headline6,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: theme.primaryColor,
                                  hint: Text(
                                      updatedHospitalsList.length != 0
                                          ? t("all")
                                          : t("none"),
                                      style: theme.textTheme.headline6.copyWith(
                                          fontSize: 16, color: Colors.white)),
                                  value: hospitalDDV,
                                  elevation: 1,
                                  onChanged: (newValue) {
                                    setState(() {
                                      hospitalDDV = newValue;
                                    });
                                  },
                                  items: updatedHospitalsList
                                      .map<DropdownMenuItem>(
                                          (FiltrationHospital hospital) {
                                    return DropdownMenuItem(
                                        value: hospital,
                                        child: Text(
                                          hospital.name,
                                          style: TextStyle(color: Colors.white),
                                        ));
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 140.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              theme.primaryColor,
                            ),
                          ),
                          child: FittedBox(
                            child: Text(
                              t("filter"),
                              textScaleFactor: 0.6,
                              style: theme.textTheme.headline5
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (entity2 is Clinic) {
                                sorCardsListSearched.clear();
                                clinicCardsListSearched.clear();
                                clinicDataFiltered = filterCards(cityDDV,
                                    areaDDV, hospitalDDV, Entity.clinic);
                              } else {
                                sorCardsListSearched.clear();
                                clinicCardsListSearched.clear();
                                sorDataFiltered = filterCards(
                                  cityDDV,
                                  areaDDV,
                                  hospitalDDV,
                                  Entity.clinic,
                                );
                              }
                              filterClicked = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              if (searchOn)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Theme(
                    data: inputTheme(context),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: entity2 is Clinic
                              ? t('search_clinic')
                              : t('search_service'),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              _controller.clear();
                              onSearchTextChanged('');
                            },
                          )),
                      onChanged: onSearchTextChanged,
                    ),
                  ),
                ),
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overScroll) {
                  overScroll.disallowGlow();
                  return;
                },
                child: Expanded(
                  child: (clinicCardsListSearched.length == 0 &&
                              entity2 is Clinic &&
                              _controller.text.isNotEmpty) ||
                          (sorCardsListSearched.length == 0 &&
                              entity2 is Service &&
                              _controller.text.isNotEmpty)
                      ? Center(
                          child: Text(
                          t("no_search_results"),
                          style: theme.textTheme.headline6,
                        ))
                      : clinicCardsListSearched.length != 0 ||
                              sorCardsListSearched.length != 0 ||
                              _controller.text.isNotEmpty
                          ? ListView.builder(
                              itemCount: entity2 is Clinic
                                  ? clinicCardsListSearched.length
                                  : sorCardsListSearched.length,
                              itemBuilder: (context, index) {
                                return entity2 is Clinic
                                    ? clinicListSorter(
                                        context, clinicCardsListSearched)[index]
                                    : sorListSorter(
                                        context, sorCardsListSearched)[index];
                              },
                            )
                          : (clinicCardsListFiltered.length == 0 &&
                                      entity2 is Clinic) ||
                                  (sorCardsListFiltered.length == 0 &&
                                      entity2 is Service)
                              ? Center(
                                  child: Text(
                                  t("no_results"),
                                  style: theme.textTheme.headline6,
                                ))
                              : ListView.builder(
                                  itemCount: entity2 is Clinic
                                      ? clinicCardsListFiltered.length
                                      : sorCardsListFiltered.length,
                                  itemBuilder: (context, index) {
                                    return entity2 is Clinic
                                        ? clinicListSorter(context,
                                            clinicCardsListFiltered)[index]
                                        : sorListSorter(context,
                                            sorCardsListFiltered)[index];
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
