import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:musika/core/constants/server_constant.dart';
import 'package:musika/core/models/failure.dart';
import 'package:musika/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.baseUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      Map<String, dynamic> resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(
        UserModel.fromMap(resBodyMap),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      Map<String, dynamic> resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(
        UserModel.fromMap(resBodyMap['user']).copyWith(token: resBodyMap['token']),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstant.baseUrl}/auth'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      Map<String, dynamic> resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(
        UserModel.fromMap(resBodyMap).copyWith(token: token),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
