import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class RememberMeToggled extends LoginEvent {}

class FormSubmitted extends LoginEvent {
  final String email;
  final String password;

  const FormSubmitted({required this.email, required this.password});
  @override
  List<Object> get props => [email,password];
}
class LoginWithRememberMe extends LoginEvent {}
class Logout extends LoginEvent {}
