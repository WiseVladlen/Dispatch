import 'package:dio/dio.dart';
import 'package:dispatch/domain/model/personal_data_model.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:dispatch/utils/object_utils.dart';
import 'package:http_parser/http_parser.dart';

extension UserModelToPersonalDataModelMapper on UserModel {
  PersonalDataModel toPersonalDataModel() {
    return PersonalDataModel(
      name: name,
      imagePath: imagePath,
    );
  }
}

extension PersonalDataCheckerToFormDataMapper on PersonalDataChecker {
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      if (isNameChanged) 'name': name,
      if (isImagePathChanged)
        'image': await imagePath.safeLet((path) async {
          final fileName = path.split('/').last;
          return MultipartFile.fromFile(
            path,
            filename: fileName,
            contentType: MediaType('image', fileName.split('.')[1]),
          );
        }),
    });
  }
}
