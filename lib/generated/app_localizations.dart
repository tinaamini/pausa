import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Pausa'**
  String get appName;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control today. Focus on what matters.'**
  String get welcomeSubtitle;

  /// No description provided for @parentMode.
  ///
  /// In en, this message translates to:
  /// **'Parent Mode'**
  String get parentMode;

  /// No description provided for @parentModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage and protect your child\'s device'**
  String get parentModeDesc;

  /// No description provided for @selfMode.
  ///
  /// In en, this message translates to:
  /// **'Self Mode'**
  String get selfMode;

  /// No description provided for @selfModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Take control and improve your focus'**
  String get selfModeDesc;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @apps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get apps;

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focus;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good night'**
  String get goodNight;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @focusSession.
  ///
  /// In en, this message translates to:
  /// **'Focus Session'**
  String get focusSession;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **' days'**
  String get days;

  /// No description provided for @keepItUp.
  ///
  /// In en, this message translates to:
  /// **'keep it up!🔥'**
  String get keepItUp;

  /// No description provided for @blockedApps.
  ///
  /// In en, this message translates to:
  /// **'Blocked Apps'**
  String get blockedApps;

  /// No description provided for @timeSaved.
  ///
  /// In en, this message translates to:
  /// **'Time Saved'**
  String get timeSaved;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @recentlyBlocked.
  ///
  /// In en, this message translates to:
  /// **'Recently Blocked'**
  String get recentlyBlocked;

  /// No description provided for @noBlockedApps.
  ///
  /// In en, this message translates to:
  /// **'No blocked apps yet'**
  String get noBlockedApps;

  /// No description provided for @searchApps.
  ///
  /// In en, this message translates to:
  /// **'Search apps'**
  String get searchApps;

  /// No description provided for @noApplicationsFound.
  ///
  /// In en, this message translates to:
  /// **'No Applications Found'**
  String get noApplicationsFound;

  /// No description provided for @minutesPerDay.
  ///
  /// In en, this message translates to:
  /// **'minutes per day'**
  String get minutesPerDay;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// No description provided for @allApps.
  ///
  /// In en, this message translates to:
  /// **'All Apps'**
  String get allApps;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @noLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get noLimit;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'per day'**
  String get perDay;

  /// No description provided for @addCustomApp.
  ///
  /// In en, this message translates to:
  /// **'+ Add Custom App'**
  String get addCustomApp;

  /// No description provided for @schedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @deepWork.
  ///
  /// In en, this message translates to:
  /// **'Deep Work'**
  String get deepWork;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @blockApps.
  ///
  /// In en, this message translates to:
  /// **'Block apps'**
  String get blockApps;

  /// No description provided for @bedtimeMode.
  ///
  /// In en, this message translates to:
  /// **'Bedtime Mode'**
  String get bedtimeMode;

  /// No description provided for @bedtimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Help your mind and body rest better'**
  String get bedtimeDesc;

  /// No description provided for @sleepSchedule.
  ///
  /// In en, this message translates to:
  /// **'Sleep Schedule'**
  String get sleepSchedule;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @grayscaleMode.
  ///
  /// In en, this message translates to:
  /// **'Grayscale Mode'**
  String get grayscaleMode;

  /// No description provided for @grayscaleDesc.
  ///
  /// In en, this message translates to:
  /// **'Reduce screen color at night'**
  String get grayscaleDesc;

  /// No description provided for @blockAllApps.
  ///
  /// In en, this message translates to:
  /// **'Block All Apps'**
  String get blockAllApps;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @totalTimeSaved.
  ///
  /// In en, this message translates to:
  /// **'Total Time Saved'**
  String get totalTimeSaved;

  /// No description provided for @topApps.
  ///
  /// In en, this message translates to:
  /// **'Top Apps'**
  String get topApps;

  /// No description provided for @setupParentalPin.
  ///
  /// In en, this message translates to:
  /// **'Set up Parental PIN'**
  String get setupParentalPin;

  /// No description provided for @pinDesc.
  ///
  /// In en, this message translates to:
  /// **'This PIN protects pausa settings and prevents unauthorized changes'**
  String get pinDesc;

  /// No description provided for @locationRules.
  ///
  /// In en, this message translates to:
  /// **'Location Rules'**
  String get locationRules;

  /// No description provided for @locationDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically switch profiles based on location'**
  String get locationDesc;

  /// No description provided for @enableLocationRules.
  ///
  /// In en, this message translates to:
  /// **'Enable Location Rules'**
  String get enableLocationRules;

  /// No description provided for @addLocation.
  ///
  /// In en, this message translates to:
  /// **'+ Add Location'**
  String get addLocation;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appProtection.
  ///
  /// In en, this message translates to:
  /// **'App Protection'**
  String get appProtection;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @manageChildDevice.
  ///
  /// In en, this message translates to:
  /// **'Manage Child Device'**
  String get manageChildDevice;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestore;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutPausa.
  ///
  /// In en, this message translates to:
  /// **'About Pausa'**
  String get aboutPausa;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
