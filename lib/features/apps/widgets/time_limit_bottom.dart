import 'package:flutter/material.dart';
import 'package:pausa/core/theme/app_colors.dart';
import 'package:pausa/data/models/Apps/installed_app.dart';

class TimeLimitBottomSheet extends StatefulWidget {
  final InstalledApp app;
  final Function(int? minutes) onSave;

  const TimeLimitBottomSheet({
    super.key,
    required this.app,
    required this.onSave,
  });

  @override
  State<TimeLimitBottomSheet> createState() => _TimeLimitBottomSheetState();
}

class _TimeLimitBottomSheetState extends State<TimeLimitBottomSheet> {
  int _selectedMinutes = 30;
  bool _noLimit = false;

  final List<int> _presets = [15, 30, 45, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    if (widget.app.dailyLimitMinutes != null) {
      _selectedMinutes = widget.app.dailyLimitMinutes!;
    } else {
      _noLimit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.textDark : AppColors.lightCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'محدودیت روزانه — ${widget.app.name}',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presets.map((min) {
              final isSelected = !_noLimit && _selectedMinutes == min;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedMinutes = min;
                  _noLimit = false;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isDark
                        ? AppColors.darkCard
                        : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    min >= 60 ? '${min ~/ 60} ساعت' : '$min دقیقه',
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('بدون محدودیت',
                  style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              Switch(
                value: _noLimit,
                onChanged: (v) => setState(() => _noLimit = v),
                activeColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(_noLimit ? null : _selectedMinutes);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('ذخیره',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}