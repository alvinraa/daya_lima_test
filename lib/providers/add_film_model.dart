import 'package:daya_lima_test/models/create_film_model.dart';
import 'package:daya_lima_test/services/services.dart';
import 'package:daya_lima_test/utils/state/finite_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AddFilmProvider extends ChangeNotifier {
  final ApiService service = ApiService();

  CreateFilmModel? createFilmModel;

  MyState myState = MyState.loading;

  Future createFilmData({
    required String title,
    required String description,
    String? poster,
  }) async {
    try {
      myState = MyState.loading;
      // print('triggered loading providers');
      notifyListeners();

      createFilmModel = await service.createFilm(
        title: title,
        description: description,
        poster: poster,
      );

      myState = MyState.loaded;
      // print('triggered loaded providers');
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        /// If want to check status code from service error
        e.response?.statusCode;
        print(e.response);
      }

      myState = MyState.failed;
      // print('triggered failed providers');
      notifyListeners();
    }
  }
}
