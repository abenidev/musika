import 'package:fpdart/fpdart.dart';
import 'package:musika/core/models/failure.dart';
import 'package:musika/core/providers/current_user_notifier.dart';
import 'package:musika/features/auth/model/user_model.dart';
import 'package:musika/features/auth/repositories/auth_local_repository.dart';
import 'package:musika/features/auth/repositories/auth_remote_repository.dart';
import 'package:musika/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    final val = switch (res) {
      Left(value: final l) => _onAuthFailed(l),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    logger.i(val);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    final val = switch (res) {
      Left(value: final l) => _onAuthFailed(l),
      Right(value: final r) => _loginSuccess(r),
    };

    logger.i(val);
  }

  AsyncValue<UserModel>? _onAuthFailed(AppFailure appFailure) {
    return state = AsyncValue.error(appFailure.message, StackTrace.current);
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getUserData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUserData(token: token);
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
        Right(value: final r) => _getUserDataSuccess(r),
      };

      return val.value;
    }

    return null;
  }

  AsyncValue<UserModel> _getUserDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
