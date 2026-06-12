import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/router.dart';
import 'core/theme/app_size.dart';
import 'features/utils/cubits/local_cubit.dart';
import 'generated/app_localizations.dart';

Future<void> main() async {
  await _precacheSvgs();

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('blocked_apps');
  // final onboardingShowCubit = OnboardingShowCubit(storage);
  // await onboardingShowCubit.load();


  runApp(MainApp(router: router));
}

class MainApp extends StatelessWidget {
  final GoRouter router;

  // final OnboardingStorage storage;
  // final OnboardingShowCubit onboardingShowCubit;

  const MainApp({
    super.key,
    required this.router,
    // required this.storage,
    // required this.onboardingShowCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
      ],
      child: _AppBootstrap(router: router),
    );
  }
}

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

class _AppBootstrap extends StatefulWidget {
  final GoRouter router;

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

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<AppPermissionCubit>().loadApps();
    //   context.read<SpecialPermissionCubit>().loadStatus();
    // });
  }

  @override
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
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('fa')],
            );
          },
        );
      },
    );
  }
}

