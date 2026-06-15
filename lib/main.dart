import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/router.dart';
import 'core/theme/app_size.dart';
import 'features/utils/cubits/local_cubit.dart';
import 'generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚀 Hive init
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('blocked_apps');



  // 🚀 preload svgs (optional)
  await _precacheSvgs();

  runApp(MainApp(router: router));
}

/// ------------------------------------------------
/// APP ROOT
/// ------------------------------------------------
class MainApp extends StatelessWidget {
  final router;

  const MainApp({
    super.key,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),
      ],
      child: _AppBootstrap(router: router),
    );
  }
}

/// ------------------------------------------------
/// BOOTSTRAP
/// ------------------------------------------------
class _AppBootstrap extends StatefulWidget {
  final router;

  const _AppBootstrap({required this.router});

  @override
  State<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<_AppBootstrap> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AppSize.init(context);

    if (_started) return;
    _started = true;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      builder: (context, child) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,



              routerConfig: widget.router,

              locale: locale,
              supportedLocales: const [
                Locale('en'),
                Locale('fa'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        );
      },
    );
  }
}

/// ------------------------------------------------
/// SVG PRECACHE
/// ------------------------------------------------
Future<void> _precacheSvgs() async {
  const paths = [];

  for (final path in paths) {
    try {
      final loader = SvgAssetLoader(path);
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
            () => loader.loadBytes(null),
      );
    } catch (e) {
      debugPrint('SVG cache failed: $path → $e');
    }
  }
}