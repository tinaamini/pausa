import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pausa/core/theme/app_text_style.dart';
import 'package:pausa/features/home/cubit/home_state.dart';
import 'package:pausa/generated/app_localizations.dart';

import 'cubit/home_Cubit.dart';
import 'cubit/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  @override
  Widget build(BuildContext context) {
    final l10n=AppLocalizations.of(context)!;
    Object _greeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) return l10n.goodMorning;
      if (hour < 17) return l10n.goodAfternoon;
      return l10n.goodNight;
    }
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return BlocBuilder<HomeCubit,HomeState>(
        builder: (context, state) {
          // if (state.isLoading) {
          //   return const Scaffold(
          //     body: Center(child: CircularProgressIndicator()),
          //   );
          // }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 50),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          '${_greeting()}، ${state.userName}! 👋',)
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
