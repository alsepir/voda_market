import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/navigations/main.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/theme.dart';
import 'package:flutter/scheduler.dart';

class AuthScreenTheme {
  AuthScreenTheme.light()
      : this.color = AppColors.typographyPrimary,
        this.helper = AppColors.typographySecondary,
        this.policy = AppColors.typographyTertiary;
  AuthScreenTheme.dark()
      : this.color = AppColors.typographyDarkPrimary,
        this.helper = AppColors.typographyDarkSecondary,
        this.policy = AppColors.typographyDarkTertiary;

  final Color color;
  final Color helper;
  final Color policy;
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key, this.canPossibleBack = false}) : super(key: key);

  final bool canPossibleBack;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _phoneController = TextEditingController();
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) async {
      ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      if (profileProvider.data != null)
        Navigator.of(context).pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  AuthScreenTheme getTheme(bool isDark) {
    if (isDark) return AuthScreenTheme.dark();
    return AuthScreenTheme.light();
  }

  void validatePhone(String value) {
    bool _isButtonActive = false;
    List<String> valueDigits = value.split('').where((element) => int.tryParse(element) is int).toList();
    if (valueDigits.length == 10) _isButtonActive = true;
    if (isButtonActive != _isButtonActive) setState(() => isButtonActive = _isButtonActive);
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    AuthScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

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
          automaticallyImplyLeading: false,
          title: widget.canPossibleBack ? Text('Авторизация') : null,
          leading: widget.canPossibleBack
              ? IconButton(
                  icon: CustomIcon(
                    CustomIcons.caretLeft,
                    color: Theme.of(context).appBarTheme.iconTheme?.color,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : null,
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
                      child: Text(
                        'Для входа введите\nномер телефона',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, height: 1.21, color: theme.color),
                      ),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            height: 64,
                            child: Input(
                              keyboardType: TextInputType.number,
                              placeholder: '(___) ___-__-__',
                              prefixText: '+7 ',
                              acceptInputFormatters: true,
                              fontSize: 28,
                              controller: _phoneController,
                              onChanged: validatePhone,
                            ),
                          ),
                          SizedBox(height: 32),
                          Text(
                            'На введенный номер придет СМС-код для подтверждения номера телефона',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.helper),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Нажимая кнопку “Получить код”, вы даёте согласие на обработку персональных данных',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.policy),
                    ),
                    SizedBox(height: 12),
                    Button(
                      disable: !isButtonActive,
                      title: 'Получить SMS',
                      type: ButtonType.primary,
                      margin: EdgeInsets.only(bottom: 12),
                      onPress: () {
                        ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                        profileProvider.authPhone = _phoneController.value.text;

                        Navigator.of(context).pushNamed(
                          '/auth/second',
                          arguments: ScreenArguments<String>(payload: _phoneController.value.text),
                        );
                      },
                    ),
                    Button(
                      title: 'Продолжить без авторизации',
                      type: ButtonType.secondary,
                      margin: EdgeInsets.only(bottom: 16),
                      onPress: () {
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
