import 'package:dispatch/domain/repository/authentication_repository.dart';
import 'package:dispatch/presentation/authentication/login/cubit/login_cubit.dart';
import 'package:dispatch/presentation/authentication/login/cubit/login_state.dart';
import 'package:dispatch/presentation/authentication/model/authentication_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        authenticationRepository: context.read<IAuthenticationRepository>(),
      ),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (oldState, newState) {
          return newState.status.isFailure && (oldState.errorMessage != newState.errorMessage);
        },
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication error'),
              ),
            );
        },
        child: const Wrap(
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _EmailInput(),
            _PasswordInput(),
            _LogInButton(),
            _SignUpButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (oldState, newState) => (oldState.email != newState.email),
      builder: (context, state) {
        return TextField(
          key: const Key('loginPage_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.email.displayError != null ? 'Invalid email' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (oldState, newState) => (oldState.password != newState.password),
      builder: (context, state) {
        return TextField(
          key: const Key('loginPage_passwordInput_textField'),
          onChanged: (password) => context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.password.displayError != null ? 'Invalid password' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _LogInButton extends StatelessWidget {
  const _LogInButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (oldState, newState) {
        return (oldState.status != newState.status) || (oldState.isValid != newState.isValid);
      },
      builder: (context, state) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.maxFinite),
          child: FilledButton(
            onPressed: (state.isValid && !state.status.isInProgress)
                ? () => context.read<LoginCubit>().logIn()
                : null,
            child: state.status.isInProgress
                ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator())
                : const Text('Log In'),
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (oldState, newState) => (oldState.status != newState.status),
      builder: (context, state) {
        return TextButton(
          onPressed: !state.status.isInProgress
              ? () => context.read<AuthenticationPageModel>().onNavigateToSignUpPage()
              : null,
          child: const Text('Don\'t have an account?'),
        );
      },
    );
  }
}
