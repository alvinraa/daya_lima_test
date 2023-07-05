import 'package:daya_lima_test/models/create_film_model.dart';
import 'package:dio/dio.dart';

import '../models/film_model.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          if (e.response!.statusCode == 401) {
            // do something
          } else {
            // do something
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<FilmModel> fetchFilm({
    required size,
    required page,
  }) async {
    try {
      //api benar
      final response = await _dio.get(
          'https://dlabs-test.irufano.com/api/movie?size=$size&page=$page');
      //api rusak untuk test error api
      // final response = await _dio.get(
      //     'https://dlabs-test.irufano.com/apiss/movie?size=$size&page=$page');
      print(response.data);

      return FilmModel.fromJson(response.data);
    } on DioError catch (_) {
      rethrow;
    }
  }

  Future<CreateFilmModel> createFilm({
    required title,
    required description,
    poster,
  }) async {
    FormData formData = FormData.fromMap({
      'title': title,
      'description': description,
      // 'poster': await MultipartFile.fromFile(poster,
      //     filename:
      //         'poster_demo.jpg'), // Ganti dengan path dan nama file gambar yang sesuai
    });

    print('poster di service $poster');
    // poster boleh kosong
    if (poster != null) {
      formData.files.add(
        MapEntry(
          'poster',
          await MultipartFile.fromFile(poster, filename: 'poster_demo.jpg'),
        ),
      );
    }
    try {
      final response = await _dio.post(
        'https://dlabs-test.irufano.com/api/movie',
        data: formData,
      );
      print(response.data);

      return CreateFilmModel.fromJson(response.data);
    } on DioError catch (e) {
      print('error dio di services $e');
      rethrow;
    }
  }
}
