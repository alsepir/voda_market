import 'package:voda/models/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/profile.dart';

class ProfileCardTheme {
  ProfileCardTheme.light()
      : color = AppColors.typographyPrimary,
        leading = AppColors.brandBlue,
        tail = AppColors.grey5,
        border = AppColors.border,
        divider = AppColors.divider,
        background = AppColors.backgroundPrimary;
  ProfileCardTheme.dark()
      : color = AppColors.typographyDarkPrimary,
        leading = AppColors.brandDarkBlue,
        tail = AppColors.darkGrey5,
        border = AppColors.borderDark,
        divider = AppColors.dividerDark,
        background = AppColors.backgroundDarkSecondary;

  final Color color;
  final Color leading;
  final Color tail;
  final Color background;
  final Color border;
  final Color divider;
}

class ProfileCardBuffer {
  ProfileCardBuffer({this.name, this.phone, this.cityId});

  String? name;
  String? phone;
  int? cityId;
}

class ProfileCard extends StatefulWidget {
  ProfileCard({Key? key, this.theme}) : super(key: key);

  final ThemeMode? theme;

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  TextEditingController _controller = TextEditingController();
  ProfileCardBuffer buffer = ProfileCardBuffer();

  @override
  Widget build(BuildContext context) {
    ProfileCardTheme _theme;
    if (widget.theme != null) {
      _theme = widget.theme == ThemeMode.dark ? ProfileCardTheme.dark() : ProfileCardTheme.light();
    } else {
      ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      _theme = themeProvider.mode == ThemeMode.dark ? ProfileCardTheme.dark() : ProfileCardTheme.light();
    }

    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    ProfileModel? data = profileProvider.data;
    TextStyle itemStyle = TextStyle(color: _theme.color, fontWeight: FontWeight.w400, fontSize: 17);

    buffer.name = data?.name;
    buffer.phone = data?.phone;
    buffer.cityId = data?.city.id;

    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: _theme.border, width: 1.0),
        borderRadius: BorderRadius.circular(24.0),
      ),
      color: _theme.background,
      shadowColor: AppColors.shadow,
      elevation: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CustomIcon(CustomIcons.profile, color: _theme.leading),
            minLeadingWidth: 12,
            title: Text(data?.name ?? '', style: itemStyle),
            trailing: CustomIcon(CustomIcons.caretRight, color: _theme.tail),
            onTap: () => showEditDialog(context, ProfileCardField.name, value: data?.name),
          ),
          Divider(height: 0.5, thickness: 0.5, indent: 16, endIndent: 16, color: _theme.divider),
          ListTile(
            leading: CustomIcon(CustomIcons.phone, color: _theme.leading),
            minLeadingWidth: 12,
            title: Text(data?.phone ?? '', style: itemStyle),
            trailing: CustomIcon(CustomIcons.caretRight, color: _theme.tail),
            onTap: () => showEditDialog(context, ProfileCardField.phone, value: data?.phone),
          ),
          Divider(height: 0.5, thickness: 0.5, indent: 16, endIndent: 16, color: _theme.divider),
          ListTile(
            leading: CustomIcon(CustomIcons.destination, color: _theme.leading),
            minLeadingWidth: 12,
            title: Text(data?.city.label ?? '', style: itemStyle),
            trailing: CustomIcon(CustomIcons.caretRight, color: _theme.tail),
            onTap: () => showEditDialog(context, ProfileCardField.city),
          ),
        ],
      ),
    );
  }

  ProfileCardModal? getModalConfig(ProfileCardField type) {
    switch (type) {
      case ProfileCardField.name:
        return ProfileCardModal.name();
      case ProfileCardField.phone:
        return ProfileCardModal.phone();
      case ProfileCardField.city:
        return ProfileCardModal.city();
      default:
        return null;
    }
  }

  Future<dynamic>? showEditDialog(BuildContext context, ProfileCardField type, {String? value}) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    List<ListItemModel> cities = profileProvider.cities ?? [];
    ProfileModel? data = profileProvider.data;
    ProfileCardModal? config = getModalConfig(type);
    _controller.text = value != null ? value : '';

    if (config == null) return null;

    Modal dialog = Modal(
      title: config.title,
      children: [
        if (config.type == ProfileCardModalType.input)
          Input(
            placeholder: config.placeholder ?? '',
            controller: _controller,
            onChanged: (value) {
              if (config.field == ProfileCardField.name) buffer.name = value;
              if (config.field == ProfileCardField.phone) buffer.phone = value;
            },
          ),
        if (config.type == ProfileCardModalType.radio)
          Transform.translate(
            offset: Offset(-6, 0),
            child: RadioButtons(
              data: cities,
              value: data?.city.id,
              onChanged: (value) {
                buffer.cityId = value;
              },
            ),
          ),
        SizedBox(height: 12),
        Button(
          title: 'Сохранить',
          onPress: () {
            if (config.field == ProfileCardField.name) profileProvider.changeName(buffer.name);
            if (config.field == ProfileCardField.phone) profileProvider.changePhone(buffer.phone);
            if (config.field == ProfileCardField.city) profileProvider.changeCity(buffer.cityId);

            Navigator.of(context, rootNavigator: true).pop();
          },
          type: ButtonType.primary,
        ),
      ],
    );

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }
}

enum ProfileCardField { name, phone, city }
enum ProfileCardModalType { input, radio }

class ProfileCardModal {
  ProfileCardModal.name()
      : this.title = 'Как к вам обращаться?',
        this.placeholder = 'Введите имя',
        this.field = ProfileCardField.name,
        this.type = ProfileCardModalType.input;
  ProfileCardModal.phone()
      : this.title = 'Ваш номер телефона',
        this.placeholder = 'Введите номер',
        this.field = ProfileCardField.phone,
        this.type = ProfileCardModalType.input;
  ProfileCardModal.city()
      : this.title = 'Ваш город',
        this.placeholder = null,
        this.field = ProfileCardField.city,
        this.type = ProfileCardModalType.radio;

  final String title;
  final String? placeholder;
  final ProfileCardField field;
  final ProfileCardModalType type;
}
