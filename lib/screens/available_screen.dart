import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/actions.dart';
import '../api/entities.dart';
import '../localizations/app_localizations.dart';
import '../models/card_data.dart';
import '../models/cities_areas.dart';
import '../models/screens_data.dart';
import '../providers/app_data.dart';
import '../utils/enumerations.dart';
import '../widgets/background_image.dart';
import '../widgets/clinic_card.dart';
import '../widgets/input_field.dart';
import '../widgets/modal_sheet_list_tile.dart';
import '../widgets/sor_card.dart';

class AvailableScreen extends StatefulWidget {
  static const String routeName = '/available';

  @override
  _AvailableScreenState createState() => _AvailableScreenState();
}

class _AvailableScreenState extends State<AvailableScreen> {
  // LatLng _location;
  String entityDetailResponse = "";
  bool filterClicked = false;
  bool searchOn = false;

  //entities+detail lists
  ClinicCardData clinicData;
  List<ClinicDetail> clinicDataFiltered = [];
  SORCardData sorData;
  List<SORDetail> sorDataFiltered = [];

  //search results
  List<ClinicCard> clinicCardsListSearched = [];
  List<SORCard> sorCardsListSearched = [];

  //filter results
  //rendered
  List<ClinicCard> clinicCardsListFiltered = [];
  List<SORCard> sorCardsListFiltered = [];

  List<ClinicCard> clinicCardsList = [];
  List<SORCard> sorCardsList = [];

  City cityDDV;
  Area areaDDV;
  FiltrationHospital hospitalDDV;
  bool filterOn = false;
  final myController = TextEditingController();

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
      entityDetailsList.sort(
          (a, b) => a.clinicCardData.price.compareTo(b.clinicCardData.price));
      return entityDetailsList;
    } else if (Provider.of<AppData>(context).sortingVars[1] == true) {
      entityDetailsList.sort(
          (a, b) => a.clinicCardData.price.compareTo(b.clinicCardData.price));
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

  List<SORCard> sorListSorter(
      BuildContext context, List<SORCard> entityDetailsList) {
    if (Provider.of<AppData>(context).sortingVars[0] == true) {
      entityDetailsList
          .sort((a, b) => a.sorCardData.price.compareTo(b.sorCardData.price));
      return entityDetailsList;
    } else if (Provider.of<AppData>(context).sortingVars[1] == true) {
      entityDetailsList
          .sort((a, b) => a.sorCardData.price.compareTo(b.sorCardData.price));
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

  noEntityDetails(ThemeData theme, AvailableScreenData selectScreenData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/doctor_sad.png",
          height: 400,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t("Unfortunately, No"),
                    style: theme.textTheme.headline6
                        .copyWith(color: theme.accentColor),
                  ),
                  Text(
                    "${getEntityTranslated(entityToString(selectScreenData.entity))}",
                    style: theme.textTheme.headline6
                        .copyWith(color: theme.accentColor),
                  ),
                ],
              ),
              Text(
                t("are available in this section for now. Please check again later!"),
                style: theme.textTheme.headline6
                    .copyWith(color: theme.accentColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getEntityTranslated(String entity) {
    if (entity == "services") {
      return t("available_services");
    }
    return t("available_clinics");
  }

  Future<void> getCities(BuildContext context) async {
    final response = await EntityAPI.getCities(context);
    if (!response) {
      Navigator.pop(context);
    }
  }

  Future<void> getAreas(BuildContext context) async {
    final response = await EntityAPI.getAreas(context);
    if (!response) {
      Navigator.pop(context);
    }
  }

  Future<void> getHospitals(BuildContext context) async {
    final response = await EntityAPI.getHospitals(context);
    if (!response) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getCities(context);
    getAreas(context);
    getHospitals(context);
    Future.delayed(Duration.zero, () async {
      AvailableScreenData selectScreenData =
          ModalRoute.of(context).settings.arguments;
      entityDetailResponse = await getCardDetails(selectScreenData);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Future<String> getCardDetails(AvailableScreenData selectScreenData) async {
    final response = await ActionAPI.getEntityDetail(
        entityToString(selectScreenData.entity),
        selectScreenData.entityMap['id'].toString());
    return response;
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

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final List<City> citiesList = appData.getCities(context);
    final List<Area> updatedAreasList = appData.getUpdatedAreas(context);
    final List<FiltrationHospital> updatedHospitalsList =
        appData.getUpdatedHospitals(context);
    final theme = Theme.of(context);
    final selectScreenData =
        (ModalRoute.of(context).settings.arguments) as AvailableScreenData;
    setAppLocalization(context);
    onSearchTextChanged(String text) async {
      sorCardsListSearched.clear();
      clinicCardsListSearched.clear();
      text = removeWhitespace(text.toLowerCase());
      if (text.isEmpty) {
        setState(() {});
        return;
      }
      if (selectScreenData.entity == Entity.clinic) {
        clinicCardsListFiltered.forEach((clinicCard) {
          if (removeWhitespace(clinicCard.clinicCardData.price.toString())
                  .contains(text) ||
              removeWhitespace(
                      clinicCard.clinicCardData.doctor.name.toLowerCase())
                  .contains(text) ||
              removeWhitespace(
                      clinicCard.clinicCardData.doctor.title.toLowerCase())
                  .contains(text)) {
            clinicCardsListSearched.add(clinicCard);
          }
        });
        setState(() {});
      } else {
        sorCardsListFiltered.forEach((sorCard) {
          if (removeWhitespace(sorCard.sorCardData.price.toString())
              .contains(text)) {
            sorCardsListSearched.add(sorCard);
          }
        });
        setState(() {});
      }
    }

    if (entityDetailResponse.isEmpty) {
      return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(selectScreenData.entityMap['name']),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ));
    }
    if (selectScreenData.entity == Entity.clinic) {
      clinicData = clinicCardFromJson(entityDetailResponse);
      if (clinicData.details.length == 0) {
        return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text(selectScreenData.entityMap['name']),
            ),
            body: noEntityDetails(theme, selectScreenData));
      }
      clinicCardsList =
          clinicData.details.asMap().entries.map<ClinicCard>((detail) {
        return ClinicCard(
          entityId: selectScreenData.entityMap['id'],
          entity: selectScreenData.entity,
          clinicCardData: clinicData.details[detail.key],
        );
      }).toList();
      if (filterClicked) {
        clinicCardsListFiltered =
            clinicDataFiltered.asMap().entries.map<ClinicCard>((detail) {
          return ClinicCard(
            entityId: selectScreenData.entityMap['id'],
            entity: selectScreenData.entity,
            clinicCardData: clinicDataFiltered[detail.key],
          );
        }).toList();
      } else {
        clinicCardsListFiltered = clinicCardsList;
      }
    } else {
      sorData = sorCardFromJson(entityDetailResponse);
      if (sorData.details.length == 0) {
        return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text(selectScreenData.entityMap['name']),
            ),
            body: noEntityDetails(theme, selectScreenData));
      }
      sorCardsList = sorData.details.asMap().entries.map<SORCard>((detail) {
        return SORCard(
          entityId: selectScreenData.entityMap['id'],
          entity: selectScreenData.entity,
          sorCardData: sorData.details[detail.key],
        );
      }).toList();
      if (filterClicked) {
        sorCardsListFiltered =
            sorDataFiltered.asMap().entries.map<SORCard>((detail) {
          return SORCard(
            entityId: selectScreenData.entityMap['id'],
            entity: selectScreenData.entity,
            sorCardData: sorDataFiltered[detail.key],
          );
        }).toList();
      } else {
        sorCardsListFiltered = sorCardsList;
      }
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text(selectScreenData.entityMap['name'])),
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
                                    items: citiesList
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
                              if (selectScreenData.entity == Entity.clinic) {
                                sorCardsListSearched.clear();
                                clinicCardsListSearched.clear();
                                clinicDataFiltered = filterCards(
                                    cityDDV,
                                    areaDDV,
                                    hospitalDDV,
                                    selectScreenData.entity);
                              } else {
                                sorCardsListSearched.clear();
                                clinicCardsListSearched.clear();
                                sorDataFiltered = filterCards(
                                  cityDDV,
                                  areaDDV,
                                  hospitalDDV,
                                  selectScreenData.entity,
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
                      controller: myController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: selectScreenData.entity == Entity.clinic
                              ? t('search_clinic')
                              : t('search_service'),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              myController.clear();
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
                              selectScreenData.entity == Entity.clinic &&
                              myController.text.isNotEmpty) ||
                          (sorCardsListSearched.length == 0 &&
                              selectScreenData.entity == Entity.service &&
                              myController.text.isNotEmpty)
                      ? Center(
                          child: Text(
                          t("no_search_results"),
                          style: theme.textTheme.headline6,
                        ))
                      : clinicCardsListSearched.length != 0 ||
                              sorCardsListSearched.length != 0 ||
                              myController.text.isNotEmpty
                          ? ListView.builder(
                              itemCount:
                                  selectScreenData.entity == Entity.clinic
                                      ? clinicCardsListSearched.length
                                      : sorCardsListSearched.length,
                              itemBuilder: (context, index) {
                                return selectScreenData.entity == Entity.clinic
                                    ? clinicListSorter(
                                        context, clinicCardsListSearched)[index]
                                    : sorListSorter(
                                        context, sorCardsListSearched)[index];
                              },
                            )
                          : (clinicCardsListFiltered.length == 0 &&
                                      selectScreenData.entity ==
                                          Entity.clinic) ||
                                  (sorCardsListFiltered.length == 0 &&
                                      selectScreenData.entity == Entity.service)
                              ? Center(
                                  child: Text(
                                  t("no_results"),
                                  style: theme.textTheme.headline6,
                                ))
                              : ListView.builder(
                                  itemCount:
                                      selectScreenData.entity == Entity.clinic
                                          ? clinicCardsListFiltered.length
                                          : sorCardsListFiltered.length,
                                  itemBuilder: (context, index) {
                                    return selectScreenData.entity ==
                                            Entity.clinic
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
