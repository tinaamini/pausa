import 'package:flutter/material.dart';
import 'package:pausa/core/theme/app_colors.dart';
import 'package:pausa/core/theme/app_text_style.dart';

class PermissionBox extends StatelessWidget {
  final List<IconData> itemIcons;
  final List<String> items;
  final List<String> items2;

  const PermissionBox({
    super.key,
    required this.itemIcons,
    required this.items,
    required this.items2,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // آیتم‌ها را دو‌تا دو‌تا کنار هم می‌چینیم
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _PermissionItem(
                icon: itemIcons[i],
                title: items[i],
                description: items2[i],
                context: context,
              )),
              if (i + 1 < items.length) ...[
                const SizedBox(width: 8),
                Expanded(child: _PermissionItem(
                  icon: itemIcons[i + 1],
                  title: items[i + 1],
                  description: items2[i + 1],
                  context: context,
                )),
              ],
            ],
          ),
        ),
      );
      if (i + 2 < items.length) rows.add(const SizedBox(height: 12));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ...rows,
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final BuildContext context;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.context,
  });

  @override
  Widget build(BuildContext buildContext) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // آیکون با سایز ثابت — نه وابسته به AppSize
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryLight,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 8),
        // Expanded تا متن‌های بلند overflow نکنند
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.usageTitleDialog(context),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyle.usageDescriptionDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}