import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../core/enum/box_types.dart';
import '../../../core/enum/theme_mode.dart';
import '../../../data/settings/settings_service.dart';
import '../../../service_locator.dart';
import 'setting_option.dart';

class ChooseThemeModeWidget extends StatefulWidget {
  const ChooseThemeModeWidget({
    Key? key,
  }) : super(key: key);

  @override
  ChooseThemeModeWidgetState createState() => ChooseThemeModeWidgetState();
}

class ChooseThemeModeWidgetState extends State<ChooseThemeModeWidget> {
  final Box<dynamic> settings =
      locator.get(instanceName: BoxType.settings.stringValue);

  void showThemeDialog() {
    showModalBottomSheet(
      constraints: BoxConstraints(
        maxWidth:
            MediaQuery.of(context).size.width >= 700 ? 700 : double.infinity,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (context) => ThemeModeWidget(
        onSelected: (selected) => settings.put(themeModeKey, selected.index),
        currentTheme:
            ThemeMode.values[settings.get(themeModeKey, defaultValue: 0)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: settings.listenable(keys: [themeModeKey]),
      builder: (context, value, child) {
        final index = value.get(themeModeKey, defaultValue: 0);
        return SettingsOption(
          title: AppLocalizations.of(context)!.themeLabel,
          subtitle: ThemeMode.values[index].themeName,
          onTap: () => showThemeDialog(),
        );
      },
    );
  }
}

class ThemeModeWidget extends StatefulWidget {
  const ThemeModeWidget({
    Key? key,
    required this.onSelected,
    required this.currentTheme,
  }) : super(key: key);
  final ThemeMode currentTheme;

  final Function(ThemeMode) onSelected;
  @override
  ThemeModeWidgetState createState() => ThemeModeWidgetState();
}

class ThemeModeWidgetState extends State<ThemeModeWidget> {
  late ThemeMode currentIndex = widget.currentTheme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.themeLabel,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          ...ThemeMode.values
              .map(
                (e) => RadioListTile(
                  value: e,
                  activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  groupValue: currentIndex,
                  onChanged: (ThemeMode? value) {
                    currentIndex = value!;
                    widget.onSelected(currentIndex);
                    setState(() {});
                  },
                  title: Text(
                    e.themeName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              )
              .toList(),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 16),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancelLabel),
            ),
          ),
        ],
      ),
    );
  }
}
