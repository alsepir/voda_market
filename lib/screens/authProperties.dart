import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/components/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/models/index.dart';

class AuthPropertiesScreenTheme {
  AuthPropertiesScreenTheme.light() : this.color = AppColors.typographyPrimary;
  AuthPropertiesScreenTheme.dark() : this.color = AppColors.typographyDarkPrimary;

  final Color color;
}

class AuthPropertiesScreenBuffer {
  AuthPropertiesScreenBuffer({this.name, this.cityId});

  String? name;
  int? cityId;
}

class AuthPropertiesScreen extends StatefulWidget {
  const AuthPropertiesScreen({Key? key}) : super(key: key);

  @override
  _AuthPropertiesScreenState createState() => _AuthPropertiesScreenState();
}

class _AuthPropertiesScreenState extends State<AuthPropertiesScreen> {
  TextEditingController _nameController = TextEditingController();
  AuthPropertiesScreenBuffer buffer = AuthPropertiesScreenBuffer(cityId: 0);
  bool isButtonActive = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  AuthPropertiesScreenTheme getTheme(bool isDark) {
    if (isDark) return AuthPropertiesScreenTheme.dark();
    return AuthPropertiesScreenTheme.light();
  }

  void validate() {
    bool _isButtonActive = false;
    if (buffer.name != null && buffer.name!.isNotEmpty && buffer.cityId != null) _isButtonActive = true;
    if (isButtonActive != _isButtonActive) setState(() => isButtonActive = _isButtonActive);
  }

  void onChangedName(String value) {
    buffer.name = value;
    validate();
  }

  void onChangedCity(int value) {
    buffer.cityId = value;
    validate();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    List<ListItemModel> cities = profileProvider.cities ?? [];
    AuthPropertiesScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(''),
          leading: IconButton(
            icon: CustomIcon(
              CustomIcons.caretLeft,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Как к вам обращаться?',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              height: 1.27,
                              color: theme.color,
                            ),
                          ),
                          SizedBox(height: 16),
                          Input(
                            placeholder: 'Введите имя и фамилию',
                            controller: _nameController,
                            onChanged: onChangedName,
                          ),
                          SizedBox(height: 40),
                          Text(
                            'В каком городе вы будете заказывать воду?',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              height: 1.27,
                              color: theme.color,
                            ),
                          ),
                          SizedBox(height: 24),
                          Transform.translate(
                            offset: Offset(-6, 0),
                            child: RadioButtons(
                              data: cities,
                              value: buffer.cityId,
                              onChanged: onChangedCity,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Button(
                      disable: !isButtonActive,
                      title: 'Завершить регистрацию',
                      type: ButtonType.primary,
                      margin: EdgeInsets.only(bottom: 12),
                      onPress: () {
                        profileProvider.setData(buffer.name ?? '', buffer.cityId ?? 0);
                        Navigator.of(context).pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
