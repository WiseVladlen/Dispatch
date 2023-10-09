import 'dart:io';

import 'package:dispatch/app/user_cubit/user_cubit.dart';
import 'package:dispatch/app/widget/circle_image.dart';
import 'package:dispatch/data/mapper/personal_data_mapper.dart';
import 'package:dispatch/domain/repository/user_repository.dart';
import 'package:dispatch/presentation/settings/cubit/settings_cubit.dart';
import 'package:dispatch/presentation/settings/cubit/settings_state.dart';
import 'package:dispatch/utils/http_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const path = '/settings';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(
        inputDataModel: context.read<UserCubit>().state.user.toPersonalDataModel(),
        userRepository: context.read<IUserRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Align(
            alignment: Alignment.centerRight,
            child: BlocConsumer<SettingsCubit, SettingsState>(
              listenWhen: (oldState, newState) => (oldState.status != newState.status),
              buildWhen: (oldState, newState) {
                return (oldState.isValid != newState.isValid) ||
                    (oldState.status != newState.status);
              },
              listener: (context, state) {
                if (state.status.isSuccess) Navigator.of(context).pop();
              },
              builder: (context, state) {
                return FilledButton(
                  onPressed: (state.isValid && !state.status.isInProgress)
                      ? () => context.read<SettingsCubit>().save()
                      : null,
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: state.status.isInProgress
                      ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator())
                      : const Text('Save'),
                );
              },
            ),
          ),
        ),
        body: const SafeArea(
          child: _SettingsView(),
        ),
      ),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (oldState, newState) {
        return newState.status.isFailure && (oldState.errorMessage != newState.errorMessage);
      },
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Unknown error')));
      },
      child: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 36),
          child: Wrap(
            runSpacing: 16,
            children: [
              _Avatar(),
              _NameInput(),
              _EmailInput(),
              _PasswordInput(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (oldState, newState) => (oldState.imagePath != newState.imagePath),
      builder: (context, state) {
        final imagePath = state.imagePath;

        return Column(
          children: [
            if (imagePath != null) ...[
              GestureDetector(
                child: isNetworkImage(imagePath)
                    ? CircleNetworkImage(
                        imagePath: imagePath,
                        radius: 64,
                        errorWidget: () => const Icon(
                          Icons.error,
                          size: 48,
                          color: Colors.pink,
                        ),
                        placeholderColor: Theme.of(context).primaryColorLight,
                      )
                    : ClipOval(
                        child: Image.file(
                          File(imagePath),
                          errorBuilder: (_, __, ___) {
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                shape: BoxShape.circle,
                              ),
                              width: 128,
                              height: 128,
                              child: const Icon(
                                Icons.error,
                                size: 48,
                                color: Colors.pink,
                              ),
                            );
                          },
                          width: 128,
                          height: 128,
                          fit: BoxFit.cover,
                        ),
                      ),
                onTap: () => _showModalBottomSheet(context),
              ),
              const Divider(height: 4, color: Colors.transparent),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _showModalBottomSheet(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Change'),
                  ),
                  TextButton.icon(
                    onPressed: () => context.read<SettingsCubit>().avatarImageDeleted(),
                    icon: const Icon(Icons.delete),
                    label: const Text('Remove'),
                  ),
                ],
              ),
            ] else ...[
              GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  radius: 64,
                  child: const Icon(Icons.add_photo_alternate_outlined, size: 48),
                ),
                onTap: () => _showModalBottomSheet(context),
              ),
              const Divider(height: 4, color: Colors.transparent),
              Center(
                child: TextButton.icon(
                  onPressed: () => _showModalBottomSheet(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add picture'),
                ),
              ),
            ],
            const Divider(height: 16, color: Colors.transparent),
          ],
        );
      },
    );
  }
}

Future<void> _showModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(12),
        right: Radius.circular(12),
      ),
    ),
    builder: (sheetContext) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                context.read<SettingsCubit>().avatarImagePicked(source: ImageSource.camera);
                Navigator.of(sheetContext).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () {
                context.read<SettingsCubit>().avatarImagePicked(source: ImageSource.gallery);
                Navigator.of(sheetContext).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

class _NameInput extends StatelessWidget {
  const _NameInput();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          left: 16,
          top: 16,
          child: Icon(Icons.account_box),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 56, right: 24),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (oldState, newState) => (oldState.name != newState.name),
            builder: (context, state) {
              return TextFormField(
                key: const Key('settingsPage_nameInput_textField'),
                initialValue: state.name.value,
                onChanged: (name) => context.read<SettingsCubit>().nameChanged(name),
                decoration: InputDecoration(
                  labelText: 'Name',
                  errorText: state.name.displayError != null ? 'Invalid name' : null,
                  border: const OutlineInputBorder(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          left: 16,
          top: 16,
          child: Icon(Icons.alternate_email),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 56, right: 24),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (oldState, newState) => (oldState.email != newState.email),
            builder: (context, state) {
              return TextFormField(
                key: const Key('settingsPage_emailInput_textField'),
                initialValue: state.email.value,
                onChanged: (email) => context.read<SettingsCubit>().emailChanged(email),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: state.email.displayError != null ? 'Invalid email' : null,
                  border: const OutlineInputBorder(),
                ),
                enabled: false,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          left: 16,
          top: 16,
          child: Icon(Icons.lock),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 56, right: 24),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (oldState, newState) => (oldState.password != newState.password),
            builder: (context, state) {
              return TextFormField(
                key: const Key('settingsPage_passwordInput_textField'),
                initialValue: state.password.value,
                onChanged: (password) => context.read<SettingsCubit>().passwordChanged(password),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: state.password.displayError != null ? 'Invalid password' : null,
                  border: const OutlineInputBorder(),
                ),
                enabled: false,
              );
            },
          ),
        ),
      ],
    );
  }
}
