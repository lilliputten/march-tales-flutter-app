import 'package:flutter/material.dart';

import 'package:i18n_extension/i18n_extension.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:march_tales_app/Init.dart';
import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/components/LoginButton.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/updaters/clearLocalTracks.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'package:march_tales_app/supportedLocales.dart';
import 'SettingsPage.i18n.dart';

// import 'package:march_tales_app/components/CustomBackButton.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late AppState _appState;
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    this._appState = context.read<AppState>();
    Future.delayed(Duration.zero, () {
      this._appState.addScrollController(this.scrollController);
    });
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero, () {
      this._appState.removeScrollController(this.scrollController);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: this.scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SettingsWidget(),
            ),
          ),
        ),
      ],
    );
  }
}

class ThemeSelector extends StatelessWidget {
  final themeItems = [
    {'value': false, 'text': 'Light'.i18n},
    {'value': true, 'text': 'Dark'.i18n},
  ];

  getThemesList(bool currentIsDarkTheme) {
    // final List<DropdownMenuItem<String>> list = [];
    return themeItems.map((item) {
      return DropdownMenuItem<String>(
        value: item['value'].toString(),
        // enabled: code != currentIsDarkTheme,
        child: Text(item['text'].toString()),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final currentIsDarkTheme = appState.isDarkTheme;
    final items = getThemesList(currentIsDarkTheme);
    return DropdownButtonFormField<String>(
      iconDisabledColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        labelText: 'Color scheme'.i18n,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      value: currentIsDarkTheme.toString(),
      elevation: 16,
      style: TextStyle(color: colorScheme.primary),
      onChanged: (String? value) {
        if (value != null) {
          final bool isDarkTheme = value.toLowerCase() == 'true';
          appState.toggleDarkTheme(isDarkTheme);
        }
      },
      // XXX FUTURE: Make selected item distinctive using `selectedItemBuilder`?
      items: items,
    );
  }
}

class LanguageSelector extends StatelessWidget {
  getLanguagesList(String currentLanguageCode) {
    final List<DropdownMenuItem<String>> list = [];
    localeNames.forEach((code, text) {
      final item = DropdownMenuItem<String>(
        value: code,
        // enabled: code != currentLanguageCode,
        child: Text(text),
      );
      list.add(item);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final currentLanguageCode = context.locale.languageCode;
    final items = getLanguagesList(currentLanguageCode);
    return DropdownButtonFormField<String>(
      iconDisabledColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        labelText: 'Application language'.i18n,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      value: currentLanguageCode,
      elevation: 16,
      style: TextStyle(color: colorScheme.primary),
      onChanged: (String? locale) {
        if (locale != null) {
          serverSession.updateLocale(locale);
          // Set system locale
          context.locale = Locale(locale);
          // Update locale in the context store
          appState.updateLocale(locale);
        }
      },
      // XXX FUTURE: Make selected item distinctive using `selectedItemBuilder`?
      items: items,
    );
  }
}

class AppInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall!;
    final AppColors appColors = theme.extension<AppColors>()!;
    final linkStyle = style.copyWith(
      decoration: TextDecoration.underline,
      color: appColors.brandColor, // Colors.blue,
      decorationColor: appColors.brandColor,
      fontWeight: FontWeight.bold,
    );

    final appVersion = Init.appVersion;
    final appTimestamp = Init.appTimestamp;
    final serverVersion = Init.serverVersion;
    final serverTimestamp = Init.serverTimestamp;

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'Application version:'.i18n,
              style: style,
            ),
            SelectableText(
              appVersion!,
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            SelectableText('/', style: style.copyWith(fontWeight: FontWeight.w200)),
            SelectableText(appTimestamp!, style: style.copyWith(fontWeight: FontWeight.w300)),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'Server version:'.i18n,
              style: style,
            ),
            SelectableText(
              serverVersion!,
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            SelectableText('/', style: style.copyWith(fontWeight: FontWeight.w200)),
            SelectableText(serverTimestamp!, style: style.copyWith(fontWeight: FontWeight.w300)),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'Web site:'.i18n,
              style: style,
            ),
            InkWell(
              onTap: () => launchUrl(Uri.parse('${AppConfig.WEB_SITE_PROTOCOL}${AppConfig.WEB_SITE_DOMAIN}')),
              child: Text(
                '${AppConfig.WEB_SITE_PROTOCOL}${AppConfig.WEB_SITE_DOMAIN}',
                style: linkStyle,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText('VK:'.i18n, style: style),
            InkWell(
                onTap: () => launchUrl(Uri.parse(AppConfig.VK_URL)), child: Text(AppConfig.VK_URL, style: linkStyle)),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText('Telegram:'.i18n, style: style),
            InkWell(
                onTap: () => launchUrl(Uri.parse(AppConfig.TG_URL)), child: Text(AppConfig.TG_URL, style: linkStyle)),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText('YouTube:'.i18n, style: style),
            InkWell(
                onTap: () => launchUrl(Uri.parse(AppConfig.YT_URL)), child: Text(AppConfig.YT_URL, style: linkStyle)),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'Contact e-mail:'.i18n,
              style: style,
            ),
            InkWell(
              onTap: () => launchUrl(Uri.parse('mailto:${AppConfig.CONTACT_EMAIL}')),
              child: Text(
                AppConfig.CONTACT_EMAIL,
                style: linkStyle,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'Developer:'.i18n,
              style: style,
            ),
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://${AppConfig.DEVELOPER_URL}')),
              child: Text(
                'https://${AppConfig.DEVELOPER_URL}',
                style: linkStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AuthInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final userName = appState.getUserName();

    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final buttonTextStyle = theme.textTheme.bodyMedium!.copyWith(color: appColors.onBrandColor);
    final textStyle = theme.textTheme.bodyMedium!;
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      textStyle: buttonTextStyle,
      backgroundColor: appColors.brandColor,
    );
    // final smallStyle = theme.textTheme.bodySmall!;
    final linkStyle = textStyle.copyWith(
      decoration: TextDecoration.underline,
      color: appColors.brandColor, // Colors.blue,
      decorationColor: appColors.brandColor,
      fontWeight: FontWeight.bold,
    );

    logout() async {
      final String signoutUrl = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/logout/';
      final result = await serverSession.get(Uri.parse(signoutUrl));
      logger.t('[logout] result=${result}');
      // Clear data...
      serverSession.updateSessionId('');
      // Clear favorites
      appState.clearFavorites();
      // Clear local tracks info
      await clearLocalTracks();
      appState.setUser();
      // debugger();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.green,
          content: Text("You've been succcessfully logged out".i18n),
        ));
      }
    }

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SelectableText(
              'User:'.i18n,
              style: textStyle,
            ),
            SelectableText(
              userName,
              style: textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        InkWell(
          onTap: () => launchUrl(Uri.parse('${AppConfig.TALES_SERVER_HOST}/profile/')),
          child: Text(
            'Open your profile on the web site'.i18n,
            style: linkStyle,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: buttonStyle,
            onPressed: logout,
            icon: Icon(Icons.logout, color: appColors.onBrandColor),
            label: Text('Log out'.i18n, style: buttonTextStyle),
          ),
        ),
      ],
    );
  }
}

class LoginBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final locale = appState.currentLocale;
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall!;
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Log in to be able to view your favorites and listen to audio on different devices.'.i18n,
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
        LoginButton(
          locale: locale,
        ),
      ],
    );
  }
}

class AuthBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isAuthorized = appState.isAuthorized();
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isAuthorized ? AuthInfo() : LoginBlock(),
      ],
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final AppColors appColors = theme.extension<AppColors>()!;
    final textStyle = theme.textTheme.bodyLarge!.copyWith(
      color: appColors.brandColor, // colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final delimiterColor = colorScheme.onSurface.withValues(alpha: 0.1);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: delimiterColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Center(child: Text(title, style: textStyle)),
      ),
    );
  }
}

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsSectionTitle(title: 'Basic settings'.i18n),
          LanguageSelector(),
          ThemeSelector(),
          SettingsSectionTitle(title: 'Authorization'.i18n),
          AuthBlock(),
          SettingsSectionTitle(title: 'Application info'.i18n),
          AppInfo(),
          // SizedBox(height: 5),
          // CustomBackButton(isRoot: true),
        ],
      ),
    );
  }
}
