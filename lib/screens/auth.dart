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
  const AuthScreen({
    Key? key,
    this.canPossibleBack = false,
    this.fromShoppingCart = false,
  }) : super(key: key);

  final bool canPossibleBack;
  final bool fromShoppingCart;

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
        appBar: Header(
          title: widget.canPossibleBack ? '??????????????????????' : null,
          leading: widget.canPossibleBack ? HeaderLeading.back : null,
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
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.fromShoppingCart
                              ? '?????? ???????????????????? ???????????? ?????????????????? ????????????????????????????. ?????????????? ?????????? ????????????????'
                              : '?????? ?????????? ??????????????\n?????????? ????????????????',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: widget.fromShoppingCart ? 22 : 28,
                            fontWeight: FontWeight.w600,
                            height: 1.21,
                            color: theme.color,
                          ),
                        ),
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
                            '???? ?????????????????? ?????????? ???????????? ??????-?????? ?????? ?????????????????????????? ???????????? ????????????????',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.helper),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '?????????????? ???????????? ??????????????????? ?????????, ???? ?????????? ???????????????? ???? ?????????????????? ???????????????????????? ????????????',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.policy),
                    ),
                    SizedBox(height: 12),
                    Button(
                      disable: !isButtonActive,
                      title: '???????????????? SMS',
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
                    if (!widget.canPossibleBack)
                      Button(
                        title: '???????????????????? ?????? ??????????????????????',
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
