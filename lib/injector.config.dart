// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'core/common/network/auth_interceptor.dart' as _i120;
import 'core/common/network/dio.dart' as _i627;
import 'core/common/storage/token_service.dart' as _i942;
import 'feature/auth/api/auth_api.dart' as _i817;
import 'feature/chat/api/chat_api.dart' as _i781;
import 'feature/chat/repository/chat_repository.dart' as _i1041;
import 'feature/chat/ui/bloc/chat_bloc.dart' as _i992;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioProvider = _$DioProvider();
    gh.lazySingleton<_i942.TokenService>(() => _i942.TokenService());
    gh.lazySingleton<_i120.AuthInterceptor>(
      () => _i120.AuthInterceptor(gh<_i942.TokenService>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioProvider.dio(gh<_i120.AuthInterceptor>()),
    );
    gh.factory<_i781.ChatApi>(
      () => _i781.ChatApi(gh<_i361.Dio>(), baseUrl: gh<String>()),
    );
    gh.factory<_i817.AuthAPI>(
      () => _i817.AuthAPI(gh<_i361.Dio>(), baseUrl: gh<String>()),
    );
    gh.lazySingleton<_i1041.ChatRepository>(
      () => _i1041.ChatRepositoryImpl(gh<_i781.ChatApi>()),
    );
    gh.factory<_i992.ChatBloc>(
      () => _i992.ChatBloc(gh<_i1041.ChatRepository>()),
    );
    return this;
  }
}

class _$DioProvider extends _i627.DioProvider {}
