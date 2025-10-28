import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebot_flutter_app/repository/auth_repository.dart';
import 'package:rebot_flutter_app/repository/credential_repository.dart';
import 'package:rebot_flutter_app/utils/app_utils.dart';

import 'package:rebot_flutter_app/bloc/login_event.dart';
import 'package:rebot_flutter_app/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CredentialRepository? _credentialRepository;
  final AuthRepository? _authRepository;
  LoginBloc()
    : _credentialRepository = CredentialRepository(),
      _authRepository = AuthRepository(),
      super(const LoginState()) {
    on<RememberMeToggled>(_onRememberMeToggled);
    on<FormSubmitted>(_onFormSubmitted);
    on<LoginWithRememberMe>(_loadCredentials);
    on<Logout>(_logout);
  }

  void _onRememberMeToggled(RememberMeToggled event, Emitter<LoginState> emit) {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: 'Email and Password cannot be empty.',
        ),
      );
      return;
    }

    if (!AppUtils.isEmailValid(event.email)) {
      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: 'Please enter a valid email address.',
        ),
      );
      return;
    }

    emit(state.copyWith(email: event.email, password: event.password));

    try {
      await _login(emit);
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _login(Emitter<LoginState> emit) async {
    await _authRepository?.login(state.email, state.password).then((va) {
      if (va.statusCode == 200) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));

        // Only save if Remember Me is checked
        if (state.rememberMe) {
          _credentialRepository?.saveCredentials(state.email, state.password);
        } else {
          // Clear any previously saved credentials
          _credentialRepository?.clearCredentials();
        }
      } else {
        if (va.statusCode == 500) {
          final Map<String, dynamic> responseBody = jsonDecode(va.body);
          emit(
            state.copyWith(
              isSubmitting: false,
              isSuccess: false,
              errorMessage: responseBody['error'],
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            isSubmitting: false,
            isSuccess: false,
            errorMessage: 'Login failed. Please try again.',
          ),
        );
      }
    });
  }

  Future<void> _loginWithException(Emitter<LoginState> emit) async {
    final response = await _authRepository?.login(state.email, state.password);

    if (response?.statusCode == 200) {
      emit(state.copyWith(isSubmitting: false, isSuccess: true));

      // Only save if Remember Me is checked
      if (state.rememberMe) {
        _credentialRepository?.saveCredentials(state.email, state.password);
      } else {
        // Clear any previously saved credentials
        _credentialRepository?.clearCredentials();
      }
    } else {
      // Throw exception for auto-login error handling
      throw Exception('Login failed with status: ${response?.statusCode}');
    }
  }

  Future<void> _loadCredentials(
    LoginWithRememberMe event,
    Emitter<LoginState> emit,
  ) async {
    final creds = await _credentialRepository?.loadCredentials();
    final email = creds?["email"];
    final password = creds?["password"];

    if (email != null && password != null) {
      emit(
        state.copyWith(
          email: email,
          password: password,
          rememberMe: true,
          isSubmitting: true, // Show loading indicator
          isSuccess: false,
        ),
      );

      // Automatically attempt login with a brief delay for UI feedback
      try {
        await Future.delayed(
          const Duration(seconds: 2),
        ); // Show "Logging you in..." for 2 seconds
        await _loginWithException(emit);
      } catch (e) {
        // If auto-login fails, show form with credentials pre-filled
        emit(
          state.copyWith(
            isSubmitting: false,
            isSuccess: false,
            errorMessage: 'Auto-login failed. Please login manually.',
          ),
        );
      }
    }
  }

  Future<void> _logout(Logout event, Emitter<LoginState> emit) async {
    if (state.rememberMe) {
      emit(state.copyWith(isSuccess: false));
    } else {
      _credentialRepository?.clearCredentials();
      emit(LoginState());
    }
  }
}
