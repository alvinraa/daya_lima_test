import 'dart:io';

import 'package:daya_lima_test/models/create_film_model.dart';
import 'package:daya_lima_test/models/film_model.dart';
import 'package:daya_lima_test/services/services.dart';
import 'package:daya_lima_test/utils/state/finite_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class FilmProvider extends ChangeNotifier {
  final ApiService service = ApiService();

  int page = 1;
  final int limit = 10;
  bool hasMoreData = true;

  FilmModel? filmModel;
  CreateFilmModel? createFilmModel;
  List<Datum>? films = [];

  MyState myState = MyState.loading;

  Future fetchFilmData() async {
    try {
      // di commend karena apabila di uncommend akan kembali ke halaman paling atas, belum tau best practice cara hilangkan behavior tsb.
      // myState = MyState.loading;
      // notifyListeners();

      filmModel = await service.fetchFilm(
        page: page,
        size: limit,
      );

      if (filmModel!.data!.length < limit) {
        hasMoreData = false;
      }

      // print(films);
      // print(filmModel!.data);
      // print('before add films length in model = ${films!.length}');
      // print('before add page = $page');

      films!.addAll(filmModel!.data!);
      page++;

      // print(films);
      // print(filmModel!.data);
      // print('films length in model = ${films!.length}');
      // print('film_model length in model = ${filmModel!.data!.length}');
      // print('page = $page');

      myState = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        /// If want to check status code from service error
        e.response?.statusCode;
      }

      myState = MyState.failed;
      notifyListeners();
    }
  }

  Future refresh() async {
    try {
      myState = MyState.loading;
      notifyListeners();

      page = 1;
      hasMoreData = true;
      films = [];

      await fetchFilmData();

      myState = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        /// If want to check status code from service error
        e.response?.statusCode;
      }

      myState = MyState.failed;
      notifyListeners();
    }
  }
}
