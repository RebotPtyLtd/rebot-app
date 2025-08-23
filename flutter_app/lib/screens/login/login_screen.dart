import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rebot_flutter_app/bloc/login_bloc.dart';
import 'package:rebot_flutter_app/bloc/login_event.dart';
import 'package:rebot_flutter_app/bloc/login_state.dart';
import 'package:rebot_flutter_app/utils/app_utils.dart';
import 'package:rebot_flutter_app/widgets/LoginButton.dart';
import 'package:rebot_flutter_app/widgets/circular_loader.dart';
import 'package:rebot_flutter_app/screens/login/widgets/login_header.dart';
import 'package:rebot_flutter_app/screens/login/widgets/login_input_section.dart';
import 'package:rebot_flutter_app/screens/login/widgets/login_animations.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;


  late LoginAnimations animations;

  @override
  void initState() {
    super.initState();
    animations = LoginAnimations(this);
    animations.slideController.forward();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    final loginBloc = context.read<LoginBloc>();

    if (loginBloc.state.email.isNotEmpty &&
        loginBloc.state.password.isNotEmpty) {
      emailController.text = loginBloc.state.email.trim();
      passwordController.text = loginBloc.state.password.trim();
    }
  }

  @override
  void dispose() {
    animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoginHeader(hexToColor: AppUtils.hexToColor),
              const SizedBox(height: 80),
              AnimatedBuilder(
                animation: animations.slideController,
                builder: (context, _) => LoginInputSection(
                  emailController: emailController,
                  passwordController: passwordController,
                  animations: animations,
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return state.isSubmitting
                      ? const Center(child: CircularLoader())
                      : Center(
                          child: FadeTransition(
                            opacity: animations.fadeAnimation,
                            child: LoginButton(
                              text: "Login",
                              onPressed: () {
                                final loginBloc = context.read<LoginBloc>();
                                loginBloc.add(
                                  FormSubmitted(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
