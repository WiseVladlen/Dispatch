class PersonalDataModel {
  const PersonalDataModel({
    required this.name,
    required this.imagePath,
  });

  final String name;
  final String? imagePath;
}

class PersonalDataChecker {
  const PersonalDataChecker._internal({
    required this.name,
    required this.imagePath,
    required this.isNameChanged,
    required this.isImagePathChanged,
  });

  final String name;
  final String? imagePath;

  final bool isNameChanged;
  final bool isImagePathChanged;

  factory PersonalDataChecker.fromStates({
    required PersonalDataModel inputDataModel,
    required PersonalDataModel outputDataModel,
  }) {
    return PersonalDataChecker._internal(
      name: outputDataModel.name,
      imagePath: outputDataModel.imagePath,
      isNameChanged: inputDataModel.name != outputDataModel.name,
      isImagePathChanged: inputDataModel.imagePath != outputDataModel.imagePath,
    );
  }
}
