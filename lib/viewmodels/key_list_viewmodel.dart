import 'package:flutter/material.dart';
import '../data/models/key_model.dart';
import '../data/repositories/key_repository.dart';

class KeyListViewModel extends ChangeNotifier {
  final KeyRepository _repository = KeyRepository();

  List<KeyModel> _keys = [];
  List<KeyModel> get keys => _keys;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadKeys() {
    _isLoading = true;
    notifyListeners();

    _keys = _repository.getKeys();
    
    _isLoading = false;
    notifyListeners();
  }
}
