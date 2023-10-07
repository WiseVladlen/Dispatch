import 'package:cached_network_image/cached_network_image.dart';
import 'package:dispatch/domain/model/personal_data_model.dart';
import 'package:dispatch/domain/repository/user_repository.dart';
import 'package:dispatch/presentation/settings/cubit/settings_state.dart';
import 'package:dispatch/utils/form/email.dart';
import 'package:dispatch/utils/form/name.dart';
import 'package:dispatch/utils/form/password.dart';
import 'package:dispatch/utils/io_utils.dart';
import 'package:dispatch/utils/object_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final _imagePicker = ImagePicker();

  final PersonalDataModel inputDataModel;

  final IUserRepository userRepository;

  SettingsCubit({
    required this.inputDataModel,
    required this.userRepository,
  }) : super(
          SettingsState(
            name: Name.dirty(inputDataModel.name),
            imagePath: inputDataModel.imagePath,
          ),
        );

  Future<void> avatarImagePicked({required ImageSource source}) async {
    try {
      (await _imagePicker.pickImage(source: source)).safeLet((file) {
        emit(state.copyWith(imagePath: file.path, changeImagePath: true));
      });
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void avatarImageDeleted() => emit(state.copyWith(imagePath: null, changeImagePath: true));

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
      name: name,
      isValid: Formz.validate([name]),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([state.name, email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.name, state.email, password]),
    ));
  }

  void save() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final checker = PersonalDataChecker.fromStates(
      inputDataModel: inputDataModel,
      outputDataModel: PersonalDataModel(
        name: state.name.value,
        imagePath: state.imagePath,
      ),
    );

    if (!checker.isNameChanged && !checker.isImagePathChanged) return;

    try {
      if (checker.isImagePathChanged) {
        inputDataModel.imagePath.safeLet((path) => CachedNetworkImage.evictFromCache(path));
      }

      await userRepository.updatePersonalData(checker);

      state.imagePath.safeLet((it) => deleteImage(it));

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
