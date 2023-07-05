import 'dart:io';

import 'package:daya_lima_test/providers/add_film_model.dart';
import 'package:daya_lima_test/providers/film_model.dart';
import 'package:daya_lima_test/utils/color_palette.dart';
import 'package:daya_lima_test/utils/state/finite_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  static const routeName = '/add-movie';

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _picker = ImagePicker();
  File? uploadPoster;

  late AddFilmProvider addFilmProvider =
      Provider.of<AddFilmProvider>(context, listen: false);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  // berguna agar button tidak dipencet terus"an
  bool isLoading = false;

  chooseImage(ImageSource source) async {
    var pickedFile = await _picker.getImage(
      source: source,
      imageQuality: 25,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      uploadPoster = File(pickedFile!.path);
    });
  }

  // ini testing pakai cara langsung tanpa providers karena sebelumnya gagal menggunakan providers(1)
  // Future<void> sendFormData() async {
  //   String url =
  //       'https://dlabs-test.irufano.com/api/movie';

  //   try {
  //     FormData formData = FormData.fromMap({
  //       'title': 'Judul Film test',
  //       'description':
  //           'Deskripsi Film test',
  //       'image': await MultipartFile.fromFile(uploadPoster!.path,
  //           filename:
  //               'poster.jpg'),
  //     });

  //     Response response = await Dio().post(url, data: formData);

  //     print(response);

  //     if (response.status == 'success') {
  //       print('Permintaan berhasil');
  //     } else {
  //       print('Permintaan gagal');
  //     }
  //   } catch (error) {
  //     print('Kesalahan: $error');
  //   }
  // }

  Future updatePoster({required BuildContext context}) async {
    var title = titleController.text;
    var desc = descriptionController.text;
    var poster = uploadPoster?.path;

    if (title == '' || desc == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Judul atau Keterangan film tidak boleh kosong"),
        ),
      );
    } else {
      setState(() {
        isLoading = true;
      });

      // print(title);
      // print(desc);
      // print(poster);

      // ini testing pakai cara langsung tanpa providers karena sebelumnya gagal menggunakan providers(2)
      // sendFormData();

      addFilmProvider.createFilmData(
        title: title,
        description: desc,
        poster: poster,
      );

      Consumer<AddFilmProvider>(
        builder: (context, provider, _) {
          switch (provider.myState) {
            case MyState.loading:
              print('loading add film');
              return const Padding(
                padding: EdgeInsets.all(15),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );

            case MyState.loaded:
              print('succes add film');

              return const SnackBar(
                  content: Text("Film berhasil di tambahkan"));
            // error handling when something happen to API
            case MyState.failed:
              print('failed add film');
              return const SnackBar(content: Text("Film gagal di tambahkan"));
            default:
              return const SizedBox();
          }
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Film berhasil di tambahkan"),
        ),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myPrimaryColor[50],
      appBar: AppBar(
        title: const Text('Menambahkan Film'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambahkan film favoritmu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              // kalimat pendukung jika dibutuhkan
              const SizedBox(height: 10),
              const Text(
                'Dengan menambahkan film favoritmu, maka film favoritmu akan masuk kedalam result API Get Film miki LimaDaya',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  prefixIcon: Icon(
                    Icons.account_box_rounded,
                    size: 20,
                  ),
                  labelText: 'Judul Film',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: 5,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  // agar menjadi tombol done, dan keyboard hilang
                  FocusScope.of(context).unfocus();
                },
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  prefixIcon: Icon(
                    Icons.account_box_rounded,
                    size: 20,
                  ),
                  labelText: 'Keterangan Film',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Poster (tidak wajib)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              uploadPoster == null
                  ? Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white,
                      ),
                      // child: Icon(
                      //   Icons.image_outlined,
                      //   color: myPrimaryColor,
                      //   size: 75,
                      // ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.image,
                          size: 75,
                          color: myPrimaryColor,
                        ),
                      ),
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white,
                      ),
                      child: Image(
                        fit: BoxFit.contain,
                        image: FileImage(uploadPoster!),
                      ),
                    ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      chooseImage(ImageSource.camera);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 50,
                      child: const Text(
                        'Kamera',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      chooseImage(ImageSource.gallery);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 50,
                      child: const Text(
                        'Geleri',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updatePoster(context: context);
                },
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Upload Film',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
