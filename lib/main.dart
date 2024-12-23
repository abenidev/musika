import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:musika/core/providers/current_user_notifier.dart';
import 'package:musika/core/theme/theme.dart';
import 'package:musika/features/auth/model/user_model.dart';
import 'package:musika/features/auth/view/pages/signup_page.dart';
import 'package:musika/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:musika/features/home/view/pages/upload_song_page.dart';

Logger logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ProviderContainer container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  await container.read(authViewModelProvider.notifier).getUserData();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel? currentUser = ref.watch(currentUserNotifierProvider);

    return MaterialApp(
      title: 'Musika',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const SignupPage() : const UploadSongPage(),
    );
  }
}
