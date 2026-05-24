import 'package:doctor/Core/networking/api_result.dart';
import 'package:doctor/Presentation/AuthScreen/data/models/login_request_body.dart';
import 'package:doctor/Presentation/AuthScreen/data/repo/login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor/Presentation/AuthScreen/logic/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;
  
  LoginCubit({required this.loginRepo})
    : super(const LoginState.initial());

  void emitLoginStates(LoginRequestBody requestBody) async {
    emit(const LoginState.loginLoading());
    final response = await loginRepo.login(requestBody);
    
    response.when(
      error: (error) {
        emit(LoginState.loginError(message: error.failure.message));
      },
      success: (loginResponse) {
        emit(LoginState.loginSuccess(loginResponse));
      },
    );
  }
}
