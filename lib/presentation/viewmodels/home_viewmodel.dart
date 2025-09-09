

import 'package:signals_flutter/signals_flutter.dart';

class HomeViewController {
  // Estado do ViewController usando Signals
  /// Aba selecionada (0 = lista, 1 = conversor)
  final _selectedIndex = Signal<int>(0);
  // Getters para acessar signals (readonly)
  ReadonlySignal<int> get selectedIndex => _selectedIndex.readonly();
  
  /// Atualiza a aba
  void changeTab(int index) {
    _selectedIndex.value = index;
  }
}

