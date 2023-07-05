import 'package:daya_lima_test/providers/film_model.dart';
import 'package:daya_lima_test/screens/add_new_movie_screen.dart';
import 'package:daya_lima_test/screens/movie_detail_screen.dart';
import 'package:daya_lima_test/utils/color_palette.dart';
import 'package:daya_lima_test/utils/state/finite_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FilmProvider _filmProvider;
  // untuk check scroll
  final ScrollController _scrollController = ScrollController();
  // hardcode variable
  final String createdBy = 'DayaLima Films';
  final String imageIsNull =
      'https://storage.googleapis.com/10fd8335-c083-4a36-96db-aba9f5867c51/web-assets/cpr/9BPaWl7U7axu6m3p/8d355a30-79bd-44b1-a212-3354486b3cbd';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // untuk tanggal local
    initializeDateFormatting('id_ID');

    _filmProvider = Provider.of<FilmProvider>(context, listen: false);
    _filmProvider.fetchFilmData();

    _scrollController.addListener(onScroll);
  }

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    // apabila scrollnya mentok dan masih memiliki data, fetch kembali
    if (currentScroll == maxScroll &&
        Provider.of<FilmProvider>(context, listen: false).hasMoreData) {
      _filmProvider.fetchFilmData();
      print('fetch data');
    }
  }

  Future onRefresh() async {
    _filmProvider.refresh();
  }

  Future onRefreshWhenFailed() async {
    _filmProvider.fetchFilmData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myPrimaryColor[50],
      appBar: AppBar(
        title: const Text('Movie'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                print('to add movie screen');
                Navigator.of(context) // variable context
                    .pushNamed(
                  AddMovieScreen.routeName,
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  size: 17,
                  color: myPrimaryColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          width: double.infinity,
          // untuk refresh halaman dengan drag kebawah
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: Consumer<FilmProvider>(
              builder: (context, provider, _) {
                switch (provider.myState) {
                  case MyState.loading:
                    print('movie loading');
                    return const Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                  case MyState.loaded:
                    print('movie loaded');
                    // list untuk format data
                    List filmsResultFormmatedDate = provider.films!.map((data) {
                      final date = data.createdDate!;
                      final formmatedDate =
                          DateFormat('EEEE, d MMM y', 'id').format(date);
                      return {"createdDate": formmatedDate};
                    }).toList();

                    // print('provider films length = ${provider.films!.length}');

                    return movieLoaded(provider, filmsResultFormmatedDate);
                  // error handling when something happen to API
                  case MyState.failed:
                    print('movie failed');
                    return movieFailed();
                  default:
                    return const SizedBox();
                }
              },
            ),
          )),
    );
  }

  ClipRRect movieLoaded(
      FilmProvider provider, List<dynamic> filmsResultFormmatedDate) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        child: ListView.separated(
          // untuk check scroll udah mentok atau belum
          controller: _scrollController,
          // untuk proses load data
          // itemCount: provider.hasMoreData
          //     ? provider.films!.length + 1
          //     : provider.films!.length,
          itemCount: provider.films!.length,
          separatorBuilder: (context, index) => const Divider(
            thickness: 1,
            height: 36,
          ),
          itemBuilder: ((context, index) {
            print('title = ${provider.films![index].id}');
            if (index < provider.films!.length) {
              return GestureDetector(
                onTap: () {
                  print('to movie detail');
                  Navigator.of(context) // variable context
                      .pushNamed(
                    MovieDetailScreen.routeName,
                    arguments: {
                      'title': provider.films![index].title,
                      'description': provider.films![index].description,
                      'poster': provider.films![index].poster,
                      'created_by': createdBy,
                      'created_date': filmsResultFormmatedDate[index]
                          ['createdDate'],
                    },
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${provider.films![index].title}\n\n',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${provider.films![index].description}\n\n',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.githubAlt,
                                  size: 12,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    createdBy,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: const FaIcon(
                                    FontAwesomeIcons.calendar,
                                    size: 12,
                                  ),
                                ),
                                Text(
                                  filmsResultFormmatedDate[index]
                                      ['createdDate'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 2,
                                offset: const Offset(4, 4))
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            // terdapat beberapa image yang null, apabila null menampilkan data gambar tida tersedia
                            provider.films![index].poster == null
                                ? imageIsNull
                                : provider.films![index].poster as String,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            // image ketika masih loading
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              return loadingProgress == null
                                  ? child
                                  // ini yang akan tampil ketika loading
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade400,
                                              blurRadius: 2,
                                              offset: const Offset(4, 4))
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                            },
                            // image ketika error
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              // ini yang akan tampil ketika error
                              // return Container(
                              //   height: 100,
                              //   width: 100,
                              //   decoration: BoxDecoration(
                              //     borderRadius:
                              //         BorderRadius.circular(10),
                              //     boxShadow: [
                              //       BoxShadow(
                              //           color: Colors
                              //               .grey.shade400,
                              //           blurRadius: 2,
                              //           offset:
                              //               const Offset(4, 4))
                              //     ],
                              //     color: Colors.grey[100],
                              //   ),
                              //   child: const Center(
                              //     child: FaIcon(FontAwesomeIcons
                              //         .circleExclamation),
                              //   ),
                              // );
                              return Image.network(
                                imageIsNull,
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(15),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  Column movieFailed() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topCenter,
          // assetnya nanti diganti
          child: Image.network(
            'https://storage.googleapis.com/10fd8335-c083-4a36-96db-aba9f5867c51/web-assets/cpr/9BPaWl7U7axu6m3p/06fcbf35-74ac-4c2b-9bd2-f2a315bfc5fc',
            height: 275,
            width: 275,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          // 'Layanan Belum Tersedia',
          'API Broken',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          alignment: Alignment.center,
          child: const Text(
            'Mohon maaf, layanan yang Anda pilih sedang dalam proses pengembangan',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onRefreshWhenFailed,
          child: const Text(
            'Refresh',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        const Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            // assetnya nanti diganti
            child: Image.network(
              'https://storage.googleapis.com/10fd8335-c083-4a36-96db-aba9f5867c51/web-assets/cpr/9BPaWl7U7axu6m3p/d23bd82f-5fc7-4ca3-b55d-444e3e49b20e',
              // height: 150,
              width: double.infinity,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }
}
