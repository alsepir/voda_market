import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/components/index.dart';
import 'package:voda/theme.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';

class AuthSecondScreenTheme {
  AuthSecondScreenTheme.light()
      : this.color = AppColors.typographyPrimary,
        this.helper = AppColors.typographySecondary,
        this.blue = AppColors.brandBlue;
  AuthSecondScreenTheme.dark()
      : this.color = AppColors.typographyDarkPrimary,
        this.helper = AppColors.typographyDarkSecondary,
        this.blue = AppColors.brandDarkBlue;

  final Color color;
  final Color helper;
  final Color blue;
}

class AuthSecondScreen extends StatefulWidget {
  const AuthSecondScreen({Key? key, this.phone = ''}) : super(key: key);

  final String phone;

  @override
  _AuthSecondScreenState createState() => _AuthSecondScreenState();
}

class _AuthSecondScreenState extends State<AuthSecondScreen> {
  bool isButtonActive = false;
  late Timer timer;
  late int timerValue = 59;

  @override
  void initState() {
    timer = startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  AuthSecondScreenTheme getTheme(bool isDark) {
    if (isDark) return AuthSecondScreenTheme.dark();
    return AuthSecondScreenTheme.light();
  }

  void validateCode(String value) {
    bool _isButtonActive = false;
    if (value.length == 4) _isButtonActive = true;
    if (isButtonActive != _isButtonActive) setState(() => isButtonActive = _isButtonActive);
  }

  Timer startTimer() {
    const oneSec = const Duration(seconds: 1);
    setState(() => timerValue = 59);
    return Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timerValue == 0) {
          setState(() => timer.cancel());
        } else {
          setState(() => timerValue--);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    AuthSecondScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

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
          title: Text('Введите код из СМС'),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIcon(CustomIcons.phone, margin: EdgeInsets.only(right: 12), color: theme.blue),
                          Text(
                            '+7 ${widget.phone}',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 22, fontWeight: FontWeight.w400, height: 1.27, color: theme.color),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 64,
                              child: PinCodeTextField(
                                appContext: context,
                                length: 4,
                                mainAxisAlignment: MainAxisAlignment.center,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                keyboardType: TextInputType.number,
                                cursorHeight: 20,
                                textStyle: TextStyle(fontSize: 34, fontWeight: FontWeight.w400),
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.underline,
                                  fieldHeight: 40,
                                  fieldWidth: 20,
                                  activeColor: Colors.transparent,
                                  selectedColor: Colors.blue,
                                  inactiveColor: Colors.grey,
                                  activeFillColor: Colors.transparent,
                                  selectedFillColor: Colors.transparent,
                                  inactiveFillColor: Colors.transparent,
                                  fieldOuterPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                backgroundColor: Color(0xFFE7EDF3),
                                enableActiveFill: true,
                                onCompleted: (value) {
                                  print("Completed");
                                },
                                onChanged: validateCode,
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                          Text(
                            'Если код не пришёл, вы можете выслать его снова ${timerValue != 0 ? 'через $timerValue сек.' : ''}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.helper),
                          ),
                          SizedBox(height: 16),
                          if (timerValue == 0)
                            InkWell(
                              onTap: () => {},
                              highlightColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(width: 1, color: theme.blue),
                                )),
                                padding: EdgeInsets.fromLTRB(4, 0, 4, 2),
                                child: Text(
                                  'Выслать снова',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.blue),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 48),
                    Button(
                      disable: !isButtonActive,
                      title: 'Войти',
                      type: ButtonType.primary,
                      margin: EdgeInsets.only(bottom: 12),
                      onPress: () {
                        Navigator.of(context).pushNamed('/auth/properties');
                      },
                    ),
                    Button(
                      title: 'Сменить номер телефона',
                      type: ButtonType.secondary,
                      margin: EdgeInsets.only(bottom: 16),
                      onPress: () {
                        Navigator.of(context).maybePop();
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
