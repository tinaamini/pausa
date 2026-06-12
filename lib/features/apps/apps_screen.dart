import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pausa/core/theme/app_colors.dart';
import 'package:pausa/core/theme/app_size.dart';
import 'package:pausa/core/theme/app_text_style.dart';
import 'package:pausa/features/apps/widgets/app_list_tile.dart';
import 'package:pausa/features/apps/widgets/time_limit_bottom.dart';
import 'package:pausa/generated/app_localizations.dart';
import 'cubit/apps_cubit.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AppsView();
  }
}

class _AppsView extends StatefulWidget {
  const _AppsView();

  @override
  State<_AppsView> createState() => _AppsViewState();
}

class _AppsViewState extends State<_AppsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      context.read<AppsCubit>().toggleShowBlocked(_tabController.index == 1);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AppsCubit, AppsState>(
      builder: (context, state) {
        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
              child: Row(
                children: [
                  const Spacer(),
                  if (state.isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.grayLight, width: 1),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(

                    border: Border(
                      bottom: BorderSide(color: AppColors.primary, width: 3),
                    ),
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: isDark
                      ? AppColors.textDark
                      : AppColors.textLight,
                  labelStyle: AppTextStyle.FocusSessionCardStyle(context),

                  tabs: [
                    Tab(text: l10n.allApps),
                    Tab(text: l10n.blocked),
                  ],
                ),
              ),
            ),

             SizedBox(height:AppSize.height * 0.04),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: context.read<AppsCubit>().search,
                decoration: InputDecoration(
                  hintText: l10n.searchApps,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : AppColors.grayLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

             SizedBox(height: AppSize.height * 0.02),

            // App List
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.filteredApps.isEmpty
                  ? Center(
                      child: Text(
                        state.showOnlyBlocked
                            ? l10n.noBlockedApps
                            : l10n.noApplicationsFound,
                        style: AppTextStyle.greetingTitleStyle(context).copyWidth(color: isDark ? AppColors.darkCard : AppColors.grayLight,)
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: state.filteredApps.length,
                      itemBuilder: (context, index) {
                        final app = state.filteredApps[index];
                        return AppListTile(
                          app: app,
                          onToggleBlock: () =>
                              context.read<AppsCubit>().toggleBlock(app),
                          onSetTimeLimit: () =>
                              _showTimeLimitSheet(context, app),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showTimeLimitSheet(BuildContext context, app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TimeLimitBottomSheet(
        app: app,
        onSave: (minutes) {
          context.read<AppsCubit>().setTimeLimit(app, minutes);
        },
      ),
    );
  }
}
