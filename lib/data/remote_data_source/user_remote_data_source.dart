import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dispatch/data/dto/user_dto.dart';
import 'package:dispatch/data/http_service/dio_service.dart';
import 'package:dispatch/data/mapper/personal_data_mapper.dart';
import 'package:dispatch/data/mapper/user_mapper.dart';
import 'package:dispatch/domain/model/personal_data_model.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:http_parser/http_parser.dart';

class UserRemoteDataSource {
  /// Returns current data of the current user.
  Future<UserModel> getUser() async {
    final uri = DioService.buildUri(path: 'users/current');
    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.getUri(uri);
    return UserDTO.fromJson(response.data).toUserModel();
  }

  /// Updates the name of the current user to [name].
  ///
  /// Returns the current updated user.
  Future<UserModel> updateName(String name) async {
    final uri = DioService.buildUri(path: 'users/update-name');
    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.postUri(uri, data: {'name': name});
    return UserDTO.fromJson(response.data).toUserModel();
  }

  /// Updates the status of the current user according to the [isOnline] parameter.
  Future<void> updateOnlineStatus({required bool isOnline}) async {
    final uri = DioService.buildUri(path: 'users/update-online-status');
    await DioService.cookieJar.loadForRequest(uri);
    await DioService.dio.setHeaders().postUri(uri, data: {'online_status': isOnline});
  }

  /// Updates the image of the current user to [imageFile].
  ///
  /// Returns the current updated user.
  Future<UserModel> updateImage(File imageFile) async {
    final uri = DioService.buildUri(path: 'users/update-image');
    final fileName = imageFile.path.split('/').last;
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType('image', fileName.split('.')[1]),
      ),
    });

    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.setHeaders().postUri(uri, data: formData);
    return UserDTO.fromJson(response.data as Map<String, dynamic>).toUserModel();
  }

  /// Updates the personal data of the current user from the [data] parameter.
  ///
  /// Returns the current updated user.
  Future<UserModel> updatePersonalData(PersonalDataChecker data) async {
    final uri = DioService.buildUri(path: 'users/update');
    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.setHeaders().postUri(uri, data: await data.toFormData());
    return UserDTO.fromJson(response.data).toUserModel();
  }

  /// Returns a list of users according to the [query].
  Future<List<UserModel>> getUsersByQuery(String query) async {
    final uri = DioService.buildUri(path: 'users', queryParameters: {'q': query});
    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.setHeaders().getUri(uri);
    return (response.data as List<dynamic>).map((e) => UserDTO.fromJson(e).toUserModel()).toList();
  }
}
