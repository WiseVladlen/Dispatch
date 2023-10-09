import 'package:dispatch/domain/repository/authentication_repository.dart';
import 'package:dispatch/presentation/authentication/model/authentication_page_model.dart';
import 'package:dispatch/presentation/authentication/sign_up/cubit/sign_up_cubit.dart';
import 'package:dispatch/presentation/authentication/sign_up/cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(
        authenticationRepository: context.read<IAuthenticationRepository>(),
      ),
      child: BlocListener<SignUpCubit, SignUpState>(
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
            _NameInput(),
            _EmailInput(),
            _PasswordInput(),
            _SignUpButton(),
            _LogInButton(),
          ],
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (oldState, newState) => (oldState.name != newState.name),
      builder: (context, state) {
        return TextField(
          key: const Key('signUpPage_nameInput_textField'),
          onChanged: (name) => context.read<SignUpCubit>().nameChanged(name),
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: state.name.displayError != null ? 'Invalid name' : null,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (oldState, newState) => (oldState.email != newState.email),
      builder: (context, state) {
        return TextField(
          key: const Key('signUpPage_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (oldState, newState) => (oldState.password != newState.password),
      builder: (context, state) {
        return TextField(
          key: const Key('signUpPage_passwordInput_textField'),
          onChanged: (password) => context.read<SignUpCubit>().passwordChanged(password),
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

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (oldState, newState) {
        return (oldState.status != newState.status) || (oldState.isValid != newState.isValid);
      },
      builder: (context, state) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.maxFinite),
          child: FilledButton(
            onPressed: (state.isValid && !state.status.isInProgress)
                ? () => context.read<SignUpCubit>().signUp()
                : null,
            child: state.status.isInProgress
                ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator())
                : const Text('Sign Up'),
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (oldState, newState) => (oldState.status != newState.status),
      builder: (context, state) {
        return TextButton(
          onPressed: !state.status.isInProgress
              ? () => context.read<AuthenticationPageModel>().onNavigateToLoginPage()
              : null,
          child: const Text('Already have an account?'),
        );
      },
    );
  }
}
