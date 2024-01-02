import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realmnotes/models/note_model.dart';
import 'package:realmnotes/provider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(NoteAdapter());

  await Hive.initFlutter();
  await Hive.openBox('notes');
  await Hive.openBox('settings');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final settingsBox = Hive.box('settings');

  double getFontSize(String scale) {
    switch (scale) {
      case 'Small':
        return 0.8;
      case 'Medium':
        return 1;
      case 'Large':
        return 1.2;

      default:
        return 1;
    }
  }

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(selectedColorOption.notifier)
          .update((state) => settingsBox.get(1) ?? 'Purple');
      ref
          .read(selectedSizeOption.notifier)
          .update((state) => settingsBox.get(2) ?? 'Medium');
      ref
          .read(sortByOption.notifier)
          .update((state) => settingsBox.get(3) ?? 'Newest');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: getFontSize(ref.watch(selectedSizeOption).toString()),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark),
        home: const HomePage(),
      ),
    );
  }
}
