import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../localization/app_strings.dart';

class LanguageProvider extends ChangeNotifier {
  final StorageService _storage;
  String _languageCode = 'en';

  LanguageProvider(this._storage) {
    _languageCode = _storage.languageCode;
  }

  String get languageCode => _languageCode;
  bool get isTamil => _languageCode == 'ta';

  void setLanguage(String code) {
    if (_languageCode != code) {
      _languageCode = code;
      _storage.setLanguageCode(code);
      notifyListeners();
    }
  }

  String tr(String key) {
    return AppStrings.get(key, _languageCode);
  }
}
