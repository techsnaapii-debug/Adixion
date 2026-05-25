import 'package:doctor/Core/networking/dio_factory.dart';
import 'package:doctor/Core/helper/token_storage_service.dart';
import 'package:doctor/Presentation/AuthScreen/data/api/register_api_service.dart';
import 'package:doctor/Presentation/AuthScreen/data/repo/register_repo.dart';
import 'package:doctor/Presentation/AuthScreen/data/api/login_api_service.dart';
import 'package:doctor/Presentation/AuthScreen/data/repo/login_repo.dart';
import 'package:doctor/Presentation/AuthScreen/data/api/forgot_password_api_service.dart';
import 'package:doctor/Presentation/AuthScreen/data/repo/forgot_password_repo.dart';
import 'package:doctor/Presentation/AuthScreen/logic/forgot_password/forgot_password_cubit.dart';
import 'package:doctor/Presentation/AuthScreen/logic/login/login_cubit.dart';
import 'package:doctor/Presentation/AuthScreen/logic/register/register_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
Future<void> setupGetIt() async {
  // Dio and Register Api Services
  Dio dio = DioFactory.getDio();
  DioFactory.addDioInterceptor();
  
  // Token Storage Service
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  
  getIt.registerLazySingleton<TokenStorageService>(
    () => TokenStorageService(getIt()),
  );
  
  getIt.registerLazySingleton<RegisterApiService>(
    () => RegisterApiService(dio),
  );

  // Register Repository
  getIt.registerLazySingleton<RegisterRepo>(
    () => RegisterRepo(registerApiService: getIt()),
  );

  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(registerRepo: getIt()),
  );

  // --- Login Setup ---
  getIt.registerLazySingleton<LoginApiService>(() => LoginApiService(dio));

  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepo(loginApiService: getIt()),
  );

  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginRepo: getIt(),
      tokenStorageService: getIt(),
    ),
  );
  // --- Forgot Password Setup ---
  getIt.registerLazySingleton<ForgotPasswordApiService>(
    () => ForgotPasswordApiService(dio),
  );

  getIt.registerLazySingleton<ForgotPasswordRepo>(
    () => ForgotPasswordRepo(apiService: getIt()),
  );

  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(repo: getIt()),
  );
}
