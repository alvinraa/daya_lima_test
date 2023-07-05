import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/color_palette.dart';

class MovieDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String? poster;
  final String createdBy;
  final String createdDate;

  const MovieDetailScreen({
    required this.title,
    required this.description,
    required this.poster,
    required this.createdBy,
    required this.createdDate,
    super.key,
  });

  static const routeName = '/movie-detail';
  final String imageIsNull =
      'https://storage.googleapis.com/10fd8335-c083-4a36-96db-aba9f5867c51/web-assets/cpr/9BPaWl7U7axu6m3p/8d355a30-79bd-44b1-a212-3354486b3cbd';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myPrimaryColor[50],
      appBar: AppBar(
        title: const Text('Event dan Promo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          width: double.infinity,
          // height: height - kToolbarHeight - 40,
          // color: Colors.blueGrey,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              color: Colors.white60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: Image.network(
                        poster == null ? imageIsNull : poster!,
                        fit: BoxFit.fill,
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
                          //     borderRadius: BorderRadius.circular(10),
                          //     boxShadow: [
                          //       BoxShadow(
                          //           color: Colors.grey.shade400,
                          //           blurRadius: 2,
                          //           offset: const Offset(4, 4))
                          //     ],
                          //     color: Colors.grey[100],
                          //   ),
                          //   child: const Center(
                          //     child: FaIcon(FontAwesomeIcons.circleExclamation),
                          //   ),
                          // );
                          return Image.network(
                            imageIsNull,
                            // height: height * 0.25,
                            // width: width,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.githubAlt,
                        size: 30,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            createdBy,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            createdDate,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    // hardcode for tab
                    '     $description',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
