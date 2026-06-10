import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pausa/features/home/cubit/home_Cubit.dart';

import 'core/router/router.dart';
import 'core/theme/app_size.dart';
import 'features/home/cubit/home_state.dart';
import 'features/utils/cubits/local_cubit.dart';
import 'generated/app_localizations.dart';

Future<void> main() async {
  await _precacheSvgs();

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

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

// class AppBlockerScreen extends StatefulWidget {
//   const AppBlockerScreen({super.key});
//
//   @override
//   State<AppBlockerScreen> createState() => _AppBlockerScreenState();
// }
//
// class _AppBlockerScreenState extends State<AppBlockerScreen> {
//   static const platform = MethodChannel('app_blocker_channel');
//
//   List<Map<String, dynamic>> apps = [];
//   final List<String> blockedApps = [];
//   bool permissionsGranted = false;
//
//   Future<void> getInstalledApps() async {
//     final result = await platform.invokeMethod('getInstalledApps');
//     setState(() {
//       apps = List<Map<String, dynamic>>.from(
//         (result as List).map((e) => Map<String, dynamic>.from(e as Map)),
//       );
//     });
//   }
//
//   Future<void> requestUsagePermission() async {
//     await platform.invokeMethod('requestUsagePermission');
//   }
//
//   Future<void> requestOverlayPermission() async {
//     await platform.invokeMethod('requestOverlayPermission');
//   }
//
//   void startAutoCheck() async {
//     String? lastApp;
//     while (mounted) {
//       try {
//         final currentApp =
//         await platform.invokeMethod<String>('getForegroundApp');
//
//         if (currentApp != lastApp) {
//           lastApp = currentApp;
//
//           if (currentApp != null && blockedApps.contains(currentApp)) {
//             final canOverlay =
//                 await platform.invokeMethod<bool>('canDrawOverlays') ?? false;
//             if (canOverlay) {
//               await platform.invokeMethod('showOverlay');
//             }
//           } else {
//             await platform.invokeMethod('removeOverlay');
//           }
//         }
//       } catch (e) {
//         debugPrint("Error checking app: $e");
//       }
//       await Future.delayed(const Duration(seconds: 2));
//     }
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     getInstalledApps();
//
//     Future.delayed(const Duration(seconds: 2), startAutoCheck);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("App Blocker"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//           Wrap(
//             alignment: WrapAlignment.center,
//             spacing: 8,
//             children: [
//               ElevatedButton(
//                 onPressed: requestUsagePermission,
//                 child: const Text("Usage Access"),
//               ),
//               ElevatedButton(
//                 onPressed: requestOverlayPermission,
//                 child: const Text("Overlay Access"),
//               ),
//               ElevatedButton(
//                 onPressed: getInstalledApps,
//                 child: const Text("Refresh Apps"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           const Divider(color: Colors.white),
//           Expanded(
//             child: ListView.builder(
//               itemCount: apps.length,
//               itemBuilder: (context, index) {
//                 final app = apps[index];
//                 final name = app['name'];
//                 final pkg = app['package'];
//                 final blocked = blockedApps.contains(pkg);
//                 return ListTile(
//                   leading: app['icon'] != null
//
//                       ? Image.memory(
//                 base64Decode(app['icon']),
//                 width: 40,
//                 height: 40,
//                 )
//                     : const Icon(Icons.apps, color: Colors.white),
//                   title: Text(
//                     name,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   subtitle: Text(pkg,
//                       style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                   trailing: Switch(
//                     value: blocked,
//                     onChanged: (value) {
//                       setState(() {
//                         if (value) {
//                           blockedApps.add(pkg);
//                         } else {
//                           blockedApps.remove(pkg);
//                         }
//                       });
//                     },
//                     activeColor: Colors.redAccent,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
