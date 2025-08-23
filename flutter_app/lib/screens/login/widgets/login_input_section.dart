import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rebot_flutter_app/bloc/login_bloc.dart';
import 'package:rebot_flutter_app/bloc/login_event.dart';
import 'package:rebot_flutter_app/widgets/simple_textfield.dart';
import 'package:rebot_flutter_app/widgets/checkbox.dart';
import 'package:rebot_flutter_app/screens/login/widgets/login_animations.dart';

class LoginInputSection extends StatelessWidget {
  final LoginAnimations animations;
  final TextEditingController emailController ;
  final TextEditingController passwordController ;
  const LoginInputSection({
    super.key,
    required this.animations,
    required this.emailController, required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Transform(
      transform: Matrix4.translationValues(
        animations.delayAnimation.value * screenWidth,
        0,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform(
            transform: Matrix4.translationValues(
              animations.slideAnimation.value * screenWidth,
              0,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to,',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Transform(
                  transform: Matrix4.translationValues(
                    animations.delaySubAnimation.value * screenWidth,
                    0,
                    0,
                  ),
                  child: Text(
                     "Offices",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          SimpleTextField(
            controller: emailController,
            label: 'Email address',
            // onChanged: (value) =>
            // emailController.text=value,
            keyboardType: TextInputType.emailAddress,
          ),

          SimpleTextField(
            controller: passwordController,
            label: 'Password',
            // onChanged: (value) =>
            //   passwordController.text=value,
            obscureText: true,
          ),
          const SizedBox(height: 30),
          CustomCheckbox(
            label: 'Remember me?',
            isChecked: context.watch<LoginBloc>().state.rememberMe,
            callback: (_) => context.read<LoginBloc>().add(RememberMeToggled()),
          ),
        ],
      ),
    );
  }
}
