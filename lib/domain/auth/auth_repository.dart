import 'package:dio/dio.dart';

class AuthRepository {
  Dio _dio = Dio();

  Future<void> signInUser({
    String? email,
    String? password
  }) async {
      dynamic _data = {
        'email': email,
        'password': password
      };

      try {
        Response _response =
            await _dio.post('https://reqres.in/api/login', data: _data);

        print(_response.toString());
      } on DioError catch (e) {
        throw Exception(e.response!.data['error'].toString());
      } catch (e) {
        print(e.toString());
      }
  }
}