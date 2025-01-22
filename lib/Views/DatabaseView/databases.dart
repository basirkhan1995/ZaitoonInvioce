import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Components/Other/functions.dart';
import 'package:zaitoon_invoice/Components/Widgets/language_dropdown.dart';
import 'package:zaitoon_invoice/Components/Widgets/onhover_widget.dart';
import 'package:zaitoon_invoice/Components/Widgets/theme_dropdown.dart';
import 'package:zaitoon_invoice/Views/Authentication/register.dart';

class LoadAllDatabases extends StatelessWidget {
  const LoadAllDatabases({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          //Header
          header(locale: locale, style: textStyle),
          //Action Buttons
          actionButtons(locale: locale, context: context),
          //Recent Databases
          recentDatabases(locale: locale, style: textStyle),
        ],
      ),
    );
  }

  Widget actionButtons(
      {required AppLocalizations locale, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Row(
        spacing: 15,
        children: [
          HoverWidget(
            onTap: () {
              Env.goto(context, RegisterView());
            },
            label: locale.newDatabase,
            icon: Icons.add,
            fontSize: 18,
            color: Colors.greenAccent.withValues(alpha: .4),
            hoverColor: Colors.green,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          HoverWidget(
            onTap: () {

            },
            label: locale.browse,
            fontSize: 18,
            icon: Icons.storage_rounded,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            color: Colors.cyan.withValues(alpha: .3),
            hoverColor: Colors.cyan,
          ),
        ],
      ),
    );
  }

  Widget header({required AppLocalizations locale, required var style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.storage_rounded),
              Text(locale.databases, style: style.titleMedium),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              AppTheme(
                width: 150,
              ),
              SelectLanguage(
                width: 150,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget recentDatabases(
      {required AppLocalizations locale, required var style}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: Column(
          children: [
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.sync_alt),
                Text(locale.recentDatabases, style: style.titleMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
