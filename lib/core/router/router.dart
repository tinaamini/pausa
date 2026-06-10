import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pausa/core/router/rout_name.dart';
import 'package:pausa/core/theme/app_colors.dart';
import 'package:pausa/features/apps/apps_screen.dart';
import 'package:pausa/features/focus/focus_screen.dart';
import 'package:pausa/features/home/cubit/home_Cubit.dart';
import 'package:pausa/features/home/cubit/home_state.dart';
import 'package:pausa/features/home/home_screen.dart';
import 'package:pausa/features/more/more_screen.dart';
import 'package:pausa/features/stats/stats_screen.dart';
import 'package:pausa/features/utils/cubits/local_cubit.dart';
import 'package:pausa/features/utils/widgets/navigation_bar.dart';



final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _shellNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {

    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: brightness == Brightness.dark ? AppColors.backGroundDark: AppColors.backGroundLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: child,
          ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: const BottomNavigationBarCustom(),
            ),

        ],
      ),
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: RouteName.home,
  navigatorKey: _rootNavigatorKey,
  routes: [
    // GoRoute(
    //   // path: RouteName.splash,
    //   // name: RouteName.splash,
    //   // builder: (context, state) => const SplashScreen(),
    // ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(create: (_) => HomeCubit(
            )),
            BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
          ],
          child: AppShell(child: child),
        );
      },
      routes: [
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: RouteName.home,
          name: RouteName.home,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder: _defaultTransition,
          ),
        ),

        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: RouteName.apps,
          name: RouteName.apps,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AppsScreen(),
            transitionsBuilder: _defaultTransition,
          ),
        ),        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: RouteName.focus,
          name: RouteName.focus,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const FocusScreen(),
            transitionsBuilder: _defaultTransition,
          ),
        ),        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: RouteName.stats,
          name: RouteName.stats,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const StatsScreen(),
            transitionsBuilder: _defaultTransition,
          ),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: RouteName.more,
          name: RouteName.more,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MoreScreen(),
            transitionsBuilder: _defaultTransition,
          ),
        ),
      ],
    ),
  ],
);

Widget _defaultTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(opacity: animation, child: child);
}
