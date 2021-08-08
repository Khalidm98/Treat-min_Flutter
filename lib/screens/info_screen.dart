import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import './password_screen.dart';
import './tabs_screen.dart';
import '../api/accounts.dart';
import '../localizations/app_localizations.dart';
import '../providers/user_data.dart';
import '../utils/dialogs.dart';
import '../widgets/background_image.dart';
import '../widgets/input_field.dart';

class InfoScreen extends StatefulWidget {
  static const String routeName = '/info';

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final Map<String, String> _account = {};
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _passObscure = true;
  bool _imageChanged = false;
  File _image;
  DateTime _date;
  String _gender;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_date == null) {
      final userData = Provider.of<UserData>(context, listen: false);
      if (userData.isLoggedIn) {
        if (userData.photo.isNotEmpty) {
          _image = File(userData.photo);
        }
        _date = userData.birth;
        _dateController.text = _date.toIso8601String().substring(0, 10);
        _gender = userData.gender;
      } else {
        _date = DateTime.now().subtract(const Duration(days: 365 * 20 + 5));
        _gender = 'i';
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final theme = Theme.of(context);
      final file = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 400,
        maxHeight: 400,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressFormat: ImageCompressFormat.png,
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
          activeControlsWidgetColor: Colors.grey[400],
          backgroundColor: Colors.white,
          dimmedLayerColor: Colors.white,
          showCropGrid: false,
          toolbarColor: theme.accentColor,
          toolbarWidgetColor: Colors.grey[300],
        ),
      );
      if (file != null) {
        _imageChanged = true;
        setState(() {
          _image = file;
        });
      }
    }
  }

  Future<void> _pickDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 80 + 20)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 12 + 3)),
      helpText: t('select_date'),
    );
    if (picked != null) {
      _date = picked;
      setState(() {
        _dateController.text = _date.toString().substring(0, 10);
      });
    }
  }

  Future<void> _submit(bool isLoggedIn) async {
    if (_gender.isEmpty || _gender == 'i') {
      setState(() => _gender = '');
      _formKey.currentState.validate();
      return;
    } else if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    _account['gender'] = _gender;
    if (_imageChanged) {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/user.png';
      imageCache.clear();
      await _image.copy(path);
      _account['photo'] = path;
    } else if (_image == null) {
      _account['photo'] = '';
    } else {
      final dir = await getApplicationDocumentsDirectory();
      _account['photo'] = '${dir.path}/user.png';
    }

    if (isLoggedIn) {
      await showDialog(
        context: context,
        child: AlertDialog(
          title: Text(t('current_password')),
          content: TextField(controller: _passController, obscureText: true),
          actions: [
            TextButton(
              child: Text(t('ok')),
              onPressed: () async {
                Navigator.pop(context);
                if (_passController.text.isEmpty) {
                  alert(context, t('confirm_password_empty'));
                } else {
                  _account['password'] = _passController.text;
                  final response =
                      await AccountAPI.editAccount(context, _account);
                  if (response) {
                    if (_imageChanged) {
                      final response =
                          await AccountAPI.changePhoto(context, _image);
                      if (response) {
                        Navigator.pop(context);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  }
                }
              },
            ),
          ],
        ),
      );
      _passController.clear();
    } else {
      _account['email'] = ModalRoute.of(context).settings.arguments;
      final response = await AccountAPI.register(context, _account);
      if (response) {
        if (_imageChanged) {
          await AccountAPI.changePhoto(context, _image);
        }
        Navigator.of(context)
            .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final langCode = Localizations.localeOf(context).languageCode;
    final userData = Provider.of<UserData>(context, listen: false);
    final isLoggedIn = userData.isLoggedIn;
    setAppLocalization(context);

    return Scaffold(
      body: BackgroundImage(
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    t(isLoggedIn ? 'edit' : 'setup'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline4,
                  ),
                ),
                Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.accentColor, width: 2),
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage('assets/images/placeholder.png')
                              : FileImage(_image),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100, left: 100),
                      child: CircleAvatar(
                        backgroundColor: theme.accentColor,
                        radius: 20,
                        child: IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                            size: 25,
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                !isLoggedIn
                    ? const SizedBox()
                    : ElevatedButton(
                        child: Text(t('change_password')),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(PasswordScreen.routeName);
                        },
                      ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      isLoggedIn
                          ? const SizedBox()
                          : InputField(
                              label: t('password'),
                              textFormField: TextFormField(
                                decoration: InputDecoration(
                                  hintText: '********',
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(
                                          () => _passObscure = !_passObscure);
                                    },
                                    child: Icon(_passObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                obscureText: _passObscure,
                                onSaved: (value) =>
                                    _account['password'] = value,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return t('password_empty');
                                  } else if (value.length < 8) {
                                    return t('password_length');
                                  } else if (int.tryParse(value) != null) {
                                    return t('password_numbers');
                                  }
                                  return null;
                                },
                              ),
                            ),
                      const SizedBox(height: 30),
                      InputField(
                        label: t('name'),
                        textFormField: TextFormField(
                          decoration: InputDecoration(
                            hintText: t('name_hint'),
                          ),
                          initialValue: isLoggedIn ? userData.name : '',
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          onSaved: (value) => _account['name'] = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              return t('name_empty');
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      InputField(
                        label: t('phone'),
                        textFormField: TextFormField(
                          decoration: InputDecoration(
                            hintText: langCode == 'ar'
                                ? '#### ### 01##'
                                : '01## ### ####',
                            counterText: '',
                          ),
                          initialValue: isLoggedIn ? userData.phone : '',
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          onSaved: (value) => _account['phone'] = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              return t('phone_empty');
                            } else if (int.tryParse(value) == null) {
                              return t('phone_numbers_only');
                            } else if (value.length < 11) {
                              return t('phone_11_numbers');
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          _pickDate();
                        },
                        child: AbsorbPointer(
                          child: InputField(
                            label: t('birth'),
                            textFormField: TextFormField(
                              decoration:
                                  InputDecoration(hintText: 'YYYY-MM-DD'),
                              controller: _dateController,
                              onSaved: (_) {
                                _account['birth'] =
                                    _date.toIso8601String().substring(0, 10);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return t('birth_empty');
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Radio(
                      value: 'M',
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                      activeColor: theme.primaryColorDark,
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _gender = 'M'),
                      child: Text(
                        t('gender_male'),
                        style: theme.textTheme.subtitle1,
                      ),
                    ),
                    Spacer(),
                    Radio(
                      value: 'F',
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                      activeColor: theme.primaryColorDark,
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _gender = 'F'),
                      child: Text(
                        t('gender_female'),
                        style: theme.textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
                _gender.isEmpty
                    ? Text(
                        t('gender_error'),
                        style: theme.textTheme.caption.copyWith(
                          color: theme.errorColor,
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: ElevatedButton(
                    child: Text(t(isLoggedIn ? 'save' : 'finish')),
                    onPressed: () => _submit(isLoggedIn),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
