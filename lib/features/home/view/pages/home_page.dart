import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musika/core/providers/current_user_notifier.dart';
import 'package:musika/features/auth/model/user_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel? user = ref.watch(currentUserNotifierProvider);
    return Scaffold(
      body: Center(
        child: Text(user.toString()),
      ),
    );
  }
}
