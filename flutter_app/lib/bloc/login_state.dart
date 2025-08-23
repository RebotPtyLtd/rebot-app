import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;


  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,

  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool? isValidForm,
    bool? isEmailValid,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,

    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    rememberMe,
    isSubmitting,
    isSuccess,
    errorMessage,

  ];
}
