import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider characterProvider = StateProvider<int>((ref) => 0);
final StateProvider selectedColorOption = StateProvider((ref) => null);
final StateProvider selectedSizeOption = StateProvider((ref) => null);
final StateProvider sortByOption = StateProvider((ref) => null);
final StateProvider showLoginPage = StateProvider<bool>((ref) => true);
final StateProvider errorMessageProvider = StateProvider((ref) => '');
