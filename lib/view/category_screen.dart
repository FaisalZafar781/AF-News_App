import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_model.dart';
import 'package:news_app/utils/enums/enums.dart';
import 'package:news_app/view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yy');
  String categoryName = 'general';

  List<String> categoriesList = [
    'General',
    'Business',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Categories'),
          ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      categoryName = categoriesList[index];
                      setState(() {
                        newsViewModel.fetchCategoriesApi(categoryName);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoryName == categoriesList[index]
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                              child: Text(
                            categoriesList[index].toString(),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // /future builder for categories
            Expanded(
              child: FutureBuilder<CategoriesModel>(
                future: newsViewModel.fetchCategoriesApi(categoryName),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitPulsingGrid(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());

                          //image of news list
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    height: height * .18,
                                    width: width * .3,
                                    placeholder: (context, url) => Container(
                                      child: const SpinKitPulsingGrid(
                                        size: 50,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: height * .18,
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                          maxLines: 4,
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

# touched on 2025-05-28T20:51:07.823778Z