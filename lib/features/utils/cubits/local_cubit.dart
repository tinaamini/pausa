import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  void toggle() {
    emit(state.languageCode == 'fa' ? const Locale('en') : const Locale('fa'));
  }

  void setLocale(Locale locale) {
    emit(locale);
  }

}